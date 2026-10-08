import Link from "next/link";
import Layout from "../../components/Layout";
import { normalizeTitle } from "../../lib/titles.mjs";
import { getApprofondimento, listApprofondimenti } from "../../lib/approfondimenti.mjs";

export function getStaticPaths() {
  return {
    paths: listApprofondimenti().map((article) => ({ params: { slug: article.slug } })),
    fallback: false,
  };
}

export function getStaticProps({ params }) {
  const article = getApprofondimento(params.slug);
  if (!article) return { notFound: true };
  return { props: { article } };
}

function citationEntry(source) {
  const entry = {
    "@type": "CreativeWork",
    name: source.title,
    url: source.url,
    author: source.author,
  };
  if (source.publication) {
    entry.isPartOf = { "@type": "CreativeWork", name: source.publication };
  }
  if (/^\d{4}$/.test(String(source.year))) {
    entry.datePublished = String(source.year);
  }
  return entry;
}

function shareImage(article) {
  const dedicated = article.ogImage;
  const image = dedicated && dedicated.src
    ? dedicated
    : (article.images || []).find((item) => item.mime === "image/jpeg" || item.mime === "image/png");
  if (!image) return null;
  return {
    url: `https://www.griko.online${image.src}`,
    alt: image.alt,
    width: image.width || 0,
    height: image.height || 0,
  };
}

function articleJsonLd(article) {
  const image = shareImage(article);
  const data = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: normalizeTitle(article.title),
    description: article.description,
    datePublished: article.date,
    dateModified: article.date,
    inLanguage: "it",
    keywords: article.keywords,
    mainEntityOfPage: {
      "@type": "WebPage",
      "@id": `https://www.griko.online/approfondimenti/${article.slug}`,
    },
    author: {
      "@type": "Organization",
      name: "griko.online",
      url: "https://www.griko.online",
    },
    publisher: {
      "@type": "Organization",
      name: "griko.online",
      url: "https://www.griko.online",
      logo: {
        "@type": "ImageObject",
        url: "https://www.griko.online/images/og-share.jpg",
        width: 1200,
        height: 630,
      },
    },
    citation: (article.sources || []).map(citationEntry),
  };
  if (image) data.image = [image.url];
  return data;
}

export default function ApprofondimentoPage({ article }) {
  const image = shareImage(article);
  return (
    <Layout
      title={`${article.title} | griko.online`}
      description={article.description}
      ogType="article"
      ogImage={image ? image.url : ""}
      ogImageAlt={image ? image.alt : ""}
      ogImageWidth={image ? image.width : 0}
      ogImageHeight={image ? image.height : 0}
      publishedTime={article.date}
      jsonLd={articleJsonLd(article)}
    >
      <article className="article-sheet">
        <header className="article-header">
          <p className="article-kicker">
            <Link href="/approfondimenti">Approfondimenti</Link>
          </p>
          <h1>{article.title}</h1>
          <p className="article-date">
            <time dateTime={article.date}>{article.dateLabel}</time>
          </p>
          <p className="lead">{article.description}</p>
        </header>

        {article.images.length > 0 ? (
          <div className="article-figures">
            {article.images.map((item) => (
              <figure key={item.src} className="article-figure">
                {item.webp ? (
                  <picture>
                    <source srcSet={item.webp} type="image/webp" />
                    <img
                      src={item.src}
                      alt={item.alt}
                      width={item.width || undefined}
                      height={item.height || undefined}
                    />
                  </picture>
                ) : (
                  <img
                    src={item.src}
                    alt={item.alt}
                    width={item.width || undefined}
                    height={item.height || undefined}
                  />
                )}
                <figcaption>
                  {item.caption ? <span className="article-figure-caption">{item.caption}</span> : null}
                  <span className="article-figure-credit">{item.credit}</span>
                </figcaption>
              </figure>
            ))}
          </div>
        ) : null}

        <div className="article-prose" dangerouslySetInnerHTML={{ __html: article.bodyHtml }} />

        <section className="article-fonti" aria-labelledby="fonti-titolo">
          <h2 id="fonti-titolo">Fonti</h2>
          <div dangerouslySetInnerHTML={{ __html: article.fontiHtml }} />
        </section>

        <section className="article-nota" aria-labelledby="nota-titolo">
          <h2 id="nota-titolo">Nota sui diritti</h2>
          <div dangerouslySetInnerHTML={{ __html: article.notaHtml }} />
        </section>

        <p className="article-back">
          <Link href="/approfondimenti" className="section-card-action">
            ← Torna agli approfondimenti
          </Link>
        </p>
      </article>
    </Layout>
  );
}
