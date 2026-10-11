// Toglie dal testo le liste di titoli "Related Posts" copiate dal sito fonte.

import { readFileSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const TITOLI = new Set(
  JSON.parse(readFileSync(join(root, "data/ciuri-related-titles.json"), "utf8")).map((t) =>
    String(t).trim()
  )
);

export function pulisciTesto(testo) {
  if (typeof testo !== "string") return testo;
  let out = testo;
  const i = out.indexOf("Related Posts:");
  if (i !== -1) out = out.slice(0, i);
  const righe = out.split("\n");
  while (righe.length && TITOLI.has(righe[righe.length - 1].trim())) righe.pop();
  return righe.join("\n").trimEnd();
}
