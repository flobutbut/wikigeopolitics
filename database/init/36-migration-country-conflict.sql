-- =====================================================
-- Migration de la table country_conflict vers le schéma cible
-- =====================================================

-- Ajouter les colonnes manquantes
ALTER TABLE country_conflict ADD COLUMN IF NOT EXISTS dateEntree DATE;
ALTER TABLE country_conflict ADD COLUMN IF NOT EXISTS dateSortie DATE;

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE country_conflict RENAME COLUMN country_id TO countryId;
ALTER TABLE country_conflict RENAME COLUMN conflict_id TO conflictId; 