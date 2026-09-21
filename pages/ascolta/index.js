import Link from "next/link";
import Layout from "../../components/Layout";

export default function AscoltaPage() {
  return (
    <Layout
      title="Ascolta — griko.online"
      description="Archivio sonoro e registrazioni di parlato e canto in lingua grika."
    >
      <div className="editorial-hero">
        <span className="editorial-hero-tag">Archivio Sonoro</span>
        <h1>Ascolta</h1>
        <p className="sub">
          Questa sezione ospiterà la documentazione audio della lingua grika parlata e cantata. 
          Raccoglierà registrazioni sul campo di parlanti nativi della Grecìa Salentina, esecuzioni di canti tradizionali e interviste orali per preservare la musicalità e la pronuncia autentica dell'idioma.
        </p>
      </div>

      <section style={{ maxWidth: "720px", marginTop: "32px" }}>
        <p>
          I materiali audio sono attualmente in fase di acquisizione, catalogazione e verifica dei diritti di diffusione.
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
