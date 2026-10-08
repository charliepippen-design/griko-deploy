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

export function creditoTesto(row) {
  if (isPalumboMatinata(row)) {
    return { tipo: "palumbo", urlFonte: row.url_fonte || "" };
  }
  if (isCiuriCePedi(row)) {
    return {
      tipo: "ciuri",
      urlFonte: row.url_fonte || "",
      licenzaUrl: CIURI_LICENSE_URL,
    };
  }
  return {
    tipo: "altro",
    urlFonte: row.url_fonte || "",
    etichetta: row.licenza || "",
  };
}
