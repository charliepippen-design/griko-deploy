# REPORT AUDIT — griko-deploy

_Audit in sola lettura. Data: 2026-09-18. Nessun file modificato per produrlo._

## 1. STACK TECNICO

**Dipendenze** (`package.json`):

| Pacchetto | Versione dichiarata | Risolta (lock) |
|---|---|---|
| next | ^14.0.0 | 14.2.35 (build) |
| react | ^18.2.0 | 18.x |
| react-dom | ^18.2.0 | 18.x |
| @supabase/supabase-js | ^2.38.0 | 2.116.0 |

- Nessuna dipendenza di sviluppo, nessun linter/TS configurato. Progetto JS puro (no TypeScript).
- `next.config.js`: solo `reactStrictMode: true`.

**`pages/index.js`** — 134 righe. Componente client-side unico (`useState`, `useMemo`). Fa esattamente:
- `import data from "../public/data/griko-data.json"` (import statico a build-time, **non** fetch runtime).
- Costruisce 3 mappe memoizzate: `lessonById`, `results` (filtro ricerca), `byCategory`.
- Ricerca: filtra `data.vocabulary` per `parola_griko`/`parola_italiano`, `includes()` case-insensitive.
- Rende: titolo, campo ricerca, lista risultati con provenienza, indice lezioni per categoria con espansione regole+vocabolario, footer nota.
- `pages/_app.js` (5 righe): importa `styles/globals.css`.
- `styles/globals.css` (47 righe): CSS semplice, nessun framework.

**File dati** `public/data/griko-data.json` (264 KB). Chiavi top-level: `lessons`, `rules`, `vocabulary`.
- `lessons[]` (oggetti annidati): `id, titolo, categoria, genere, desinenza, video_index, rules[], vocabulary[]`
  - `rules[]` annidati: `{id, regola_testo}`
  - `vocabulary[]` annidati: `{id, parola_griko, parola_italiano}`
- `rules[]` (piatto): `{id, lesson_id, regola_testo}`
- `vocabulary[]` (piatto): `{id, lesson_id, parola_griko, parola_italiano}`
- **I dati esistono in doppia forma**: annidati dentro `lessons` + due array piatti. Ridondanza voluta.

**Organizzazione cartella** (esclusi node_modules/.git/.next):

| Elemento | Descrizione |
|---|---|
| `pages/` | index.js, _app.js (Next pages router) |
| `public/data/griko-data.json` | unico file dati servito al client |
| `styles/globals.css` | stile |
| `transcripts_clean/` | 73 file .txt (trascrizioni pulite, sorgente) — **non serviti dal sito** |
| `01_lessons.csv / 02_rules.csv / 03_vocabulary.csv` | CSV sorgente |
| `_extraction_raw.txt` | output grezzo estrazione LLM |
| `clean_vtt.py / build_csv.py / build_db.py` | script pipeline (non eseguiti dal build) |
| `griko_grammar.db` | SQLite 69 KB — **non usato dal sito**, non in public/ |
| `vercel.json` | solo `{"buildCommand":"npm run build"}` |
| `next.config.js`, `package.json`, `package-lock.json` | config |
| `.vercel/` | link progetto `anthony-laners-projects/griko-deploy` |

## 2. STATO DEI DATI (`griko-data.json`)

