-- =====================================================
-- Migration de la table demographic_data vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE demographic_data RENAME COLUMN country_id TO countryId;
ALTER TABLE demographic_data RENAME COLUMN median_age TO medianAge;
ALTER TABLE demographic_data RENAME COLUMN fertility_rate TO fertilityRate;
ALTER TABLE demographic_data RENAME COLUMN life_expectancy TO lifeExpectancy;
ALTER TABLE demographic_data RENAME COLUMN urbanization_rate TO urbanizationRate;
ALTER TABLE demographic_data RENAME COLUMN elderly_percentage TO elderlyPercentage;
ALTER TABLE demographic_data RENAME COLUMN gdp_per_capita TO gdpPerCapita;
ALTER TABLE demographic_data RENAME COLUMN hdi_index TO hdiIndex;
ALTER TABLE demographic_data RENAME COLUMN literacy_rate TO literacyRate;
ALTER TABLE demographic_data RENAME COLUMN data_source TO dataSource;

-- Ajouter les colonnes manquantes
ALTER TABLE demographic_data ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE demographic_data ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE demographic_data ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE demographic_data ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'demographic_data' 
ORDER BY ordinal_position; 