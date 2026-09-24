# -*- coding: utf-8 -*-
"""
Costruisce lo schema normalizzato del corso di Carmine Greco (lezioni,
regole, vocabolario deduplicato, occorrenze) a partire da:
  - data/carmine_greco_lessons_full.json (metadati originali: titolo,
    categoria, durata, sommario, proverbio, youtube_url)
  - carmine_extracted_merged.json (regole + vocabolario gia' rielaborati
    editorialmente da trascrizione grezza, prodotti in batch)

Poi inserisce tutto in Supabase (tabelle carmine_lessons / carmine_rules /
carmine_lexemes / carmine_occurrences), stesso pattern di migrate_to_supabase.py
usato per il corso di Daniele Palma.

NON ESEGUITO AUTOMATICAMENTE: richiede conferma esplicita prima del lancio.
Uso:
    SUPABASE_SECRET_KEY=... python build_and_insert_carmine.py
"""
import json
import os
import sys
import requests

sys.stdout.reconfigure(encoding="utf-8")

SUPABASE_URL = "https://xhpcztzisqdzqiwrojvl.supabase.co"
SUPABASE_SECRET_KEY = os.environ.get("SUPABASE_SECRET_KEY", "")

if not SUPABASE_SECRET_KEY:
    sys.exit("Errore: variabile d'ambiente SUPABASE_SECRET_KEY non impostata.")

HEADERS = {
    "apikey": SUPABASE_SECRET_KEY,
    "Authorization": f"Bearer {SUPABASE_SECRET_KEY}",
    "Content-Type": "application/json",
    "Prefer": "return=representation",
}


def batch_insert(table, rows, batch_size=100):
    inserted = []
    for i in range(0, len(rows), batch_size):
        batch = rows[i:i + batch_size]
        res = requests.post(f"{SUPABASE_URL}/rest/v1/{table}", headers=HEADERS, json=batch, timeout=30)
        if res.status_code not in (200, 201):
            raise RuntimeError(f"Errore inserimento in {table}: HTTP {res.status_code} - {res.text[:300]}")
        inserted.extend(res.json())
        print(f"  [{table}] inseriti {len(inserted)}/{len(rows)}")
    return inserted


def main():
    with open("data/carmine_greco_lessons_full.json", encoding="utf-8") as f:
        orig = {l["video_id"]: l for l in json.load(f)["lessons"]}

    with open("carmine_extracted_merged.json", encoding="utf-8") as f:
        extracted = json.load(f)

    # 1. Lezioni (metadati + join con l'estrazione)
    lessons_rows = []
    for l in extracted:
        meta = orig[l["video_id"]]
        lessons_rows.append({
            "id": l["order"],
            "video_id": l["video_id"],
            "titolo": meta["title"],
            "categoria": meta["category"],
            "categoria_label": meta["category_label"],
            "durata": meta["duration"],
            "sommario": meta["summary"],
            "proverbio": meta.get("proverb"),
            "youtube_url": meta["youtube_url"],
        })

    # 2. Regole (una riga per regola, collegata alla lezione)
    rules_rows = []
    for l in extracted:
        for regola in l["rules"]:
            rules_rows.append({"lesson_id": l["order"], "regola_testo": regola})

    # 3. Vocabolario deduplicato globalmente (stessa logica di migrate_to_supabase.py)
    unique_lexemes = []
    seen = set()
    raw_occurrences = []  # (parola_griko, parola_italiano, lesson_id)
    for l in extracted:
        for v in l["vocabulary"]:
            g = v["parola_griko"].strip()
            it = v["parola_italiano"].strip()
            if not g or not it:
                continue
            key = (g, it)
            if key not in seen:
                seen.add(key)
                unique_lexemes.append({"parola_griko": g, "parola_italiano": it})
            raw_occurrences.append((g, it, l["order"]))

    print(f"Lezioni (gia' presenti, non toccate): {len(lessons_rows)}")
    print(f"Regole: {len(rules_rows)}")
    print(f"Lessemi unici: {len(unique_lexemes)} (da {len(raw_occurrences)} occorrenze grezze)")

    # --- Inserimento ---
    # NOTA: carmine_lessons NON viene toccata qui. Le 24 lezioni erano gia'
    # state inserite (stessi video_id/ordine) da un'altra sessione in
    # parallelo; questo script sostituisce solo regole/vocabolario/
    # occorrenze, che erano state svuotate a mano prima di lanciarlo.
    print("\n1. Inserimento carmine_rules...")
    batch_insert("carmine_rules", rules_rows)

    print("\n2. Inserimento carmine_lexemes...")
    inserted_lexemes = batch_insert("carmine_lexemes", unique_lexemes)
    lexeme_map = {(r["parola_griko"], r["parola_italiano"]): r["id"] for r in inserted_lexemes}

    print("\n3. Inserimento carmine_occurrences...")
    occurrences_rows = []
    occ_seen = set()
    for g, it, lesson_id in raw_occurrences:
        lexeme_id = lexeme_map[(g, it)]
        key = (lexeme_id, lesson_id)
        if key not in occ_seen:
            occ_seen.add(key)
            occurrences_rows.append({"lexeme_id": lexeme_id, "lesson_id": lesson_id})
    batch_insert("carmine_occurrences", occurrences_rows)

    print("\nCompletato.")


if __name__ == "__main__":
    main()
