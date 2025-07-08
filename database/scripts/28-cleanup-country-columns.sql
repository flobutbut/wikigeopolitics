-- =====================================================
-- Nettoyage des champs doublons/inutiles dans country
-- =====================================================

-- Copier les valeurs utiles avant suppression
UPDATE country SET dateCreation = created_at::date WHERE dateCreation IS NULL AND created_at IS NOT NULL;
UPDATE country SET dateDerniereMiseAJour = updated_at::date WHERE dateDerniereMiseAJour IS NULL AND updated_at IS NOT NULL;
UPDATE country SET regimePolitique = current_regime_id WHERE regimePolitique IS NULL AND current_regime_id IS NOT NULL;

-- Supprimer les champs en doublon ou inutiles
ALTER TABLE country DROP COLUMN IF EXISTS created_at;
ALTER TABLE country DROP COLUMN IF EXISTS updated_at;
ALTER TABLE country DROP COLUMN IF EXISTS current_regime_id;
ALTER TABLE country DROP COLUMN IF EXISTS appartenanceGeographique; 