import csv

rules, vocab = [], []
lesson = None
for line in open(r"C:\griko-deploy\_extraction_raw.txt", encoding="utf-8"):
    line = line.rstrip("\n")
    if line.startswith("@@LESSON"):
        lesson = int(line.split()[1])
    elif line.startswith("#RULE "):
        rules.append((lesson, line[6:].strip()))
    elif line.startswith("$VOCAB "):
        body = line[7:]
        if "::" in body:
            g, i = body.split("::", 1)
            vocab.append((lesson, g.strip(), i.strip()))

with open(r"C:\griko-deploy\02_rules.csv", "w", encoding="utf-8", newline="") as f:
    w = csv.writer(f)
    w.writerow(["id", "lesson_id", "regola_testo"])
    for n, (lid, txt) in enumerate(rules, 1):
        w.writerow([n, lid, txt])

with open(r"C:\griko-deploy\03_vocabulary.csv", "w", encoding="utf-8", newline="") as f:
    w = csv.writer(f)
    w.writerow(["id", "lesson_id", "parola_griko", "parola_italiano"])
    for n, (lid, g, i) in enumerate(vocab, 1):
        w.writerow([n, lid, g, i])

lessons_lines = sum(1 for _ in open(r"C:\griko-deploy\01_lessons.csv", encoding="utf-8")) - 1
print(f"01_lessons.csv  righe dati: {lessons_lines}")
print(f"02_rules.csv    righe dati: {len(rules)}")
print(f"03_vocabulary.csv righe dati: {len(vocab)}")
