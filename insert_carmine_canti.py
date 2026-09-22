# -*- coding: utf-8 -*-
"""
Inserisce in Supabase (tabella public.testi_liberi) i 4 commenti video di
Carmine Greco ai canti tradizionali (Kalinifta, Klama, Aremu Rindinedda-mu,
Agapi-mu Fidela Protinì), presi da public/data/carmine_greco_lessons.json.

IMPORTANTE: questo NON è testo tradizionale di pubblico dominio come il resto
di testi_liberi — è la trascrizione della spiegazione parlata (in italiano)
di Carmine Greco nei suoi video YouTube. Per questo la licenza è
"cortesia_carmine_greco", non "pubblico_dominio_tradizione_orale", e il
testo NON viene marcato notranslate lato frontend (leggi/index.js già
gestisce questo tramite isGrikoText()).

NON ESEGUITO AUTOMATICAMENTE: lancialo solo dopo conferma esplicita, con
    SUPABASE_SECRET_KEY=... python insert_carmine_canti.py
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
    "Prefer": "resolution=merge-duplicates,return=representation",
}


def slugify(video_id: str) -> str:
    return f"carmine-canto-{video_id}"


def main():
    with open("public/data/carmine_greco_lessons.json", encoding="utf-8") as f:
        data = json.load(f)

    poesie = [l for l in data["lessons"] if l.get("is_poetry")]
    print(f"Trovate {len(poesie)} lezioni-canto di Carmine Greco da inserire.\n")

    for l in poesie:
        row = {
            "slug": slugify(l["video_id"]),
            "titolo": l["title"],
            "categoria": "canto_carmine_greco",
            "testo": l["transcript"],
            "url_fonte": l["youtube_url"],
            "licenza": "cortesia_carmine_greco",
        }
        res = requests.post(
            f"{SUPABASE_URL}/rest/v1/testi_liberi?on_conflict=slug",
            headers=HEADERS,
            json=row,
            timeout=20,
        )
        if res.status_code not in (200, 201):
            print(f"  [ERRORE] {row['slug']}: HTTP {res.status_code} - {res.text[:200]}")
        else:
            print(f"  [OK] {row['titolo']}")

    print("\nCompletato.")


if __name__ == "__main__":
    main()
