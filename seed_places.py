import json
import os
import requests

SUPABASE_URL = "https://xhpcztzisqdzqiwrojvl.supabase.co"
SUPABASE_SECRET_KEY = os.environ.get("SUPABASE_SECRET_KEY", "")

HEADERS = {
    "apikey": SUPABASE_SECRET_KEY,
    "Authorization": f"Bearer {SUPABASE_SECRET_KEY}",
    "Content-Type": "application/json",
    "Prefer": "resolution=merge-duplicates"
}

def main():
    json_path = os.path.join(os.path.dirname(__file__), "public", "data", "places.json")
    with open(json_path, encoding="utf-8") as f:
        places = json.load(f)

    print(f"Caricamento {len(places)} comuni in corso su Supabase ({SUPABASE_URL})...")

    # Tenta inserimento via PostgREST
    url = f"{SUPABASE_URL}/rest/v1/places"
    res = requests.post(url, headers=HEADERS, json=places)

    if res.status_code in (200, 201):
        print(f"  [SUCCESSO] {len(places)} comuni inseriti/aggiornati con successo nella tabella 'places'!")
    else:
        print(f"  [ATTENZIONE] Risposta Supabase: HTTP {res.status_code} - {res.text}")
        if res.status_code == 404:
            print("\n  NOTA: La tabella 'places' deve essere prima creata tramite SQL Editor:")
            print("  https://supabase.com/dashboard/project/xhpcztzisqdzqiwrojvl/sql/new")
            print("  Lo schema DDL pronto si trova in: supabase_places_schema.sql")

if __name__ == "__main__":
    main()
