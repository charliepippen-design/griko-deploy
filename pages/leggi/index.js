import { useState, useMemo, useEffect } from "react";
import Link from "next/link";
import Layout from "../../components/Layout";
import { supabase } from "../../lib/supabase";

// Cache in memoria per evitare ri-fetch ad ogni navigazione interna
let memoryCache = null;

// Criterio di ordinamento editoriale: dalla saggezza quotidiana (proverbi)
// all'infanzia (filastrocche), al canto condiviso (canti), al rito del lutto
// (morolòj), fino al racconto lungo della sera (fiabe). Ordine fisso e
// riconoscibile, non alfabetico a caso.
const CATEGORY_META = {
  proverbio: {
    order: 1,
    label: "Proverbi e massime di vita",
    note: "Saggezza tramandata a voce: la famiglia, il lavoro, la ricchezza, la povertà, l'amore.",
  },
  filastrocca: {
    order: 2,
    label: "Filastrocche e ninne nanne",
    note: "Versi per addormentare e per giocare, trasmessi di madre in figlia.",
  },
  canto_popolare: {
    order: 3,
    label: "Canti popolari e religiosi",
    note: "Canti d'amore, di preghiera e di festa cantati nelle case e nelle chiese della Grecìa Salentina.",
  },
  "morolòj": {
    order: 4,
    label: "Morolòj — lamenti funebri",
    note: "Il pianto rituale intonato alla morte di un familiare, forma poetica antichissima.",
  },
  fiaba: {
    order: 5,
    label: "Fiabe popolari",
    note: "Racconti lunghi della tradizione orale salentina, trascritti dalle raccolte storiche.",
  },
};

function categoryMeta(cat) {
  return CATEGORY_META[cat] || { order: 99, label: cat, note: "" };
}

// Estrae il numero da titoli come "Fiaba 92 – ..." per ordinare in modo
// naturale invece che alfabetico ("Fiaba 10" prima di "Fiaba 2" altrimenti).
function leadingNumber(titolo) {
  const m = titolo.match(/(\d+)/);
  return m ? parseInt(m[1], 10) : Number.MAX_SAFE_INTEGER;
}

function excerpt(testo, len = 90) {
  const clean = testo.replace(/\s+/g, " ").trim();
  return clean.length > len ? clean.slice(0, len).trim() + "…" : clean;
}

