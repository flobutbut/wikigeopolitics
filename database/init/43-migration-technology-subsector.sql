-- =====================================================
-- Migration de la table technology_subsector vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE technology_subsector RENAME COLUMN sector_id TO sectorId;
ALTER TABLE technology_subsector RENAME COLUMN geopolitical_issues TO geopoliticalIssues;

-- Ajouter les colonnes manquantes
ALTER TABLE technology_subsector ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE technology_subsector ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE technology_subsector ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'technology_subsector' 
ORDER BY ordinal_position; 