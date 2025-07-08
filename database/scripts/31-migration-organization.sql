-- =====================================================
-- Migration de la table organization vers le schéma cible
-- =====================================================

-- Copier la valeur de created_at dans date_creation si besoin
UPDATE organization SET date_creation = created_at::date WHERE date_creation IS NULL AND created_at IS NOT NULL;

-- Supprimer les champs doublons
ALTER TABLE organization DROP COLUMN IF EXISTS created_at;
ALTER TABLE organization DROP COLUMN IF EXISTS updated_at;

-- Renommer date_creation en dateCreation
ALTER TABLE organization RENAME COLUMN date_creation TO dateCreation; 