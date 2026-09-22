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
          I dati didattici e lessicali attualmente fruibili sul portale provengono da due importanti fonti aperte della divulgazione contemporanea della Grecìa Salentina:
        </p>

        <ul style={{ margin: "16px 0 24px 20px", color: "var(--text-secondary)" }}>
          <li style={{ marginBottom: "10px" }}>
            <strong>Daniele Palma:</strong> 73 micro-lezioni didattiche focalizzate su regole morfologiche puntuali e frasario bilingue, da cui è stato estratto il vocabolario di base (684 lessemi).
          </li>
          <li style={{ marginBottom: "10px" }}>
            <strong>Carmine Greco:</strong> un corso grammaticale sistematico e organico in 24 lezioni teoriche approfondite (dall'alfabeto alla coniugazione completa del verbo, corredate da proverbi commentati) affiancato da 4 video-letture esegetiche di capolavori della poesia e del canto popolare griko (*Kalinifta*, *Klama*, *Aremu rindinedda-mu*, *Agapi-mu fidela protinì*).
          </li>
        </ul>

        <p>
          I testi trascritti rappresentano una straordinaria risorsa di documentazione viva, ma non un'edizione cartacea chiusa: sono parte di un cantiere aperto e collaborativo, volto a conservare la voce parlata di chi difende l'idioma sul territorio.
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
