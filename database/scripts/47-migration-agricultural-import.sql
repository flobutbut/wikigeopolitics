-- =====================================================
-- Migration de la table agricultural_import vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE agricultural_import RENAME COLUMN country_id TO countryId;
ALTER TABLE agricultural_import RENAME COLUMN product_id TO productId;
ALTER TABLE agricultural_import RENAME COLUMN import_value TO importValue;
ALTER TABLE agricultural_import RENAME COLUMN import_unit TO importUnit;
ALTER TABLE agricultural_import RENAME COLUMN import_year TO importYear;

-- Ajouter les colonnes manquantes
ALTER TABLE agricultural_import ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE agricultural_import ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE agricultural_import ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE agricultural_import ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'agricultural_import' 
ORDER BY ordinal_position; 