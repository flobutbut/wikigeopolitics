-- Compléter les données des chefs d'État pour tous les pays restants

-- Amérique du Nord et Centrale
UPDATE country_political_regime 
SET chef_etat = 'Andrés Manuel López Obrador', date_prise_poste = '2018-12-01'
WHERE country_id = 'mexico' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Justin Trudeau', date_prise_poste = '2015-11-04'
WHERE country_id = 'canada' AND current_regime = true;

-- Amérique du Sud
UPDATE country_political_regime 
SET chef_etat = 'Javier Milei', date_prise_poste = '2023-12-10'
WHERE country_id = 'argentina' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Luiz Inácio Lula da Silva', date_prise_poste = '2023-01-01'
WHERE country_id = 'brazil' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Gabriel Boric', date_prise_poste = '2022-03-11'
WHERE country_id = 'chile' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Gustavo Petro', date_prise_poste = '2022-08-07'
WHERE country_id = 'colombia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Guillermo Lasso', date_prise_poste = '2021-05-24'
WHERE country_id = 'ecuador' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Pedro Castillo', date_prise_poste = '2021-07-28'
WHERE country_id = 'peru' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Luis Lacalle Pou', date_prise_poste = '2020-03-01'
WHERE country_id = 'uruguay' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Nicolás Maduro', date_prise_poste = '2013-04-19'
WHERE country_id = 'venezuela' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Mario Abdo Benítez', date_prise_poste = '2018-08-15'
WHERE country_id = 'paraguay' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Luis Arce', date_prise_poste = '2020-11-08'
WHERE country_id = 'bolivia' AND current_regime = true;

-- Europe de l'Est
UPDATE country_political_regime 
SET chef_etat = 'Volodymyr Zelensky', date_prise_poste = '2019-05-20'
WHERE country_id = 'ukraine' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Vladimir Poutine', date_prise_poste = '2024-05-07'
WHERE country_id = 'russia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Alexander Lukashenko', date_prise_poste = '1994-07-20'
WHERE country_id = 'belarus' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Maia Sandu', date_prise_poste = '2020-12-24'
WHERE country_id = 'moldova' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Klaus Iohannis', date_prise_poste = '2014-12-21'
WHERE country_id = 'romania' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Rumen Radev', date_prise_poste = '2021-11-22'
WHERE country_id = 'bulgaria' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Zoran Milanović', date_prise_poste = '2020-02-18'
WHERE country_id = 'croatia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Nataša Pirc Musar', date_prise_poste = '2022-12-23'
WHERE country_id = 'slovenia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Zuzana Čaputová', date_prise_poste = '2019-06-15'
WHERE country_id = 'slovakia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Gitanas Nausėda', date_prise_poste = '2024-05-26'
WHERE country_id = 'lithuania' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Edgars Rinkēvičs', date_prise_poste = '2023-07-08'
WHERE country_id = 'latvia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Alar Karis', date_prise_poste = '2021-10-11'
WHERE country_id = 'estonia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Alexander Stubb', date_prise_poste = '2024-03-01'
WHERE country_id = 'finland' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Guðni Th. Jóhannesson', date_prise_poste = '2016-08-01'
WHERE country_id = 'iceland' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Michael D. Higgins', date_prise_poste = '2011-11-11'
WHERE country_id = 'ireland' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Marcelo Rebelo de Sousa', date_prise_poste = '2016-03-09'
WHERE country_id = 'portugal' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Katerina Sakellaropoulou', date_prise_poste = '2020-03-13'
WHERE country_id = 'greece' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Nikos Christodoulides', date_prise_poste = '2023-02-28'
WHERE country_id = 'cyprus' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'George Vella', date_prise_poste = '2019-04-04'
WHERE country_id = 'malta' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Henri', date_prise_poste = '2000-10-07'
WHERE country_id = 'luxembourg' AND current_regime = true;

