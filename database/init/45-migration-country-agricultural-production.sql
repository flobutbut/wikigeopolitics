-- =====================================================
-- Migration de la table country_agricultural_production vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE country_agricultural_production RENAME COLUMN country_id TO countryId;
ALTER TABLE country_agricultural_production RENAME COLUMN product_id TO productId;
ALTER TABLE country_agricultural_production RENAME COLUMN production_value TO productionValue;
ALTER TABLE country_agricultural_production RENAME COLUMN production_unit TO productionUnit;
ALTER TABLE country_agricultural_production RENAME COLUMN production_year TO productionYear;
ALTER TABLE country_agricultural_production RENAME COLUMN percentage_of_global TO percentageOfGlobal;

-- Ajouter les colonnes manquantes
ALTER TABLE country_agricultural_production ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE country_agricultural_production ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE country_agricultural_production ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE country_agricultural_production ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'country_agricultural_production' 
ORDER BY ordinal_position; 