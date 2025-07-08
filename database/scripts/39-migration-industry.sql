-- =====================================================
-- Migration de la table industry vers le schéma cible
-- =====================================================

-- Renommer les colonnes en camelCase
ALTER TABLE industry RENAME COLUMN production_mondiale TO productionMondiale;
ALTER TABLE industry RENAME COLUMN chaine_approvisionnement TO chaineApprovisionnement;

-- Supprimer les champs doublons
ALTER TABLE industry DROP COLUMN IF EXISTS created_at;
ALTER TABLE industry DROP COLUMN IF EXISTS updated_at; 