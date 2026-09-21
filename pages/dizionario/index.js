import { useState, useMemo, useEffect } from "react";
import { useRouter } from "next/router";
import Layout from "../../components/Layout";
import { supabase } from "../../lib/supabase";

// Global client-side in-memory cache to prevent re-fetching on every internal navigation
let memoryCache = null;

export default function Dizionario() {
  const router = useRouter();
  const [lessons, setLessons] = useState(memoryCache ? memoryCache.lessons : []);
  const [rules, setRules] = useState(memoryCache ? memoryCache.rules : []);
  const [lexemes, setLexemes] = useState(memoryCache ? memoryCache.lexemes : []);
  const [occurrences, setOccurrences] = useState(memoryCache ? memoryCache.occurrences : []);
  const [loading, setLoading] = useState(!memoryCache);
  const [loadingStep, setLoadingStep] = useState(memoryCache ? "Completato" : "Connessione al database...");
  const [error, setError] = useState(null);

  const [query, setQuery] = useState("");
  const [openLesson, setOpenLesson] = useState(null);

  // Sync search query from URL parameter if present (?q=...)
  useEffect(() => {
    if (router.query.q && typeof router.query.q === "string") {
      setQuery(router.query.q);
    }
  }, [router.query.q]);

  useEffect(() => {
    if (memoryCache) {
      setLoading(false);
      return;
    }

    let isMounted = true;

    async function loadDataProgressive() {
      setLoading(true);
      setError(null);
      setLoadingStep("Caricamento indice grammaticale e lezioni...");

      const timeoutId = setTimeout(() => {
        if (isMounted && loading) {
          setError("Il server Supabase sta impiegando più tempo del previsto. Clicca Riprova per riconnetterti.");
          setLoading(false);
        }
      }, 14000);

      try {
        // Step 1: Fetch lightweight tables first (lessons + rules)
        const [
          { data: lData, error: lErr },
          { data: rData, error: rErr }
        ] = await Promise.all([
          supabase.from("lessons").select("*").order("id", { ascending: true }),
          supabase.from("rules").select("*").order("id", { ascending: true })
        ]);

        if (lErr) throw lErr;
        if (rErr) throw rErr;

        if (isMounted) {
          setLessons(lData || []);
          setRules(rData || []);
          setLoadingStep("Caricamento vocabolario e lessemi griki...");
        }

        // Step 2: Fetch vocabulary lexemes and occurrences
        const [
          { data: lxData, error: lxErr },
          { data: oData, error: oErr }
        ] = await Promise.all([
          supabase.from("lexemes").select("*").order("parola_griko", { ascending: true }),
          supabase.from("occurrences").select("*").order("id", { ascending: true })
        ]);

        if (lxErr) throw lxErr;
        if (oErr) throw oErr;

        clearTimeout(timeoutId);

        if (isMounted) {
          setLexemes(lxData || []);
          setOccurrences(oData || []);
          setLoading(false);

          // Populate cache
          memoryCache = {
            lessons: lData || [],
            rules: rData || [],
            lexemes: lxData || [],
            occurrences: oData || []
          };
        }
      } catch (err) {
        clearTimeout(timeoutId);
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
    };
  }, []);

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

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return [];
    return lexemes
      .filter(
        (lx) =>
          lx.parola_griko.toLowerCase().includes(q) ||
          lx.parola_italiano.toLowerCase().includes(q)
      )
      .map((lx) => {
        const occs = occurrencesByLexeme[lx.id] || [];
        const linkedLessons = occs
          .map((o) => lessonById[o.lesson_id])
          .filter(Boolean);
        return {
          ...lx,
          lessons: linkedLessons,
        };
      });
  }, [query, lexemes, occurrencesByLexeme, lessonById]);

  return (
    <Layout
      title="Dizionario & Grammatica Grika — griko.online"
      description="Consultazione del vocabolario, delle regole grammaticali e delle 73 lezioni della lingua grika salentina."
    >
      <div className="wrap">
        {/* Header Sezione */}
        <div className="editorial-hero" style={{ marginBottom: "32px", padding: "36px 28px" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", flexWrap: "wrap", gap: "12px" }}>
            <div>
              <span className="editorial-hero-tag">Sezione Impara · Corso Daniele Palma</span>
              <h1 style={{ fontSize: "2.4rem", marginBottom: "8px" }}>Dizionario &amp; Grammatica</h1>
            </div>
            <div className="badge-pill-cultural">
              <span>Isola Ellenofona Salentina</span>
            </div>
          </div>
          <p className="sub" style={{ fontSize: "1.1rem" }}>
            Vocabolario ragionato e regole grammaticali del dialetto neo-greco del Salento —{" "}
            {loading ? (
              <span style={{ color: "var(--accent-gold)" }}>{loadingStep}</span>
            ) : error ? (
              <span style={{ color: "var(--accent-terra)" }}>Stato offline</span>
            ) : (
              `${lessons.length} lezioni, ${lexemes.length} lessemi (${occurrences.length} occorrenze registrate), ${rules.length} regole.`
            )}
          </p>
        </div>

        {/* Skeleton Screen durante il caricamento iniziale */}
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
                placeholder="Cerca una parola in griko o in italiano (es. kalimera, terra, mare, mangiare)..."
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
                  Trascrizioni dal corso YouTube di Daniele Palma
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
                              {lRules.length === 0 && lVocab.length === 0 && (
                                <p className="empty">
                                  Nessuna regola o vocabolo estratto per questa lezione.
                                </p>
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
    </Layout>
  );
}
