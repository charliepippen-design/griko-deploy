import Link from "next/link";
import Layout from "../../components/Layout";
import { listApprofondimenti } from "../../lib/approfondimenti.mjs";

export function getStaticProps() {
  return { props: { articles: listApprofondimenti() } };
}

export default function ApprofondimentiIndex({ articles = [] }) {
  return (
    <Layout
      title="Approfondimenti | griko.online"
      description="Saggi e guide sulla lingua grika e sulla Grecìa Salentina, con le fonti di ogni articolo."
    >
      <div className="editorial-hero">
        <span className="editorial-hero-tag">Saggi e guide</span>
        <h1>Approfondimenti</h1>
        <p className="sub">
          Testi sulla lingua grika e sui paesi della Grecìa Salentina. Ogni articolo riporta le fonti usate.
        </p>
      </div>

      {articles.length === 0 ? (
        <p className="empty">Nessun approfondimento è disponibile.</p>
      ) : (
        <div className="article-index-list">
          {articles.map((article) => (
            <article key={article.slug} className="article-index-card">
              <Link href={`/approfondimenti/${article.slug}`} className="article-index-link">
                <time dateTime={article.date}>{article.dateLabel}</time>
                <h2>{article.title}</h2>
                <p>{article.description}</p>
              </Link>
            </article>
          ))}
        </div>
      )}
    </Layout>
  );
}
