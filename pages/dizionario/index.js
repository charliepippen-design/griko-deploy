import { useState, useMemo, useEffect } from "react";
import { useRouter } from "next/router";
import Link from "next/link";
import Layout from "../../components/Layout";
import { supabase } from "../../lib/supabase";
import carmineData from "../../data/carmine_greco_lessons.json";

// Global client-side in-memory cache to prevent re-fetching on every internal navigation
let memoryCache = null;

const CARMINE_CATEGORIES = [
  { id: "tutte", label: "Tutte le lezioni" },
  { id: "fonetica", label: "Fonetica & Alfabeto" },
  { id: "nomi", label: "Morfologia Nominale" },
  { id: "aggettivi", label: "Aggettivi" },
  { id: "pronomi_numerali", label: "Pronomi & Numerali" },
  { id: "invariabili", label: "Parti Invariabili" },
  { id: "verbi", label: "Sistema Verbale" },
];

export default function Dizionario() {
  const router = useRouter();

  // Selezione del corso: "carmine" (Corso Sistematico) oppure "palma" (Micro-regole & Vocabolario)
  const [activeCourse, setActiveCourse] = useState("palma");

  // Dati Corso Daniele Palma (Supabase + cache)
  const [lessons, setLessons] = useState(memoryCache ? memoryCache.lessons : []);
  const [rules, setRules] = useState(memoryCache ? memoryCache.rules : []);
  const [lexemes, setLexemes] = useState(memoryCache ? memoryCache.lexemes : []);
  const [occurrences, setOccurrences] = useState(memoryCache ? memoryCache.occurrences : []);
  const [loading, setLoading] = useState(!memoryCache);
  const [loadingStep, setLoadingStep] = useState(memoryCache ? "Completato" : "Connessione al database...");
  const [error, setError] = useState(null);

  const [query, setQuery] = useState("");
  const [openLesson, setOpenLesson] = useState(null);

  // Dati Corso Carmine Greco (24 lezioni di grammatica) - metadati statici (titolo,
  // durata, proverbio, link YouTube) più regole/vocabolario estratti su Supabase.
  const carmineLessons = useMemo(
    () => carmineData.lessons.filter((l) => !l.is_poetry),
    []
  );
  const [carmineCategory, setCarmineCategory] = useState("tutte");
  const [carmineSearch, setCarmineSearch] = useState("");
  const [openCarmineLesson, setOpenCarmineLesson] = useState(null);

  // Regole e vocabolario del corso di Carmine Greco (carmine_lessons/rules/lexemes/occurrences)
  const [carmineRules, setCarmineRules] = useState(memoryCache ? memoryCache.carmineRules : []);
  const [carmineLexemes, setCarmineLexemes] = useState(memoryCache ? memoryCache.carmineLexemes : []);
  const [carmineOccurrences, setCarmineOccurrences] = useState(memoryCache ? memoryCache.carmineOccurrences : []);

  // Sincronizzazione query URL (?q=... e ?corso=...)
  useEffect(() => {
    if (router.query.corso === "carmine") {
      setActiveCourse("carmine");
    } else if (router.query.corso === "palma") {
      setActiveCourse("palma");
    }

    if (router.query.q && typeof router.query.q === "string") {
      setQuery(router.query.q);
    }
  }, [router.query.corso, router.query.q]);

  useEffect(() => {
    if (memoryCache) {
      setLoading(false);
      return;
    }

    let isMounted = true;
    let timeoutIds = [];

    async function loadDataProgressive() {
      setLoading(true);
      setError(null);
      setLoadingStep("Connessione al database...");

      // Messaggi che cambiano nel tempo: su connessioni lente (es. VPN,
      // rete mobile) il fetch può richiedere diversi secondi, e un testo
      // statico fa sembrare la pagina bloccata anche quando sta solo
      // aspettando la risposta del server. Rassicuriamo l'utente invece
      // di lasciare lo stesso messaggio per tutta l'attesa.
      timeoutIds.push(setTimeout(() => {
        if (isMounted) setLoadingStep("Connessione lenta, un momento ancora...");
      }, 4000));
      timeoutIds.push(setTimeout(() => {
        if (isMounted) setLoadingStep("Il server sta rispondendo, quasi pronto...");
      }, 9000));

      const hardTimeoutId = setTimeout(() => {
        if (isMounted) {
          setError("Il server Supabase sta impiegando più tempo del previsto. Clicca Riprova per riconnetterti.");
          setLoading(false);
        }
      }, 20000);
      timeoutIds.push(hardTimeoutId);

      try {
        // Le 4 query partono tutte insieme in un solo giro di rete invece di
        // due Promise.all in sequenza: su connessioni ad alta latenza questo
        // dimezza il tempo di attesa prima che la pagina risulti pronta.
        const [
          { data: lData, error: lErr },
          { data: rData, error: rErr },
          { data: lxData, error: lxErr },
          { data: oData, error: oErr },
          { data: crData, error: crErr },
          { data: clxData, error: clxErr },
          { data: coData, error: coErr }
        ] = await Promise.all([
          supabase.from("lessons").select("*").order("id", { ascending: true }),
          supabase.from("rules").select("*").order("id", { ascending: true }),
          supabase.from("lexemes").select("*").order("parola_griko", { ascending: true }),
          supabase.from("occurrences").select("*").order("id", { ascending: true }),
          supabase.from("carmine_rules").select("*").order("id", { ascending: true }),
          supabase.from("carmine_lexemes").select("*").order("parola_griko", { ascending: true }),
          supabase.from("carmine_occurrences").select("*").order("id", { ascending: true })
        ]);

        if (lErr) throw lErr;
        if (rErr) throw rErr;
        if (lxErr) throw lxErr;
        if (oErr) throw oErr;
        // Le tabelle di Carmine Greco sono un'aggiunta più recente: se non
        // rispondono non blocchiamo il corso di Palma, mostriamo solo un log.
        if (crErr) console.error("Errore carmine_rules:", crErr);
        if (clxErr) console.error("Errore carmine_lexemes:", clxErr);
        if (coErr) console.error("Errore carmine_occurrences:", coErr);

        timeoutIds.forEach(clearTimeout);

        if (isMounted) {
          setLessons(lData || []);
          setRules(rData || []);
          setLexemes(lxData || []);
          setOccurrences(oData || []);
          setCarmineRules(crData || []);
          setCarmineLexemes(clxData || []);
          setCarmineOccurrences(coData || []);
          setLoading(false);

          memoryCache = {
            lessons: lData || [],
            rules: rData || [],
            lexemes: lxData || [],
            occurrences: oData || [],
            carmineRules: crData || [],
            carmineLexemes: clxData || [],
            carmineOccurrences: coData || []
          };
        }
      } catch (err) {
        timeoutIds.forEach(clearTimeout);
        console.error("Errore recupero Supabase:", err);
        if (isMounted) {
          setError(err.message || "Errore di connessione a Supabase");
          setLoading(false);
        }
      }
    }

    loadDataProgressive();

    return () => {
      isMounted = false;
      timeoutIds.forEach(clearTimeout);
    };
  }, []);

  // Mappature e filtri per Daniele Palma
  const lessonById = useMemo(() => {
    const m = {};
    for (const l of lessons) m[l.id] = l;
    return m;
  }, [lessons]);

  const lexemeById = useMemo(() => {
    const m = {};
    for (const lx of lexemes) m[lx.id] = lx;
    return m;
  }, [lexemes]);

  const occurrencesByLesson = useMemo(() => {
    const m = {};
    for (const o of occurrences) {
      (m[o.lesson_id] = m[o.lesson_id] || []).push(o);
    }
    return m;
  }, [occurrences]);

  const occurrencesByLexeme = useMemo(() => {
    const m = {};
    for (const o of occurrences) {
      (m[o.lexeme_id] = m[o.lexeme_id] || []).push(o);
    }
    return m;
  }, [occurrences]);

  const rulesByLesson = useMemo(() => {
    const m = {};
    for (const r of rules) {
      (m[r.lesson_id] = m[r.lesson_id] || []).push(r);
    }
    return m;
  }, [rules]);

  const byCategory = useMemo(() => {
    const m = {};
    for (const l of lessons) {
      (m[l.categoria] = m[l.categoria] || []).push(l);
    }
    return m;
  }, [lessons]);

  // Mappature per il corso di Carmine Greco (regole/vocabolario per lezione,
  // indicizzati per id di lezione = "order" nel JSON dei metadati statici)
  const carmineLessonById = useMemo(() => {
    const m = {};
    for (const l of carmineLessons) m[l.order] = l;
    return m;
  }, [carmineLessons]);

  const carmineRulesByLesson = useMemo(() => {
    const m = {};
    for (const r of carmineRules) {
      (m[r.lesson_id] = m[r.lesson_id] || []).push(r);
    }
    return m;
  }, [carmineRules]);

  const carmineLexemeById = useMemo(() => {
    const m = {};
    for (const lx of carmineLexemes) m[lx.id] = lx;
    return m;
  }, [carmineLexemes]);

  const carmineOccurrencesByLesson = useMemo(() => {
    const m = {};
    for (const o of carmineOccurrences) {
      (m[o.lesson_id] = m[o.lesson_id] || []).push(o);
    }
    return m;
  }, [carmineOccurrences]);

  const carmineOccurrencesByLexeme = useMemo(() => {
    const m = {};
    for (const o of carmineOccurrences) {
      (m[o.lexeme_id] = m[o.lexeme_id] || []).push(o);
    }
    return m;
  }, [carmineOccurrences]);

  // Ricerca unificata: cerca sia nel vocabolario di Daniele Palma sia in
  // quello di Carmine Greco, indicando sempre la fonte di ciascun risultato.
  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return [];

    const palmaResults = lexemes
      .filter(
        (lx) =>
          lx.parola_griko.toLowerCase().includes(q) ||
          lx.parola_italiano.toLowerCase().includes(q)
      )
      .map((lx) => {
        const occs = occurrencesByLexeme[lx.id] || [];
        const linkedLessons = occs
          .map((o) => lessonById[o.lesson_id])
          .filter(Boolean)
          .map((l) => ({ id: l.id, titolo: l.titolo, categoria: l.categoria }));
        return {
          id: `palma-${lx.id}`,
          source: "palma",
          parola_griko: lx.parola_griko,
          parola_italiano: lx.parola_italiano,
          lessons: linkedLessons,
        };
      });

    const carmineResults = carmineLexemes
      .filter(
        (lx) =>
          lx.parola_griko.toLowerCase().includes(q) ||
          lx.parola_italiano.toLowerCase().includes(q)
      )
      .map((lx) => {
        const occs = carmineOccurrencesByLexeme[lx.id] || [];
        const linkedLessons = occs
          .map((o) => carmineLessonById[o.lesson_id])
          .filter(Boolean)
          .map((l) => ({ id: l.order, titolo: l.title, categoria: l.category_label }));
        return {
          id: `carmine-${lx.id}`,
          source: "carmine",
          parola_griko: lx.parola_griko,
          parola_italiano: lx.parola_italiano,
          lessons: linkedLessons,
        };
      });

    return [...palmaResults, ...carmineResults];
  }, [
    query,
    lexemes,
    occurrencesByLexeme,
    lessonById,
    carmineLexemes,
    carmineOccurrencesByLexeme,
    carmineLessonById,
  ]);

  // Filtri per Carmine Greco
  const filteredCarmineLessons = useMemo(() => {
    return carmineLessons.filter((l) => {
      const matchCat =
        carmineCategory === "tutte" || l.category === carmineCategory;
      const q = carmineSearch.trim().toLowerCase();
      const matchSearch =
        !q ||
        l.title.toLowerCase().includes(q) ||
        l.summary.toLowerCase().includes(q) ||
        (l.proverb && l.proverb.toLowerCase().includes(q)) ||
        (l.transcript && l.transcript.toLowerCase().includes(q));
      return matchCat && matchSearch;
    });
  }, [carmineLessons, carmineCategory, carmineSearch]);

  return (
    <Layout
      title="Dizionario & Grammatica Grika — griko.online"
      description="Consultazione del vocabolario, del corso sistematico di Carmine Greco (24 lezioni) e delle 73 lezioni di Daniele Palma."
    >
      <div className="wrap">
        {/* Header Sezione */}
        <div className="editorial-hero" style={{ marginBottom: "28px", padding: "36px 28px" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", flexWrap: "wrap", gap: "12px" }}>
            <div>
              <span className="editorial-hero-tag">Sezione Impara · Didattica &amp; Grammatica</span>
              <h1 style={{ fontSize: "2.4rem", marginBottom: "8px" }}>Dizionario &amp; Grammatica</h1>
            </div>
            <div className="badge-pill-cultural">
              <span>Isola Ellenofona Salentina</span>
            </div>
          </div>
          <p className="sub" style={{ fontSize: "1.1rem" }}>
            Due percorsi didattici complementari per esplorare il patrimonio linguistico del Salento ellenofono: 
            il trattato teorico di <strong>Carmine Greco</strong> (24 lezioni con proverbi commentati) e il frasario a micro-regole di <strong>Daniele Palma</strong> con vocabolario indicizzato.
          </p>
        </div>

        {/* Selettore dei Due Corsi Didattici */}
        <div className="course-author-switcher">
          <button
            type="button"
            className={`course-tab-btn ${activeCourse === "palma" ? "active" : ""}`}
            onClick={() => setActiveCourse("palma")}
          >
            <span className="course-tab-title">Corso a Micro-Regole di Daniele Palma</span>
            <span className="course-tab-meta">
              73 lezioni brevi · 684 lessemi bilingui · 158 regole morfologiche
            </span>
          </button>

          <button
            type="button"
            className={`course-tab-btn ${activeCourse === "carmine" ? "active" : ""}`}
            onClick={() => setActiveCourse("carmine")}
          >
            <span className="course-tab-title">Corso Sistematico di Carmine Greco</span>
            <span className="course-tab-meta">
              24 lezioni organiche · {carmineLexemes.length || "…"} lessemi bilingui · {carmineRules.length || "…"} regole grammaticali
            </span>
          </button>
        </div>

        {/* ====================================================================
            VISTA 1: CORSO DI DANIELE PALMA (VOCABOLARIO & 73 MICRO-LEZIONI)
            ==================================================================== */}
        {activeCourse === "palma" && (
          <div>
            {loading && lessons.length === 0 ? (
              <div className="skeleton-container" aria-label="Caricamento dizionario in corso...">
                <div className="skeleton-box skeleton-shimmer" style={{ width: "100%", height: "54px", borderRadius: "8px", marginBottom: "28px" }} />
                <div style={{ display: "flex", gap: "16px", marginBottom: "20px" }}>
                  <div className="skeleton-box skeleton-shimmer" style={{ width: "180px", height: "24px" }} />
                  <div className="skeleton-box skeleton-shimmer" style={{ width: "120px", height: "24px" }} />
                </div>
                {[1, 2, 3, 4, 5, 6].map((i) => (
                  <div key={i} className="skeleton-lesson-card">
                    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                      <div className="skeleton-box skeleton-shimmer" style={{ width: `${45 + (i * 7) % 35}%`, height: "20px" }} />
                      <div className="skeleton-box skeleton-shimmer" style={{ width: "60px", height: "16px" }} />
                    </div>
                  </div>
                ))}
                <p style={{ textAlign: "center", color: "var(--text-tertiary)", marginTop: "16px", fontSize: "0.85rem" }}>
                  <span className="loading-spinner" style={{ width: "14px", height: "14px", borderWidth: "2px" }} />
                  Sincronizzazione archivio lessicale in corso...
                </p>
              </div>
            ) : error ? (
              <div className="error-box">
                <p><strong>Errore di caricamento:</strong> {error}</p>
                <button className="retry-btn" onClick={() => window.location.reload()}>
                  Riprova connessione
                </button>
              </div>
            ) : (
              <>
                {/* Input di Ricerca Vocabolario */}
                <div className="search-wrap">
                  <input
                    className="search"
                    type="text"
                    placeholder="Cerca una parola in griko o in italiano, tra i due corsi (es. kalimera, terra, mare, mangiare)..."
                    value={query}
                    onChange={(e) => setQuery(e.target.value)}
                    autoFocus={Boolean(router.query.q)}
                  />
                  {query && (
                    <button
                      type="button"
                      className="search-clear-btn"
                      onClick={() => setQuery("")}
                      aria-label="Cancella ricerca"
                    >
                      ✕
                    </button>
                  )}
                </div>

                {/* Risultati di Ricerca Live */}
                {query.trim() && (
                  <section style={{ marginBottom: "40px" }}>
                    <h2>
                      {results.length} risultat{results.length === 1 ? "o" : "i"} per “{query.trim()}”
                    </h2>
                    {results.length === 0 ? (
                      <p className="empty">Nessun lessema trovato per questo termine di ricerca.</p>
                    ) : (
                      <ul className="results">
                        {results.map((v) => (
                          <li key={v.id}>
                            <span
                              className="src-badge"
                              title={v.source === "carmine" ? "Corso di Carmine Greco" : "Corso di Daniele Palma"}
                            >
                              {v.source === "carmine" ? "Carmine Greco" : "Daniele Palma"}
                            </span>
                            <span className="griko notranslate" translate="no">{v.parola_griko}</span>
                            <span className="arrow">→</span>
                            <span className="ita">{v.parola_italiano}</span>
                            {v.lessons && v.lessons.length > 0 && (
                              <span className="prov">
                                {v.lessons.map((l, idx) => (
                                  <span key={l.id}>
                                    {idx > 0 && " · "}
                                    {l.categoria} · {l.titolo}
                                  </span>
                                ))}
                              </span>
                            )}
                          </li>
                        ))}
                      </ul>
                    )}
                  </section>
                )}

                {/* Indice Lezioni Raggruppato per Categorie */}
                <section>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", flexWrap: "wrap", marginBottom: "16px" }}>
                    <h2>Indice ragionato delle 73 lezioni</h2>
                    <span style={{ fontSize: "0.85rem", color: "var(--text-tertiary)" }}>
                      Trascrizioni didattiche di Daniele Palma
                    </span>
                  </div>

                  {Object.keys(byCategory).map((cat) => (
                    <div key={cat} className="cat">
                      <h3>{cat}</h3>
                      <ul className="lessons">
                        {byCategory[cat].map((l) => {
                          const lRules = rulesByLesson[l.id] || [];
                          const lOccs = occurrencesByLesson[l.id] || [];
                          const lVocab = lOccs
                            .map((o) => lexemeById[o.lexeme_id])
                            .filter(Boolean);

                          return (
                            <li key={l.id}>
                              <button
                                type="button"
                                className="lesson-btn"
                                onClick={() => setOpenLesson(openLesson === l.id ? null : l.id)}
                                aria-expanded={openLesson === l.id}
                              >
                                <span className="lnum">{l.id}</span>
                                <span className="lesson-title-text">{l.titolo}</span>
                                {l.genere ? <em> · {l.genere}</em> : null}
                                {l.desinenza ? <em> · {l.desinenza}</em> : null}
                                <span className="lesson-expand-arrow">{openLesson === l.id ? "▲" : "▼"}</span>
                              </button>

                              {openLesson === l.id && (
                                <div className="detail">
                                  {lRules.length > 0 && (
                                    <>
                                      <h4>Regole grammaticali ({lRules.length})</h4>
                                      <ul>
                                        {lRules.map((r) => (
                                          <li key={r.id}>{r.regola_testo}</li>
                                        ))}
                                      </ul>
                                    </>
                                  )}
                                  {lVocab.length > 0 && (
                                    <>
                                      <h4>Vocabolario estratto ({lVocab.length})</h4>
                                      <table className="vtab">
                                        <tbody>
                                          {lVocab.map((v) => (
                                            <tr key={v.id}>
                                              <td className="griko notranslate" translate="no">{v.parola_griko}</td>
                                              <td>{v.parola_italiano}</td>
                                            </tr>
                                          ))}
                                        </tbody>
                                      </table>
                                    </>
                                  )}
                                </div>
                              )}
                            </li>
                          );
                        })}
                      </ul>
                    </div>
                  ))}
                </section>
              </>
            )}
          </div>
        )}

        {/* ====================================================================
            VISTA 2: CORSO SISTEMATICO DI CARMINE GRECO (24 LEZIONI)
            ==================================================================== */}
        {activeCourse === "carmine" && (
          <div>
            {/* Barra di Filtraggio Macro-Categorie */}
            <div className="carmine-filter-bar">
              <div className="carmine-pills-row">
                {CARMINE_CATEGORIES.map((cat) => (
                  <button
                    key={cat.id}
                    type="button"
                    className={`carmine-pill ${carmineCategory === cat.id ? "active" : ""}`}
                    onClick={() => setCarmineCategory(cat.id)}
                  >
                    {cat.label}
                  </button>
                ))}
              </div>

              {/* Filtro Ricerca Veloce tra le Lezioni */}
              <div className="search-wrap" style={{ marginTop: "12px" }}>
                <input
                  className="search"
                  type="text"
                  placeholder="Filtra tra le 24 lezioni di Carmine Greco (es. alfabeto, articolo, imperativo, participio)..."
                  value={carmineSearch}
                  onChange={(e) => setCarmineSearch(e.target.value)}
                />
                {carmineSearch && (
                  <button
                    type="button"
                    className="search-clear-btn"
                    onClick={() => setCarmineSearch("")}
                    aria-label="Cancella filtro"
                  >
                    ✕
                  </button>
                )}
              </div>
            </div>

            {/* Conteggio Risultati */}
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "20px", color: "var(--text-secondary)", fontSize: "0.9rem" }}>
              <span>
                Visualizzando <strong>{filteredCarmineLessons.length}</strong> su 24 lezioni
              </span>
              <span style={{ fontSize: "0.8rem", color: "var(--text-tertiary)" }}>
                Audio e lezioni originali di Carmine Greco
              </span>
            </div>

            {/* Lista delle Lezioni di Carmine Greco */}
            <div className="carmine-lessons-list">
              {filteredCarmineLessons.length === 0 ? (
                <div className="empty-box" style={{ padding: "40px 20px", textAlign: "center", background: "var(--bg-surface)", borderRadius: "var(--radius-lg)" }}>
                  <p>Nessuna lezione trovata con i filtri correnti.</p>
                  <button
                    type="button"
                    className="carmine-pill"
                    onClick={() => { setCarmineCategory("tutte"); setCarmineSearch(""); }}
                  >
                    Resetta filtri
                  </button>
                </div>
              ) : (
                filteredCarmineLessons.map((l) => {
                  return (
                    <article key={l.video_id} className="carmine-card">
                      <div className="carmine-card-top">
                        <div className="carmine-badges-group">
                          <span className="carmine-num-badge">#{String(l.order).padStart(2, "0")}</span>
                          <span className="carmine-cat-badge">{l.category_label}</span>
                        </div>
                        <div className="carmine-meta-info">
                          <span>⏱ {l.duration} min</span>
                          <span>·</span>
                          <span>~{l.words_count} parole</span>
                        </div>
                      </div>

                      <h2 className="carmine-lesson-heading">{l.title}</h2>
                      <p className="carmine-summary-body">{l.summary}</p>

                      {l.proverb && (
                        <div className="carmine-proverb-highlight">
                          <strong>Proverbio commentato:</strong> {l.proverb}
                        </div>
                      )}

                      <div className="carmine-card-actions">
                        <a
                          href={l.youtube_url}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="carmine-yt-link"
                        >
                          Guarda la lezione su YouTube ↗
                        </a>
                        {(() => {
                          const lRules = carmineRulesByLesson[l.order] || [];
                          const lOccs = carmineOccurrencesByLesson[l.order] || [];
                          const lVocab = lOccs
                            .map((o) => carmineLexemeById[o.lexeme_id])
                            .filter(Boolean);
                          if (lRules.length === 0 && lVocab.length === 0) return null;
                          const isOpen = openCarmineLesson === l.order;
                          return (
                            <button
                              type="button"
                              className="lesson-btn"
                              style={{ marginTop: "10px" }}
                              onClick={() => setOpenCarmineLesson(isOpen ? null : l.order)}
                              aria-expanded={isOpen}
                            >
                              <span className="lesson-title-text">
                                Regole ({lRules.length}) e vocabolario ({lVocab.length}) di questa lezione
                              </span>
                              <span className="lesson-expand-arrow">{isOpen ? "▲" : "▼"}</span>
                            </button>
                          );
                        })()}
                      </div>

                      {openCarmineLesson === l.order && (() => {
                        const lRules = carmineRulesByLesson[l.order] || [];
                        const lOccs = carmineOccurrencesByLesson[l.order] || [];
                        const lVocab = lOccs
                          .map((o) => carmineLexemeById[o.lexeme_id])
                          .filter(Boolean);
                        return (
                          <div className="detail">
                            {lRules.length > 0 && (
                              <>
                                <h4>Regole grammaticali ({lRules.length})</h4>
                                <ul>
                                  {lRules.map((r) => (
                                    <li key={r.id}>{r.regola_testo}</li>
                                  ))}
                                </ul>
                              </>
                            )}
                            {lVocab.length > 0 && (
                              <>
                                <h4>Vocabolario estratto ({lVocab.length})</h4>
                                <table className="vtab">
                                  <tbody>
                                    {lVocab.map((v) => (
                                      <tr key={v.id}>
                                        <td className="griko notranslate" translate="no">{v.parola_griko}</td>
                                        <td>{v.parola_italiano}</td>
                                      </tr>
                                    ))}
                                  </tbody>
                                </table>
                              </>
                            )}
                          </div>
                        );
                      })()}
                    </article>
                  );
                })
              )}
            </div>
          </div>
        )}
      </div>
    </Layout>
  );
}
