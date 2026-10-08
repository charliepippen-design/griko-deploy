// Caricamento dell'archivio per getStaticProps.
// Lo snapshot in data/snapshot e' la fonte che il build usa sempre.
// Supabase e' un aggiornamento facoltativo: se le variabili mancano, se il
// progetto e' in pausa o se la richiesta supera il tempo massimo, si resta
// sullo snapshot e il build non fallisce.
//
// Non vengono mai restituiti i campi transcript / trascrizione, ne' i testi
// con licenza o categoria del commento parlato di Carmine Greco.

import palmaSnapshot from "../data/snapshot/palma.json";
import carmineSnapshot from "../data/snapshot/carmine.json";
import testiSnapshot from "../data/snapshot/testi.json";
import placesSnapshot from "../public/data/places.json";
import { excerpt } from "./testiMeta.js";

const TIMEOUT_MS = 2500;
export const REVALIDATE_SECONDS = 60 * 60 * 24;

const DEFAULT_URL = "https://xhpcztzisqdzqiwrojvl.supabase.co";
const DEFAULT_KEY =
  "sb_publishable_fvHGcE6xrVfdg5tHLZKZUQ_7yKSg_iV";

const FORBIDDEN_KEY = /^(transcript|trascrizione)$/i;

// Sopra questa dimensione l'indice di /leggi riceve solo le anteprime.
// Il testo intero resta sulla scheda /leggi/[slug], gia' nel HTML.
const INDEX_FULL_TEXT_BUDGET = 900000;

function stripForbidden(value) {
  if (Array.isArray(value)) return value.map(stripForbidden);
  if (value && typeof value === "object") {
    const out = {};
    for (const [key, inner] of Object.entries(value)) {
      if (FORBIDDEN_KEY.test(key)) continue;
      out[key] = stripForbidden(inner);
    }
    return out;
  }
  return value;
}

function asNumber(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n : value;
}

function presentLesson(row) {
  return {
    id: asNumber(row.id),
    titolo: row.titolo || "",
    categoria: row.categoria || "",
    genere: row.genere || "",
    desinenza: row.desinenza || "",
  };
}

function presentRule(row) {
  return {
    id: asNumber(row.id),
    lesson_id: asNumber(row.lesson_id),
    regola_testo: row.regola_testo || "",
  };
}

function presentLexeme(row) {
  return {
    id: asNumber(row.id),
    parola_griko: row.parola_griko || "",
    parola_italiano: row.parola_italiano || "",
  };
}

function presentOccurrence(row) {
  return {
    id: asNumber(row.id),
    lexeme_id: asNumber(row.lexeme_id),
    lesson_id: asNumber(row.lesson_id),
  };
}

function presentPalma(raw) {
  const src = raw && typeof raw === "object" ? raw : {};
  return {
    lessons: (src.lessons || []).map(presentLesson),
    rules: (src.rules || []).map(presentRule),
    lexemes: (src.lexemes || []).map(presentLexeme),
    occurrences: (src.occurrences || []).map(presentOccurrence),
  };
}

function presentCarmine(raw) {
  const src = raw && typeof raw === "object" ? raw : {};
  return {
    rules: (src.rules || []).map(presentRule),
    lexemes: (src.lexemes || []).map(presentLexeme),
    occurrences: (src.occurrences || []).map(presentOccurrence),
  };
}

function presentPlace(row) {
  return {
    id: row.id,
    nome: row.nome || "",
    nome_griko: row.nome_griko || "",
    nome_griko_alfabeto: row.nome_griko_alfabeto || "",
    popolazione: row.popolazione ?? null,
    anno_popolazione: row.anno_popolazione ?? null,
    lat: row.lat ?? null,
    lng: row.lng ?? null,
    cenno_storico: row.cenno_storico || "",
    elemento_interesse: row.elemento_interesse || "",
    fonte_wikipedia_url: row.fonte_wikipedia_url || "",
    fonte_wikidata_url: row.fonte_wikidata_url || "",
    ordine: row.ordine ?? null,
  };
}

