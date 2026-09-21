import csv
import os
import requests

BASE = r"C:\griko-deploy"
SUPABASE_URL = "https://xhpcztzisqdzqiwrojvl.supabase.co"
SUPABASE_SECRET_KEY = os.environ.get("SUPABASE_SECRET_KEY", "")

HEADERS = {
    "apikey": SUPABASE_SECRET_KEY,
    "Authorization": f"Bearer {SUPABASE_SECRET_KEY}",
    "Content-Type": "application/json",
    "Prefer": "return=representation"
}

def read_csv(filename):
    filepath = os.path.join(BASE, filename)
    with open(filepath, encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))

def batch_insert(table_name, rows, batch_size=100):
    total = len(rows)
    inserted = []
    for i in range(0, total, batch_size):
        batch = rows[i:i + batch_size]
        res = requests.post(f"{SUPABASE_URL}/rest/v1/{table_name}", headers=HEADERS, json=batch)
        if res.status_code not in (200, 201):
            raise RuntimeError(f"Errore inserimento in {table_name} batch {i}-{i+len(batch)}: HTTP {res.status_code} - {res.text}")
        inserted.extend(res.json())
        print(f"  [{table_name}] Inseriti {len(inserted)}/{total} record...")
    return inserted

def main():
    print("=== AVVIO MIGRAZIONE DATI SU SUPABASE (SOTTO-FASE B) ===")
    
    lessons_csv = read_csv("01_lessons.csv")
    rules_csv = read_csv("02_rules.csv")
    vocab_csv = read_csv("03_vocabulary.csv")
    
    print(f"CSV letti: lessons={len(lessons_csv)}, rules={len(rules_csv)}, vocabulary={len(vocab_csv)}")
    
    # 0. Svuota tabelle per idempotenza (ordine inverso FK)
    print("\n1. Pulizia preventiva tabelle esistenti...")
    del_headers = {
        "apikey": SUPABASE_SECRET_KEY,
        "Authorization": f"Bearer {SUPABASE_SECRET_KEY}"
    }
    for tbl in ["occurrences", "lexemes", "rules", "lessons"]:
        r = requests.delete(f"{SUPABASE_URL}/rest/v1/{tbl}?id=gt.0", headers=del_headers)
        if r.status_code not in (200, 204):
            print(f"  Nota svuotamento {tbl}: HTTP {r.status_code} ({r.text})")
        else:
            print(f"  Tabella {tbl} svuotata con successo.")
            
    # 1. Inserimento lessons (73 record)
    print("\n2. Inserimento lessons...")
    lessons_data = [
        {
            "id": int(l["id"]),
            "titolo": l["titolo"].strip(),
            "categoria": l["categoria"].strip(),
            "genere": l["genere"].strip(),
            "desinenza": l["desinenza"].strip(),
            "video_index": int(l["video_index"])
        }
        for l in lessons_csv
    ]
    batch_insert("lessons", lessons_data)
    
    # 2. Inserimento rules (158 record)
    print("\n3. Inserimento rules...")
    rules_data = [
        {
            "id": int(r["id"]),
            "lesson_id": int(r["lesson_id"]),
            "regola_testo": r["regola_testo"].strip()
        }
        for r in rules_csv
    ]
    batch_insert("rules", rules_data)
    
    # 3. Deduplicazione vocabolario in lexemes unici
    print("\n4. Deduplicazione vocabolario in lexemes unici...")
    unique_lexemes = []
    seen = set()
    for v in vocab_csv:
        g = v["parola_griko"].strip()
        it = v["parola_italiano"].strip()
        key = (g, it)
        if key not in seen:
            seen.add(key)
            unique_lexemes.append({"parola_griko": g, "parola_italiano": it})
            
    print(f"  Totale coppie uniche trovate: {len(unique_lexemes)} su {len(vocab_csv)} righe iniziali")
    print(f"  Coppie duplicate rimosse: {len(vocab_csv) - len(unique_lexemes)}")
    
    # Inserimento lexemes
    inserted_lexemes = batch_insert("lexemes", unique_lexemes)
    
    # Mappatura (parola_griko, parola_italiano) -> lexeme_id
    lexeme_map = {
        (row["parola_griko"], row["parola_italiano"]): row["id"]
        for row in inserted_lexemes
    }
    
    # 4. Creazione occurrences (716 record)
    print("\n5. Creazione e inserimento occurrences...")
    occurrences_data = []
    for v in vocab_csv:
        g = v["parola_griko"].strip()
        it = v["parola_italiano"].strip()
        lid = int(v["lesson_id"])
        lexeme_id = lexeme_map[(g, it)]
        occurrences_data.append({
            "lexeme_id": lexeme_id,
            "lesson_id": lid
        })
        
    batch_insert("occurrences", occurrences_data)
    
    # 5. Verifica e conteggi finali da Supabase
    print("\n=== VERIFICA CONTEGGI REALI DA SUPABASE ===")
    counts = {}
    for tbl in ["lessons", "rules", "lexemes", "occurrences"]:
        res = requests.get(
            f"{SUPABASE_URL}/rest/v1/{tbl}?select=count",
            headers={**HEADERS, "Prefer": "count=exact"}
        )
        if res.status_code in (200, 206) and res.json():
            counts[tbl] = res.json()[0]["count"]
        else:
            counts[tbl] = f"Errore {res.status_code}"
            
    print(f"Conteggio 'lessons':     {counts.get('lessons')} (atteso: 73)")
    print(f"Conteggio 'rules':       {counts.get('rules')} (atteso: 158)")
    print(f"Conteggio 'lexemes':     {counts.get('lexemes')} (atteso: 684, < 716 confermato)")
    print(f"Conteggio 'occurrences': {counts.get('occurrences')} (atteso: 716)")
    
    assert counts.get("lessons") == 73, f"Lessons non corretto: {counts.get('lessons')}"
    assert counts.get("rules") == 158, f"Rules non corretto: {counts.get('rules')}"
    assert counts.get("lexemes") == 684, f"Lexemes non corretto: {counts.get('lexemes')}"
    assert counts.get("occurrences") == 716, f"Occurrences non corretto: {counts.get('occurrences')}"
    assert counts.get("lexemes") < 716, "Lexemes deve essere minore di 716 per deduplicazione!"
    
    print("\nMigrazione SOTTO-FASE B completata con successo e validata al 100%!")

if __name__ == "__main__":
    main()
