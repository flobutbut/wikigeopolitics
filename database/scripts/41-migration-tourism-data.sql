-- =====================================================
-- Migration de la table tourism_data vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE tourism_data RENAME COLUMN country_id TO countryId;
ALTER TABLE tourism_data RENAME COLUMN annual_visitors TO annualVisitors;
ALTER TABLE tourism_data RENAME COLUMN visitors_year TO visitorsYear;
ALTER TABLE tourism_data RENAME COLUMN major_attractions TO majorAttractions;
ALTER TABLE tourism_data RENAME COLUMN economic_impact TO economicImpact;
ALTER TABLE tourism_data RENAME COLUMN economic_impact_unit TO economicImpactUnit;

-- Ajouter les colonnes manquantes
ALTER TABLE tourism_data ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE tourism_data ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE tourism_data ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE tourism_data ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'tourism_data' 
ORDER BY ordinal_position; 