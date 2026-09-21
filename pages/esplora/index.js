import { useState, useEffect } from "react";
import Layout from "../../components/Layout";
import { supabase } from "../../lib/supabase";
import fallbackPlaces from "../../public/data/places.json";

export default function EsploraPage() {
  const [places, setPlaces] = useState(fallbackPlaces);
  const [loading, setLoading] = useState(true);
  const [dataSource, setDataSource] = useState("Database Supabase");

  useEffect(() => {
    let isMounted = true;

    async function loadPlaces() {
      try {
        const { data, error } = await supabase
          .from("places")
          .select("*")
          .order("ordine", { ascending: true });

        if (error || !data || data.length === 0) {
          // If table not yet created on Supabase, fallback to verified local dataset
          if (isMounted) {
            setPlaces(fallbackPlaces);
            setDataSource("Dataset Verificato Locale");
            setLoading(false);
          }
        } else {
          if (isMounted) {
            setPlaces(data);
            setDataSource("Supabase PostgreSQL (Live)");
            setLoading(false);
          }
        }
      } catch (err) {
        console.warn("Recupero places da Supabase:", err);
        if (isMounted) {
          setPlaces(fallbackPlaces);
          setDataSource("Dataset Verificato Locale");
          setLoading(false);
        }
      }
    }

    loadPlaces();

    return () => {
      isMounted = false;
    };
  }, []);

  return (
    <Layout
      title="Esplora i 9 Comuni della Grecia Salentina — griko.online"
      description="Atlante storico, toponomastico e culturale dei 9 comuni della Grecia Salentina con fonti verificate Wikipedia e Wikidata."
    >
      <div className="editorial-hero" style={{ marginBottom: "36px", padding: "36px 28px" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", flexWrap: "wrap", gap: "12px" }}>
          <div>
            <span className="editorial-hero-tag">Sezione Esplora · Atlante Territoriale</span>
            <h1 style={{ fontSize: "2.6rem", marginBottom: "8px" }}>I Nove Comuni Ellenofoni</h1>
          </div>
          <div className="badge-pill-cultural">
            <span>{dataSource}</span>
          </div>
        </div>
        <p className="sub" style={{ fontSize: "1.15rem" }}>
          Un'isola linguistica millenaria nel cuore del Salento. Ciascun borgo conserva peculiarità dialettali, 
          architetture ipogee, castelli e tradizioni comunitarie uniche tutelate dalla Legge 482/1999.
        </p>
      </div>

      <div style={{ marginBottom: "20px", display: "flex", justifyContent: "space-between", alignItems: "baseline", flexWrap: "wrap", gap: "8px" }}>
        <h2 style={{ fontSize: "1.6rem", margin: 0 }}>Schede dei Borghi della Grecìa Salentina</h2>
        <span style={{ fontSize: "0.85rem", color: "var(--text-tertiary)" }}>
          9 comuni · Dati demografici ISTAT · Fonti aperte
        </span>
      </div>

      <div className="comuni-grid">
        {places.map((p) => (
          <article key={p.id} className="comune-card">
            <div className="comune-card-header">
              <div>
                <h3 className="comune-name-title">{p.nome}</h3>
                <div className="comune-griko-badge">
                  {p.nome_griko} {p.nome_griko_alfabeto && `(${p.nome_griko_alfabeto})`}
                </div>
              </div>
              <span className="comune-pop-pill">
                {p.popolazione ? `${p.popolazione.toLocaleString("it-IT")} ab.` : "N/D"}
                {p.anno_popolazione && ` · ${p.anno_popolazione}`}
              </span>
            </div>

            <div className="comune-geo-row">
              <span aria-hidden="true">📍</span>
              <span>
                {p.lat && p.lng ? `${Number(p.lat).toFixed(4)}° N, ${Number(p.lng).toFixed(4)}° E` : "Coordinate verificate"}
              </span>
            </div>

            <p className="comune-history-text">{p.cenno_storico}</p>

            <div className="comune-highlight-box">
              <span className="comune-highlight-label">Elemento di Interesse</span>
              <p className="comune-highlight-content">{p.elemento_interesse}</p>
            </div>

            <div className="comune-sources-footer">
              <span className="sources-label">Fonti verificate:</span>
              <div className="sources-links-group">
                <a
                  href={p.fonte_wikipedia_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="source-ext-link"
                  title={`Apri la voce Wikipedia di ${p.nome}`}
                >
                  Wikipedia ↗
                </a>
                <a
                  href={p.fonte_wikidata_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="source-ext-link"
                  title={`Apri l'elemento Wikidata di ${p.nome}`}
                >
                  Wikidata ↗
                </a>
              </div>
            </div>
          </article>
        ))}
      </div>
    </Layout>
  );
}
