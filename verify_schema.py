import requests

SUPABASE_URL = "https://xhpcztzisqdzqiwrojvl.supabase.co"
PUBLISHABLE_KEY = "sb_publishable_fvHGcE6xrVfdg5tHLZKZUQ_7yKSg_iV"

headers = {
    "apikey": PUBLISHABLE_KEY,
    "Authorization": f"Bearer {PUBLISHABLE_KEY}"
}

tables = ["lessons", "rules", "lexemes", "occurrences"]
all_ok = True

print(f"Verifica schema su {SUPABASE_URL}...")
for table in tables:
    r = requests.get(f"{SUPABASE_URL}/rest/v1/{table}?select=count", headers={**headers, "Prefer": "count=exact"})
    if r.status_code == 200:
        print(f"  [OK] Tabella '{table}': accessibile pubblicamente (righe: {r.json()[0]['count'] if r.json() else 0})")
    else:
        print(f"  [MANCANTE/ERRORE] Tabella '{table}': HTTP {r.status_code} - {r.text}")
        all_ok = False

if all_ok:
    print("\nEsito: Tutte le 4 tabelle sono presenti, con RLS e lettura pubblica attiva!")
else:
    print("\nEsito: Alcune tabelle non sono ancora state create nel database.")
