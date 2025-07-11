-- Migration de la structure de la table political_regime
-- Renommer characteristics en description et supprimer examples

-- 1. Vérifier si description existe déjà
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'political_regime' AND column_name = 'description'
    ) THEN
        -- Ajouter la nouvelle colonne description si elle n'existe pas
        ALTER TABLE political_regime ADD COLUMN description TEXT;
    END IF;
END $$;

-- 2. Copier les données de characteristics vers description (si characteristics existe)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'political_regime' AND column_name = 'characteristics'
    ) THEN
        -- Convertir le JSONB en texte pour la description
        UPDATE political_regime 
        SET description = characteristics::text 
        WHERE characteristics IS NOT NULL AND (description IS NULL OR description = '');
    END IF;
END $$;

-- 3. Supprimer l'ancienne colonne characteristics (si elle existe)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'political_regime' AND column_name = 'characteristics'
    ) THEN
        ALTER TABLE political_regime DROP COLUMN characteristics;
    END IF;
END $$;

-- 4. Supprimer la colonne examples (si elle existe)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'political_regime' AND column_name = 'examples'
    ) THEN
        ALTER TABLE political_regime DROP COLUMN examples;
    END IF;
END $$;

-- 5. Vérifier la nouvelle structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'political_regime' 
ORDER BY ordinal_position; 