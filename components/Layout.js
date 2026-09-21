import Head from "next/head";
import Link from "next/link";
import { useRouter } from "next/router";
import { useState } from "react";
import ThemeToggle from "./ThemeToggle";

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

  return (
    <div className="site-wrapper">
      <Head>
        <title>{title}</title>
        <meta name="description" content={description} />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta charSet="utf-8" />
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
          </div>
        </div>
      </footer>
    </div>
  );
}
