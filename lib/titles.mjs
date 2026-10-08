// Titoli, meta OG/Twitter e nomi JSON-LD: un solo separatore,
// nessuno spazio doppio, nessun trattino lungo.

const LONG_DASH = /[\u2012\u2013\u2014\u2015]/g;

export function normalizeTitle(value) {
  let text = String(value ?? "")
    .replace(LONG_DASH, " | ")
    .replace(/\s+/g, " ")
    .trim();
  text = text.replace(/(?:\s*\|\s*){2,}/g, " | ");
  text = text.replace(/^(?:\|\s*)+/, "").replace(/(?:\s*\|)+$/, "").trim();
  return text;
}

export function normalizeJsonLdNames(node) {
  if (Array.isArray(node)) return node.map(normalizeJsonLdNames);
  if (node && typeof node === "object") {
    const out = {};
    for (const [key, value] of Object.entries(node)) {
      if (key === "name" && typeof value === "string") out[key] = normalizeTitle(value);
      else out[key] = normalizeJsonLdNames(value);
    }
    return out;
  }
  return node;
}
