import Link from "next/link";
import Layout from "../../components/Layout";

export default function PersonePage() {
  return (
    <Layout
      title="Persone & Custodi della Memoria — griko.online"
      description="Biografie e testimonianze dei poeti, studiosi e custodi della lingua grika."
    >
      <div className="editorial-hero">
        <span className="editorial-hero-tag">Memoria e Biografie</span>
        <h1>Persone</h1>
        <p className="sub">
          Questa sezione sarà dedicata alle donne e agli uomini che hanno custodito, documentato e cantato il griko nel tempo. 
          Raccoglierà schede biografiche di studiosi, poeti popolari e testimoni della tradizione orale locale, per dare un volto e una storia a chi ha tenuto viva la lingua.
        </p>
      </div>

      <section style={{ maxWidth: "720px", marginTop: "32px" }}>
        <p>
          I profili biografici e le testimonianze storiche sono in corso di redazione filologica e verifica delle fonti archivistiche.
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
