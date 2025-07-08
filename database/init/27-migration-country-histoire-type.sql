-- =====================================================
-- Migration du champ histoire (jsonb -> string) dans country
-- =====================================================

-- 1. Ajouter une colonne temporaire de type text
ALTER TABLE country ADD COLUMN IF NOT EXISTS histoire_tmp TEXT;

-- 2. Copier les données converties (jsonb -> text)
UPDATE country SET histoire_tmp = histoire::text WHERE histoire IS NOT NULL;

-- 3. Supprimer l'ancienne colonne jsonb
ALTER TABLE country DROP COLUMN IF EXISTS histoire;

-- 4. Renommer la colonne temporaire
ALTER TABLE country RENAME COLUMN histoire_tmp TO histoire; 