# -*- coding: utf-8 -*-
"""
Scarica da ciuricepedi.it SOLO il materiale non protetto da copyright
(tradizione orale: fiabe, canti popolari, morolòj, proverbi, filastrocche)
e lo inietta in Supabase (tabella public.testi_liberi) via REST API.

ESCLUDE deliberatamente:
- /la-letteratura/letteratura-dautore/*  (opere d'autore protette)
- /i-video/*                              (media)
- /i-canti/gruppi-musicali/*              (esecuzioni/gruppi contemporanei)
- saggi/articoli critici a firma di autore vivente (BLACKLIST_PATTERNS)

SICUREZZA CONTENUTO (lezione appresa da un run precedente):
il tema WordPress del sito mostra più articoli in una sola pagina sulle URL
"di sezione" (es. /la-lingua/storia-e-teorie/), ciascuno con il proprio
<article class="entry-title">. Se si estrae ingenuamente il testo da quelle
pagine si mischia dentro anche il contenuto di saggi protetti. Per questo
la pagina viene scartata ogni volta che contiene PIÙ DI UN blocco articolo:
si accettano solo URL "foglia" a singolo post.
"""
import os
import re
import sys
import time
import requests
from bs4 import BeautifulSoup

sys.stdout.reconfigure(encoding="utf-8")

BASE = "https://www.ciuricepedi.it"
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

BLACKLIST_PATTERNS = [
    "/la-letteratura/letteratura-dautore",
    "/i-video",
    "/i-canti/gruppi-musicali",
    "lorigine-del-griko",
    "lingua-e-identita-il-caso-del-griko",
    "la-lingua-greco-salentina-tra-passato-e-futuro",
    "il-griko-la-mia-testimonianza",
    "il-griko-e-la-sua-anima",
    "lettera-aperta-sul-griko",
    "il-griko-storia-di-un-fenomeno-linguistico",
]

# Solo URL "foglia" verificate come singolo post (niente pagine di
# sezione/archivio, che mescolano più articoli).
CATEGORY_SOURCES = {
    "proverbio": [
        "/i-proverbi-la-natura-1", "/i-proverbi-la-natura-2", "/i-proverbi-la-natura-3",
        "/massime-di-vita-1", "/massime-di-vita-2", "/massime-di-vita-3",
        "/massime-di-vita-4", "/massime-di-vita-5", "/massime-di-vita-6",
        "/la-donna", "/il-matrimonio", "/i-figli", "/la-famiglia",
        "/il-denaro", "/la-ricchezza", "/la-poverta",
        "/ordine-naturale-ordine-morale", "/paradossi", "/il-lavoro",
        "/e-glossa-ti-tsichi-la-lingua-dellanima",
    ],
    "filastrocca": [
        "/ninne-nanne-martano", "/ninne-nanne-calimera",
        "/ninna-nanna-della-grecia-salentina",
    ],
    "morolòj": [
        "/moroloj-1-lamento-funebre", "/moroloj-2-lamento-funebre-per-la-figlia",
        "/moroloj-3-lamento-funebre-per-la-madre", "/moroloj-4-lamarezza-della-morte",
        "/moroloj-5-pianto-dellorfana", "/moroloj-6-infelice-chi-presiede-al-pianto",
        "/moroloj-7-pianto-per-la-morte-del-figlio",
        "/moroloj-8-preghiera-alla-terra-per-la-figlia-morta",
        "/moroloj-9-dialogo-tra-la-figlia-e-il-padre-morto",
        "/moroloj-10-invito-al-pianto",
    ],
    "canto_popolare": [
        "/kalinifta", "/aremu-rindineddha", "/aremo-rindineddha",
        "/preghiera-della-sera", "/preghiera-alladdolorata",
        "/preghiera-del-contadino", "/preghiera-a-san-pantaleo",
        "/santo-natale", "/sulla-tomba-di-cristo", "/il-tradimento-di-giuda",
        "/il-canto-della-passione", "/e-passiuna-canto-tradizionale",
    ],
}

