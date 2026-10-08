// Rigenera data/snapshot a partire dai JSON gia' nel repo.
// Supabase, se risponde, sostituisce un gruppo solo quando i conteggi sono
// pieni. Altrimenti si resta sulla derivazione locale.
//
// I testi liberi non sono nel repo: con --scrape si rileggono da ciuricepedi.it
// (stesse URL e stessa esclusione delle pagine d'autore di scrape_free_texts.py).
// Le trascrizioni integrali di Carmine Greco non vengono scritte.
//
// Uso:
//   node scripts/refresh-snapshot.mjs
//   node scripts/refresh-snapshot.mjs --scrape
//   node scripts/refresh-snapshot.mjs --scrape --limit 5

import { readFileSync, writeFileSync, mkdirSync, readdirSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const outDir = join(root, "data", "snapshot");
const BASE = "https://www.ciuricepedi.it";
const SUPABASE_URL = (
  process.env.NEXT_PUBLIC_SUPABASE_URL ||
  process.env.SUPABASE_URL ||
  "https://xhpcztzisqdzqiwrojvl.supabase.co"
).replace(/\/$/, "");
const SUPABASE_KEY =
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ||
  process.env.SUPABASE_ANON_KEY ||
  "sb_publishable_fvHGcE6xrVfdg5tHLZKZUQ_7yKSg_iV";

const args = new Set(process.argv.slice(2));
const doScrape = args.has("--scrape");
const limitEq = process.argv.find((arg) => arg.startsWith("--limit="));
const limitIdx = process.argv.indexOf("--limit");
const limit = limitEq
  ? Number(limitEq.slice("--limit=".length))
  : limitIdx !== -1
    ? Number(process.argv[limitIdx + 1])
    : Infinity;

function readJson(relativePath) {
  return JSON.parse(readFileSync(join(root, relativePath), "utf8"));
}

function assertNoForbiddenKeys(value, trail) {
  if (Array.isArray(value)) {
    value.forEach((item, index) => assertNoForbiddenKeys(item, `${trail}[${index}]`));
    return;
  }
  if (value && typeof value === "object") {
    for (const [key, inner] of Object.entries(value)) {
      if (/^(transcript|trascrizione)$/i.test(key)) {
        throw new Error(`Chiave vietata "${key}" in ${trail}`);
      }
      assertNoForbiddenKeys(inner, `${trail}.${key}`);
    }
  }
}

function normalize(text) {
  return String(text || "").replace(/\s+/g, " ").trim().toLowerCase();
}

function loadBannedSnippets() {
  const snippets = [];
  const dir = join(root, "carmine_transcripts_clean");
  for (const name of readdirSync(dir)) {
    if (!name.endsWith(".txt")) continue;
    const text = normalize(readFileSync(join(dir, name), "utf8"));
    if (text.length > 200) snippets.push(text.slice(0, 240));
  }
  const full = readJson("data/carmine_greco_lessons_full.json");
  for (const lesson of full.lessons || []) {
    if (typeof lesson.transcript === "string") {
      const text = normalize(lesson.transcript);
      if (text.length > 200) snippets.push(text.slice(0, 240));
    }
  }
  return snippets;
}

function assertNoBannedText(value, snippets, trail) {
  if (typeof value === "string") {
    if (value.length < 200) return;
    const norm = normalize(value);
    for (const snippet of snippets) {
      if (norm.includes(snippet)) {
        throw new Error(`Testo troppo vicino a una trascrizione di Carmine Greco in ${trail}`);
      }
    }
    return;
  }
  if (Array.isArray(value)) {
    value.forEach((item, index) => assertNoBannedText(item, snippets, `${trail}[${index}]`));
    return;
  }
  if (value && typeof value === "object") {
    for (const [key, inner] of Object.entries(value)) {
      assertNoBannedText(inner, snippets, `${trail}.${key}`);
    }
  }
}

function derivePalma() {
  const data = readJson("public/data/griko-data.json");
  const lessons = data.lessons.map((lesson) => ({
    id: Number(lesson.id),
    titolo: String(lesson.titolo || "").trim(),
    categoria: String(lesson.categoria || "").trim(),
    genere: String(lesson.genere || "").trim(),
    desinenza: String(lesson.desinenza || "").trim(),
  }));
  const rules = data.rules.map((rule) => ({
    id: Number(rule.id),
    lesson_id: Number(rule.lesson_id),
    regola_testo: String(rule.regola_testo || "").trim(),
  }));

  const lexemes = [];
  const seen = new Map();
  const occurrences = [];
  const occSeen = new Set();
  let lexemeId = 1;
  let occurrenceId = 1;
  for (const row of data.vocabulary) {
    const griko = String(row.parola_griko || "").trim();
    const italiano = String(row.parola_italiano || "").trim();
    const lessonId = Number(row.lesson_id);
    if (!griko || !italiano || !Number.isFinite(lessonId)) continue;
    const key = `${griko}\u0000${italiano}`;
    let id = seen.get(key);
    if (!id) {
      id = lexemeId++;
      seen.set(key, id);
      lexemes.push({ id, parola_griko: griko, parola_italiano: italiano });
    }
    const occKey = `${id}\u0000${lessonId}`;
    if (occSeen.has(occKey)) continue;
    occSeen.add(occKey);
    occurrences.push({ id: occurrenceId++, lexeme_id: id, lesson_id: lessonId });
  }
  lexemes.sort((a, b) => a.parola_griko.localeCompare(b.parola_griko, "it"));
  return { lessons, rules, lexemes, occurrences };
}

function deriveCarmine() {
  const extracted = readJson("carmine_extracted_merged.json");
  const rules = [];
  const lexemes = [];
  const seen = new Map();
  const occurrences = [];
  const occSeen = new Set();
  let ruleId = 1;
  let lexemeId = 1;
  let occurrenceId = 1;

  for (const lesson of extracted) {
    const lessonId = Number(lesson.order);
    for (const regola of lesson.rules || []) {
      const testo = String(regola || "").trim();
      if (!testo) continue;
      rules.push({ id: ruleId++, lesson_id: lessonId, regola_testo: testo });
    }
    for (const row of lesson.vocabulary || []) {
      const griko = String(row.parola_griko || "").trim();
      const italiano = String(row.parola_italiano || "").trim();
      if (!griko || !italiano) continue;
      const key = `${griko}\u0000${italiano}`;
      let id = seen.get(key);
      if (!id) {
        id = lexemeId++;
        seen.set(key, id);
        lexemes.push({ id, parola_griko: griko, parola_italiano: italiano });
      }
      const occKey = `${id}\u0000${lessonId}`;
      if (occSeen.has(occKey)) continue;
      occSeen.add(occKey);
      occurrences.push({ id: occurrenceId++, lexeme_id: id, lesson_id: lessonId });
    }
  }
  lexemes.sort((a, b) => a.parola_griko.localeCompare(b.parola_griko, "it"));
  return { rules, lexemes, occurrences };
}

function extractQuoted(block) {
  return [...block.matchAll(/"([^"]+)"/g)].map((match) => match[1]);
}

function loadScrapePlan() {
  const source = readFileSync(join(root, "scrape_free_texts.py"), "utf8");
  const blacklistMatch = source.match(/^BLACKLIST_PATTERNS = \[([\s\S]*?)^\]/m);
  const sourcesMatch = source.match(/^CATEGORY_SOURCES = \{([\s\S]*?)^\}/m);
  const fiabaMatch = source.match(/^FIABA_SLUGS = \[([\s\S]*?)^\]/m);
  if (!blacklistMatch || !sourcesMatch || !fiabaMatch) {
    throw new Error("Impossibile leggere gli elenchi da scrape_free_texts.py");
  }
  const blacklist = extractQuoted(blacklistMatch[1]);
  const categories = {};
  const re = /"([^"]+)":\s*\[([\s\S]*?)\]/g;
  let match;
  while ((match = re.exec(sourcesMatch[1]))) {
    categories[match[1]] = extractQuoted(match[2]);
  }
  categories.fiaba = extractQuoted(fiabaMatch[1]).map((slug) => `/${slug}`);
  const targets = [];
  for (const [categoria, paths] of Object.entries(categories)) {
    for (const path of paths) {
      if (blacklist.some((pattern) => path.includes(pattern))) continue;
      targets.push({ path, categoria });
    }
  }
  if ((categories.fiaba || []).length < 100 || (categories.proverbio || []).length < 15) {
    throw new Error(
      `Elenchi incompleti: fiabe=${(categories.fiaba || []).length}, proverbi=${(categories.proverbio || []).length}`
    );
  }
  return { blacklist, targets };
}

