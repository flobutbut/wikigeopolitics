-- =====================================================
-- Migration de la table country_industry vers le schéma cible
-- =====================================================

-- Ajouter les colonnes manquantes
ALTER TABLE country_industry ADD COLUMN IF NOT EXISTS role VARCHAR(100);
ALTER TABLE country_industry ADD COLUMN IF NOT EXISTS valeurAjoutee FLOAT;
ALTER TABLE country_industry ADD COLUMN IF NOT EXISTS unite VARCHAR(50);
ALTER TABLE country_industry ADD COLUMN IF NOT EXISTS annee DATE;

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE country_industry RENAME COLUMN country_id TO countryId;
ALTER TABLE country_industry RENAME COLUMN industry_id TO industryId;

-- Supprimer les colonnes inutiles
ALTER TABLE country_industry DROP COLUMN IF EXISTS production_volume;
ALTER TABLE country_industry DROP COLUMN IF EXISTS importance; 