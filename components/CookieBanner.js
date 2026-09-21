import { useState, useEffect } from "react";

export default function CookieBanner() {
  const [mounted, setMounted] = useState(false);
  const [isOpen, setIsOpen] = useState(false);
  const [isCustomizing, setIsCustomizing] = useState(false);
  const [analyticsConsent, setAnalyticsConsent] = useState(false);

  useEffect(() => {
    setMounted(true);

    try {
      const stored = localStorage.getItem("griko_cookie_consent");
      if (!stored) {
        // Nessuna scelta espressa: mostra il banner
        setIsOpen(true);
      } else {
        const parsed = JSON.parse(stored);
        setAnalyticsConsent(Boolean(parsed.analytics));
      }
    } catch (e) {
      setIsOpen(true);
    }

    // Listener per riaprire le preferenze dal footer
    const handleOpen = () => {
      setIsCustomizing(true);
      setIsOpen(true);
    };

    window.addEventListener("open-cookie-banner", handleOpen);
    return () => window.removeEventListener("open-cookie-banner", handleOpen);
  }, []);

  const updateConsent = (analyticsGranted) => {
    try {
      localStorage.setItem(
        "griko_cookie_consent",
        JSON.stringify({
          analytics: analyticsGranted,
          timestamp: new Date().toISOString(),
          version: "1.0"
        })
      );
    } catch (e) {}

    // Google Consent Mode v2 update
    if (typeof window !== "undefined") {
      if (typeof window.gtag === "function") {
        window.gtag("consent", "update", {
          analytics_storage: analyticsGranted ? "granted" : "denied",
          ad_storage: "denied",
          ad_user_data: "denied",
          ad_personalization: "denied"
        });
      }

      window.dataLayer = window.dataLayer || [];
      window.dataLayer.push({
        event: "consent_updated",
        analytics_consent: analyticsGranted ? "granted" : "denied"
      });
    }

    setAnalyticsConsent(analyticsGranted);
    setIsOpen(false);
    setIsCustomizing(false);
  };

  const handleAcceptAll = () => {
    updateConsent(true);
  };

  const handleRejectAll = () => {
    updateConsent(false);
  };

  const handleSaveCustom = () => {
    updateConsent(analyticsConsent);
  };

  if (!mounted || !isOpen) return null;

  return (
    <div
      className="cookie-banner-backdrop"
      role="dialog"
      aria-modal="true"
      aria-labelledby="cookie-title"
      aria-describedby="cookie-desc"
    >
      <div className="cookie-banner-card">
        <div className="cookie-banner-header">
          <div className="cookie-title-row">
            <span className="cookie-badge-icon" aria-hidden="true">🍪</span>
            <h3 id="cookie-title" className="cookie-title">
              Informativa su Privacy e Cookie
            </h3>
          </div>
          <span className="cookie-law-pill">Conforme GDPR & ePrivacy</span>
        </div>

        <div id="cookie-desc" className="cookie-banner-body">
          <p>
            Su <strong>griko.online</strong> rispettiamo la tua riservatezza. Utilizziamo cookie tecnici 
            essenziali per garantire il corretto funzionamento del portale e per memorizzare la scelta del tema (Chiaro/Scuro).
          </p>
          <p>
            Previo tuo consenso esplicito, utilizziamo <strong>Google Analytics 4</strong> (tramite Google Tag Manager) 
            esclusivamente per analizzare in forma anonima e aggregata l'utilizzo del vocabolario e delle risorse culturali. 
            <strong> Non utilizziamo cookie di profilazione commerciale né pubblicità di terze parti.</strong>
          </p>

          {isCustomizing && (
            <div className="cookie-custom-panel">
              <h4 className="cookie-custom-title">Personalizza le preferenze</h4>

              <div className="cookie-option-item">
                <div className="cookie-option-info">
                  <div className="cookie-option-name">
                    <strong>Cookie Tecnici e di Funzionalità</strong>
                    <span className="cookie-always-active-tag">Sempre attivi</span>
                  </div>
                  <p className="cookie-option-desc">
                    Necessari per la navigazione, il salvataggio del tema (Dark/Light) e per ricordare le tue preferenze di consenso.
                  </p>
                </div>
                <input type="checkbox" checked disabled className="cookie-toggle-checkbox" aria-label="Cookie tecnici sempre attivi" />
              </div>

              <div className="cookie-option-item">
                <div className="cookie-option-info">
                  <div className="cookie-option-name">
                    <strong>Cookie Analitici (Google Analytics 4)</strong>
                    <span className="cookie-optional-tag">Opzionali</span>
                  </div>
                  <p className="cookie-option-desc">
                    Raccolgono dati statistici anonimi (visite, consultazioni delle lezioni, termini cercati) per aiutarci a capire quali contenuti ampliare.
                  </p>
                </div>
                <label className="cookie-switch-label">
                  <input
                    type="checkbox"
                    checked={analyticsConsent}
                    onChange={(e) => setAnalyticsConsent(e.target.checked)}
                    className="cookie-switch-input"
                    aria-label="Abilita cookie analitici"
                  />
                  <span className="cookie-switch-slider" />
                </label>
              </div>
            </div>
          )}
        </div>

        <div className="cookie-banner-actions">
          {!isCustomizing ? (
            <>
              <button
                type="button"
                className="cookie-btn cookie-btn-customize"
                onClick={() => setIsCustomizing(true)}
              >
                Personalizza
              </button>
              <button
                type="button"
                className="cookie-btn cookie-btn-reject"
                onClick={handleRejectAll}
              >
                Rifiuta non necessari
              </button>
              <button
                type="button"
                className="cookie-btn cookie-btn-accept"
                onClick={handleAcceptAll}
              >
                Accetta tutti
              </button>
            </>
          ) : (
            <>
              <button
                type="button"
                className="cookie-btn cookie-btn-customize"
                onClick={() => setIsCustomizing(false)}
              >
                ← Indietro
              </button>
              <button
                type="button"
                className="cookie-btn cookie-btn-reject"
                onClick={handleRejectAll}
              >
                Rifiuta tutti
              </button>
              <button
                type="button"
                className="cookie-btn cookie-btn-accept"
                onClick={handleSaveCustom}
              >
                Salva preferenze
              </button>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
