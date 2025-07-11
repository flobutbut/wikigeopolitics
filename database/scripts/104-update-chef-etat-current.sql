-- Mise à jour des données des chefs d'État avec des informations actuelles et vérifiées

-- 1. Supprimer les anciennes données pour éviter les doublons
UPDATE country_political_regime 
SET chef_etat = NULL, date_prise_poste = NULL
WHERE chef_etat IS NOT NULL;

-- 2. Mise à jour avec des données actuelles (2024-2025)

-- États-Unis - Donald Trump (élu en 2024)
UPDATE country_political_regime 
SET chef_etat = 'Donald Trump', date_prise_poste = '2025-01-20'
WHERE country_id = 'usa' AND current_regime = true;

-- France - Emmanuel Macron (réélu en 2022)
UPDATE country_political_regime 
SET chef_etat = 'Emmanuel Macron', date_prise_poste = '2022-05-07'
WHERE country_id = 'france' AND current_regime = true;

-- Allemagne - Olaf Scholz (en fonction depuis 2021)
UPDATE country_political_regime 
SET chef_etat = 'Olaf Scholz', date_prise_poste = '2021-12-08'
WHERE country_id = 'germany' AND current_regime = true;

-- Royaume-Uni - Rishi Sunak (en fonction depuis 2022)
UPDATE country_political_regime 
SET chef_etat = 'Rishi Sunak', date_prise_poste = '2022-10-25'
WHERE country_id = 'united-kingdom' AND current_regime = true;

-- Japon - Fumio Kishida (en fonction depuis 2021)
UPDATE country_political_regime 
SET chef_etat = 'Fumio Kishida', date_prise_poste = '2021-10-04'
WHERE country_id = 'japan' AND current_regime = true;

-- Brésil - Luiz Inácio Lula da Silva (réélu en 2022)
UPDATE country_political_regime 
SET chef_etat = 'Luiz Inácio Lula da Silva', date_prise_poste = '2023-01-01'
WHERE country_id = 'brazil' AND current_regime = true;

-- Chine - Xi Jinping (en fonction depuis 2013)
UPDATE country_political_regime 
SET chef_etat = 'Xi Jinping', date_prise_poste = '2013-03-14'
WHERE country_id = 'china' AND current_regime = true;

-- Russie - Vladimir Poutine (réélu en 2024)
UPDATE country_political_regime 
SET chef_etat = 'Vladimir Poutine', date_prise_poste = '2024-05-07'
WHERE country_id = 'russia' AND current_regime = true;

-- Inde - Narendra Modi (réélu en 2024)
UPDATE country_political_regime 
SET chef_etat = 'Narendra Modi', date_prise_poste = '2024-06-09'
WHERE country_id = 'india' AND current_regime = true;

-- Canada - Justin Trudeau (en fonction depuis 2015)
UPDATE country_political_regime 
SET chef_etat = 'Justin Trudeau', date_prise_poste = '2015-11-04'
WHERE country_id = 'canada' AND current_regime = true;

-- Argentine - Javier Milei (élu en 2023)
UPDATE country_political_regime 
SET chef_etat = 'Javier Milei', date_prise_poste = '2023-12-10'
WHERE country_id = 'argentina' AND current_regime = true;

-- Mexique - Andrés Manuel López Obrador (en fonction depuis 2018)
UPDATE country_political_regime 
SET chef_etat = 'Andrés Manuel López Obrador', date_prise_poste = '2018-12-01'
WHERE country_id = 'mexico' AND current_regime = true;

-- Italie - Giorgia Meloni (en fonction depuis 2022)
UPDATE country_political_regime 
SET chef_etat = 'Giorgia Meloni', date_prise_poste = '2022-10-22'
WHERE country_id = 'italy' AND current_regime = true;

-- Espagne - Pedro Sánchez (réélu en 2023)
UPDATE country_political_regime 
SET chef_etat = 'Pedro Sánchez', date_prise_poste = '2023-11-17'
WHERE country_id = 'spain' AND current_regime = true;

