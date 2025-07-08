-- =====================================================
-- Migration de la table relation vers le schéma cible
-- =====================================================

-- Ajouter la colonne nom si absente
ALTER TABLE relation ADD COLUMN IF NOT EXISTS nom VARCHAR(255);

-- Renommer les colonnes date_debut et date_fin
ALTER TABLE relation RENAME COLUMN date_debut TO dateDebut;
ALTER TABLE relation RENAME COLUMN date_fin TO dateFin;

-- Supprimer les champs doublons
ALTER TABLE relation DROP COLUMN IF EXISTS created_at;
ALTER TABLE relation DROP COLUMN IF EXISTS updated_at; 