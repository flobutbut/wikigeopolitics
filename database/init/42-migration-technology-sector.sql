-- =====================================================
-- Migration de la table technology_sector vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE technology_sector RENAME COLUMN global_market_value TO globalMarketValue;
ALTER TABLE technology_sector RENAME COLUMN global_market_unit TO globalMarketUnit;
ALTER TABLE technology_sector RENAME COLUMN global_market_year TO globalMarketYear;

-- Ajouter les colonnes manquantes
ALTER TABLE technology_sector ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE technology_sector ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE technology_sector ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'technology_sector' 
ORDER BY ordinal_position; 