-- Asie
UPDATE country_political_regime 
SET chef_etat = 'Xi Jinping', date_prise_poste = '2013-03-14'
WHERE country_id = 'china' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Narendra Modi', date_prise_poste = '2024-06-09'
WHERE country_id = 'india' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Fumio Kishida', date_prise_poste = '2021-10-04'
WHERE country_id = 'japan' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Yoon Suk-yeol', date_prise_poste = '2022-05-10'
WHERE country_id = 'south-korea' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Kim Jong-un', date_prise_poste = '2011-12-17'
WHERE country_id = 'north-korea' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Ebrahim Raisi', date_prise_poste = '2021-08-03'
WHERE country_id = 'iran' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Mohammed ben Salmane', date_prise_poste = '2017-06-21'
WHERE country_id = 'saudi-arabia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Recep Tayyip Erdoğan', date_prise_poste = '2023-06-03'
WHERE country_id = 'turkey' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Donald Tusk', date_prise_poste = '2023-12-13'
WHERE country_id = 'poland' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Petr Pavel', date_prise_poste = '2023-03-09'
WHERE country_id = 'czech-republic' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Viktor Orbán', date_prise_poste = '2010-05-29'
WHERE country_id = 'hungary' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Vladimir Putin', date_prise_poste = '2024-05-07'
WHERE country_id = 'russia' AND current_regime = true;

-- Afrique
UPDATE country_political_regime 
SET chef_etat = 'Cyril Ramaphosa', date_prise_poste = '2024-06-14'
WHERE country_id = 'south-africa' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Abdelmadjid Tebboune', date_prise_poste = '2019-12-19'
WHERE country_id = 'algeria' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Abdel Fattah al-Sissi', date_prise_poste = '2014-06-08'
WHERE country_id = 'egypt' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Muhammadu Buhari', date_prise_poste = '2015-05-29'
WHERE country_id = 'nigeria' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Uhuru Kenyatta', date_prise_poste = '2013-04-09'
WHERE country_id = 'kenya' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'John Magufuli', date_prise_poste = '2015-11-05'
WHERE country_id = 'tanzania' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Yoweri Museveni', date_prise_poste = '1986-01-29'
WHERE country_id = 'uganda' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Paul Kagame', date_prise_poste = '2000-04-22'
WHERE country_id = 'rwanda' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Félix Tshisekedi', date_prise_poste = '2019-01-24'
WHERE country_id = 'congo' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Denis Sassou-Nguesso', date_prise_poste = '1997-10-25'
WHERE country_id = 'congo-brazzaville' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Idriss Déby', date_prise_poste = '1990-12-02'
WHERE country_id = 'chad' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Faustin-Archange Touadéra', date_prise_poste = '2016-03-30'
WHERE country_id = 'central-african-republic' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Salva Kiir Mayardit', date_prise_poste = '2011-07-09'
WHERE country_id = 'south-sudan' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Omar al-Bashir', date_prise_poste = '1989-06-30'
WHERE country_id = 'sudan' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Isaias Afwerki', date_prise_poste = '1993-05-24'
WHERE country_id = 'eritrea' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Abiy Ahmed', date_prise_poste = '2018-04-02'
WHERE country_id = 'ethiopia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Hassan Sheikh Mohamud', date_prise_poste = '2022-05-15'
WHERE country_id = 'somalia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Ismail Omar Guelleh', date_prise_poste = '1999-05-08'
WHERE country_id = 'djibouti' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Mohamed Ould Ghazouani', date_prise_poste = '2019-08-01'
WHERE country_id = 'mauritania' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Macky Sall', date_prise_poste = '2012-04-02'
WHERE country_id = 'senegal' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Muhammadu Buhari', date_prise_poste = '2015-05-29'
WHERE country_id = 'nigeria' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Nana Akufo-Addo', date_prise_poste = '2017-01-07'
WHERE country_id = 'ghana' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Alassane Ouattara', date_prise_poste = '2010-12-04'
WHERE country_id = 'ivory-coast' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Patrice Talon', date_prise_poste = '2016-04-06'
WHERE country_id = 'benin' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Faure Gnassingbé', date_prise_poste = '2005-05-04'
WHERE country_id = 'togo' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Roch Marc Christian Kaboré', date_prise_poste = '2015-12-29'
WHERE country_id = 'burkina-faso' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Mahamadou Issoufou', date_prise_poste = '2011-04-07'
WHERE country_id = 'niger' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Ibrahim Boubacar Keïta', date_prise_poste = '2013-09-04'
WHERE country_id = 'mali' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Alpha Condé', date_prise_poste = '2010-12-21'
WHERE country_id = 'guinea' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Jorge Carlos Fonseca', date_prise_poste = '2011-09-09'
WHERE country_id = 'cape-verde' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'José Mário Vaz', date_prise_poste = '2014-06-23'
WHERE country_id = 'guinea-bissau' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Jorge Bom Jesus', date_prise_poste = '2016-05-03'
WHERE country_id = 'sao-tome-and-principe' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'João Lourenço', date_prise_poste = '2017-09-26'
WHERE country_id = 'angola' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Filipe Nyusi', date_prise_poste = '2015-01-15'
WHERE country_id = 'mozambique' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Hage Geingob', date_prise_poste = '2015-03-21'
WHERE country_id = 'namibia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Mokgweetsi Masisi', date_prise_poste = '2018-04-01'
WHERE country_id = 'botswana' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Emmerson Mnangagwa', date_prise_poste = '2017-11-24'
WHERE country_id = 'zimbabwe' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Edgar Lungu', date_prise_poste = '2015-01-25'
WHERE country_id = 'zambia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Hichilema Hakainde', date_prise_poste = '2021-08-24'
WHERE country_id = 'zambia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Peter Mutharika', date_prise_poste = '2014-05-31'
WHERE country_id = 'malawi' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Lazarus Chakwera', date_prise_poste = '2020-06-28'
WHERE country_id = 'malawi' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Filipe Nyusi', date_prise_poste = '2015-01-15'
WHERE country_id = 'mozambique' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Samia Suluhu Hassan', date_prise_poste = '2021-03-19'
WHERE country_id = 'tanzania' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'William Ruto', date_prise_poste = '2022-09-13'
WHERE country_id = 'kenya' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Bola Tinubu', date_prise_poste = '2023-05-29'
WHERE country_id = 'nigeria' AND current_regime = true;

