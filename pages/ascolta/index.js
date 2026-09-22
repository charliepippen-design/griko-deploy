import { useState } from "react";
import Link from "next/link";
import Layout from "../../components/Layout";
import carmineData from "../../public/data/carmine_greco_lessons.json";

export default function AscoltaPage() {
  const [openTranscript, setOpenTranscript] = useState(null);

  // Filtra i 4 componimenti poetici e musicali di Carmine Greco
  const poetryWorks = carmineData.lessons.filter((l) => l.is_poetry);
  const grammarCount = carmineData.lessons.filter((l) => !l.is_poetry).length;

  return (
    <Layout
      title="Ascolta — Archivio Sonoro e Canti della Grecìa Salentina"
      description="Ascolta i canti tradizionali, i morolòja e le poesie in lingua grika: interpretazione, trascrizione e commento a cura di Carmine Greco."
    >
      <div className="editorial-hero">
        <div className="hero-cultural-badge">
          <span className="badge-dot" />
          <span>Archivio Sonoro Vivo · Tradizione Orale</span>
        </div>
        <h1>Ascolta la Voce del Salento Ellenofono</h1>
        <p className="sub">
          Dalle serenate notturne (*Kalinifta*) ai lamenti rituali (*Morolòja*), fino ai canti d’amore e dell’emigrazione. 
          Ascolta la viva voce del griko attraverso le video-letture e il commento esegetico di <strong>Carmine Greco</strong>.
        </p>
      </div>

      {/* Griglia delle Opere Tradizionali e Canti */}
      <section className="ascolta-grid-area" style={{ marginTop: "36px" }}>
        <div className="ascolta-cards-grid">
          {poetryWorks.map((item) => {
            const isOpen = openTranscript === item.video_id;

            return (
              <article key={item.video_id} className="ascolta-card">
                <div className="ascolta-card-media">
                  <iframe
                    src={item.embed_url}
                    title={item.title}
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    allowFullScreen
                    className="ascolta-video-frame"
                    loading="lazy"
                  />
                </div>

                <div className="ascolta-card-content">
                  <div className="ascolta-card-meta">
                    <span className="ascolta-tag">{item.category_label}</span>
                    <span className="ascolta-durata">⏱ {item.duration} min</span>
                  </div>

                  <h2 className="ascolta-card-title">{item.title}</h2>
                  <p className="ascolta-card-summary">{item.summary}</p>

                  {item.proverb && (
                    <div className="ascolta-proverb-box">
                      <span className="proverb-icon">📜</span>
                      <blockquote className="proverb-quote">{item.proverb}</blockquote>
                    </div>
                  )}

                  <div className="ascolta-actions-row">
                    <button
                      type="button"
                      className="ascolta-transcript-toggle"
                      onClick={() => setOpenTranscript(isOpen ? null : item.video_id)}
                      aria-expanded={isOpen}
                    >
                      {isOpen ? "▲ Nascondi trascrizione" : "▼ Leggi testo e trascrizione"}
                    </button>

                    <a
                      href={item.youtube_url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="ascolta-yt-link"
                    >
                      Guarda su YouTube ↗
                    </a>
                  </div>

                  {isOpen && (
                    <div className="ascolta-transcript-body">
                      <div className="transcript-scroll-area">
                        {item.transcript.split("\n").map((line, idx) => (
                          <p key={idx} className="transcript-line">
                            {line}
                          </p>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              </article>
            );
          })}
        </div>
      </section>

      {/* Banner di Raccordo con il Corso Grammaticale di Carmine Greco */}
      <section className="ascolta-grammar-banner">
        <div className="grammar-banner-inner">
          <div className="grammar-banner-text">
            <h3>Vuoi ascoltare anche la grammatica parlata?</h3>
            <p>
              Oltre ai canti, Carmine Greco ha registrato un corso sistematico di <strong>{grammarCount} lezioni parlate</strong> (oltre 7 ore di audio): 
              dall'alfabeto alla coniugazione dei verbi, con la pronuncia viva delle desinenze e proverbi antichi commentati.
            </p>
          </div>
          <div className="grammar-banner-cta">
            <Link href="/dizionario?corso=carmine" className="button-accent-full">
              Esplora le 24 Lezioni di Grammatica →
            </Link>
          </div>
        </div>
      </section>
    </Layout>
  );
}
