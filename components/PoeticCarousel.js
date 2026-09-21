import { useState, useEffect, useRef } from "react";
import Link from "next/link";
import defaultSlides from "../public/data/poetic_slides.json";

export default function PoeticCarousel({ slides = defaultSlides }) {
  const [current, setCurrent] = useState(0);
  const [isPaused, setIsPaused] = useState(false);
  const [showGreekScript, setShowGreekScript] = useState(false);
  const timerRef = useRef(null);

  const total = slides.length;

  // Auto-play logic
  useEffect(() => {
    if (isPaused) {
      if (timerRef.current) clearInterval(timerRef.current);
      return;
    }

    timerRef.current = setInterval(() => {
      setCurrent((prev) => (prev + 1) % total);
    }, 7000);

    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [isPaused, total]);

  const goToNext = () => {
    setCurrent((prev) => (prev + 1) % total);
  };

  const goToPrev = () => {
    setCurrent((prev) => (prev - 1 + total) % total);
  };

  const goToSlide = (idx) => {
    setCurrent(idx);
  };

  if (!slides || slides.length === 0) return null;

  const activeSlide = slides[current];

  return (
    <section
      className="poetic-carousel-wrapper"
      onMouseEnter={() => setIsPaused(true)}
      onMouseLeave={() => setIsPaused(false)}
      aria-label="Carosello poetico del Salento e della Grecia Salentina"
    >
      {/* Background Slides */}
      <div className="poetic-carousel-viewport">
        {slides.map((slide, idx) => (
          <div
            key={slide.id}
            className={`poetic-slide ${idx === current ? "active" : ""}`}
            style={{ backgroundImage: `url(${slide.immagine_url})` }}
            role="group"
            aria-roledescription="slide"
            aria-label={`${idx + 1} di ${total}: ${slide.titolo_canto}`}
          >
            {/* Visual Overlays for Contrast and Warm Salento Atmosphere */}
            <div className="poetic-overlay-gradient" />
            <div className="poetic-overlay-vignette" />
          </div>
        ))}
      </div>

      {/* Floating Content Card (Centered / Lower) */}
      <div className="poetic-content-container">
        <div className="poetic-meta-row">
          <span className="poetic-badge-loc">
            <span className="poetic-badge-icon">📍</span> {activeSlide.contesto_luogo}
          </span>
          <span className="poetic-ambient-tag">{activeSlide.tag_ambientazione}</span>

          <button
            type="button"
            className="poetic-script-toggle-btn"
            onClick={() => setShowGreekScript((prev) => !prev)}
            title="Alterna caratteri greci / traslitterazione latina"
          >
            {showGreekScript ? "Grafia Latina" : "Caratteri Greci (Ελληνικά)"}
          </button>
        </div>

        {/* Verse in Griko */}
        <blockquote className="poetic-verse-griko">
          {showGreekScript && activeSlide.verso_griko_alfabeto ? (
            <p className="verse-text-greek">{activeSlide.verso_griko_alfabeto}</p>
          ) : (
            <p className="verse-text-latin">{activeSlide.verso_griko}</p>
          )}
        </blockquote>

        {/* Italian Translation */}
        <div className="poetic-verse-italian">
          <p>« {activeSlide.traduzione_italiano} »</p>
        </div>

        {/* Origin / Author & Navigation link */}
        <div className="poetic-footer-row">
          <div className="poetic-credit">
            <strong className="poetic-song-title">{activeSlide.titolo_canto}</strong>
            <span className="poetic-author-sep">·</span>
            <span className="poetic-author-name">{activeSlide.autore_origine}</span>
          </div>

          <div className="poetic-actions">
            <Link href="/ascolta" className="poetic-deepen-link">
              Ascolta canti ↗
            </Link>
          </div>
        </div>
      </div>

      {/* Prev / Next Controls */}
      <button
        type="button"
        className="poetic-nav-btn prev"
        onClick={goToPrev}
        aria-label="Slide precedente"
      >
        ‹
      </button>
      <button
        type="button"
        className="poetic-nav-btn next"
        onClick={goToNext}
        aria-label="Slide successiva"
      >
        ›
      </button>

      {/* Bottom Timeline Indicators */}
      <div className="poetic-indicators">
        {slides.map((slide, idx) => (
          <button
            key={slide.id}
            type="button"
            className={`poetic-indicator-bar ${idx === current ? "active" : ""}`}
            onClick={() => goToSlide(idx)}
            aria-label={`Vai alla slide ${idx + 1}: ${slide.titolo_canto}`}
          >
            <span className="indicator-progress" />
          </button>
        ))}

        {/* Pause / Play Toggle */}
        <button
          type="button"
          className="poetic-playpause-btn"
          onClick={() => setIsPaused((prev) => !prev)}
          aria-label={isPaused ? "Avvia riproduzione automatica" : "Pausa riproduzione automatica"}
          title={isPaused ? "Riproduci" : "Metti in pausa"}
        >
          {isPaused ? "▶" : "⏸"}
        </button>
      </div>
    </section>
  );
}
