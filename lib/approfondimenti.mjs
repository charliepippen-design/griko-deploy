// Articoli statici: content/approfondimenti/*.md, letti solo in build.

import { existsSync, readFileSync, readdirSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";
import { parse as parseYaml } from "yaml";
import { citationNumbers, renderMarkdown, splitArticleSections } from "./markdownArticle.mjs";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const contentDir = join(root, "content/approfondimenti");
const manifestPath = join(contentDir, "immagini.json");

const MONTHS = [
  "gennaio",
  "febbraio",
  "marzo",
  "aprile",
  "maggio",
  "giugno",
  "luglio",
  "agosto",
  "settembre",
  "ottobre",
  "novembre",
  "dicembre",
];

export function formatArticleDate(iso) {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(String(iso || ""));
  if (!match) return String(iso || "");
  const month = MONTHS[Number(match[2]) - 1];
  if (!month) return String(iso);
  return `${Number(match[3])} ${month} ${match[1]}`;
}

function readManifest() {
  if (!existsSync(manifestPath)) return {};
  const data = JSON.parse(readFileSync(manifestPath, "utf8"));
  if (!data || typeof data !== "object" || Array.isArray(data)) return {};
  return data;
}

function parseArticleFile(filename) {
  const raw = readFileSync(join(contentDir, filename), "utf8");
  if (!raw.startsWith("---\n")) {
    throw new Error(`${filename}: front matter mancante`);
  }
  const end = raw.indexOf("\n---\n", 4);
  if (end < 0) throw new Error(`${filename}: front matter non chiuso`);
  const data = parseYaml(raw.slice(4, end));
  const markdown = raw.slice(end + "\n---\n".length);
  if (!data || typeof data.title !== "string" || typeof data.slug !== "string") {
    throw new Error(`${filename}: title o slug mancante`);
  }
  if (typeof data.description !== "string" || typeof data.date !== "string") {
    throw new Error(`${filename}: description o date mancante`);
  }
  if (!Array.isArray(data.sources) || data.sources.length === 0) {
    throw new Error(`${filename}: elenco fonti vuoto`);
  }
  return { data, markdown };
}

function usableImages(slug, candidates) {
  const saved = readManifest()[slug];
  if (!Array.isArray(saved) || !Array.isArray(candidates)) return [];
  const byPage = new Map(saved.map((item) => [item.pageUrl, item]));
  const images = [];
  for (const candidate of candidates) {
    if (!candidate || typeof candidate.credit !== "string" || !candidate.credit.trim()) continue;
    const hit = byPage.get(candidate.url);
    if (!hit || typeof hit.src !== "string" || !hit.src.startsWith("/")) continue;
    const filePath = join(root, "public", hit.src.replace(/^\//, ""));
    if (!existsSync(filePath)) continue;
    images.push({
      src: hit.src,
      alt: typeof candidate.alt === "string" ? candidate.alt : "",
      credit: candidate.credit,
      caption: typeof candidate.caption === "string" ? candidate.caption : "",
      width: Number.isInteger(hit.width) ? hit.width : null,
      height: Number.isInteger(hit.height) ? hit.height : null,
      mime: typeof hit.mime === "string" ? hit.mime : "",
    });
  }
  return images;
}

function loadAll() {
  const files = readdirSync(contentDir)
    .filter((name) => name.endsWith(".md"))
    .sort();
  return files.map((filename) => {
    const { data, markdown } = parseArticleFile(filename);
    const sections = splitArticleSections(markdown);
    const cited = citationNumbers(sections.body);
    const fonteNumbers = new Set();
    for (const line of sections.fonti.split("\n")) {
      const match = /^(\d+)\. /.exec(line);
      if (match) fonteNumbers.add(Number(match[1]));
    }
    for (const n of cited) {
      if (!fonteNumbers.has(n)) {
        throw new Error(`${data.slug}: il rimando [${n}] non ha una voce nelle Fonti`);
      }
    }
    const sourceNumbers = new Set(data.sources.map((source) => source.n));
    for (const n of fonteNumbers) {
      if (!sourceNumbers.has(n)) {
        throw new Error(`${data.slug}: la fonte ${n} non e' nel front matter`);
      }
    }
    return {
      slug: data.slug,
      title: data.title,
      description: data.description,
      date: data.date,
      dateLabel: formatArticleDate(data.date),
      keywords: Array.isArray(data.keywords) ? data.keywords.filter((item) => typeof item === "string") : [],
      sources: data.sources,
      images: usableImages(data.slug, data.images),
      bodyHtml: renderMarkdown(sections.body, { citations: true }),
      fontiHtml: renderMarkdown(sections.fonti, { citations: false, fonteIds: true }),
      notaHtml: renderMarkdown(sections.nota, { citations: false }),
    };
  });
}

let cache = null;

function articles() {
  if (!cache) cache = loadAll();
  return cache;
}

export function listApprofondimenti() {
  return articles()
    .map((article) => ({
      slug: article.slug,
      title: article.title,
      description: article.description,
      date: article.date,
      dateLabel: article.dateLabel,
    }))
    .sort((a, b) => {
      if (a.date !== b.date) return a.date < b.date ? 1 : -1;
      return a.title.localeCompare(b.title, "it");
    });
}

export function getApprofondimento(slug) {
  return articles().find((article) => article.slug === slug) || null;
}

export function approfondimentiSitemapEntries() {
  return listApprofondimenti().map((article) => ({
    path: `/approfondimenti/${article.slug}`,
    lastmod: article.date,
  }));
}
