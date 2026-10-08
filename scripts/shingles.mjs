// Impronte di finestre di testo. Il refresh dello snapshot confronta
// queste impronte e non apre i file delle trascrizioni.
import { createHash } from "crypto";

export const WINDOW = 24;
export const STEP = 8;

export function normalizeWords(text) {
  return String(text || "")
    .toLowerCase()
    .normalize("NFKC")
    .replace(/[^\p{L}\p{N}\s]/gu, " ")
    .split(/\s+/)
    .filter(Boolean);
}

export function shingleHash(phrase) {
  return createHash("sha256").update(phrase).digest("hex").slice(0, 16);
}

export function windowHashes(text, step = 1) {
  const words = normalizeWords(text);
  const hashes = [];
  if (words.length < WINDOW) return hashes;
  for (let i = 0; i + WINDOW <= words.length; i += step) {
    hashes.push(shingleHash(words.slice(i, i + WINDOW).join(" ")));
  }
  return hashes;
}