# Le fiabe popolari (o-kunto-*) sono numerate come pagine singole fiaba-N-*.
FIABA_SLUGS = [
    "fiaba-1-o-milissi-ce-cikala", "fiaba-2-e-kiatera-tu-iju", "fiaba-3-o-kunto-tu-pondiku",
    "fiaba-4-o-kunto-mon-bucceri", "fiaba-5-o-kunto-moi-ruvittai", "fiaba-6-o-kunto-mo-rekko",
    "fiaba-7-o-liko-e-alipuna-ce-o-korafi", "fiaba-8-cini-pu-is-ekame-i-chari-o-demoni",
    "fiaba-9-o-kunto-ma-ta-sika", "fiaba-10-o-kunto-tu-re-portagallu", "fiaba-11",
    "fiaba-12-o-kunto-tu-liuna-is-akula-ce-is-furmikula", "fiaba-13-o-kunto-mi-pettera",
    "fiaba-14-o-kunto-ma-mia-kiatera-korasi", "fiaba-16-e-guscia-fsematara",
    "fiaba-18-o-kunto-tu-gran-biziri", "fiaba-19-o-kunto-mes-tris-kiatere",
    "fiaba-20-o-kunto-to-minkiuno", "fiaba-21-o-kunto-tis-furtuna", "fiaba-22-o-kunto-mo-merkanto",
    "fiaba-23-o-kunto-mi-kiatera-keccia", "fiaba-24-o-kunto-mo-demoni",
    "fiaba-25-o-kunto-mu-bernulitu", "fiaba-26-o-kunto-tis-principessa",
    "fiaba-27-o-kunto-mi-kulonna", "fiaba-28-o-kunto-tu-pescivindulu",
    "fiaba-29-o-kunto-mu-latru", "fiaba-30-o-kunto-tu-ja-pedru",
    "fiaba-31-o-kunto-mu-dodeka-minu", "fiaba-32-o-kunto-tu-liuna-fse-krusafi",
    "fiaba-33-o-kunto-to-buccero", "fiaba-34-o-kunto-mi-sciddhutza",
    "fiaba-35-o-liko-ce-alipuna-sti-massaria", "fiaba-36-o-kunto-mi-foni",
    "fiaba-37-o-kunto-mafsari", "fiaba-37-o-kunto-mo-nanni-orko",
    "fiaba-39-o-kunto-mi-madonna", "fiaba-40-o-kunto-mi-forata",
    "fiaba-41-cuntu-de-lu-surdatu", "fiaba-42-o-kunto-ku-la-cerasa-marena",
    "fiaba-43-o-kunto-mo-kalo-kami", "fiaba-44-o-kunto-mi-kiatera-atti-spagna",
    "fiaba-45-o-kunto-mon-a-giuvanni", "fiaba-46-o-kunto-mi-kiatera-ascimi",
    "fiaba-47-o-kunto-mi-mula", "fiaba-48-o-kunto-mi-sarditza",
    "fiaba-49-o-kunto-mo-tanato", "fiaba-50-o-kunto-mo-pedai-trisemero",
    "fiaba-51-o-kunto-me-diu-kiatere", "fiaba-52-o-kunto-mo-padre-abate",
    "fiaba-53-o-kunto-mo-gesu-nazareno", "fiaba-54-o-kunto-min-aderfi",
    "fiaba-55-o-kunto-mon-ipuno", "fiaba-56-o-kunto-tu-ja-pedru",
    "fiaba-57-o-kunto-mo-korasi", "fiaba-58-o-liuna-o-liko-e-alipuna-ce-o-ciuccio",
    "fiaba-59-o-kunto-mes-efta-kiatere", "fiaba-60-o-kunto-mus-kriu",
    "fiaba-61-o-kunto-mon-argulo-afsilo", "fiaba-62-ncora-non-e-natu-e-se-chiama-gian-dunatu",
    "fiaba-63-o-kunto-mus-tris-abetu", "fiaba-64-o-kunto-ma-mia-lokandiera",
    "fiaba-65-o-kunto-tis-pedrusinella", "fiaba-66-o-kunto-mon-vekkio",
    "fiaba-67-o-kunto-mi-cilia", "fiaba-68-e-mana-tu-a-pedro",
    "fiaba-69-o-kunto-mon-a-giuvanni", "fiaba-70-o-kunto-mi-katerini",
    "fiaba-71-o-kunto-mi-donna-kiarina", "fiaba-72-cuttenta-lu-signore",
    "fiaba-73-o-kunto-tis-tramuntana", "fiaba-74-o-kunto-ti-sella-ce-is-allakai",
    "fiaba-75-o-kunto-ti-pilamu-ce-i-vegna", "fiaba-76-a-dekatria-loja-is-alissia",
    "fiaba-77-o-kunto-mo-rikkibandu", "fiaba-78-o-kunto-tu-mesciu-frangisku",
    "fiaba-79-o-kunto-mon-atzari-rodino", "fiaba-80-o-kunto-me-dekatri-fate",
    "fiaba-81-o-kunto-ti-bella-rachele", "fiaba-82-o-kunto-mi-pupa",
    "fiaba-83-o-kunto-mon-a-nicola", "fiaba-84-o-kunto-mo-ci-sia-sia",
    "fiaba-85-o-kunto-mo-pedi-pesammeno", "fiaba-86-o-kunto-mo-don-kajatzo",
    "fiaba-87-o-kunto-mi-rudea", "fiaba-88-o-kunto-mi-sbriglia-mi-piuma-ce-min-allakai",
    "fiaba-89-o-kunto-mon-avokao", "fiaba-90-o-kunto-molo-to-kosmo",
    "fiaba-91-o-kunto-mes-tris-aderfe", "fiaba-92-o-kunto-mon-a-giakomo-apu-galizia",
    "fiaba-93-o-kunto-mon-aderfo-ce-min-aderfi", "fiaba-95-o-kunto-mon-an-bito",
    "fiaba-96-o-kunto-mo-sopo", "fiaba-97-o-kunto-min-appidea",
    "fiaba-98-o-kunto-mon-afimo-vromero", "fiaba-99-o-kunto-mo-servo",
    "fiaba-100-o-kunto-mo-daftilidi", "fiaba-101-o-kunto-me-ghineke",
    "fiaba-102-o-kunto-mu-magu", "fiaba-103-o-kunto-mon-annamurao",
    "fiaba-104-o-kunto-mi-kiatera-ascimi", "fiaba-105-o-kunto-mo-signoro-mea-ce-i-signura-mali",
    "fiaba-106-o-kunto-mon-arnai", "fiaba-107-o-kunto-mi-kiatera-tu-gran-turkiu",
    "fiaba-108-o-kunto-mes-tris-kiatere", "fiaba-109-o-kunto-mi-limba-mi-kandila-ce-mi-pinna",
    "fiaba-110-o-kunto-mo-pekurari", "fiaba-111-o-kunto-mo-mesciachillo",
    "fiaba-112-appendice-o-kunto-mi-katzottina", "fiaba-113-appendice-o-kunto-mo-papa-gregorio",
    "fiaba-114-appendice-o-kunto-mo-drago", "fiaba-115-appendice-o-kunto-mo-tridicino",
]
CATEGORY_SOURCES["fiaba"] = [f"/{s}" for s in FIABA_SLUGS]


