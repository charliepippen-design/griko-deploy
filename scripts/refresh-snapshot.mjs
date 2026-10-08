// Aggiorna data/snapshot/ leggendo Supabase con la chiave publishable.
// Il sito non chiama Supabase in build: dopo questo script va committato
// lo snapshot e rifatto il deploy.
//
//   node scripts/refresh-snapshot.mjs
//
// Non scrive i campi transcript / trascrizione, ne' i commenti parlati di
// Carmine Greco (categoria canto_carmine_greco, licenza cortesia_carmine_greco).
// Se il download fallisce, i file gia' presenti restano invariati.

import { readFileSync, writeFileSync, mkdirSync, readdirSync, renameSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const outDir = join(root, "data", "snapshot");

const SUPABASE_URL = (
  process.env.NEXT_PUBLIC_SUPABASE_URL ||
  "https://xhpcztzisqdzqiwrojvl.supabase.co"
).replace(/\/$/, "");
const SUPABASE_KEY =
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ||
  "sb_publishable_fvHGcE6xrVfdg5tHLZKZUQ_7yKSg_iV";

const TABLES = {
  lessons: "select=id,titolo,categoria,genere,desinenza&order=id.asc",
  rules: "select=id,lesson_id,regola_testo&order=id.asc",
  lexemes: "select=id,parola_griko,parola_italiano&order=id.asc",
  occurrences: "select=id,lexeme_id,lesson_id&order=id.asc",
  carmine_lessons:
    "select=id,video_id,titolo,categoria,categoria_label,durata,sommario,proverbio,youtube_url&order=id.asc",
  carmine_rules: "select=id,lesson_id,regola_testo&order=id.asc",
  carmine_lexemes: "select=id,parola_griko,parola_italiano&order=id.asc",
  carmine_occurrences: "select=id,lexeme_id,lesson_id&order=id.asc",
  testi_liberi:
    "select=slug,titolo,categoria,testo,url_fonte,licenza&categoria=neq.canto_carmine_greco&licenza=neq.cortesia_carmine_greco&order=titolo.asc",
};

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
  const full = JSON.parse(readFileSync(join(root, "data/carmine_greco_lessons_full.json"), "utf8"));
  for (const lesson of full.lessons || []) {
    if (typeof lesson.transcript !== "string") continue;
    const text = normalize(lesson.transcript);
    if (text.length > 200) snippets.push(text.slice(0, 240));
  }
  return snippets;
}

function assertClean(value, snippets, trail = "$") {
  if (typeof value === "string") {
    if (value.length < 200) return;
    const norm = normalize(value);
    if (snippets.some((snippet) => norm.includes(snippet))) {
      throw new Error(`Testo troppo vicino a una trascrizione di Carmine Greco in ${trail}`);
    }
    return;
  }
  if (Array.isArray(value)) {
    value.forEach((item, index) => assertClean(item, snippets, `${trail}[${index}]`));
    return;
  }
  if (value && typeof value === "object") {
    for (const [key, inner] of Object.entries(value)) {
      if (/^(transcript|trascrizione)$/i.test(key)) {
        throw new Error(`Chiave vietata "${key}" in ${trail}`);
      }
      assertClean(inner, snippets, `${trail}.${key}`);
    }
  }
}

async function fetchTable(table, query) {
  const pageSize = 1000;
  const rows = [];
  for (let offset = 0; offset < 10000; offset += pageSize) {
    const endpoint = `${SUPABASE_URL}/rest/v1/${table}?${query}&limit=${pageSize}&offset=${offset}`;
    const res = await fetch(endpoint, {
      headers: {
        apikey: SUPABASE_KEY,
        Authorization: `Bearer ${SUPABASE_KEY}`,
        Accept: "application/json",
      },
      signal: AbortSignal.timeout(20000),
    });
    if (!res.ok) {
      throw new Error(`${table} HTTP ${res.status}`);
    }
    const data = await res.json();
    if (!Array.isArray(data)) throw new Error(`${table}: risposta non valida`);
    rows.push(...data);
    if (data.length < pageSize) break;
  }
  return rows;
}