export function isSafeTesto(row) {
  if (!row || typeof row !== "object") return false;
  if (row.categoria === "canto_carmine_greco") return false;
  if (row.licenza === "cortesia_carmine_greco") return false;
  if (typeof row.slug !== "string" || !/^[a-z0-9_-]+$/i.test(row.slug)) return false;
  if (typeof row.titolo !== "string" || !row.titolo.trim()) return false;
  if (typeof row.testo !== "string" || row.testo.trim().length < 20) return false;
  return true;
}

function presentTesto(row) {
  return {
    slug: row.slug,
    titolo: row.titolo,
    categoria: row.categoria || "",
    testo: row.testo,
    url_fonte: row.url_fonte || "",
    licenza: row.licenza || "",
  };
}

function readLocal() {
  const palma = presentPalma(stripForbidden(palmaSnapshot));
  const carmine = presentCarmine(stripForbidden(carmineSnapshot));
  const testi = (Array.isArray(testiSnapshot) ? testiSnapshot : [])
    .map((row) => stripForbidden(row))
    .filter(isSafeTesto)
    .map(presentTesto);
  const places = (Array.isArray(placesSnapshot) ? placesSnapshot : []).map(presentPlace);
  return { palma, carmine, testi, places };
}

function supabaseConfig() {
  if (process.env.SKIP_SUPABASE === "1") return null;
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL ?? DEFAULT_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? DEFAULT_KEY;
  if (!url || !key) return null;
  return { url: url.replace(/\/$/, ""), key };
}

async function fetchTable(cfg, table, query, signal) {
  const pageSize = 1000;
  const rows = [];
  for (let offset = 0; offset < 5000; offset += pageSize) {
    const endpoint = `${cfg.url}/rest/v1/${table}?${query}&limit=${pageSize}&offset=${offset}`;
    const res = await fetch(endpoint, {
      headers: {
        apikey: cfg.key,
        Authorization: `Bearer ${cfg.key}`,
        Accept: "application/json",
      },
      signal,
    });
    if (!res.ok) {
      throw new Error(`${table} HTTP ${res.status}`);
    }
    const data = await res.json();
    if (!Array.isArray(data)) {
      throw new Error(`${table} risposta non valida`);
    }
    rows.push(...data);
    if (data.length < pageSize) break;
  }
  return rows;
}

async function tryRemote() {
  const cfg = supabaseConfig();
  if (!cfg) return null;
  const signal = AbortSignal.timeout(TIMEOUT_MS);
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
      places,
    ] = await Promise.all([
      fetchTable(
        cfg,
        "lessons",
        "select=id,titolo,categoria,genere,desinenza&order=id.asc",
        signal
      ),
      fetchTable(
        cfg,
        "rules",
        "select=id,lesson_id,regola_testo&order=id.asc",
        signal
      ),
      fetchTable(
        cfg,
        "lexemes",
        "select=id,parola_griko,parola_italiano&order=parola_griko.asc",
        signal
      ),
      fetchTable(
        cfg,
        "occurrences",
        "select=id,lexeme_id,lesson_id&order=id.asc",
        signal
      ),
      fetchTable(
        cfg,
        "carmine_rules",
        "select=id,lesson_id,regola_testo&order=id.asc",
        signal
      ),
      fetchTable(
        cfg,
        "carmine_lexemes",
        "select=id,parola_griko,parola_italiano&order=parola_griko.asc",
        signal
      ),
      fetchTable(
        cfg,
        "carmine_occurrences",
        "select=id,lexeme_id,lesson_id&order=id.asc",
        signal
      ),
      fetchTable(
        cfg,
        "testi_liberi",
        "select=slug,titolo,categoria,testo,url_fonte,licenza&categoria=neq.canto_carmine_greco&order=titolo.asc",
        signal
      ),
      fetchTable(
        cfg,
        "places",
        "select=id,nome,nome_griko,nome_griko_alfabeto,popolazione,anno_popolazione,lat,lng,cenno_storico,elemento_interesse,fonte_wikipedia_url,fonte_wikidata_url,ordine&order=ordine.asc",
        signal
      ),
    ]);

    return {
      palma: presentPalma({ lessons, rules, lexemes, occurrences }),
      carmine: presentCarmine({
        rules: carmineRules,
        lexemes: carmineLexemes,
        occurrences: carmineOccurrences,
      }),
      testi: testi.map((row) => stripForbidden(row)).filter(isSafeTesto).map(presentTesto),
      places: places.map(presentPlace),
    };
  } catch (err) {
    console.warn(
      "[archive] Supabase non disponibile, uso lo snapshot locale:",
      err && err.message ? err.message : err
    );
    return null;
  }
}

