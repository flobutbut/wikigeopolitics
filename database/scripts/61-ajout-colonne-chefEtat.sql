-- Ajout de la colonne chefEtat à la table country
ALTER TABLE country ADD COLUMN IF NOT EXISTS chefEtat VARCHAR(100); 