-- =====================================================
-- Migration de la table conflict vers le schéma cible
-- =====================================================

-- Renommer les colonnes date_debut et date_fin
ALTER TABLE conflict RENAME COLUMN date_debut TO dateDebut;
ALTER TABLE conflict RENAME COLUMN date_fin TO dateFin;

-- Renommer efforts_paix en effortsPaix
ALTER TABLE conflict RENAME COLUMN efforts_paix TO effortsPaix;

-- Supprimer les champs doublons
ALTER TABLE conflict DROP COLUMN IF EXISTS created_at;
ALTER TABLE conflict DROP COLUMN IF EXISTS updated_at; 