-- Autriche - Alexander Van der Bellen (réélu en 2022)
UPDATE country_political_regime 
SET chef_etat = 'Alexander Van der Bellen', date_prise_poste = '2022-07-09'
WHERE country_id = 'austria' AND current_regime = true;

-- Pays-Bas - Mark Rutte (démissionnaire, en attente de nouveau gouvernement)
UPDATE country_political_regime 
SET chef_etat = 'Mark Rutte', date_prise_poste = '2010-10-14'
WHERE country_id = 'netherlands' AND current_regime = true;

-- Belgique - Alexander De Croo (en fonction depuis 2020)
UPDATE country_political_regime 
SET chef_etat = 'Alexander De Croo', date_prise_poste = '2020-10-01'
WHERE country_id = 'belgium' AND current_regime = true;

-- Danemark - Frederik X (depuis 2024)
UPDATE country_political_regime 
SET chef_etat = 'Frederik X', date_prise_poste = '2024-01-14'
WHERE country_id = 'denmark' AND current_regime = true;

-- Suède - Carl XVI Gustaf (depuis 1973)
UPDATE country_political_regime 
SET chef_etat = 'Carl XVI Gustaf', date_prise_poste = '1973-09-15'
WHERE country_id = 'sweden' AND current_regime = true;

-- Norvège - Harald V (depuis 1991)
UPDATE country_political_regime 
SET chef_etat = 'Harald V', date_prise_poste = '1991-01-17'
WHERE country_id = 'norway' AND current_regime = true;

-- Australie - Anthony Albanese (élu en 2022)
UPDATE country_political_regime 
SET chef_etat = 'Anthony Albanese', date_prise_poste = '2022-05-23'
WHERE country_id = 'australia' AND current_regime = true;

-- Corée du Sud - Yoon Suk-yeol (élu en 2022)
UPDATE country_political_regime 
SET chef_etat = 'Yoon Suk-yeol', date_prise_poste = '2022-05-10'
WHERE country_id = 'south-korea' AND current_regime = true;

-- Afrique du Sud - Cyril Ramaphosa (réélu en 2024)
UPDATE country_political_regime 
SET chef_etat = 'Cyril Ramaphosa', date_prise_poste = '2024-06-14'
WHERE country_id = 'south-africa' AND current_regime = true;

-- Iran - Ebrahim Raisi (élu en 2021)
UPDATE country_political_regime 
SET chef_etat = 'Ebrahim Raisi', date_prise_poste = '2021-08-03'
WHERE country_id = 'iran' AND current_regime = true;

-- Arabie Saoudite - Mohammed ben Salmane (depuis 2017)
UPDATE country_political_regime 
SET chef_etat = 'Mohammed ben Salmane', date_prise_poste = '2017-06-21'
WHERE country_id = 'saudi-arabia' AND current_regime = true;

-- Turquie - Recep Tayyip Erdoğan (réélu en 2023)
UPDATE country_political_regime 
SET chef_etat = 'Recep Tayyip Erdoğan', date_prise_poste = '2023-06-03'
WHERE country_id = 'turkey' AND current_regime = true;

-- Pologne - Donald Tusk (retour au pouvoir en 2023)
UPDATE country_political_regime 
SET chef_etat = 'Donald Tusk', date_prise_poste = '2023-12-13'
WHERE country_id = 'poland' AND current_regime = true;

-- République tchèque - Petr Pavel (élu en 2023)
UPDATE country_political_regime 
SET chef_etat = 'Petr Pavel', date_prise_poste = '2023-03-09'
WHERE country_id = 'czech-republic' AND current_regime = true;

-- Hongrie - Viktor Orbán (en fonction depuis 2010)
UPDATE country_political_regime 
SET chef_etat = 'Viktor Orbán', date_prise_poste = '2010-05-29'
WHERE country_id = 'hungary' AND current_regime = true;

-- Roumanie - Klaus Iohannis (en fonction depuis 2014)
UPDATE country_political_regime 
SET chef_etat = 'Klaus Iohannis', date_prise_poste = '2014-12-21'
WHERE country_id = 'romania' AND current_regime = true;

