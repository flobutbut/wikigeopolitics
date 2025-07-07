-- Structure des régimes politiques - Approche hybride
-- Ajouté le 2024-01-XX

-- 1. Ajout du champ current_regime_id à la table country
ALTER TABLE country ADD COLUMN IF NOT EXISTS current_regime_id VARCHAR(50) REFERENCES political_regime(id);

-- 2. Création de la vue simplifiée
DROP VIEW IF EXISTS v_country_regimes;
CREATE VIEW v_country_regimes AS
SELECT 
    c.id,
    c.nom,
    c.continent,
    pr.name as current_regime,
    pr.characteristics as regime_characteristics
FROM country c
LEFT JOIN political_regime pr ON c.current_regime_id = pr.id;

-- 3. Attribution des régimes aux pays (exemples)
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id IN ('usa', 'france', 'germany', 'uk', 'canada');
UPDATE country SET current_regime_id = 'monarchie-constitutionnelle' WHERE id IN ('uk', 'japan');
UPDATE country SET current_regime_id = 'republique-federale' WHERE id IN ('usa', 'germany', 'brazil', 'india', 'australia');
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id IN ('china', 'russia', 'north-korea', 'iran', 'saudi-arabia');

-- 4. Requêtes utiles pour vérifier la structure

-- Tous les régimes politiques
SELECT id, name, description FROM political_regime ORDER BY name;

-- Pays par régime politique
SELECT pr.name as regime, COUNT(c.id) as nombre_pays, array_agg(c.nom) as pays
FROM political_regime pr
LEFT JOIN country c ON pr.id = c.current_regime_id
GROUP BY pr.id, pr.name
ORDER BY pr.name;

-- Pays sans régime assigné
SELECT c.nom, c.continent 
FROM country c 
WHERE c.current_regime_id IS NULL 
ORDER BY c.nom;

-- Vue des pays avec leurs régimes
SELECT * FROM v_country_regimes WHERE current_regime IS NOT NULL ORDER BY nom; 