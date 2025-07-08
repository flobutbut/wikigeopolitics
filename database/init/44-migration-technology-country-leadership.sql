-- =====================================================
-- Migration de la table technology_country_leadership vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE technology_country_leadership RENAME COLUMN subsector_id TO subsectorId;
ALTER TABLE technology_country_leadership RENAME COLUMN country_id TO countryId;

-- Ajouter les colonnes manquantes
ALTER TABLE technology_country_leadership ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE technology_country_leadership ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE technology_country_leadership ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE technology_country_leadership ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'technology_country_leadership' 
ORDER BY ordinal_position; 