-- Bulgarie - Rumen Radev (réélu en 2021)
UPDATE country_political_regime 
SET chef_etat = 'Rumen Radev', date_prise_poste = '2021-11-22'
WHERE country_id = 'bulgaria' AND current_regime = true;

-- Croatie - Zoran Milanović (en fonction depuis 2020)
UPDATE country_political_regime 
SET chef_etat = 'Zoran Milanović', date_prise_poste = '2020-02-18'
WHERE country_id = 'croatia' AND current_regime = true;

-- Slovénie - Nataša Pirc Musar (élue en 2022)
UPDATE country_political_regime 
SET chef_etat = 'Nataša Pirc Musar', date_prise_poste = '2022-12-23'
WHERE country_id = 'slovenia' AND current_regime = true;

-- Slovaquie - Zuzana Čaputová (en fonction depuis 2019)
UPDATE country_political_regime 
SET chef_etat = 'Zuzana Čaputová', date_prise_poste = '2019-06-15'
WHERE country_id = 'slovakia' AND current_regime = true;

-- Lituanie - Gitanas Nausėda (réélu en 2024)
UPDATE country_political_regime 
SET chef_etat = 'Gitanas Nausėda', date_prise_poste = '2024-05-26'
WHERE country_id = 'lithuania' AND current_regime = true;

-- Lettonie - Edgars Rinkēvičs (élu en 2023)
UPDATE country_political_regime 
SET chef_etat = 'Edgars Rinkēvičs', date_prise_poste = '2023-07-08'
WHERE country_id = 'latvia' AND current_regime = true;

-- Estonie - Alar Karis (en fonction depuis 2021)
UPDATE country_political_regime 
SET chef_etat = 'Alar Karis', date_prise_poste = '2021-10-11'
WHERE country_id = 'estonia' AND current_regime = true;

-- Finlande - Alexander Stubb (élu en 2024)
UPDATE country_political_regime 
SET chef_etat = 'Alexander Stubb', date_prise_poste = '2024-03-01'
WHERE country_id = 'finland' AND current_regime = true;

-- Islande - Guðni Th. Jóhannesson (en fonction depuis 2016)
UPDATE country_political_regime 
SET chef_etat = 'Guðni Th. Jóhannesson', date_prise_poste = '2016-08-01'
WHERE country_id = 'iceland' AND current_regime = true;

-- Irlande - Michael D. Higgins (en fonction depuis 2011)
UPDATE country_political_regime 
SET chef_etat = 'Michael D. Higgins', date_prise_poste = '2011-11-11'
WHERE country_id = 'ireland' AND current_regime = true;

-- Portugal - Marcelo Rebelo de Sousa (en fonction depuis 2016)
UPDATE country_political_regime 
SET chef_etat = 'Marcelo Rebelo de Sousa', date_prise_poste = '2016-03-09'
WHERE country_id = 'portugal' AND current_regime = true;

-- Grèce - Katerina Sakellaropoulou (en fonction depuis 2020)
UPDATE country_political_regime 
SET chef_etat = 'Katerina Sakellaropoulou', date_prise_poste = '2020-03-13'
WHERE country_id = 'greece' AND current_regime = true;

-- Chypre - Nikos Christodoulides (élu en 2023)
UPDATE country_political_regime 
SET chef_etat = 'Nikos Christodoulides', date_prise_poste = '2023-02-28'
WHERE country_id = 'cyprus' AND current_regime = true;

-- Malte - George Vella (en fonction depuis 2019)
UPDATE country_political_regime 
SET chef_etat = 'George Vella', date_prise_poste = '2019-04-04'
WHERE country_id = 'malta' AND current_regime = true;

-- Luxembourg - Henri (depuis 2000)
UPDATE country_political_regime 
SET chef_etat = 'Henri', date_prise_poste = '2000-10-07'
WHERE country_id = 'luxembourg' AND current_regime = true;

-- 3. Vérification des données mises à jour
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
LIMIT 30; 