function decodeEntities(value) {
  return value
    .replace(/&nbsp;/gi, " ")
    .replace(/&amp;/gi, "&")
    .replace(/&quot;/gi, '"')
    .replace(/&#0*39;|&apos;/gi, "'")
    .replace(/&lt;/gi, "<")
    .replace(/&gt;/gi, ">")
    .replace(/&#(\d+);/g, (all, digits) => {
      const code = Number(digits);
      return code > 0 && code < 0x110000 ? String.fromCodePoint(code) : all;
    })
    .replace(/&#x([0-9a-f]+);/gi, (all, hex) => {
      const code = parseInt(hex, 16);
      return code > 0 && code < 0x110000 ? String.fromCodePoint(code) : all;
    });
}

function stripTags(value) {
  return decodeEntities(value.replace(/<[^>]+>/g, " ")).replace(/\s+/g, " ").trim();
}

function extractSingleArticle(html) {
  const articleCount = (html.match(/<article\b/gi) || []).length;
  const titleCount = (html.match(/entry-title/gi) || []).length;
  if (articleCount > 1 || titleCount > 1) return null;
  const titleMatch =
    html.match(/<h1[^>]*class="[^"]*entry-title[^"]*"[^>]*>([\s\S]*?)<\/h1>/i) ||
    html.match(/<h1[^>]*>([\s\S]*?)<\/h1>/i);
  const titolo = titleMatch ? stripTags(titleMatch[1]) : "";
  const articleMatch = html.match(/<article\b[^>]*>([\s\S]*?)<\/article>/i);
  const scope = articleMatch ? articleMatch[1] : "";
  if (!scope) return null;
  const cleaned = scope
    .replace(/<script[\s\S]*?<\/script>/gi, "")
    .replace(/<style[\s\S]*?<\/style>/gi, "")
    .replace(/<(nav|header|footer|aside|form)\b[\s\S]*?<\/\1>/gi, "");
  const blocks = [];
  const re = /<(p|li)\b[^>]*>([\s\S]*?)<\/\1>/gi;
  let block;
  while ((block = re.exec(cleaned))) {
    const text = stripTags(block[2]);
    if (text.length > 1) blocks.push(text);
  }
  return { titolo, testo: blocks.join("\n") };
}

