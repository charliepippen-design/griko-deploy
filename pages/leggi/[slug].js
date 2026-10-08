import Link from "next/link";
import Layout from "../../components/Layout";
import { getLeggiTestoProps, listTestiSlugs } from "../../lib/archive.mjs";
import { categoryMeta, excerpt, isGrikoText, licenseLabel } from "../../lib/testiMeta";

export default function TestoPage({ testo }) {
  const meta = categoryMeta(testo.categoria);
  const griko = isGrikoText(testo.categoria);
  const fonte = licenseLabel(testo.licenza);

  return (
    <Layout
      title={`${testo.titolo} | griko.online`}
      description={excerpt(testo.testo, 160)}
    >
      <div className="wrap">
        <article className="reading-panel reading-page">
          <span className="reading-panel-tag">{meta.label}</span>
          <h1>{testo.titolo}</h1>
          {griko ? (
            <p className="reading-panel-text notranslate" translate="no">{testo.testo}</p>
          ) : (
            <p className="reading-panel-text">{testo.testo}</p>
          )}
          <p className="reading-panel-source">
            {testo.url_fonte ? (
              <>
                Fonte:{" "}
                <a href={testo.url_fonte} target="_blank" rel="noopener noreferrer">
                  {testo.url_fonte}
                </a>
              </>
            ) : (
              "Fonte non indicata"
            )}
            {fonte ? ` · ${fonte}` : ""}
          </p>
        </article>
        <p style={{ marginTop: "16px" }}>
          <Link href="/leggi" className="section-card-action">
            ← Torna all'antologia
          </Link>
        </p>
      </div>
    </Layout>
  );
}

export function getStaticPaths() {
  return {
    paths: listTestiSlugs().map((slug) => ({ params: { slug } })),
    fallback: "blocking",
  };
}

export function getStaticProps({ params }) {
  return getLeggiTestoProps(params.slug);
}
