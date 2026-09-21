-- ==============================================================================
-- FASE 4 / OBIETTIVO 2: TABELLA PLACES (I 9 COMUNI DELLA GRECIA SALENTINA)
-- Progetto Supabase: xhpcztzisqdzqiwrojvl
-- Eseguire questo script nel SQL Editor di Supabase:
-- https://supabase.com/dashboard/project/xhpcztzisqdzqiwrojvl/sql/new
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.places (
    id TEXT PRIMARY KEY,                       -- slug identificativo (es. 'calimera', 'corigliano-dotranto')
    nome TEXT NOT NULL,                        -- nome ufficiale italiano
    nome_griko TEXT,                           -- traslitterazione latina (es. 'Kalimèra')
    nome_griko_alfabeto TEXT,                  -- grafia in caratteri greci (es. 'Καλημέρα')
    popolazione INTEGER,                       -- abitanti residenti (ISTAT)
    anno_popolazione INTEGER,                  -- anno di rilevazione (es. 2024)
    lat NUMERIC(9, 6),                         -- latitudine
    lng NUMERIC(9, 6),                         -- longitudine
    cenno_storico TEXT NOT NULL,               -- sintesi storica originale (riscritta, no copyright)
    elemento_interesse TEXT NOT NULL,          -- monumento o tradizione caratterizzante
    fonte_wikipedia_url TEXT NOT NULL,         -- link trasparente alla voce Wikipedia
    fonte_wikidata_url TEXT NOT NULL,          -- link trasparente all'elemento Wikidata
    ordine INTEGER DEFAULT 0,                  -- ordinamento per presentazione
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Abilitazione Row Level Security (RLS)
ALTER TABLE public.places ENABLE ROW LEVEL SECURITY;

-- Policy di lettura pubblica per chiunque (anon / publishable key)
DROP POLICY IF EXISTS "Allow public read on places" ON public.places;
CREATE POLICY "Allow public read on places"
    ON public.places FOR SELECT
    TO public
    USING (true);
