import { useState } from "react";
import { useRouter } from "next/router";
import Link from "next/link";
import Layout from "../components/Layout";
import PoeticCarousel from "../components/PoeticCarousel";

const SECTIONS = [
  {
    title: "Impara",
    glyph: "Γ",
    href: "/dizionario",
    tag: "Vocabolario & 73 Lezioni",
    description: "Consulta 684 lessemi, le regole grammaticali sistematiche e l'indice delle 73 lezioni trascritte dal corso di Daniele Palma.",
    subtext: "Vocabolario bilingue · Ricerca live",
    cta: "Apri il dizionario →",
  },
  {
    title: "Ascolta",
    glyph: "♫",
    href: "/ascolta",
    tag: "Archivio Sonoro Vivo",
    description: "In preparazione: registrazioni sul campo di parlanti nativi, canti tradizionali polifonici e testimonianze orali della Grecìa.",
    subtext: "Canti salentini · Parlato autentico",
    cta: "Scopri la sezione →",
  },
  {
    title: "Leggi",
    glyph: "𝚪",
    href: "/leggi",
    tag: "Testi & Poesia Salentina",
    description: "Antologia di componimenti tradizionali, canti di lavoro, ninne nanne e proverbi popolari con traduzione italiana a fronte.",
    subtext: "Testo a fronte · Poesia popolare",
    cta: "Leggi l'antologia →",
  },
  {
    title: "Esplora",
    glyph: "🏛",
    href: "/esplora",
    tag: "Atlante dei 9 Comuni",
    description: "Schede storiche e territoriali dei nove borghi ellenofoni: toponomastica in lingua, parchi di pozzelle, castelli e cripte rupestri.",
    subtext: "9 Comuni · Dati storici e fonti verificate",
    cta: "Esplora i comuni →",
  },
  {
    title: "Persone",
    glyph: "✦",
    href: "/persone",
    tag: "Memoria & Custodi",
    description: "I volti, le biografie e le testimonianze dei poeti, studiosi e anziani parlanti che hanno tramandato e difeso l'idioma griko.",
    subtext: "Biografie · Testimonianze orali",
    cta: "Vedi le storie →",
  },
  {
    title: "Archivio",
    glyph: "📜",
    href: "/archivio",
    tag: "Fonti & Glossari Storici",
    description: "Raccolta digitale di glossari d'epoca, studi filologici, pubblicazioni accademiche e documenti ad accesso libero per la ricerca.",
    subtext: "Documentazione aperta · Bibliografia",
    cta: "Accedi all'archivio →",
  },
  {
    title: "Il Progetto",
    glyph: "★",
    href: "/il-progetto",
    tag: "Metodologia & Origine",
    description: "La visione di griko.online: documentazione partecipata indipendente, trasparenza sulle fonti YouTube di Daniele Palma e contributi aperti.",
    subtext: "Progetto indipendente · Trasparenza",
    cta: "Leggi la genesi →",
  },
];

const MUNICIPALITIES_PREVIEW = [
  { name: "Calimera", griko: "Kalimèra" },
  { name: "Castrignano dei Greci", griko: "Kascignana" },
  { name: "Corigliano d'Otranto", griko: "Choriàna" },
  { name: "Martano", griko: "Martana" },
  { name: "Melpignano", griko: "Lipignana" },
  { name: "Soleto", griko: "Sulìto" },
  { name: "Sternatia", griko: "Chóra" },
  { name: "Zollino", griko: "Tzuḍḍinu" },
  { name: "Carpignano Salentino", griko: "Carpignanu" },
];

