-- ==============================================================================
-- Schema Supabase per il Corso Grammaticale e Canti di Carmine Greco
-- 28 lezioni (24 di grammatica sistematica + 4 canti/poesie tradizionali)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.carmine_greco_lessons (
    id SERIAL PRIMARY KEY,
    ordine INTEGER NOT NULL UNIQUE,
    video_id TEXT NOT NULL UNIQUE,
    titolo TEXT NOT NULL,
    categoria TEXT NOT NULL,
    categoria_label TEXT NOT NULL,
    durata TEXT NOT NULL,
    conteggio_parole INTEGER NOT NULL,
    sommario TEXT NOT NULL,
    proverbio_chiave TEXT,
    trascrizione TEXT NOT NULL,
    is_poetry BOOLEAN NOT NULL DEFAULT FALSE,
    creato_il TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_carmine_categoria ON public.carmine_greco_lessons (categoria);
CREATE INDEX IF NOT EXISTS idx_carmine_ordine ON public.carmine_greco_lessons (ordine);

-- Policy di lettura pubblica (RLS)
ALTER TABLE public.carmine_greco_lessons ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read on carmine_greco_lessons" ON public.carmine_greco_lessons;
CREATE POLICY "Allow public read on carmine_greco_lessons"
    ON public.carmine_greco_lessons FOR SELECT
    TO public
    USING (true);

-- I dati di partenza con le trascrizioni parlate di Carmine Greco sono stati
-- rimossi dal repository per ragioni di diritto d'autore. I dati della tabella
-- risiedono in Supabase.