export default function LeggiPage() {
  const [testi, setTesti] = useState(memoryCache || []);
  const [loading, setLoading] = useState(!memoryCache);
  const [error, setError] = useState(null);
  const [query, setQuery] = useState("");
  const [activeCategory, setActiveCategory] = useState(null); // null = tutte
  const [selected, setSelected] = useState(null); // testo aperto nel pannello di lettura

  useEffect(() => {
    if (memoryCache) return;
    let isMounted = true;

    async function load() {
      setLoading(true);
      setError(null);
      const { data, error: err } = await supabase
        .from("testi_liberi")
        .select("*")
        .order("titolo", { ascending: true });

      if (!isMounted) return;
      if (err) {
        setError(err.message || "Errore di connessione a Supabase");
        setLoading(false);
        return;
      }
      setTesti(data || []);
      memoryCache = data || [];
      setLoading(false);
    }

    load();
    return () => {
      isMounted = false;
    };
  }, []);

  // Chiudi il pannello di lettura con Esc e blocca lo scroll del body mentre è aperto
  useEffect(() => {
    if (!selected) return;
    const onKey = (e) => e.key === "Escape" && setSelected(null);
    document.addEventListener("keydown", onKey);
    document.body.style.overflow = "hidden";
    return () => {
      document.removeEventListener("keydown", onKey);
      document.body.style.overflow = "";
    };
  }, [selected]);

  const byCategory = useMemo(() => {
    const m = {};
    for (const t of testi) {
      (m[t.categoria] = m[t.categoria] || []).push(t);
    }
    for (const cat of Object.keys(m)) {
      m[cat].sort((a, b) => {
        const na = leadingNumber(a.titolo);
        const nb = leadingNumber(b.titolo);
        if (na !== nb) return na - nb;
        return a.titolo.localeCompare(b.titolo, "it");
      });
    }
    return m;
  }, [testi]);

  const orderedCategories = useMemo(
    () => Object.keys(byCategory).sort((a, b) => categoryMeta(a).order - categoryMeta(b).order),
    [byCategory]
  );

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return [];
    return testi.filter(
      (t) => t.titolo.toLowerCase().includes(q) || t.testo.toLowerCase().includes(q)
    );
  }, [query, testi]);

  const visibleCategories = activeCategory
    ? orderedCategories.filter((c) => c === activeCategory)
    : orderedCategories;

  return (
    <Layout
      title="Leggi — griko.online"
      description="Antologia di testi tradizionali del griko: fiabe, canti popolari, morolòj, filastrocche e proverbi, con fonte citata."
    >
      <div className="wrap">
        <div className="editorial-hero">
          <span className="editorial-hero-tag">Antologia di Testi</span>
          <h1>Leggi</h1>
          <p className="sub">
            {loading
              ? "Caricamento antologia in corso..."
              : error
              ? "Stato offline"
              : `${testi.length} testi della tradizione orale salentina, organizzati per genere.`}
          </p>
          <p className="sub" style={{ fontSize: "0.9rem" }}>
            Fiabe, canti, morolòj, filastrocche e proverbi trascritti da fonti
            popolari libere da diritti d'autore. Ogni testo riporta la pagina
            di provenienza.
          </p>
        </div>

        {loading && testi.length === 0 ? (
          <div className="skeleton-container" aria-label="Caricamento antologia in corso...">
            <div className="testi-grid">
              {[1, 2, 3, 4, 5, 6].map((i) => (
                <div key={i} className="skeleton-box skeleton-shimmer" style={{ height: "108px", borderRadius: "14px" }} />
              ))}
            </div>
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
            <div className="search-wrap">
              <input
                className="search"
                type="text"
                placeholder="Cerca un testo per titolo o parola contenuta..."
                value={query}
                onChange={(e) => setQuery(e.target.value)}
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

            {query.trim() ? (
              <section className="testi-section" style={{ borderTop: "none", paddingTop: 0 }}>
                <h2>
                  {results.length} risultat{results.length === 1 ? "o" : "i"} per “{query.trim()}”
                </h2>
                {results.length === 0 ? (
                  <p className="empty">Nessun testo trovato per questo termine di ricerca.</p>
                ) : (
                  <div className="testi-grid">
                    {results.map((t) => (
                      <TestoCard key={t.slug} t={t} onOpen={() => setSelected(t)} />
                    ))}
                  </div>
                )}
              </section>
            ) : (
              <>
                <div className="testi-category-filter">
                  <button
                    type="button"
                    className={`testi-filter-chip ${!activeCategory ? "active" : ""}`}
                    onClick={() => setActiveCategory(null)}
                  >
                    Tutte le categorie ({testi.length})
                  </button>
                  {orderedCategories.map((cat) => (
                    <button
                      key={cat}
                      type="button"
                      className={`testi-filter-chip ${activeCategory === cat ? "active" : ""}`}
                      onClick={() => setActiveCategory(cat)}
                    >
                      {categoryMeta(cat).label} ({byCategory[cat].length})
                    </button>
                  ))}
                </div>

                {visibleCategories.map((cat) => {
                  const meta = categoryMeta(cat);
                  return (
                    <section key={cat} className="testi-section">
                      <div className="testi-section-head">
                        <h3>{meta.label}</h3>
                        <span className="testi-section-count">{byCategory[cat].length} testi</span>
                      </div>
                      {meta.note && <p className="testi-section-note">{meta.note}</p>}

                      <div className="testi-grid">
                        {byCategory[cat].map((t) => (
                          <TestoCard key={t.slug} t={t} onOpen={() => setSelected(t)} />
                        ))}
                      </div>
                    </section>
                  );
                })}
              </>
            )}
          </>
        )}

        <p style={{ marginTop: "16px" }}>
          <Link href="/" className="section-card-action">
            ← Torna alla Home page
          </Link>
        </p>
      </div>

      {selected && (
        <div
          className="reading-overlay"
          onClick={(e) => e.target === e.currentTarget && setSelected(null)}
        >
          <div className="reading-panel" role="dialog" aria-modal="true">
            <button
              type="button"
              className="reading-close"
              onClick={() => setSelected(null)}
              aria-label="Chiudi lettura"
            >
              ✕
            </button>
            <span className="reading-panel-tag">{categoryMeta(selected.categoria).label}</span>
            <h2>{selected.titolo}</h2>
            <p className="reading-panel-text">{selected.testo}</p>
            <p className="reading-panel-source">
              Fonte: <a href={selected.url_fonte} target="_blank" rel="noopener noreferrer">{selected.url_fonte}</a>
              {" · "}
              {selected.licenza === "pubblico_dominio_tradizione_orale"
                ? "pubblico dominio / tradizione orale"
                : selected.licenza}
            </p>
          </div>
        </div>
      )}
    </Layout>
  );
}

function TestoCard({ t, onOpen }) {
  return (
    <button type="button" className="testo-card" onClick={onOpen}>
      <span className="testo-card-title">{t.titolo}</span>
      <span className="testo-card-excerpt">{excerpt(t.testo)}</span>
    </button>
  );
}
