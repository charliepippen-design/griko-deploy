// Dati di build per Dizionario, Leggi ed Esplora.
// La fonte e' lo snapshot committato in data/snapshot. Supabase non viene
// chiamato qui: si aggiorna solo con scripts/refresh-snapshot.mjs.
//
// I campi transcript / trascrizione non sono nello snapshot e, se comparissero,
// vengono scartati. Lo stesso per i commenti parlati di Carmine Greco.

import palmaSnapshot from "../data/snapshot/palma.json";
import carmineSnapshot from "../data/snapshot/carmine.json";
import testiSnapshot from "../data/snapshot/testi.json";
import placesSnapshot from "../public/data/places.json";
import { excerpt } from "./testiMeta.js";
import { normalizeTitle } from "./titles.mjs";

const FORBIDDEN_KEY = /^(transcript|trascrizione)$/i;

// Sopra questa dimensione l'indice di /leggi riceve solo le anteprime.
// Il testo intero resta sulla scheda /leggi/[slug].
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

function presentCarmineLesson(row) {
  return {
    id: asNumber(row.id),
    video_id: row.video_id || "",
    titolo: row.titolo || "",
    categoria: row.categoria || "",
    categoria_label: row.categoria_label || "",
    durata: row.durata || "",
    sommario: row.sommario || "",
    proverbio: row.proverbio || "",
    youtube_url: row.youtube_url || "",
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
    titolo: normalizeTitle(row.titolo),
    categoria: row.categoria || "",
    testo: row.testo,
    url_fonte: row.url_fonte || "",
    licenza: row.licenza || "",
  };
}

function readArchive() {
  const palmaSrc = stripForbidden(palmaSnapshot);
  const carmineSrc = stripForbidden(carmineSnapshot);
  return {
    palma: {
      lessons: (palmaSrc.lessons || []).map(presentLesson),
      rules: (palmaSrc.rules || []).map(presentRule),
      lexemes: (palmaSrc.lexemes || []).map(presentLexeme),
      occurrences: (palmaSrc.occurrences || []).map(presentOccurrence),
    },
    carmine: {
      lessons: (carmineSrc.lessons || []).map(presentCarmineLesson),
      rules: (carmineSrc.rules || []).map(presentRule),
      lexemes: (carmineSrc.lexemes || []).map(presentLexeme),
      occurrences: (carmineSrc.occurrences || []).map(presentOccurrence),
    },
    testi: (Array.isArray(testiSnapshot) ? testiSnapshot : [])
      .map((row) => stripForbidden(row))
      .filter(isSafeTesto)
      .map(presentTesto),
    places: (Array.isArray(placesSnapshot) ? placesSnapshot : []).map(presentPlace),
  };
}

const archive = readArchive();

export function getDizionarioProps() {
  return {
    props: {
      lessons: archive.palma.lessons,
      rules: archive.palma.rules,
      lexemes: archive.palma.lexemes,
      occurrences: archive.palma.occurrences,
      carmineLessons: archive.carmine.lessons,
      carmineRules: archive.carmine.rules,
      carmineLexemes: archive.carmine.lexemes,
      carmineOccurrences: archive.carmine.occurrences,
    },
  };
}

export function getLeggiIndexProps() {
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
  return { props: { testi, ricercaCompleta } };
}

export function listTestiSlugs() {
  return archive.testi.map((row) => row.slug).filter((slug) => /^[a-z0-9_-]+$/i.test(slug));
}

export function getLeggiTestoProps(slug) {
  if (typeof slug !== "string" || !/^[a-z0-9_-]+$/i.test(slug)) {
    return { notFound: true };
  }
  const testo = archive.testi.find((row) => row.slug === slug);
  if (!testo) return { notFound: true };
  return { props: { testo } };
}

export function getEsploraProps() {
  return {
    props: {
      places: archive.places,
      dataSource: "Archivio verificato",
    },
  };
}