- **Lezioni: 73** · **Regole: 158** · **Vocabolario: 716**
- `lesson_id` validi: **rules 158/158**, **vocab 716/716** (100% collegati; id lezioni 1–73 contigui).
- **Duplicati esatti** (stessa coppia griko+italiano): **29 coppie duplicate = 32 righe extra**. Top: `sidero::ferro` (3×), `mina::mese` (3×), `lico::lupo` (3×), poi 2× su `arteo`, `kalò`, `zonari`, `claro`, `avuo`, `milo`, `rodo`, ecc.
- Forme griko che ricorrono in più righe (a prescindere dall'italiano): **38**.
- **Campi vuoti/mancanti**: vocab con griko o italiano vuoto = **0**; regole vuote = **0**; titolo/categoria vuoti = **0**.
  - `genere` vuoto in **17** lezioni (categorie dove non applicabile: articoli, fonetica, ecc.).
  - `desinenza` vuota in **29** lezioni (idem, campo non applicabile).
- Lezioni **senza regole: nessuna**. Lezioni **senza vocabolario: 1** → id **45** ("Ìmesta griki - Otranto e Roca 1480/81", storia).
- Distribuzione categorie: sostantivi 38, aggettivi 15, lessico 10, articoli 3, fonetica 3, storia 1, preposizioni 1, grammatica 1, introduzione 1.

## 3. STATO SUPABASE

- **Nessun progetto Supabase è usato.** `@supabase/supabase-js` compare **solo** in `package.json`/`package-lock.json` come dipendenza installata; **zero import** nel codice sorgente (`pages/index.js` importa esclusivamente il JSON statico). Nessun client Supabase istanziato, nessuna variabile d'ambiente Supabase (rimosse da `vercel.json` nel commit `f916a94`).
- Le tabelle `lessons/rules/vocabulary` esistono **solo** nel file SQLite locale `griko_grammar.db` (73/158/716 righe), che **non è un database Supabase** e **non è collegato al sito** (non è in `public/`, non viene interrogato a runtime).
- **Il sito lavora al 100% sul JSON statico**, bundlizzato a build-time. Nessun database a runtime.

## 4. FUNZIONALITÀ ESISTENTI (solo ciò che è implementato e funziona)

1. Pagina singola statica servita da Vercel (`griko-deploy.vercel.app`).
2. Campo di ricerca testuale.
3. Ricerca live su 716 voci: match parziale case-insensitive su parola griko **o** italiana.
4. Ogni risultato mostra: parola griko, freccia, traduzione, categoria + titolo lezione di provenienza.
5. Conteggio risultati dinamico ("N risultati per …").
6. Indice delle 73 lezioni raggruppate per 9 categorie grammaticali.
7. Ogni lezione è un bottone che espande/chiude (una alla volta) mostrando: elenco regole + tabella vocabolario della lezione; se assenti, messaggio "nessun dato".
8. Etichette genere/desinenza accanto al titolo lezione quando presenti.
9. Footer con nota di provenienza/non-verifica filologica.

Non esiste: audio, immagini, link ai video YouTube, pagine multiple, navigazione/routing, filtri per categoria, dettaglio persona/luogo, login, editing.

## 5. LIMITI STRUTTURALI ATTUALI (vincoli tecnici, senza progettare)

- **Nessun database runtime**: dati read-only bundlizzati nel JS; ogni modifica richiede rigenerare il JSON e ri-deployare. Non c'è scrittura.
- **Schema chiuso a 3 entità** (lessons/rules/vocabulary): nessuna tabella/campo per **persone**, **luoghi**, **fonti/bibliografia**, **file audio**, **immagini**. Non esistono chiavi esterne oltre `lesson_id`.
- **Nessun campo audio/media**: né percorsi file, né URL, né riferimenti timestamp al video sorgente (il `video_index` esiste ma non c'è l'ID YouTube né link).
- **Nessuna fonte per-voce**: le 716 voci non hanno campo sorgente/citazione/affidabilità; provenienza tracciata solo a livello lezione.
- **Nessun versioning**: nessun campo data/revisione/autore; il JSON non ha storia (l'unica storia è quella git dei commit).
- **Nessun ruolo utente/auth**: sito 100% pubblico statico, nessuna nozione di utente, permessi o editing.
- **Ridondanza dati non normalizzata**: stesso contenuto in forma annidata + piatta nello stesso file; nessuna single-source-of-truth a runtime.
- **Griko non normalizzato**: 38 forme griko ripetute e 32 righe duplicate, senza chiave lessema univoca (nessun concetto di "voce di dizionario" distinta dall'occorrenza in lezione).

## 6. RISCHI

**Aggiunta di tabelle / cambio struttura JSON:**
- `pages/index.js` accede a chiavi fisse: `data.lessons`, `data.vocabulary`, e per lezione `l.rules`, `l.vocabulary`, `l.categoria/genere/desinenza/titolo/id`; per voce `parola_griko`, `parola_italiano`, `lesson_id`. **Rinominare o rimuovere una di queste chiavi rompe il render** (import statico: errore a build-time o campi `undefined` a runtime).
- L'import è statico e **schema-implicito**: nessuna validazione, nessun TypeScript, nessun default. Un JSON malformato o con chiave mancante fallisce silenziosamente (liste vuote) o in build.
- Aggiungere entità nuove (persone/luoghi/audio) **non rompe** di per sé il sito finché le 3 chiavi esistenti restano, ma **non verrebbero mostrate** senza modifiche al componente.
- Un nuovo DB (Supabase) richiederebbe di sostituire l'import statico con fetch/SDK: cambio del modello di rendering (static → data-fetching), oggi inesistente.

**Fragilità pipeline build/deploy (osservata oggi):**
- **Deploy manuale**: gli unici deploy andati a buon fine sono via `vercel --prod --yes` da locale. L'auto-deploy da git-push **non è confermato** (i commit vuoti "Trigger/Retry Vercel deploy" non hanno prodotto un deploy verificato).
- **Rete instabile**: `git push` è fallito 2 volte con `Could not resolve host: github.com` (DNS), riuscito solo al retry.
- **Storia git già riscritta una volta** (force-push, commit `e73de20`) per rimuovere un binario da 129 MB in `node_modules` che superava il limite GitHub 100 MB — indica che `node_modules` era finito in un commit; oggi è in `.gitignore` ma la fragilità dipende dal rispetto di quel file.
- **Pipeline dati fuori dal build**: la catena `.vtt → clean_vtt.py → build_csv.py → build_db.py → JSON` è **manuale**, non parte del `npm run build`. Il sito serve il JSON committato: se lo si rigenera e non lo si committa/deploya, il sito resta indietro senza errori.
- **`griko_grammar.db` e i CSV/script sono nel repo pubblico** ma inerti: divergenza silenziosa possibile tra DB/CSV e il JSON effettivamente servito.
- **Warning LF→CRLF** ad ogni commit (Windows): cosmetico, non bloccante.
