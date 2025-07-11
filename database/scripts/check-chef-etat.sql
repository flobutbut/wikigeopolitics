-- Vérification des chefs d'État dans country_political_regime
SELECT 
    COUNT(*) as total_pays,
    COUNT(CASE WHEN chef_etat = 'Chef d''État actuel' THEN 1 END) as avec_chef_etat_actuel,
    COUNT(CASE WHEN chef_etat != 'Chef d''État actuel' AND chef_etat IS NOT NULL THEN 1 END) as avec_vrai_chef_etat
FROM country_political_regime;

-- Liste des pays avec "Chef d'État actuel"
SELECT 
    c.nom as pays,
    cpr.chef_etat,
    cpr.date_prise_poste,
    cpr.regime_politique
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
WHERE cpr.chef_etat = 'Chef d''État actuel'
ORDER BY c.nom;

-- Liste des 50 premiers pays à traiter
SELECT 
    c.id as country_id,
    c.nom as pays,
    cpr.chef_etat,
    cpr.date_prise_poste
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
WHERE cpr.chef_etat = 'Chef d''État actuel'
ORDER BY c.nom
LIMIT 50;

-- Liste des 50 pays suivants à traiter
SELECT 
    c.id as country_id,
    c.nom as pays,
    cpr.chef_etat,
    cpr.date_prise_poste
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
WHERE cpr.chef_etat = 'Chef d''État actuel'
ORDER BY c.nom
LIMIT 50 OFFSET 50; 