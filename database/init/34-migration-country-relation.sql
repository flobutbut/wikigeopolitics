-- =====================================================
-- Migration de la table country_relation vers le schéma cible
-- =====================================================

-- Ajouter les colonnes manquantes
ALTER TABLE country_relation ADD COLUMN IF NOT EXISTS statut VARCHAR(100);
ALTER TABLE country_relation ADD COLUMN IF NOT EXISTS dateAdhesion DATE;
ALTER TABLE country_relation ADD COLUMN IF NOT EXISTS dateSortie DATE;

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE country_relation RENAME COLUMN country_id TO countryId;
ALTER TABLE country_relation RENAME COLUMN relation_id TO relationId;

-- Supprimer la colonne role si elle n'est pas utile
ALTER TABLE country_relation DROP COLUMN IF EXISTS role; 