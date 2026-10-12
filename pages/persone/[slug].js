import ApprofondimentoPage from "../approfondimenti/[slug]";
import { getApprofondimento } from "../../lib/approfondimenti.mjs";
import { PERSONE_SLUGS } from "../../lib/persone.mjs";

export function getStaticPaths() {
  return {
    paths: PERSONE_SLUGS.map((slug) => ({ params: { slug } })),
    fallback: false,
  };
}

export function getStaticProps({ params }) {
  const article = PERSONE_SLUGS.includes(params.slug) ? getApprofondimento(params.slug) : null;
  if (!article) return { notFound: true };
  return { props: { article } };
}

export default ApprofondimentoPage;
