import Link from "next/link";
import Layout from "../../components/Layout";

export default function LeggiPage() {
  return (
    <Layout
      title="Leggi — griko.online"
      description="Antologia di testi tradizionali, poesie e proverbi in lingua grika con traduzione a fronte."
    >
      <div className="editorial-hero">
        <span className="editorial-hero-tag">Antologia di Testi</span>
        <h1>Leggi</h1>
        <p className="sub">
          Questa sezione presenterà un'antologia ragionata della produzione letteraria e poetica in griko. 
          Conterrà componimenti tradizionali, rime popolari e proverbi storici dei diversi comuni, corredati da traduzione italiana a fronte e note di contesto culturale.
        </p>
      </div>

      <section style={{ maxWidth: "720px", marginTop: "32px" }}>
        <p>
          I testi sono in fase di trascrizione e allineamento bilingue a partire dalle fonti a stampa storiche e dalle raccolte orali del Salento.
        </p>
        <p>
          <Link href="/" className="section-card-action">
            ← Torna alla Home page
          </Link>
        </p>
      </section>
    </Layout>
  );
}
