-- =====================================================
-- Migration de la table resource vers le schéma cible
-- =====================================================

-- Renommer les colonnes en camelCase
ALTER TABLE resource RENAME COLUMN reserves_mondiales TO reservesMondiales;
ALTER TABLE resource RENAME COLUMN impact_environnemental TO impactEnvironnemental;
ALTER TABLE resource RENAME COLUMN enjeux_geopolitiques TO enjeuxGeopolitiques;

-- Supprimer les champs doublons
ALTER TABLE resource DROP COLUMN IF EXISTS created_at;
ALTER TABLE resource DROP COLUMN IF EXISTS updated_at; 