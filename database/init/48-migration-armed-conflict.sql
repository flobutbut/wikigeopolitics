-- =====================================================
-- Migration de la table armed_conflict vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE armed_conflict RENAME COLUMN start_year TO startYear;
ALTER TABLE armed_conflict RENAME COLUMN end_year TO endYear;
ALTER TABLE armed_conflict RENAME COLUMN involved_countries TO involvedCountries;
ALTER TABLE armed_conflict RENAME COLUMN casualty_estimates TO casualtyEstimates;
ALTER TABLE armed_conflict RENAME COLUMN geopolitical_impact TO geopoliticalImpact;

-- Ajouter les colonnes manquantes
ALTER TABLE armed_conflict ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE armed_conflict ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE armed_conflict ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'armed_conflict' 
ORDER BY ordinal_position; 