-- Vérification de l'état actuel de la table political_regime
-- Avant migration

-- 1. Vérifier la structure actuelle
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'political_regime' 
ORDER BY ordinal_position;

-- 2. Compter le nombre d'enregistrements
SELECT COUNT(*) as total_regimes FROM political_regime;

-- 3. Vérifier quelques exemples de données
SELECT id, name, description, characteristics, examples 
FROM political_regime 
LIMIT 5;

-- 4. Vérifier les types de données dans characteristics
SELECT DISTINCT jsonb_typeof(characteristics) as characteristics_type
FROM political_regime 
WHERE characteristics IS NOT NULL; 