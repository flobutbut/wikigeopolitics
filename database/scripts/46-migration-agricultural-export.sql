-- =====================================================
-- Migration de la table agricultural_export vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE agricultural_export RENAME COLUMN country_id TO countryId;
ALTER TABLE agricultural_export RENAME COLUMN product_id TO productId;
ALTER TABLE agricultural_export RENAME COLUMN export_value TO exportValue;
ALTER TABLE agricultural_export RENAME COLUMN export_unit TO exportUnit;
ALTER TABLE agricultural_export RENAME COLUMN export_year TO exportYear;
ALTER TABLE agricultural_export RENAME COLUMN percentage_of_global TO percentageOfGlobal;

-- Ajouter les colonnes manquantes
ALTER TABLE agricultural_export ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE agricultural_export ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE agricultural_export ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE agricultural_export ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'agricultural_export' 
ORDER BY ordinal_position; 