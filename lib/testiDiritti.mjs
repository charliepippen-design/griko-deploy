// Diritti e esclusioni dei testi di /leggi.
// Non riscrive lo snapshot: un refresh successivo continua a rispettarle.

import { TESTI_ESCLUSI } from "../data/testi-esclusi.mjs";
import { normalizeTitle } from "./titles.mjs";

export const CIURI_LICENSE_URL = "https://creativecommons.org/licenses/by-nc/4.0/deed.it";

function fold(value) {
  return normalizeTitle(value)
    .toLowerCase()
    .normalize("NFD")
    .replace(/\p{M}/gu, "")
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

const slugs = new Set(TESTI_ESCLUSI.map((entry) => entry.slug));
const titleKeys = TESTI_ESCLUSI.map((entry) => fold(entry.titolo)).filter((key) => key.length >= 8);

export function isExcludedTesto(row) {
  if (!row || typeof row !== "object") return false;
  if (typeof row.slug === "string" && slugs.has(row.slug)) return true;
  const title = fold(row.titolo || "");
  if (!title) return false;
  return titleKeys.some((key) => title === key || title.includes(key));
}

export function isPalumboMatinata(row) {
  const slug = String(row?.slug || "");
  const licenza = String(row?.licenza || "");
  const url = String(row?.url_fonte || "");
  if (slug === "matinata-kali-nifta-palumbo") return true;
  if (/palumbo/i.test(licenza) && /1918|pubblico_dominio_autore/.test(licenza)) return true;
  if (/wikisource\.org/i.test(url) && /matinata/i.test(`${url} ${slug}`)) return true;
  return false;
}

export function isCiuriCePedi(row) {
  if (!row || typeof row !== "object" || isPalumboMatinata(row)) return false;
  const url = String(row.url_fonte || "");
  const licenza = String(row.licenza || "");
  if (/ciuricepedi\.it/i.test(url)) return true;
  if (/ciuri|by-nc/i.test(licenza)) return true;
  return false;
}

// Fonti a stampa dei testi: sono le righe di attribuzione di ogni pagina di
// Ciuri ce Pedì (verificate l'11 ottobre 2026); i dati del volume delle fiabe
// vengono dal catalogo RetePop.
const SICURO = "Salvatore Sicuro, Ìtela na su po..., Ghetonìa, 1999";
const PALUMBO_CORIGLIANO = "manoscritto di Vito Domenico Palumbo relativo ai canti di Corigliano d'Otranto, da";
const moroloj = (pagine) => ({
  formula: "traduzione",
  fonte: `${PALUMBO_CORIGLIANO} ${SICURO}, ${pagine}`,
});
const APPENDICE = (voce) => ({
  formula: "trascrizione",
  fonte: `Fiaba registrata da Salvatore Tommasi a Calimera il 19 marzo 1998 dalla voce di ${voce}`,
});

const FIABE = {
  formula: "trascrizione",
  fonte:
    "Fiaba dai quaderni di Vito Domenico Palumbo (1883-1912), pubblicata da Salvatore Tommasi in Io' mia forà... Fiabe e racconti della Grecìa salentina, Ghetonìa, 1998",
};

export const FONTI_TESTI = {
  "il-canto-della-passione": {
    formula: "traduzione",
    fonte: `${SICURO}, pp. 203-215 (versione di Corigliano d'Otranto)`,
  },
  "il-tradimento-di-giuda": { formula: "traduzione", fonte: `${SICURO}, pp. 230-233` },
  "sulla-tomba-di-cristo": {
    formula: "traduzione",
    fonte: `${SICURO}, pp. 214-219 (versione di Corigliano d'Otranto)`,
  },
  "moroloj-4-lamarezza-della-morte": moroloj("pp. 358-359"),
  "moroloj-5-pianto-dellorfana": moroloj("pp. 348-351"),
  "moroloj-6-infelice-chi-presiede-al-pianto": moroloj("pp. 323-325"),
  "moroloj-7-pianto-per-la-morte-del-figlio": moroloj("pp. 300-303"),
  "moroloj-8-preghiera-alla-terra-per-la-figlia-morta": moroloj("pp. 325-329"),
  "moroloj-9-dialogo-tra-la-figlia-e-il-padre-morto": moroloj("pp. 308-313"),
  "moroloj-10-invito-al-pianto": moroloj("pp. 296-299"),
  "preghiera-della-sera": { formula: "traduzione", fonte: `${SICURO}, p. 23` },
  "preghiera-a-san-pantaleo": { formula: "solo-fonte", fonte: `${SICURO}, p. 398 (Zollino)` },
  "preghiera-alladdolorata": {
    formula: "solo-fonte",
    fonte: `${SICURO}, p. 234 (Corigliano d'Otranto)`,
  },
  "preghiera-del-contadino": {
    formula: "solo-fonte",
    fonte: `${SICURO}, p. 234 (Corigliano d'Otranto)`,
  },
  "santo-natale": {
    formula: "solo-fonte",
    fonte: `${SICURO}, p. 176 (Castrignano dei Greci)`,
  },
  "moroloj-1-lamento-funebre": {
    formula: "traduzione",
    fonte: "Giannino Aprile, Traùdia, Ghetonìa, 1990, pp. 165-166",
  },
  "ninne-nanne-calimera": {
    formula: "solo-fonte",
    fonte: "Giannino Aprile, Traùdia, Ghetonìa, 1990, pp. 157-158",
  },
  "ninne-nanne-martano": {
    formula: "trascrizione",
    fonte:
      "Ninne nanne da un quaderno di autore martanese ritrovato tra i manoscritti di Vito Domenico Palumbo, pubblicate anche in Francesca Licci, Iu' lei o lȏ, Ghetonìa, 2015, pp. 124-136",
  },
  "fiaba-112-appendice-o-kunto-mi-katzottina": APPENDICE("Biagia Palma"),
  "fiaba-113-appendice-o-kunto-mo-papa-gregorio": APPENDICE("Biagia Palma"),
  "fiaba-114-appendice-o-kunto-mo-drago": APPENDICE("Brizio Luigi Tommasi"),
  "fiaba-115-appendice-o-kunto-mo-tridicino": APPENDICE("Brizio Luigi Tommasi"),
};

export function fontePer(slug) {
  const s = String(slug || "");
  if (Object.hasOwn(FONTI_TESTI, s)) return FONTI_TESTI[s];
  if (s.startsWith("fiaba-")) return FIABE;
  return null;
}

const LICENZE_FORMULA = {
  traduzione: "traduzione_cc_by_nc_4.0_ciuri_ce_pedi",
  trascrizione: "cc_by_nc_4.0_ciuri_ce_pedi",
  "solo-fonte": "da_verificare_fonte_a_stampa",
};

export function licenzaTesto(row) {
  const voce = fontePer(row?.slug);
  return (voce && LICENZE_FORMULA[voce.formula]) || row?.licenza;
}

export function creditoTesto(row) {
  if (isPalumboMatinata(row)) {
    return { tipo: "palumbo", urlFonte: row.url_fonte || "" };
  }
  if (isCiuriCePedi(row)) {
    const credito = {
      tipo: "ciuri",
      urlFonte: row.url_fonte || "",
      licenzaUrl: CIURI_LICENSE_URL,
    };
    const voce = fontePer(row.slug);
    if (voce) {
      credito.fonte = voce.fonte;
      credito.formula = voce.formula;
    }
    return credito;
  }
  return {
    tipo: "altro",
    urlFonte: row.url_fonte || "",
    etichetta: row.licenza || "",
  };
}