function slugify(pathname) {
  let clean = pathname || "";
  try {
    clean = decodeURIComponent(clean);
  } catch {
    return null;
  }
  const slug = clean.replace(/^\/+|\/+$/g, "").replace(/\//g, "__");
  if (!/^[a-z0-9_-]+$/i.test(slug)) return null;
  return slug;
}

function isBlacklisted(pathname, blacklist) {
  return blacklist.some((pattern) => pathname.includes(pattern));
}

async function scrapeOne(target, blacklist) {
  const url = BASE + target.path;
  try {
    const res = await fetch(url, {
      redirect: "follow",
      headers: { "User-Agent": "Mozilla/5.0 (griko-archivio-libero-bot)" },
      signal: AbortSignal.timeout(20000),
    });
    if (!res.ok) {
      return { ok: false, path: target.path, reason: `HTTP ${res.status}` };
    }
    const finalPath = new URL(res.url).pathname;
    if (isBlacklisted(finalPath, blacklist)) {
      return { ok: false, path: target.path, reason: "redirect verso pagina esclusa" };
    }
    const html = await res.text();
    const extracted = extractSingleArticle(html);
    if (!extracted || !extracted.titolo || extracted.testo.length < 40) {
      return { ok: false, path: target.path, reason: "pagina vuota o con piu' articoli" };
    }
    const slug = slugify(finalPath);
    if (!slug) return { ok: false, path: target.path, reason: "slug non valido" };
    return {
      ok: true,
      row: {
        slug,
        titolo: extracted.titolo,
        categoria: target.categoria,
        testo: extracted.testo,
        url_fonte: BASE + finalPath.replace(/\/$/, ""),
        licenza: "pubblico_dominio_tradizione_orale",
      },
    };
  } catch (err) {
    return {
      ok: false,
      path: target.path,
      reason: err && err.message ? err.message : "errore di rete",
    };
  }
}

async function mapPool(items, size, worker) {
  const out = new Array(items.length);
  let cursor = 0;
  async function run() {
    while (cursor < items.length) {
      const index = cursor++;
      out[index] = await worker(items[index], index);
    }
  }
  await Promise.all(Array.from({ length: Math.min(size, items.length) }, run));
  return out;
}

async function scrapeTesti() {
  const { blacklist, targets } = loadScrapePlan();
  const sample = await scrapeOne(
    { path: "/i-proverbi-la-natura-1", categoria: "proverbio" },
    blacklist
  );
  if (!sample.ok) {
    throw new Error(`Estrazione di prova fallita: ${sample.reason}`);
  }
  console.log(`Prova di estrazione OK: "${sample.row.titolo}" (${sample.row.testo.length} caratteri)`);

  const selected = Number.isFinite(limit) ? targets.slice(0, limit) : targets;
  console.log(`Pagine da leggere: ${selected.length}`);
  let done = 0;
  const results = await mapPool(selected, 3, async (target) => {
    const result = await scrapeOne(target, blacklist);
    done += 1;
    if (done % 20 === 0 || done === selected.length) {
      console.log(`  lette ${done}/${selected.length}`);
    }
    await new Promise((resolve) => setTimeout(resolve, 150));
    return result;
  });

  const testi = [];
  const seen = new Set();
  let failed = 0;
  for (const result of results) {
    if (!result.ok) {
      failed += 1;
      console.warn(`  [skip] ${result.path}: ${result.reason}`);
      continue;
    }
    if (seen.has(result.row.slug)) continue;
    seen.add(result.row.slug);
    testi.push(result.row);
  }
  console.log(`Testi estratti: ${testi.length} (saltati ${failed})`);
  if (!Number.isFinite(limit) && testi.length < 30) {
    throw new Error("Troppi pochi testi estratti: lo snapshot non viene sovrascritto.");
  }
  return testi;
}

async function fetchTable(table, query) {
  const pageSize = 1000;
  const rows = [];
  const signal = AbortSignal.timeout(8000);
  for (let offset = 0; offset < 5000; offset += pageSize) {
    const endpoint = `${SUPABASE_URL}/rest/v1/${table}?${query}&limit=${pageSize}&offset=${offset}`;
    const res = await fetch(endpoint, {
      headers: {
        apikey: SUPABASE_KEY,
        Authorization: `Bearer ${SUPABASE_KEY}`,
        Accept: "application/json",
      },
      signal,
    });
    if (!res.ok) throw new Error(`${table} HTTP ${res.status}`);
    const data = await res.json();
    if (!Array.isArray(data)) throw new Error(`${table} risposta non valida`);
    rows.push(...data);
    if (data.length < pageSize) break;
  }
  return rows;
}

async function trySupabaseGroups() {
  if (!SUPABASE_URL || !SUPABASE_KEY) return null;
  try {
    const [
      lessons,
      rules,
      lexemes,
      occurrences,
      carmineRules,
      carmineLexemes,
      carmineOccurrences,
      testi,
    ] = await Promise.all([
      fetchTable("lessons", "select=id,titolo,categoria,genere,desinenza&order=id.asc"),
      fetchTable("rules", "select=id,lesson_id,regola_testo&order=id.asc"),
      fetchTable("lexemes", "select=id,parola_griko,parola_italiano&order=parola_griko.asc"),
      fetchTable("occurrences", "select=id,lexeme_id,lesson_id&order=id.asc"),
      fetchTable("carmine_rules", "select=id,lesson_id,regola_testo&order=id.asc"),
      fetchTable("carmine_lexemes", "select=id,parola_griko,parola_italiano&order=parola_griko.asc"),
      fetchTable("carmine_occurrences", "select=id,lexeme_id,lesson_id&order=id.asc"),
      fetchTable(
        "testi_liberi",
        "select=slug,titolo,categoria,testo,url_fonte,licenza&categoria=neq.canto_carmine_greco&order=titolo.asc"
      ),
    ]);
    return {
      palma: { lessons, rules, lexemes, occurrences },
      carmine: {
        rules: carmineRules,
        lexemes: carmineLexemes,
        occurrences: carmineOccurrences,
      },
      testi: testi.filter(
        (row) =>
          row &&
          row.categoria !== "canto_carmine_greco" &&
          row.licenza !== "cortesia_carmine_greco" &&
          typeof row.slug === "string" &&
          /^[a-z0-9_-]+$/i.test(row.slug) &&
          typeof row.testo === "string" &&
          row.testo.trim().length >= 20
      ),
    };
  } catch (err) {
    console.warn("[snapshot] Supabase non disponibile:", err && err.message ? err.message : err);
    return null;
  }
}

function writeJson(name, value) {
  const file = join(outDir, name);
  const json = JSON.stringify(value, null, 2) + "\n";
  writeFileSync(file, json);
  return Buffer.byteLength(json);
}

async function main() {
  mkdirSync(outDir, { recursive: true });
  const banned = loadBannedSnippets();
  let palma = derivePalma();
  let carmine = deriveCarmine();
  let palmaSource = "public/data/griko-data.json";
  let carmineSource = "carmine_extracted_merged.json";
  let testiSource = "data/snapshot/testi.json";
  let testi = [];

  const remote = await trySupabaseGroups();
  if (remote && remote.palma.lessons.length >= 70 && remote.palma.lexemes.length >= 600) {
    palma = remote.palma;
    palmaSource = "supabase";
  }
  if (remote && remote.carmine.rules.length >= 200 && remote.carmine.lexemes.length >= 400) {
    carmine = remote.carmine;
    carmineSource = "supabase";
  }

  if (remote && remote.testi.length >= 20 && !doScrape) {
    testi = remote.testi.map((row) => ({
      slug: row.slug,
      titolo: row.titolo,
      categoria: row.categoria,
      testo: row.testo,
      url_fonte: row.url_fonte || "",
      licenza: row.licenza || "pubblico_dominio_tradizione_orale",
    }));
    testiSource = "supabase";
  } else if (doScrape) {
    testi = await scrapeTesti();
    testiSource = "ciuricepedi.it";
  } else {
    try {
      const existing = readJson("data/snapshot/testi.json");
      if (Array.isArray(existing)) testi = existing;
    } catch {
      console.warn(
        "[snapshot] testi.json assente. Rieseguire con --scrape oppure con Supabase raggiungibile."
      );
    }
  }

  const payload = { palma, carmine, testi };
  assertNoForbiddenKeys(payload, "$");
  assertNoBannedText(payload, banned, "$");

  const palmaBytes = writeJson("palma.json", palma);
  const carmineBytes = writeJson("carmine.json", carmine);
  const testiBytes = writeJson("testi.json", testi);
  const manifest = {
    generatedAt: new Date().toISOString(),
    sources: {
      palma: palmaSource,
      carmine: carmineSource,
      testi: testiSource,
      places: "public/data/places.json",
    },
    counts: {
      lessons: palma.lessons.length,
      rules: palma.rules.length,
      lexemes: palma.lexemes.length,
      occurrences: palma.occurrences.length,
      carmineRules: carmine.rules.length,
      carmineLexemes: carmine.lexemes.length,
      carmineOccurrences: carmine.occurrences.length,
      testi: testi.length,
    },
    bytes: {
      palma: palmaBytes,
      carmine: carmineBytes,
      testi: testiBytes,
    },
    excluded:
      "Nessuna trascrizione integrale di Carmine Greco: esclusi i campi transcript e trascrizione, i file in carmine_transcripts_clean/ e i testi con categoria canto_carmine_greco o licenza cortesia_carmine_greco.",
    refresh: "node scripts/refresh-snapshot.mjs --scrape",
  };
  const manifestBytes = writeJson("manifest.json", manifest);
  console.log(JSON.stringify({ ...manifest, bytes: { ...manifest.bytes, manifest: manifestBytes } }, null, 2));
}

main().catch((err) => {
  console.error(err && err.stack ? err.stack : err);
  process.exit(1);
});
