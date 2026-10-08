import { useState, useMemo } from "react";
import Link from "next/link";
import Layout from "../../components/Layout";
import TestoCredit from "../../components/TestoCredit";
import { getLeggiIndexProps } from "../../lib/archive.mjs";
import { categoryMeta, isGrikoText, leadingNumber } from "../../lib/testiMeta";

export default function LeggiPage({ testi = [], ricercaCompleta = false }) {
  const [query, setQuery] = useState("");
  const [activeCategory, setActiveCategory] = useState(null);

  const byCategory = useMemo(() => {
    const grouped = {};
    for (const testo of testi) {
      (grouped[testo.categoria] = grouped[testo.categoria] || []).push(testo);
    }
    for (const cat of Object.keys(grouped)) {
      grouped[cat].sort((a, b) => {
        const na = leadingNumber(a.titolo);
        const nb = leadingNumber(b.titolo);
        if (na !== nb) return na - nb;
        return a.titolo.localeCompare(b.titolo, "it");
      });
    }
    return grouped;
  }, [testi]);

  const orderedCategories = useMemo(
    () => Object.keys(byCategory).sort((a, b) => categoryMeta(a).order - categoryMeta(b).order),
    [byCategory]
  );

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return [];
    return testi.filter((testo) => {
      const haystack = `${testo.titolo}\n${testo.testo || testo.anteprima || ""}`.toLowerCase();
      return haystack.includes(q);
    });
  }, [query, testi]);

  const visibleCategories = activeCategory
    ? orderedCategories.filter((cat) => cat === activeCategory)
    : orderedCategories;

  return (
    <Layout
      title="Leggi | griko.online"
      description="Antologia di testi tradizionali del griko: fiabe, canti popolari, morolòj, filastrocche e proverbi, con fonte citata."
    >
      <div className="wrap">
        <div className="editorial-hero">
          <span className="editorial-hero-tag">Antologia di Testi</span>
          <h1>Leggi</h1>
          <p className="sub">
            {testi.length > 0
              ? `${testi.length} testi della tradizione orale salentina, organizzati per genere.`
              : "Antologia non disponibile in archivio."}
          </p>
          <p className="sub" style={{ fontSize: "0.9rem" }}>
            Fiabe, canti, morolòj, filastrocche e proverbi. Le trascrizioni e le
            traduzioni italiane tratte da Ciuri ce Pedì sono di Salvatore Tommasi,
            con licenza CC BY-NC 4.0. La Matinata di Vito Domenico Palumbo è in
            pubblico dominio.
          </p>
        </div>

        {testi.length === 0 ? (
          <p className="empty">Nessun testo è disponibile nell'archivio locale.</p>
        ) : (
          <>
            <div className="search-wrap">
              <input
                className="search"
                type="text"
                placeholder={
                  ricercaCompleta
                    ? "Cerca un testo per titolo o parola contenuta..."
                    : "Cerca un testo per titolo o anteprima..."
                }
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
            {!ricercaCompleta && (
              <p className="empty" style={{ marginTop: "-12px" }}>
                La ricerca in questa pagina confronta titolo e anteprima. Il testo intero è nella scheda di ogni componimento.
              </p>
            )}

            {query.trim() ? (
              <section className="testi-section" style={{ borderTop: "none", paddingTop: 0 }}>
                <h2>
                  {results.length} risultat{results.length === 1 ? "o" : "i"} per “{query.trim()}”
                </h2>
                {results.length === 0 ? (
                  <p className="empty">Nessun testo trovato per questo termine di ricerca.</p>
                ) : (
                  <div className="testi-grid">
                    {results.map((testo) => (
                      <TestoCard key={testo.slug} testo={testo} />
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
                        {byCategory[cat].map((testo) => (
                          <TestoCard key={testo.slug} testo={testo} />
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
    </Layout>
  );
}

function TestoCard({ testo }) {
  const preview = testo.anteprima || "";
  return (
    <article className="testo-card">
      <Link href={`/leggi/${testo.slug}`} className="testo-card-link">
        <span className="testo-card-title">{testo.titolo}</span>
        {isGrikoText(testo.categoria) ? (
          <span className="testo-card-excerpt notranslate" translate="no">{preview}</span>
        ) : (
          <span className="testo-card-excerpt">{preview}</span>
        )}
      </Link>
      <TestoCredit credito={testo.credito} className="testo-card-credit" />
    </article>
  );
}

export function getStaticProps() {
  return getLeggiIndexProps();
}
