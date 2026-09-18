import { useState, useMemo } from "react";
import data from "../public/data/griko-data.json";

export default function Home() {
  const [query, setQuery] = useState("");
  const [openLesson, setOpenLesson] = useState(null);

  const lessonById = useMemo(() => {
    const m = {};
    for (const l of data.lessons) m[l.id] = l;
    return m;
  }, []);

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return [];
    return data.vocabulary.filter(
      (v) =>
        v.parola_griko.toLowerCase().includes(q) ||
        v.parola_italiano.toLowerCase().includes(q)
    );
  }, [query]);

  const byCategory = useMemo(() => {
    const m = {};
    for (const l of data.lessons) {
      (m[l.categoria] = m[l.categoria] || []).push(l);
    }
    return m;
  }, []);

  return (
    <main className="wrap">
      <h1>Griko Traduttore</h1>
      <p className="sub">
        Vocabolario e grammatica del Greco Salentino — {data.lessons.length} lezioni,{" "}
        {data.vocabulary.length} voci, {data.rules.length} regole.
      </p>

      <input
        className="search"
        type="text"
        placeholder="Cerca una parola in griko o in italiano…"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />

      {query.trim() && (
        <section>
          <h2>
            {results.length} risultat{results.length === 1 ? "o" : "i"} per “{query.trim()}”
          </h2>
          <ul className="results">
            {results.map((v) => {
              const l = lessonById[v.lesson_id];
              return (
                <li key={v.id}>
                  <span className="griko">{v.parola_griko}</span>
                  <span className="arrow">→</span>
                  <span className="ita">{v.parola_italiano}</span>
                  {l && (
                    <span className="prov">
                      {l.categoria} · {l.titolo}
                    </span>
                  )}
                </li>
              );
            })}
          </ul>
        </section>
      )}

      <section>
        <h2>Indice delle lezioni</h2>
        {Object.keys(byCategory).map((cat) => (
          <div key={cat} className="cat">
            <h3>{cat}</h3>
            <ul className="lessons">
              {byCategory[cat].map((l) => (
                <li key={l.id}>
                  <button
                    className="lesson-btn"
                    onClick={() => setOpenLesson(openLesson === l.id ? null : l.id)}
                  >
                    <span className="lnum">{l.id}</span> {l.titolo}
                    {l.genere ? <em> · {l.genere}</em> : null}
                    {l.desinenza ? <em> · {l.desinenza}</em> : null}
                  </button>
                  {openLesson === l.id && (
                    <div className="detail">
                      {l.rules.length > 0 && (
                        <>
                          <h4>Regole</h4>
                          <ul>
                            {l.rules.map((r) => (
                              <li key={r.id}>{r.regola_testo}</li>
                            ))}
                          </ul>
                        </>
                      )}
                      {l.vocabulary.length > 0 && (
                        <>
                          <h4>Vocabolario ({l.vocabulary.length})</h4>
                          <table className="vtab">
                            <tbody>
                              {l.vocabulary.map((v) => (
                                <tr key={v.id}>
                                  <td className="griko">{v.parola_griko}</td>
                                  <td>{v.parola_italiano}</td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </>
                      )}
                      {l.rules.length === 0 && l.vocabulary.length === 0 && (
                        <p className="empty">Nessuna regola o vocabolo estratto per questa lezione.</p>
                      )}
                    </div>
                  )}
                </li>
              ))}
            </ul>
          </div>
        ))}
      </section>

      <footer>
        Dati estratti dal corso YouTube di Daniele Palma tramite trascrizione automatica. Le forme
        griko non sono state verificate filologicamente.
      </footer>
    </main>
  );
}
