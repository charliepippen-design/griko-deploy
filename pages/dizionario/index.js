import { useState, useMemo, useEffect } from "react";
import { useRouter } from "next/router";
import Layout from "../../components/Layout";
import { getDizionarioProps } from "../../lib/archive.mjs";
import carmineData from "../../data/carmine_greco_lessons.json";

const CARMINE_CATEGORIES = [
  { id: "tutte", label: "Tutte le lezioni" },
  { id: "fonetica", label: "Fonetica & Alfabeto" },
  { id: "nomi", label: "Morfologia Nominale" },
  { id: "aggettivi", label: "Aggettivi" },
  { id: "pronomi_numerali", label: "Pronomi & Numerali" },
  { id: "invariabili", label: "Parti Invariabili" },
  { id: "verbi", label: "Sistema Verbale" },
];

export default function Dizionario({
  lessons = [],
  rules = [],
  lexemes = [],
  occurrences = [],
  carmineRules = [],
  carmineLexemes = [],
  carmineOccurrences = [],
}) {
  const router = useRouter();

  const [activeCourse, setActiveCourse] = useState("palma");
  const [query, setQuery] = useState("");

  // Metadati del corso (titolo, durata, proverbio, link YouTube) dal JSON senza
  // trascrizione. Regole e vocabolario arrivano dalle props.
  const carmineLessons = useMemo(
    () => carmineData.lessons.filter((lesson) => !lesson.is_poetry),
    []
  );
  const [carmineCategory, setCarmineCategory] = useState("tutte");
  const [carmineSearch, setCarmineSearch] = useState("");

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

  const lessonById = useMemo(() => {
    const map = {};
    for (const lesson of lessons) map[lesson.id] = lesson;
    return map;
  }, [lessons]);

  const lexemeById = useMemo(() => {
    const map = {};
    for (const lexeme of lexemes) map[lexeme.id] = lexeme;
    return map;
  }, [lexemes]);

  const occurrencesByLesson = useMemo(() => {
    const map = {};
    for (const occurrence of occurrences) {
      (map[occurrence.lesson_id] = map[occurrence.lesson_id] || []).push(occurrence);
    }
    return map;
  }, [occurrences]);

  const occurrencesByLexeme = useMemo(() => {
    const map = {};
    for (const occurrence of occurrences) {
      (map[occurrence.lexeme_id] = map[occurrence.lexeme_id] || []).push(occurrence);
    }
    return map;
  }, [occurrences]);

  const rulesByLesson = useMemo(() => {
    const map = {};
    for (const rule of rules) {
      (map[rule.lesson_id] = map[rule.lesson_id] || []).push(rule);
    }
    return map;
  }, [rules]);

  const byCategory = useMemo(() => {
    const map = {};
    for (const lesson of lessons) {
      (map[lesson.categoria] = map[lesson.categoria] || []).push(lesson);
    }
    return map;
  }, [lessons]);

  const carmineLessonById = useMemo(() => {
    const map = {};
    for (const lesson of carmineLessons) map[lesson.order] = lesson;
    return map;
  }, [carmineLessons]);

  const carmineRulesByLesson = useMemo(() => {
    const map = {};
    for (const rule of carmineRules) {
      (map[rule.lesson_id] = map[rule.lesson_id] || []).push(rule);
    }
    return map;
  }, [carmineRules]);

  const carmineLexemeById = useMemo(() => {
    const map = {};
    for (const lexeme of carmineLexemes) map[lexeme.id] = lexeme;
    return map;
  }, [carmineLexemes]);

  const carmineOccurrencesByLesson = useMemo(() => {
    const map = {};
    for (const occurrence of carmineOccurrences) {
      (map[occurrence.lesson_id] = map[occurrence.lesson_id] || []).push(occurrence);
    }
    return map;
  }, [carmineOccurrences]);

  const carmineOccurrencesByLexeme = useMemo(() => {
    const map = {};
    for (const occurrence of carmineOccurrences) {
      (map[occurrence.lexeme_id] = map[occurrence.lexeme_id] || []).push(occurrence);
    }
    return map;
  }, [carmineOccurrences]);

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return [];

    const palmaResults = lexemes
      .filter(
        (lexeme) =>
          lexeme.parola_griko.toLowerCase().includes(q) ||
          lexeme.parola_italiano.toLowerCase().includes(q)
      )
      .map((lexeme) => {
        const occs = occurrencesByLexeme[lexeme.id] || [];
        const linkedLessons = occs
          .map((occurrence) => lessonById[occurrence.lesson_id])
          .filter(Boolean)
          .map((lesson) => ({ id: lesson.id, titolo: lesson.titolo, categoria: lesson.categoria }));
        return {
          id: `palma-${lexeme.id}`,
          source: "palma",
          parola_griko: lexeme.parola_griko,
          parola_italiano: lexeme.parola_italiano,
          lessons: linkedLessons,
        };
      });

    const carmineResults = carmineLexemes
      .filter(
        (lexeme) =>
          lexeme.parola_griko.toLowerCase().includes(q) ||
          lexeme.parola_italiano.toLowerCase().includes(q)
      )
      .map((lexeme) => {
        const occs = carmineOccurrencesByLexeme[lexeme.id] || [];
        const linkedLessons = occs
          .map((occurrence) => carmineLessonById[occurrence.lesson_id])
          .filter(Boolean)
          .map((lesson) => ({ id: lesson.order, titolo: lesson.title, categoria: lesson.category_label }));
        return {
          id: `carmine-${lexeme.id}`,
          source: "carmine",
          parola_griko: lexeme.parola_griko,
          parola_italiano: lexeme.parola_italiano,
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

  const filteredCarmineLessons = useMemo(() => {
    return carmineLessons.filter((lesson) => {
      const matchCat = carmineCategory === "tutte" || lesson.category === carmineCategory;
      const q = carmineSearch.trim().toLowerCase();
      const matchSearch =
        !q ||
        lesson.title.toLowerCase().includes(q) ||
        lesson.summary.toLowerCase().includes(q) ||
        (lesson.proverb && lesson.proverb.toLowerCase().includes(q));
      return matchCat && matchSearch;
    });
  }, [carmineLessons, carmineCategory, carmineSearch]);

  return (
    <Layout
      title="Dizionario e Grammatica Grika | griko.online"
      description="Consultazione del vocabolario, del corso sistematico di Carmine Greco (24 lezioni) e delle 73 lezioni di Daniele Palma."
    >
      <div className="wrap">
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

        <div className="course-author-switcher">
          <button
            type="button"
            className={`course-tab-btn ${activeCourse === "palma" ? "active" : ""}`}
            onClick={() => setActiveCourse("palma")}
          >
            <span className="course-tab-title">Corso a Micro-Regole di Daniele Palma</span>
            <span className="course-tab-meta">
              {lessons.length} lezioni brevi · {lexemes.length} lessemi bilingui · {rules.length} regole morfologiche
            </span>
          </button>

          <button
            type="button"
            className={`course-tab-btn ${activeCourse === "carmine" ? "active" : ""}`}
            onClick={() => setActiveCourse("carmine")}
          >
            <span className="course-tab-title">Corso Sistematico di Carmine Greco</span>
            <span className="course-tab-meta">
              {carmineLessons.length} lezioni organiche · {carmineLexemes.length} lessemi bilingui · {carmineRules.length} regole grammaticali
            </span>
          </button>
        </div>

        <div hidden={activeCourse !== "palma"}>
          {lessons.length === 0 ? (
            <p className="empty">Nessuna lezione è disponibile nell'archivio locale.</p>
          ) : (
            <>
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

              {query.trim() && (
                <section style={{ marginBottom: "40px" }}>
                  <h2>
                    {results.length} risultat{results.length === 1 ? "o" : "i"} per “{query.trim()}”
                  </h2>
                  {results.length === 0 ? (
                    <p className="empty">Nessun lessema trovato per questo termine di ricerca.</p>
                  ) : (
                    <ul className="results">
                      {results.map((voce) => (
                        <li key={voce.id}>
                          <span
                            className="src-badge"
                            title={voce.source === "carmine" ? "Corso di Carmine Greco" : "Corso di Daniele Palma"}
                          >
                            {voce.source === "carmine" ? "Carmine Greco" : "Daniele Palma"}
                          </span>
                          <span className="griko notranslate" translate="no">{voce.parola_griko}</span>
                          <span className="arrow">→</span>
                          <span className="ita">{voce.parola_italiano}</span>
                          {voce.lessons && voce.lessons.length > 0 && (
                            <span className="prov">
                              {voce.lessons.map((lesson, idx) => (
                                <span key={lesson.id}>
                                  {idx > 0 && " · "}
                                  {lesson.categoria} · {lesson.titolo}
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

              <section>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", flexWrap: "wrap", marginBottom: "16px" }}>
                  <h2>Indice ragionato delle {lessons.length} lezioni</h2>
                  <span style={{ fontSize: "0.85rem", color: "var(--text-tertiary)" }}>
                    Trascrizioni didattiche di Daniele Palma
                  </span>
                </div>

                {Object.keys(byCategory).map((cat) => (
                  <div key={cat} className="cat">
                    <h3>{cat}</h3>
                    <ul className="lessons">
                      {byCategory[cat].map((lesson) => {
                        const lessonRules = rulesByLesson[lesson.id] || [];
                        const lessonVocab = (occurrencesByLesson[lesson.id] || [])
                          .map((occurrence) => lexemeById[occurrence.lexeme_id])
                          .filter(Boolean);

                        return (
                          <li key={lesson.id}>
                            <details className="lesson-details">
                              <summary className="lesson-btn">
                                <span className="lnum">{lesson.id}</span>
                                <span className="lesson-title-text">{lesson.titolo}</span>
                                {lesson.genere ? <em> · {lesson.genere}</em> : null}
                                {lesson.desinenza ? <em> · {lesson.desinenza}</em> : null}
                                <span className="lesson-expand-arrow arrow-closed" aria-hidden="true">▼</span>
                                <span className="lesson-expand-arrow arrow-open" aria-hidden="true">▲</span>
                              </summary>
                              <LessonBody rules={lessonRules} vocab={lessonVocab} />
                            </details>
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

        <div hidden={activeCourse !== "carmine"}>
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

          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "20px", color: "var(--text-secondary)", fontSize: "0.9rem" }}>
            <span>
              Visualizzando <strong>{filteredCarmineLessons.length}</strong> su {carmineLessons.length} lezioni
            </span>
            <span style={{ fontSize: "0.8rem", color: "var(--text-tertiary)" }}>
              Audio e lezioni originali di Carmine Greco
            </span>
          </div>

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
              filteredCarmineLessons.map((lesson) => {
                const lessonRules = carmineRulesByLesson[lesson.order] || [];
                const lessonVocab = (carmineOccurrencesByLesson[lesson.order] || [])
                  .map((occurrence) => carmineLexemeById[occurrence.lexeme_id])
                  .filter(Boolean);
                return (
                  <article key={lesson.video_id} className="carmine-card">
                    <div className="carmine-card-top">
                      <div className="carmine-badges-group">
                        <span className="carmine-num-badge">#{String(lesson.order).padStart(2, "0")}</span>
                        <span className="carmine-cat-badge">{lesson.category_label}</span>
                      </div>
                      <div className="carmine-meta-info">
                        <span>⏱ {lesson.duration} min</span>
                        <span>·</span>
                        <span>~{lesson.words_count} parole</span>
                      </div>
                    </div>

                    <h2 className="carmine-lesson-heading">{lesson.title}</h2>
                    <p className="carmine-summary-body">{lesson.summary}</p>

                    {lesson.proverb && (
                      <div className="carmine-proverb-highlight">
                        <strong>Proverbio commentato:</strong> {lesson.proverb}
                      </div>
                    )}

                    <div className="carmine-card-actions">
                      <a
                        href={lesson.youtube_url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="carmine-yt-link"
                      >
                        Guarda la lezione su YouTube ↗
                      </a>
                    </div>

                    {lessonRules.length === 0 && lessonVocab.length === 0 ? null : (
                      <details className="lesson-details">
                        <summary className="lesson-btn" style={{ marginTop: "10px" }}>
                          <span className="lesson-title-text">
                            Regole ({lessonRules.length}) e vocabolario ({lessonVocab.length}) di questa lezione
                          </span>
                          <span className="lesson-expand-arrow arrow-closed" aria-hidden="true">▼</span>
                          <span className="lesson-expand-arrow arrow-open" aria-hidden="true">▲</span>
                        </summary>
                        <LessonBody rules={lessonRules} vocab={lessonVocab} />
                      </details>
                    )}
                  </article>
                );
              })
            )}
          </div>
        </div>
      </div>
    </Layout>
  );
}

function LessonBody({ rules, vocab }) {
  if (rules.length === 0 && vocab.length === 0) {
    return (
      <div className="detail">
        <p className="empty">Nessuna regola o voce di vocabolario per questa lezione.</p>
      </div>
    );
  }
  return (
    <div className="detail">
      {rules.length > 0 && (
        <>
          <h4>Regole grammaticali ({rules.length})</h4>
          <ul>
            {rules.map((rule) => (
              <li key={rule.id}>{rule.regola_testo}</li>
            ))}
          </ul>
        </>
      )}
      {vocab.length > 0 && (
        <>
          <h4>Vocabolario estratto ({vocab.length})</h4>
          <table className="vtab">
            <tbody>
              {vocab.map((voce) => (
                <tr key={voce.id}>
                  <td className="griko notranslate" translate="no">{voce.parola_griko}</td>
                  <td>{voce.parola_italiano}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}
    </div>
  );
}

export function getStaticProps() {
  return getDizionarioProps();
}