def is_blacklisted(path: str) -> bool:
    return any(pat in path for pat in BLACKLIST_PATTERNS)


def fetch_html(path: str):
    url = BASE + path if path.startswith("/") else path
    try:
        r = requests.get(url, timeout=20, headers={"User-Agent": "Mozilla/5.0 (griko-archivio-libero-bot)"})
        if r.status_code != 200:
            print(f"  [SKIP] {url} -> HTTP {r.status_code}")
            return None, None
        final_path = re.sub(r"^https?://[^/]+", "", r.url)
        if final_path.rstrip("/") != path.rstrip("/") and is_blacklisted(final_path):
            print(f"  [SKIP redirect->protetto] {path} -> {final_path}")
            return None, None
        return r.text, final_path
    except requests.RequestException as e:
        print(f"  [ERRORE] {url}: {e}")
        return None, None


def extract_single_article(html: str):
    """Ritorna (titolo, testo) SOLO se la pagina contiene esattamente un
    articolo. Se ne contiene 0 o più di 1 (pagina indice/archivio) ritorna
    (None, None) per sicurezza copyright."""
    soup = BeautifulSoup(html, "html.parser")

    articles = soup.find_all("article")
    entry_titles = soup.find_all(class_="entry-title")
    if len(articles) > 1 or len(entry_titles) > 1:
        return None, None  # pagina con più post: scartata a priori

    title_tag = soup.find(class_="entry-title") or soup.find("h1")
    titolo = title_tag.get_text(strip=True) if title_tag else None

    content = articles[0] if articles else (soup.find("main") or soup.body)
    if content is None:
        return titolo, None

    for tag in content.find_all(["script", "style", "nav", "header", "footer", "aside", "form"]):
        tag.decompose()

    paragraphs = [p.get_text(" ", strip=True) for p in content.find_all(["p", "li"])]
    testo = "\n".join(p for p in paragraphs if p)
    return titolo, testo


def slugify(path: str) -> str:
    return path.strip("/").replace("/", "__") or "home"


def push_row(row: dict):
    res = requests.post(
        f"{SUPABASE_URL}/rest/v1/testi_liberi?on_conflict=slug",
        headers=HEADERS,
        json=row,
        timeout=20,
    )
    if res.status_code not in (200, 201):
        print(f"  [ERRORE PUSH] {row['slug']}: HTTP {res.status_code} - {res.text[:200]}")
        return False
    return True


def main():
    all_targets = []
    for categoria, paths in CATEGORY_SOURCES.items():
        for p in paths:
            if not is_blacklisted(p):
                all_targets.append((p, categoria))

    print(f"Totale pagine da elaborare: {len(all_targets)}\n")

    ok, skipped, failed = 0, 0, 0
    seen_final_paths = set()
    for path, categoria in all_targets:
        if is_blacklisted(path):
            skipped += 1
            continue
        html, final_path = fetch_html(path)
        if not html:
            failed += 1
            continue
        if final_path in seen_final_paths:
            skipped += 1
            continue
        seen_final_paths.add(final_path)

        titolo, testo = extract_single_article(html)
        if not titolo or not testo or len(testo) < 20:
            print(f"  [SKIP multi-articolo/vuoto] {path}")
            skipped += 1
            continue

        row = {
            "slug": slugify(final_path),
            "titolo": titolo,
            "categoria": categoria,
            "testo": testo,
            "url_fonte": BASE + final_path,
            "licenza": "pubblico_dominio_tradizione_orale",
        }
        if push_row(row):
            ok += 1
            print(f"  [OK] {categoria:15s} {titolo}")
        else:
            failed += 1
        time.sleep(0.3)

    print(f"\nCompletato. Inseriti/aggiornati: {ok} | Falliti: {failed} | Saltati: {skipped}")


if __name__ == "__main__":
    main()
