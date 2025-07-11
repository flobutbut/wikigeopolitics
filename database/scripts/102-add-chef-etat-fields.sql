-- Ajout des champs chef_etat et date_prise_poste à la table country_political_regime

-- 1. Ajouter la colonne chef_etat (nom du chef d'État)
ALTER TABLE country_political_regime 
ADD COLUMN chef_etat VARCHAR(255);

-- 2. Ajouter la colonne date_prise_poste (date de prise de poste)
ALTER TABLE country_political_regime 
ADD COLUMN date_prise_poste DATE;

-- 3. Vérifier la nouvelle structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'country_political_regime' 
ORDER BY ordinal_position;

-- 4. Afficher quelques exemples de données actuelles
SELECT 
    c.nom as pays,
    pr.name as regime,
    cpr.chef_etat,
    cpr.date_prise_poste,
    cpr.current_regime
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true
ORDER BY c.nom
LIMIT 10; 