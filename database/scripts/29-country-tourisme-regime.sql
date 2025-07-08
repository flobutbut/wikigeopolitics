-- =====================================================
-- Nettoyage : suppression de tourisme, FK regimePolitique
-- =====================================================

-- 1. Supprimer le champ tourisme
ALTER TABLE country DROP COLUMN IF EXISTS tourisme;

-- 2. Transformation de regimePolitique en FK
-- a. Ajouter une colonne temporaire pour la FK
ALTER TABLE country ADD COLUMN IF NOT EXISTS regime_politique_id VARCHAR(50);

-- b. Remplir la colonne temporaire à partir du nom du régime (corrigé)
UPDATE country SET regime_politique_id = pr.id
FROM political_regime pr
WHERE country.regimePolitique = pr.name;

-- c. Supprimer l'ancienne colonne regimePolitique
ALTER TABLE country DROP COLUMN IF EXISTS regimePolitique;

-- d. Renommer la colonne temporaire
ALTER TABLE country RENAME COLUMN regime_politique_id TO regimePolitique;

-- e. Ajouter la contrainte de clé étrangère
ALTER TABLE country ADD CONSTRAINT fk_country_regime FOREIGN KEY (regimePolitique) REFERENCES political_regime(id); 