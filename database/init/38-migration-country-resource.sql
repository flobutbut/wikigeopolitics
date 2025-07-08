-- =====================================================
-- Migration de la table country_resource vers le schéma cible
-- =====================================================

-- Ajouter les colonnes manquantes
ALTER TABLE country_resource ADD COLUMN IF NOT EXISTS role VARCHAR(100);
ALTER TABLE country_resource ADD COLUMN IF NOT EXISTS quantite FLOAT;
ALTER TABLE country_resource ADD COLUMN IF NOT EXISTS unite VARCHAR(50);

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE country_resource RENAME COLUMN country_id TO countryId;
ALTER TABLE country_resource RENAME COLUMN resource_id TO resourceId;

-- Supprimer les colonnes inutiles
ALTER TABLE country_resource DROP COLUMN IF EXISTS production_volume;
ALTER TABLE country_resource DROP COLUMN IF EXISTS reserves; 