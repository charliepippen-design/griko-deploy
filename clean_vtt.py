import re, glob, os

SRC = r"C:\griko"
OUT = r"C:\griko-deploy\transcripts_clean"
os.makedirs(OUT, exist_ok=True)

def clean(path):
    raw = open(path, encoding="utf-8", errors="replace").read().split("\n")
    lines = []
    for ln in raw:
        if "-->" in ln:                       # timestamp cue line
            continue
        s = ln.strip()
        if s in ("WEBVTT",) or s.startswith("Kind:") or s.startswith("Language:"):
            continue
        s = re.sub(r"<[^>]+>", "", s)         # strip inline <...> tags
        s = s.strip()
        if not s:
            continue
        if re.fullmatch(r"\[.*?\]", s):       # drop [Musica] etc.
            continue
        lines.append(s)
    # collapse consecutive duplicates (rolling-caption repeats are adjacent)
    out = []
    for s in lines:
        if out and s == out[-1]:
            continue
        out.append(s)
    return out

files = sorted(glob.glob(os.path.join(SRC, "*.vtt")))
assert len(files) == 73, f"attesi 73 vtt, trovati {len(files)}"

counts = []
for f in files:
    idx = os.path.basename(f)[:2]             # "01".."73"
    text = clean(f)
    counts.append(len(text))
    with open(os.path.join(OUT, f"{idx}.txt"), "w", encoding="utf-8") as w:
        w.write("\n".join(text) + "\n")

print(f"file scritti: {len(files)}")
print(f"righe pulite: min={min(counts)} max={max(counts)} media={sum(counts)/len(counts):.1f}")