function keepTesto(row) {
  if (!row || typeof row !== "object") return false;
  if (row.categoria === "canto_carmine_greco") return false;
  if (row.licenza === "cortesia_carmine_greco") return false;
  if (typeof row.slug !== "string" || !/^[a-z0-9_-]+$/i.test(row.slug)) return false;
  if (!row.titolo || typeof row.testo !== "string" || row.testo.trim().length < 20) return false;
  return true;
}

function presentTesto(row) {
  return {
    slug: row.slug,
    titolo: row.titolo,
    categoria: row.categoria,
    testo: row.testo,
    url_fonte: row.url_fonte || "",
    licenza: row.licenza || "",
  };
}

function writeAtomic(name, value) {
  const json = JSON.stringify(value, null, 2) + "\n";
  const finalPath = join(outDir, name);
  const tempPath = `${finalPath}.tmp`;
  writeFileSync(tempPath, json);
  renameSync(tempPath, finalPath);
  return Buffer.byteLength(json);
}

function expectAtLeast(label, actual, minimum) {
  if (actual < minimum) {
    throw new Error(`${label}: ${actual} righe, attese almeno ${minimum}. Snapshot non aggiornato.`);
  }
}

async function main() {
  mkdirSync(outDir, { recursive: true });
  const banned = loadBannedSnippets();
  const data = {};
  for (const [table, query] of Object.entries(TABLES)) {
    data[table] = await fetchTable(table, query);
    console.log(`  ${table}: ${data[table].length}`);
  }

  const testi = data.testi_liberi.filter(keepTesto).map(presentTesto);
  const palma = {
    lessons: data.lessons,
    rules: data.rules,
    lexemes: data.lexemes,
    occurrences: data.occurrences,
  };
  const carmine = {
    lessons: data.carmine_lessons,
    rules: data.carmine_rules,
    lexemes: data.carmine_lexemes,
    occurrences: data.carmine_occurrences,
  };

  expectAtLeast("lessons", palma.lessons.length, 73);
  expectAtLeast("rules", palma.rules.length, 158);
  expectAtLeast("lexemes", palma.lexemes.length, 684);
  expectAtLeast("occurrences", palma.occurrences.length, 716);
  expectAtLeast("carmine_lessons", carmine.lessons.length, 24);
  expectAtLeast("carmine_rules", carmine.rules.length, 283);
  expectAtLeast("carmine_lexemes", carmine.lexemes.length, 700);
  expectAtLeast("carmine_occurrences", carmine.occurrences.length, 781);
  expectAtLeast("testi_liberi", testi.length, 150);

  const payload = { palma, carmine, testi };
  assertClean(payload, banned);

  const palmaBytes = writeAtomic("palma.json", palma);
  const carmineBytes = writeAtomic("carmine.json", carmine);
  const testiBytes = writeAtomic("testi.json", testi);
  const manifest = {
    generatedAt: new Date().toISOString(),
    source: "supabase",
    supabaseRef: "xhpcztzisqdzqiwrojvl",
    counts: {
      lessons: palma.lessons.length,
      rules: palma.rules.length,
      lexemes: palma.lexemes.length,
      occurrences: palma.occurrences.length,
      carmineLessons: carmine.lessons.length,
      carmineRules: carmine.rules.length,
      carmineLexemes: carmine.lexemes.length,
      carmineOccurrences: carmine.occurrences.length,
      testi: testi.length,
    },
    bytes: { palma: palmaBytes, carmine: carmineBytes, testi: testiBytes },
    places: "public/data/places.json (la tabella places non e' su Supabase)",
    excluded:
      "Esclusi i campi transcript e trascrizione e i testi con categoria canto_carmine_greco o licenza cortesia_carmine_greco.",
    refresh: "node scripts/refresh-snapshot.mjs",
  };
  writeAtomic("manifest.json", manifest);
  console.log(JSON.stringify(manifest, null, 2));
}

main().catch((err) => {
  console.error(err && err.message ? err.message : err);
  process.exit(1);
});
