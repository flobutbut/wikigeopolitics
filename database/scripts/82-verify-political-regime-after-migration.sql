-- Vérification de l'état de la table political_regime après migration

-- 1. Vérifier la structure finale
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'political_regime' 
ORDER BY ordinal_position;

-- 2. Compter le nombre d'enregistrements
SELECT COUNT(*) as total_regimes FROM political_regime;

-- 3. Vérifier quelques exemples de données
SELECT id, name, description 
FROM political_regime 
ORDER BY name;

-- 4. Vérifier que toutes les descriptions ne sont pas vides
SELECT COUNT(*) as regimes_with_description
FROM political_regime 
WHERE description IS NOT NULL AND description != ''; 