export default function HomePage() {
  const router = useRouter();
  const [quickQuery, setQuickQuery] = useState("");

  const handleSearchSubmit = (e) => {
    e.preventDefault();
    if (quickQuery.trim()) {
      router.push(`/dizionario?q=${encodeURIComponent(quickQuery.trim())}`);
    } else {
      router.push("/dizionario");
    }
  };

  return (
    <Layout
      title="griko.online — Lingua, memoria e cultura della Grecia Salentina"
      description="Portale culturale dedicato alla tutela, studio e documentazione del patrimonio linguistico griko: dizionario, grammatica, borghi ellenofoni e archivio."
    >
      {/* Carosello Poetico Salento, Mare e Grecia Salentina */}
      <PoeticCarousel />

      {/* Hero Section Ridisegnata con Profondità Culturale */}
      <section className="portal-hero">
        <div className="portal-hero-grid">
          {/* Colonna Sinistra: Manifesto e Ricerca Immediata */}
          <div className="portal-hero-left">
            <div className="hero-cultural-badge">
              <span className="badge-dot" />
              <span>Patrimonio Linguistico Minoritario · Legge 482/1999</span>
            </div>

            <h1 className="hero-main-title">
              Lingua, memoria e cultura della Grecìa Salentina
            </h1>

            <p className="hero-manifesto-text">
              Non soltanto un traduttore: uno spazio digitale aperto e rigoroso per esplorare 
              il patrimonio neo-greco del Salento, dalla grammatica parlata alla memoria monumentale dei nove borghi ellenofoni.
            </p>

            {/* Quick Search Bar Integrata */}
            <form onSubmit={handleSearchSubmit} className="hero-search-form">
              <div className="hero-search-input-box">
                <span className="search-symbol-icon" aria-hidden="true">🔍</span>
                <input
                  type="text"
                  className="hero-search-field"
                  placeholder="Cerca un termine in griko o italiano (es. kalimera, terra, pràma)..."
                  value={quickQuery}
                  onChange={(e) => setQuickQuery(e.target.value)}
                  aria-label="Cerca nel vocabolario"
                />
                <button type="submit" className="hero-search-submit">
                  Cerca nel dizionario →
                </button>
              </div>

              <div className="hero-quick-tags">
                <span className="quick-tags-label">Ricerche frequenti:</span>
                {["Kalimèra", "terra", "matthia", "pràma", "chora", "glossa"].map((word) => (
                  <Link
                    key={word}
                    href={`/dizionario?q=${encodeURIComponent(word)}`}
                    className="hero-tag-link"
                  >
                    {word}
                  </Link>
                ))}
              </div>
            </form>
          </div>

          {/* Colonna Destra: Card Identitaria Salentina */}
          <div className="portal-hero-right">
            <div className="salento-feature-card">
              <div className="card-top-accent">
                <span className="glyph-watermark">Γ</span>
                <span className="heritage-tag">Identità Ellenofona</span>
              </div>

              <blockquote className="griko-motto">
                “I glossa ma en ghiati ena pràma chariatiko, ma en i kardìa ma.”
              </blockquote>
              <cite className="griko-motto-trans">
                «La nostra lingua non è cosa rozza: è il nostro cuore.»
              </cite>

              <div className="hero-stats-row">
                <div className="stat-item">
                  <span className="stat-number">73</span>
                  <span className="stat-label">Lezioni Didattiche</span>
                </div>
                <div className="stat-item">
                  <span className="stat-number">684</span>
                  <span className="stat-label">Lessemi Registrati</span>
                </div>
                <div className="stat-item">
                  <span className="stat-number">9</span>
                  <span className="stat-label">Comuni Salentini</span>
                </div>
              </div>

              <div className="card-footer-action">
                <Link href="/dizionario" className="button-accent-full">
                  Consulta il Vocabolario Completo →
                </Link>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Barra Territoriale Panoramica dei 9 Comuni */}
      <section className="municipalities-strip">
        <div className="strip-header">
          <span className="strip-title">I Nove Comuni della Grecìa Salentina</span>
          <Link href="/esplora" className="strip-link">
            Vedi l'atlante completo dei comuni →
          </Link>
        </div>
        <div className="strip-pills">
          {MUNICIPALITIES_PREVIEW.map((m) => (
            <Link key={m.name} href="/esplora" className="municipality-pill">
              <span className="m-name">{m.name}</span>
              <span className="m-griko">{m.griko}</span>
            </Link>
          ))}
        </div>
      </section>

      {/* Griglia delle Sezioni Principali Ridisegnata */}
      <section className="portal-sections-area">
        <div className="sections-header-block">
          <h2>Sezioni del Portale</h2>
          <p>
            Un percorso culturale integrato per apprendere la lingua, consultare le fonti storiche e scoprire la geografia della Grecìa Salentina.
          </p>
        </div>

        <div className="rich-section-grid">
          {SECTIONS.map((sec) => (
            <Link key={sec.href} href={sec.href} className="rich-section-card">
              <div className="card-header-row">
                <span className="card-glyph-badge" aria-hidden="true">
                  {sec.glyph}
                </span>
                <span className="card-meta-tag">{sec.tag}</span>
              </div>

              <h3 className="card-main-title">{sec.title}</h3>
              <p className="card-desc-body">{sec.description}</p>

              <div className="card-bottom-row">
                <span className="card-subtext">{sec.subtext}</span>
                <span className="card-cta-action">{sec.cta}</span>
              </div>
            </Link>
          ))}
        </div>
      </section>
    </Layout>
  );
}
