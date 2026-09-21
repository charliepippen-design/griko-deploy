import Link from "next/link";
import Layout from "../../components/Layout";

export default function IlProgettoPage() {
  return (
    <Layout
      title="Il Progetto — griko.online"
      description="Cos'è griko.online, l'origine dei dati dal corso di Daniele Palma e la documentazione aperta della lingua grika."
    >
      <div className="editorial-hero">
        <span className="editorial-hero-tag">Metodologia e Origine</span>
        <h1>Il Progetto griko.online</h1>
        <p className="sub">
          Uno spazio indipendente per documentare, ascoltare e studiare la lingua della Grecia Salentina.
        </p>
      </div>

      <article style={{ maxWidth: "760px", marginTop: "32px", fontSize: "1.05rem", lineHeight: "1.75" }}>
        <p className="lead">
          <strong>griko.online</strong> nasce con un obiettivo chiaro: rendere accessibile e consultabile il patrimonio linguistico della Grecìa Salentina attraverso strumenti digitali moderni e aperti.
        </p>

        <p>
          I dati del dizionario e delle lezioni grammaticali attualmente pubblicati provengono dalla trascrizione automatica del corso didattico YouTube curato da <strong>Daniele Palma</strong>. Rappresentano un punto di partenza prezioso, ma non costituiscono ancora un'edizione filologicamente definitiva: le forme lessicali, gli accenti e le regole sono attualmente in fase di revisione e verifica.
        </p>

        <p>
          Il portale è concepito come un cantiere partecipato. È aperto al contributo di parlanti nativi, ricercatori, associazioni culturali locali e appassionati che desiderino proporre correzioni, integrare varianti paesane o condividere registrazioni e testi.
        </p>

        <div style={{ marginTop: "40px", paddingTop: "24px", borderTop: "1px solid var(--border-color)" }}>
          <Link href="/" className="section-card-action">
            ← Torna alla Home page
          </Link>
          {" · "}
          <Link href="/dizionario" className="section-card-action">
            Consulta il Dizionario →
          </Link>
        </div>
      </article>
    </Layout>
  );
}
