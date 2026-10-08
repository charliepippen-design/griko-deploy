// Scrive public/sitemap.xml prima di next build.
// Pagine statiche e ogni /leggi/[slug] dello snapshot.
// lastmod e' la data dello snapshot; se manca, la data del build.
// Nessun changefreq.

import { readFileSync, writeFileSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";
import { isExcludedTesto } from "../lib/testiDiritti.mjs";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const SITE = "https://www.griko.online";

const STATIC_PATHS = [
  "/",
  "/dizionario",
  "/ascolta",
  "/leggi",
  "/esplora",
  "/persone",
  "/archivio",
  "/il-progetto",
];

function lastmodFromSnapshot() {
  try {
    const manifest = JSON.parse(readFileSync(join(root, "data/snapshot/manifest.json"), "utf8"));
    const stamp = String(manifest.generatedAt || "");
    if (/^\d{4}-\d{2}-\d{2}/.test(stamp)) return stamp.slice(0, 10);
  } catch {
    // lo snapshot puo' mancare in un checkout parziale: si usa la data del build
  }
  return new Date().toISOString().slice(0, 10);
}

function leggiPaths() {
  const testi = JSON.parse(readFileSync(join(root, "data/snapshot/testi.json"), "utf8"));
  if (!Array.isArray(testi)) throw new Error("data/snapshot/testi.json non e' un elenco");
  const paths = [];
  for (const row of testi) {
    if (!row || typeof row.slug !== "string" || !/^[a-z0-9_-]+$/i.test(row.slug)) continue;
    if (row.categoria === "canto_carmine_greco") continue;
    if (row.licenza === "cortesia_carmine_greco") continue;
    if (!row.titolo || typeof row.testo !== "string" || row.testo.trim().length < 20) continue;
    if (isExcludedTesto(row)) continue;
    paths.push(`/leggi/${row.slug}`);
  }
  return paths;
}

function escapeXml(value) {
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function render(paths, lastmod) {
  const urls = paths
    .map((path) => {
      const loc = path === "/" ? `${SITE}/` : `${SITE}${path}`;
      return `  <url>\n    <loc>${escapeXml(loc)}</loc>\n    <lastmod>${lastmod}</lastmod>\n  </url>`;
    })
    .join("\n");
  return `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${urls}\n</urlset>\n`;
}

const lastmod = lastmodFromSnapshot();
const paths = [...STATIC_PATHS, ...leggiPaths()];
const xml = render(paths, lastmod);
writeFileSync(join(root, "public/sitemap.xml"), xml);
console.log(`sitemap.xml: ${paths.length} url, lastmod ${lastmod}`);
