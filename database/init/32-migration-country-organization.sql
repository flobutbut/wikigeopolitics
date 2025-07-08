-- =====================================================
-- Migration de la table country_organization vers le schéma cible
-- =====================================================

-- Ajouter la colonne dateSortie si absente
ALTER TABLE country_organization ADD COLUMN IF NOT EXISTS dateSortie DATE;

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE country_organization RENAME COLUMN country_id TO countryId;
ALTER TABLE country_organization RENAME COLUMN organization_id TO organizationId;
ALTER TABLE country_organization RENAME COLUMN date_adhesion TO dateAdhesion;

-- Supprimer la colonne statut si elle n'est pas utile
ALTER TABLE country_organization DROP COLUMN IF EXISTS statut; 