-- =====================================================
-- Migration de la table company vers le schéma cible
-- =====================================================

ALTER TABLE company DROP COLUMN IF EXISTS created_at;
ALTER TABLE company DROP COLUMN IF EXISTS updated_at; 