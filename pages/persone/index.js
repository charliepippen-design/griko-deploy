import Link from "next/link";
import Layout from "../../components/Layout";
import { listPersone } from "../../lib/approfondimenti.mjs";

export function getStaticProps() {
  return { props: { articles: listPersone() } };
}

export default function PersonePage({ articles = [] }) {
  return (
    <Layout
      title="Persone | griko.online"
      description="Schede biografiche di chi ha documentato e cantato il griko, con le fonti di ogni scheda."
    >
      <div className="editorial-hero">
        <span className="editorial-hero-tag">Memoria e Biografie</span>
        <h1>Persone</h1>
        <p className="sub">
          Schede biografiche di chi ha documentato e cantato il griko, con le fonti di ogni scheda.
        </p>
      </div>

      {articles.length === 0 ? (
        <p className="empty">Nessuna scheda è disponibile.</p>
      ) : (
        <div className="article-index-list">
          {articles.map((article) => (
            <article key={article.slug} className="article-index-card">
              <Link href={article.path} className="article-index-link">
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
