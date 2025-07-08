-- =====================================================
-- Ajout des colonnes manquantes aux tables de relation
-- selon le schéma cible
-- =====================================================

-- Ajouter les colonnes manquantes à CONFLICT_COUNTRY
ALTER TABLE conflict_country ADD COLUMN IF NOT EXISTS dateEntree DATE;
ALTER TABLE conflict_country ADD COLUMN IF NOT EXISTS dateSortie DATE;

-- Ajouter les colonnes manquantes à RESOURCE_COUNTRY
ALTER TABLE resource_country ADD COLUMN IF NOT EXISTS quantite FLOAT;
ALTER TABLE resource_country ADD COLUMN IF NOT EXISTS unite VARCHAR(50);

-- Ajouter les colonnes manquantes à INDUSTRY_COUNTRY
ALTER TABLE industry_country ADD COLUMN IF NOT EXISTS valeurAjoutee FLOAT;
ALTER TABLE industry_country ADD COLUMN IF NOT EXISTS unite VARCHAR(50);
ALTER TABLE industry_country ADD COLUMN IF NOT EXISTS annee DATE;

-- Ajouter les colonnes manquantes à COUNTRY_ORGANIZATION
ALTER TABLE country_organization ADD COLUMN IF NOT EXISTS dateSortie DATE;

-- Vérifier les structures des tables de relation
SELECT 'conflict_country' as table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'conflict_country' 
ORDER BY ordinal_position
UNION ALL
SELECT 'resource_country' as table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'resource_country' 
ORDER BY ordinal_position
UNION ALL
SELECT 'industry_country' as table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'industry_country' 
ORDER BY ordinal_position; 