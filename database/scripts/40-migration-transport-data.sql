-- =====================================================
-- Migration de la table transport_data vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE transport_data RENAME COLUMN country_id TO countryId;
ALTER TABLE transport_data RENAME COLUMN transport_type TO transportType;
ALTER TABLE transport_data RENAME COLUMN volume_value TO volumeValue;
ALTER TABLE transport_data RENAME COLUMN volume_unit TO volumeUnit;
ALTER TABLE transport_data RENAME COLUMN volume_year TO volumeYear;
ALTER TABLE transport_data RENAME COLUMN infrastructure_data TO infrastructureData;

-- Ajouter les colonnes manquantes
ALTER TABLE transport_data ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE transport_data ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE transport_data ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE transport_data ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'transport_data' 
ORDER BY ordinal_position; 