-- Océanie
UPDATE country_political_regime 
SET chef_etat = 'Anthony Albanese', date_prise_poste = '2022-05-23'
WHERE country_id = 'australia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Jacinda Ardern', date_prise_poste = '2017-10-26'
WHERE country_id = 'new-zealand' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Christopher Luxon', date_prise_poste = '2023-11-27'
WHERE country_id = 'new-zealand' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Frank Bainimarama', date_prise_poste = '2007-01-05'
WHERE country_id = 'fiji' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Sitiveni Rabuka', date_prise_poste = '2022-12-24'
WHERE country_id = 'fiji' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'James Marape', date_prise_poste = '2019-05-30'
WHERE country_id = 'papua-new-guinea' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Manasseh Sogavare', date_prise_poste = '2019-04-24'
WHERE country_id = 'solomon-islands' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Taneti Maamau', date_prise_poste = '2016-03-11'
WHERE country_id = 'kiribati' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'David Panuelo', date_prise_poste = '2019-05-11'
WHERE country_id = 'micronesia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Wesley Simina', date_prise_poste = '2023-05-11'
WHERE country_id = 'micronesia' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Surangel Whipps Jr.', date_prise_poste = '2021-01-21'
WHERE country_id = 'palau' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Kausea Natano', date_prise_poste = '2019-09-19'
WHERE country_id = 'tuvalu' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Feleti Teo', date_prise_poste = '2024-02-26'
WHERE country_id = 'tuvalu' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Fiame Naomi Mataafa', date_prise_poste = '2021-05-24'
WHERE country_id = 'samoa' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Tupou VI', date_prise_poste = '2012-03-18'
WHERE country_id = 'tonga' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Nikunau Island Council', date_prise_poste = '1979-07-12'
WHERE country_id = 'nauru' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'David Kabua', date_prise_poste = '2020-01-27'
WHERE country_id = 'marshall-islands' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Iroojlaplap Jurelang Zedkaia', date_prise_poste = '2009-10-26'
WHERE country_id = 'marshall-islands' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Baldwin Lonsdale', date_prise_poste = '2014-09-22'
WHERE country_id = 'vanuatu' AND current_regime = true;

UPDATE country_political_regime 
SET chef_etat = 'Nikenike Vurobaravu', date_prise_poste = '2022-07-23'
WHERE country_id = 'vanuatu' AND current_regime = true;

-- Vérification finale
SELECT 
    COUNT(*) as total_pays_avec_chef_etat,
    COUNT(CASE WHEN chef_etat IS NOT NULL THEN 1 END) as pays_avec_chef_etat,
    COUNT(CASE WHEN chef_etat IS NULL THEN 1 END) as pays_sans_chef_etat
FROM country_political_regime 
WHERE current_regime = true;

-- Afficher quelques exemples de pays avec leurs chefs d'État
SELECT 
    c.nom as pays,
    pr.name as regime,
    cpr.chef_etat,
    cpr.date_prise_poste
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true AND cpr.chef_etat IS NOT NULL
ORDER BY c.nom
LIMIT 50; 