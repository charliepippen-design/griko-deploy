import Head from "next/head";
import Link from "next/link";
import { useRouter } from "next/router";
import { useState } from "react";
import ThemeToggle from "./ThemeToggle";
import CookieBanner from "./CookieBanner";

const NAV_ITEMS = [
  { label: "Home", href: "/" },
  { label: "Impara", href: "/dizionario" },
  { label: "Ascolta", href: "/ascolta" },
  { label: "Leggi", href: "/leggi" },
  { label: "Esplora", href: "/esplora" },
  { label: "Persone", href: "/persone" },
  { label: "Archivio", href: "/archivio" },
  { label: "Il Progetto", href: "/il-progetto" },
];

export default function Layout({
  children,
  title = "griko.online — Lingua e cultura della Grecia Salentina",
  description = "Portale dedicato alla tutela, documentazione e riscoperta della lingua grika e delle tradizioni della Grecia Salentina."
}) {
  const router = useRouter();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const isActive = (href) => {
    if (href === "/") {
      return router.pathname === "/";
    }
    return router.pathname.startsWith(href);
  };

  const cleanPath = router.asPath ? router.asPath.split("?")[0] : "";
  const canonicalUrl = `https://www.griko.online${cleanPath === "/" ? "" : cleanPath}`;

  const schemaOrgJSONLD = [
    {
      "@context": "https://schema.org",
      "@type": "WebSite",
      "name": "griko.online",
      "url": "https://www.griko.online",
      "description": "Portale culturale aperto dedicato alla tutela, studio e documentazione della lingua grika e della Grecìa Salentina.",
      "inLanguage": ["it", "el"],
      "potentialAction": {
        "@type": "SearchAction",
        "target": "https://www.griko.online/dizionario?q={search_term_string}",
        "query-input": "required name=search_term_string"
      }
    },
    {
      "@context": "https://schema.org",
      "@type": "EducationalOrganization",
      "name": "griko.online",
      "url": "https://www.griko.online",
      "logo": "https://www.griko.online/images/og-share.jpg",
      "areaServed": {
        "@type": "AdministrativeArea",
        "name": "Grecìa Salentina, Puglia, Italia"
      },
      "knowsAbout": [
        "Lingua Grika",
        "Grecìa Salentina",
        "Dialetti italo-greci",
        "Cultura e folklore del Salento",
        "Legge 482/1999"
      ]
    }
  ];

  return (
    <div className="site-wrapper">
      <Head>
        <title>{title}</title>
        <meta name="description" content={description} />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta charSet="utf-8" />

        {/* Canonical URL per evitare duplicati */}
        <link rel="canonical" href={canonicalUrl} />

        {/* Direttive per Motori di Ricerca (Googlebot, Bingbot) e Crawler AI */}
        <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1" />
        <meta name="googlebot" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1" />
        <meta name="bingbot" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1" />

        {/* Parole chiave ed entità territoriali */}
        <meta name="keywords" content="griko, greco salentino, lingua grika, grecia salentina, dizionario griko, grammatica griko, salento, puglia, calimera, martano, corigliano dotranto, soleto, sternatia, melpignano, zollino, castrignano dei greci, carpignano salentino, canzoni griche, kalinifta, canti salentini, minoranza linguistica" />
        <meta name="author" content="griko.online" />
        <meta name="geo.region" content="IT-LE" />
        <meta name="geo.placename" content="Grecìa Salentina, Salento, Puglia, Italia" />

        {/* Open Graph (Facebook, WhatsApp, LinkedIn, Telegram, AI Chat Previews) */}
        <meta property="og:site_name" content="griko.online" />
        <meta property="og:title" content={title} />
        <meta property="og:description" content={description} />
        <meta property="og:url" content={canonicalUrl} />
        <meta property="og:type" content="website" />
        <meta property="og:locale" content="it_IT" />
        <meta property="og:image" content="https://www.griko.online/images/og-share.jpg" />
        <meta property="og:image:width" content="1200" />
        <meta property="og:image:height" content="630" />
        <meta property="og:image:alt" content="griko.online — Portale culturale della Grecìa Salentina" />

        {/* Twitter Card */}
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content={title} />
        <meta name="twitter:description" content={description} />
        <meta name="twitter:image" content="https://www.griko.online/images/og-share.jpg" />

        {/* Schema.org Structured Data (JSON-LD) per Google e AI Knowledge Graph */}
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(schemaOrgJSONLD) }}
        />
      </Head>

      {/* Top micro-bar with cultural contextual note */}
      <div className="site-topbar">
        <div className="topbar-inner">
          <span className="topbar-tagline">
            Portale di documentazione e memoria della lingua di minoranza della Grecia Salentina
          </span>
          <span className="topbar-status">Archivio aperto</span>
        </div>
      </div>

      {/* Main Header */}
      <header className="site-header">
        <div className="header-inner">
          <div className="site-brand">
            <Link href="/" className="brand-link">
              <span className="brand-symbol" aria-hidden="true">Γ</span>
              <div className="brand-text">
                <span className="brand-title">griko.online</span>
                <span className="brand-subtitle">
                  Grecia Salentina · Calimera, Castrignano, Corigliano, Martano, Melpignano, Soleto, Sternatia, Zollino, Carpignano
                </span>
              </div>
            </Link>
          </div>

          <div className="header-right">
            {/* Desktop / Collapsible Navigation */}
            <nav className={`site-nav ${mobileMenuOpen ? "mobile-open" : ""}`}>
              <ul className="nav-list">
                {NAV_ITEMS.map((item) => {
                  const active = isActive(item.href);
                  return (
                    <li key={item.href} className="nav-item">
                      <Link
                        href={item.href}
                        className={`nav-link ${active ? "active" : ""}`}
                        onClick={() => setMobileMenuOpen(false)}
                      >
                        {item.label}
                      </Link>
                    </li>
                  );
                })}
              </ul>
            </nav>

            {/* Dark / Light Mode Switcher */}
            <ThemeToggle />

            {/* Mobile hamburger button */}
            <button
              type="button"
              className={`menu-toggle ${mobileMenuOpen ? "open" : ""}`}
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              aria-label={mobileMenuOpen ? "Chiudi menu di navigazione" : "Apri menu di navigazione"}
              aria-expanded={mobileMenuOpen}
            >
              <span className="bar" />
              <span className="bar" />
              <span className="bar" />
            </button>
          </div>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="site-main">
        {children}
      </main>

      {/* Footer */}
      <footer className="site-footer">
        <div className="footer-inner">
          <div className="footer-grid">
            <div className="footer-col footer-col-about">
              <h3 className="footer-title">griko.online</h3>
              <p className="footer-desc">
                Uno spazio digitale indipendente per documentare, ascoltare e studiare il dialetto neo-greco del Salento.
                Un patrimonio linguistico millenario tutelato dalla Legge 482/1999, vivo nelle voci e nelle memorie del territorio.
              </p>
            </div>

            <div className="footer-col">
              <h4 className="footer-heading">Sezioni</h4>
              <ul className="footer-links">
                {NAV_ITEMS.map((item) => (
                  <li key={item.href}>
                    <Link href={item.href} className="footer-link">
                      {item.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>

            <div className="footer-col">
              <h4 className="footer-heading">Grecia Salentina</h4>
              <ul className="footer-links municipalities">
                <li>Calimera <em>(Kalimèra)</em></li>
                <li>Castrignano dei Greci <em>(Kascignana)</em></li>
                <li>Corigliano d'Otranto <em>(Choriàna)</em></li>
                <li>Martano <em>(Martana)</em></li>
                <li>Melpignano <em>(Lipignana)</em></li>
                <li>Soleto <em>(Sulìto)</em></li>
                <li>Sternatia <em>(Chora)</em></li>
                <li>Zollino <em>(Tzuḍḍinu)</em></li>
                <li>Carpignano Salentino</li>
              </ul>
            </div>

            <div className="footer-col">
              <h4 className="footer-heading">Origine dei Dati</h4>
              <p className="footer-note">
                I dati del vocabolario e delle lezioni sono tratti dalle lezioni didattiche di Daniele Palma. 
                Le trascrizioni sono in fase di revisione linguistica collaborativa.
              </p>
              <div className="footer-badge">
                <span>Documentazione partecipata</span>
              </div>
            </div>
          </div>

          <div className="footer-bottom">
            <p className="copyright">
              © {new Date().getFullYear()} griko.online — Portale per la tutela e valorizzazione del patrimonio linguistico griko.
            </p>
            <p className="footer-license">
              Contenuti e documentazione rilasciati nel rispetto delle fonti territoriali e della cultura salentina.
            </p>
            <div className="footer-cookie-row">
              <button
                type="button"
                className="footer-cookie-btn"
                onClick={() => {
                  if (typeof window !== "undefined") {
                    window.dispatchEvent(new Event("open-cookie-banner"));
                  }
                }}
              >
                Preferenze Cookie & Privacy
              </button>
            </div>
          </div>
        </div>
      </footer>

      {/* Banner Consenso Cookie GDPR & Consent Mode v2 */}
      <CookieBanner />
    </div>
  );
}