function acceptCount(remoteLength, localLength, minimum) {
  if (remoteLength < minimum) return false;
  if (localLength > 0 && remoteLength + 1 < localLength * 0.9) return false;
  return true;
}

let pending;

function loadArchive() {
  if (!pending) {
    pending = (async () => {
      const local = readLocal();
      const remote = await tryRemote();
      if (!remote) {
        return { ...local, placesSource: "snapshot", testiSource: "snapshot" };
      }
      const palma = acceptCount(remote.palma.lessons.length, local.palma.lessons.length, 70) &&
        acceptCount(remote.palma.lexemes.length, local.palma.lexemes.length, 600)
        ? remote.palma
        : local.palma;
      const carmine = acceptCount(remote.carmine.rules.length, local.carmine.rules.length, 200) &&
        acceptCount(remote.carmine.lexemes.length, local.carmine.lexemes.length, 400)
        ? remote.carmine
        : local.carmine;
      const testi = acceptCount(remote.testi.length, local.testi.length, 20)
        ? remote.testi
        : local.testi;
      const places = acceptCount(remote.places.length, local.places.length, 9)
        ? remote.places
        : local.places;
      return {
        palma,
        carmine,
        testi,
        places,
        placesSource: places === remote.places ? "supabase" : "snapshot",
        testiSource: testi === remote.testi ? "supabase" : "snapshot",
      };
    })().catch((err) => {
      console.warn(
        "[archive] errore inatteso, uso lo snapshot locale:",
        err && err.message ? err.message : err
      );
      const local = readLocal();
      return { ...local, placesSource: "snapshot", testiSource: "snapshot" };
    });
  }
  return pending;
}

export async function getDizionarioProps() {
  const archive = await loadArchive();
  return {
    props: {
      lessons: archive.palma.lessons,
      rules: archive.palma.rules,
      lexemes: archive.palma.lexemes,
      occurrences: archive.palma.occurrences,
      carmineRules: archive.carmine.rules,
      carmineLexemes: archive.carmine.lexemes,
      carmineOccurrences: archive.carmine.occurrences,
    },
    revalidate: REVALIDATE_SECONDS,
  };
}

export async function getLeggiIndexProps() {
  const archive = await loadArchive();
  const total = archive.testi.reduce((sum, row) => sum + row.testo.length, 0);
  const ricercaCompleta = total <= INDEX_FULL_TEXT_BUDGET;
  const testi = archive.testi.map((row) => {
    const item = {
      slug: row.slug,
      titolo: row.titolo,
      categoria: row.categoria,
      anteprima: excerpt(row.testo, 180),
      url_fonte: row.url_fonte,
      licenza: row.licenza,
    };
    if (ricercaCompleta) item.testo = row.testo;
    return item;
  });
  return {
    props: { testi, ricercaCompleta },
    revalidate: REVALIDATE_SECONDS,
  };
}

export function listTestiSlugs() {
  return readLocal()
    .testi.map((row) => row.slug)
    .filter((slug) => /^[a-z0-9_-]+$/i.test(slug));
}

export async function getLeggiTestoProps(slug) {
  if (typeof slug !== "string" || !/^[a-z0-9_-]+$/i.test(slug)) {
    return { notFound: true, revalidate: REVALIDATE_SECONDS };
  }
  const archive = await loadArchive();
  const fromArchive = archive.testi.find((row) => row.slug === slug);
  const local = readLocal().testi.find((row) => row.slug === slug);
  const testo = fromArchive || local;
  if (!testo) {
    return { notFound: true, revalidate: REVALIDATE_SECONDS };
  }
  return {
    props: { testo: presentTesto(testo) },
    revalidate: REVALIDATE_SECONDS,
  };
}

export async function getEsploraProps() {
  const archive = await loadArchive();
  return {
    props: {
      places: archive.places,
      dataSource:
        archive.placesSource === "supabase" ? "Dati aggiornati" : "Archivio verificato",
    },
    revalidate: REVALIDATE_SECONDS,
  };
}
