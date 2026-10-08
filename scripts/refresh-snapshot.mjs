// Aggiorna data/snapshot/ leggendo Supabase con la chiave publishable.
// Il sito non chiama Supabase in build: dopo questo script va committato
// lo snapshot e rifatto il deploy.
//
//   node scripts/refresh-snapshot.mjs
//
// Non scrive i campi transcript / trascrizione, ne' i commenti parlati di
// Carmine Greco. Non legge carmine_transcripts_clean/ ne'
// data/carmine_greco_lessons_full.json: il controllo usa categoria, licenza,
// slug, id video noti e le impronte gia' salvate in scripts/carmine-shingles.json.
// Se il download fallisce, i file gia' presenti restano invariati.

import { readFileSync, writeFileSync, mkdirSync, renameSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";
import { normalizeTitle } from "../lib/titles.mjs";
import { windowHashes } from "./shingles.mjs";

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

// Commenti parlati gia' pubblicati in testi_liberi. Lo slug e' carmine-canto-<id>.
const CARMINE_VIDEO_IDS = ["1aPLzdvMZD8", "HBPfozK7mmg", "kEjiN6uOi08", "msCVBKK1dD0"];

// Un testo attribuito a Carmine Greco piu' lungo di cosi' e' un commento parlato,
// non un canto in pubblico dominio. Le fiabe lunghe non portano questi segnali.
const CARMINE_TESTO_LIMIT = 1500;

function loadBannedShingles() {
  const file = join(root, "scripts/carmine-shingles.json");
  const parsed = JSON.parse(readFileSync(file, "utf8"));
  const hashes = Array.isArray(parsed.hashes) ? parsed.hashes : [];
  if (hashes.length < 1000) {
    throw new Error("scripts/carmine-shingles.json non contiene le impronte attese");
  }
  return new Set(hashes);
}

function isCarmineCommentary(row) {
  const slug = String(row.slug || "");
  const categoria = String(row.categoria || "");
  const licenza = String(row.licenza || "");
  if (categoria === "canto_carmine_greco" || /carmine/i.test(categoria)) return true;
  if (licenza === "cortesia_carmine_greco" || /carmine/i.test(licenza)) return true;
  if (/^carmine-/i.test(slug)) return true;
  const blob = `${slug} ${row.titolo || ""} ${row.url_fonte || ""}`;
  if (CARMINE_VIDEO_IDS.some((id) => blob.includes(id))) return true;
  return false;
}

function assertClean(value, banned, trail = "$") {
  if (typeof value === "string") {
    for (const hash of windowHashes(value, 1)) {
      if (banned.has(hash)) {
        throw new Error(`Testo troppo vicino a una trascrizione di Carmine Greco in ${trail}`);
      }
    }
    return;
  }
  if (Array.isArray(value)) {
    value.forEach((item, index) => assertClean(item, banned, `${trail}[${index}]`));
    return;
  }
  if (value && typeof value === "object") {
    for (const [key, inner] of Object.entries(value)) {
      if (/^(transcript|trascrizione)$/i.test(key)) {
        throw new Error(`Chiave vietata "${key}" in ${trail}`);
      }
      assertClean(inner, banned, `${trail}.${key}`);
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
  if (isCarmineCommentary(row)) return false;
  const authorHint = `${row.categoria || ""} ${row.licenza || ""} ${row.slug || ""} ${row.titolo || ""}`;
  if (typeof row.testo === "string" && row.testo.length > CARMINE_TESTO_LIMIT && /carmine/i.test(authorHint)) {
    return false;
  }
  if (typeof row.slug !== "string" || !/^[a-z0-9_-]+$/i.test(row.slug)) return false;
  if (!row.titolo || typeof row.testo !== "string" || row.testo.trim().length < 20) return false;
  return true;
}

function presentTesto(row) {
  return {
    slug: row.slug,
    titolo: normalizeTitle(row.titolo),
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
  const banned = loadBannedShingles();
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
      "Esclusi i campi transcript e trascrizione, i testi di Carmine Greco (categoria, licenza, slug carmine-*, id video noti, testo lungo attribuito a quell'autore) e le righe che ripetono una finestra di 24 parole delle trascrizioni.",
    refresh: "node scripts/refresh-snapshot.mjs",
  };
  writeAtomic("manifest.json", manifest);
  console.log(JSON.stringify(manifest, null, 2));
}

main().catch((err) => {
  console.error(err && err.message ? err.message : err);
  process.exit(1);
});
