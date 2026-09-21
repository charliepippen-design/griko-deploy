import Link from "next/link";
import Layout from "../../components/Layout";

export default function ArchivioPage() {
  return (
    <Layout
      title="Archivio Documentale — griko.online"
      description="Raccolta documentale, testi storici e bibliografia aperta sul griko salentino."
    >
      <div className="editorial-hero">
        <span className="editorial-hero-tag">Fondo Documentale</span>
        <h1>Archivio</h1>
        <p className="sub">
          Questa sezione fungerà da biblioteca e archivio digitale delle fonti storiche sul dialetto neo-greco del Salento. 
          Raccoglierà riferimenti a glossari d'epoca, saggi linguistici, pubblicazioni aperte e documenti d'archivio per studiosi, studenti e appassionati.
        </p>
      </div>

      <section style={{ maxWidth: "720px", marginTop: "32px" }}>
        <p>
          La bibliografia di riferimento e i collegamenti alle collezioni digitali ad accesso aperto sono attualmente in fase di strutturazione.
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
