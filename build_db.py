import csv, json, os, sqlite3

BASE = r"C:\griko-deploy"

def read_csv(name):
    with open(os.path.join(BASE, name), encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))

lessons = read_csv("01_lessons.csv")
rules = read_csv("02_rules.csv")
vocab = read_csv("03_vocabulary.csv")

# --- SQLite ---
db = os.path.join(BASE, "griko_grammar.db")
if os.path.exists(db):
    os.remove(db)
con = sqlite3.connect(db)
con.execute("PRAGMA foreign_keys = ON")
cur = con.cursor()
cur.execute("""CREATE TABLE lessons (
    id INTEGER PRIMARY KEY, titolo TEXT, categoria TEXT,
    genere TEXT, desinenza TEXT, video_index INTEGER)""")
cur.execute("""CREATE TABLE rules (
    id INTEGER PRIMARY KEY, lesson_id INTEGER, regola_testo TEXT,
    FOREIGN KEY(lesson_id) REFERENCES lessons(id))""")
cur.execute("""CREATE TABLE vocabulary (
    id INTEGER PRIMARY KEY, lesson_id INTEGER,
    parola_griko TEXT, parola_italiano TEXT,
    FOREIGN KEY(lesson_id) REFERENCES lessons(id))""")

cur.executemany("INSERT INTO lessons VALUES (?,?,?,?,?,?)",
    [(int(l["id"]), l["titolo"], l["categoria"], l["genere"], l["desinenza"], int(l["video_index"])) for l in lessons])
cur.executemany("INSERT INTO rules VALUES (?,?,?)",
    [(int(r["id"]), int(r["lesson_id"]), r["regola_testo"]) for r in rules])
cur.executemany("INSERT INTO vocabulary VALUES (?,?,?,?)",
    [(int(v["id"]), int(v["lesson_id"]), v["parola_griko"], v["parola_italiano"]) for v in vocab])
con.commit()
con.close()

# --- JSON (nested) ---
rules_by_lesson, vocab_by_lesson = {}, {}
for r in rules:
    rules_by_lesson.setdefault(int(r["lesson_id"]), []).append(
        {"id": int(r["id"]), "regola_testo": r["regola_testo"]})
for v in vocab:
    vocab_by_lesson.setdefault(int(v["lesson_id"]), []).append(
        {"id": int(v["id"]), "parola_griko": v["parola_griko"], "parola_italiano": v["parola_italiano"]})

nested = []
for l in lessons:
    lid = int(l["id"])
    nested.append({
        "id": lid, "titolo": l["titolo"], "categoria": l["categoria"],
        "genere": l["genere"], "desinenza": l["desinenza"], "video_index": int(l["video_index"]),
        "rules": rules_by_lesson.get(lid, []),
        "vocabulary": vocab_by_lesson.get(lid, []),
    })

out = {"lessons": nested,
       "rules": [{"id": int(r["id"]), "lesson_id": int(r["lesson_id"]), "regola_testo": r["regola_testo"]} for r in rules],
       "vocabulary": [{"id": int(v["id"]), "lesson_id": int(v["lesson_id"]), "parola_griko": v["parola_griko"], "parola_italiano": v["parola_italiano"]} for v in vocab]}

os.makedirs(os.path.join(BASE, "public", "data"), exist_ok=True)
with open(os.path.join(BASE, "public", "data", "griko-data.json"), "w", encoding="utf-8") as f:
    json.dump(out, f, ensure_ascii=False, indent=2)

print(f"DB creato: {db}")
print(f"  lessons={len(lessons)} rules={len(rules)} vocabulary={len(vocab)}")
print(f"JSON creato: public/data/griko-data.json ({os.path.getsize(os.path.join(BASE,'public','data','griko-data.json'))} byte)")
