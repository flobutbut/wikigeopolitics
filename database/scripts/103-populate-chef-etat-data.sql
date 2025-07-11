-- Remplissage des champs chef_etat et date_prise_poste avec des données crédibles

-- 1. Mise à jour des chefs d'État pour les pays majeurs
UPDATE country_political_regime 
SET chef_etat = 'Emmanuel Macron', date_prise_poste = '2017-05-14'
WHERE country_id = 'france' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Joe Biden', date_prise_poste = '2021-01-20'
WHERE country_id = 'usa' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Olaf Scholz', date_prise_poste = '2021-12-08'
WHERE country_id = 'germany' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Rishi Sunak', date_prise_poste = '2022-10-25'
WHERE country_id = 'united-kingdom' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Fumio Kishida', date_prise_poste = '2021-10-04'
WHERE country_id = 'japan' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Luiz Inácio Lula da Silva', date_prise_poste = '2023-01-01'
WHERE country_id = 'brazil' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Xi Jinping', date_prise_poste = '2013-03-14'
WHERE country_id = 'china' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Vladimir Poutine', date_prise_poste = '2012-05-07'
WHERE country_id = 'russia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Narendra Modi', date_prise_poste = '2014-05-26'
WHERE country_id = 'india' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Justin Trudeau', date_prise_poste = '2015-11-04'
WHERE country_id = 'canada' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Alberto Fernández', date_prise_poste = '2019-12-10'
WHERE country_id = 'argentina' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Andrés Manuel López Obrador', date_prise_poste = '2018-12-01'
WHERE country_id = 'mexico' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Giorgia Meloni', date_prise_poste = '2022-10-22'
WHERE country_id = 'italy' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Pedro Sánchez', date_prise_poste = '2018-06-02'
WHERE country_id = 'spain' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Alexander Van der Bellen', date_prise_poste = '2017-01-26'
WHERE country_id = 'austria' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Willem-Alexander', date_prise_poste = '2013-04-30'
WHERE country_id = 'netherlands' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Philippe', date_prise_poste = '2013-07-21'
WHERE country_id = 'belgium' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Margrethe II', date_prise_poste = '1972-01-14'
WHERE country_id = 'denmark' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Carl XVI Gustaf', date_prise_poste = '1973-09-15'
WHERE country_id = 'sweden' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Harald V', date_prise_poste = '1991-01-17'
WHERE country_id = 'norway' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Charles III', date_prise_poste = '2022-09-08'
WHERE country_id = 'united-kingdom' AND current_regime = true;

-- 2. Vérification des données mises à jour
SELECT 
    c.nom as pays,
    pr.name as regime,
    cpr.chef_etat,
    cpr.date_prise_poste,
    cpr.current_regime
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true AND cpr.chef_etat IS NOT NULL
ORDER BY c.nom
LIMIT 20; 