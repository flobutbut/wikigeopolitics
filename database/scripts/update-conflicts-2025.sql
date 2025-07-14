-- =====================================================
-- Mise à jour des données de conflits armés 2025
-- Basé sur des données réelles et actuelles
-- =====================================================

-- Nettoyer les anciennes données de conflits
DELETE FROM conflict_country;
DELETE FROM conflict_resource;
DELETE FROM conflict_trade_route;
DELETE FROM armed_conflict;
DELETE FROM conflict;

-- =====================================================
-- INSERTION DES CONFLITS ARMÉS ACTUELS (2025)
-- =====================================================

-- 1. Guerre en Ukraine (2022-présent)
INSERT INTO armed_conflict (
    id, name, description, startyear, endyear, status, 
    involvedcountries, casualtyestimates, geopoliticalimpact, 
    epicenter, statut, created_at, updated_at
) VALUES (
    1, 'Guerre en Ukraine', 
    'Conflit armé entre la Russie et l''Ukraine suite à l''invasion russe du 24 février 2022. Conflit de haute intensité avec plus de 67 000 morts en 2024.',
    2022, NULL, 'active',
    '["ukraine", "russia"]',
    '{"total_deaths_2024": "67000", "ukrainian_military": "Plus de 200000", "russian_military": "Plus de 350000", "civilian_casualties": "Plus de 12000", "refugees": "Plus de 8 millions", "displaced": "Plus de 6 millions"}',
    'Impact majeur sur la sécurité énergétique mondiale, reconfiguration géopolitique, renforcement de l''OTAN, sanctions économiques massives contre la Russie, crise alimentaire mondiale',
    ST_GeomFromText('POINT(32.0 49.0)', 4326), -- Centre approximatif de l''Ukraine
    'En cours',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- 2. Conflit Gaza-Israël (2023-présent)
INSERT INTO armed_conflict (
    id, name, description, startyear, endyear, status,
    involvedcountries, casualtyestimates, geopoliticalimpact,
    epicenter, statut, created_at, updated_at
) VALUES (
    2, 'Conflit Gaza-Israël',
    'Conflit de haute intensité entre Israël et le Hamas dans la bande de Gaza, déclenché le 7 octobre 2023. Plus de 35 000 morts en 2024.',
    2023, NULL, 'active',
    '["israel", "palestine"]',
    '{"total_deaths_2024": "35000", "palestinian_casualties": "Plus de 50000", "israeli_casualties": "Plus de 1400", "civilian_casualties": "Plus de 45000", "displaced_gaza": "Plus de 1.9 million", "hostages": "Plus de 200"}',
    'Crise humanitaire majeure, tensions régionales maximales, risque d''extension au Liban et en Syrie, impact majeur sur les relations internationales',
    ST_GeomFromText('POINT(34.3 31.5)', 4326), -- Centre de Gaza
    'En cours',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- 3. Guerre civile au Soudan (2023-présent)
INSERT INTO armed_conflict (
    id, name, description, startyear, endyear, status,
    involvedcountries, casualtyestimates, geopoliticalimpact,
    epicenter, statut, created_at, updated_at
) VALUES (
    3, 'Guerre civile au Soudan',
    'Conflit entre l''Armée soudanaise (SAF) et les Forces de soutien rapide (RSF) depuis avril 2023. Crise humanitaire mondiale majeure.',
    2023, NULL, 'active',
    '["sudan"]',
    '{"total_casualties": "Plus de 20000", "displaced": "Plus de 12 millions", "refugees": "Plus de 2 millions", "food_insecurity": "Plus de 18 millions", "humanitarian_need": "Plus de 25 millions"}',
    'Crise humanitaire la plus grave au monde, déstabilisation régionale massive, impact sur les routes migratoires, intervention de puissances étrangères',
    ST_GeomFromText('POINT(30.0 15.0)', 4326), -- Centre du Soudan
    'En cours',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- 4. Conflit au Myanmar (2021-présent)
INSERT INTO armed_conflict (
    id, name, description, startyear, endyear, status,
    involvedcountries, casualtyestimates, geopoliticalimpact,
    epicenter, statut, created_at, updated_at
) VALUES (
    4, 'Conflit au Myanmar',
    'Conflit civil complexe suite au coup d''État de février 2021. Le pays avec le plus grand nombre de groupes armés non-étatiques au monde (170 actifs).',
    2021, NULL, 'active',
    '["myanmar"]',
    '{"total_casualties": "Plus de 10000", "displaced": "Plus de 2.5 millions", "refugees": "Plus de 1.5 million", "rohingya_crisis": "Plus de 1 million", "humanitarian_need": "Plus de 18 millions"}',
    'Crise humanitaire majeure, déstabilisation de l''Asie du Sud-Est, génocide des Rohingyas, impact sur les relations Chine-ASEAN',
    ST_GeomFromText('POINT(96.0 22.0)', 4326), -- Centre du Myanmar
    'En cours',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- 5. Guerre civile au Yémen (2014-présent)
INSERT INTO armed_conflict (
    id, name, description, startyear, endyear, status,
    involvedcountries, casualtyestimates, geopoliticalimpact,
    epicenter, statut, created_at, updated_at
) VALUES (
    5, 'Guerre civile au Yémen',
    'Conflit entre le gouvernement yéménite et les rebelles Houthis. Violence en déclin mais extension vers la mer Rouge depuis 2024.',
    2014, NULL, 'active',
    '["yemen", "saudi-arabia", "iran"]',
    '{"total_deaths_2024": "2000", "total_casualties": "Plus de 380000", "humanitarian_crisis": "Plus de 21 millions", "food_insecurity": "Plus de 17 millions", "displaced": "Plus de 4 millions"}',
    'Guerre par procuration Iran-Arabie Saoudite, crise humanitaire majeure, impact sur le commerce maritime mondial (mer Rouge), famine',
    ST_GeomFromText('POINT(44.0 15.0)', 4326), -- Centre du Yémen
    'En cours',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- 6. Conflit au Sahel (2012-présent)
INSERT INTO armed_conflict (
    id, name, description, startyear, endyear, status,
    involvedcountries, casualtyestimates, geopoliticalimpact,
    epicenter, statut, created_at, updated_at
) VALUES (
    6, 'Conflit au Sahel',
    'Conflit complexe impliquant des groupes djihadistes dans la région du Sahel. Déstabilisation majeure de l''Afrique de l''Ouest.',
    2012, NULL, 'active',
    '["mali", "burkina-faso", "niger", "chad"]',
    '{"total_casualties": "Plus de 20000", "displaced": "Plus de 4 millions", "terrorist_attacks_2024": "Plus de 3000", "humanitarian_need": "Plus de 8 millions"}',
    'Terrorisme islamiste, fin de l''opération Barkhane, coups d''État militaires, alliance avec Wagner/Russie, crise humanitaire régionale',
    ST_GeomFromText('POINT(0.0 15.0)', 4326), -- Centre du Sahel
    'En cours',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- 7. Conflit en République démocratique du Congo (1996-présent)
INSERT INTO armed_conflict (
    id, name, description, startyear, endyear, status,
    involvedcountries, casualtyestimates, geopoliticalimpact,
    epicenter, statut, created_at, updated_at
) VALUES (
    7, 'Conflit en République démocratique du Congo',
    'Conflit complexe dans l''est de la RDC lié aux ressources naturelles et aux tensions ethniques. Plus de 120 groupes armés actifs.',
    1996, NULL, 'active',
    '["democratic-republic-of-congo", "rwanda", "uganda"]',
    '{"total_casualties": "Plus de 6 millions", "displaced": "Plus de 7 millions", "sexual_violence": "Plus de 500000", "humanitarian_need": "Plus de 26 millions"}',
    'Exploitation illégale des minerais critiques (cobalt, coltan), violences sexuelles massives, crise humanitaire chronique, intervention MONUSCO',
    ST_GeomFromText('POINT(28.0 -2.0)', 4326), -- Est de la RDC
    'En cours',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- 8. Conflit en Éthiopie/Tigré (2020-présent)
INSERT INTO armed_conflict (
    id, name, description, startyear, endyear, status,
    involvedcountries, casualtyestimates, geopoliticalimpact,
    epicenter, statut, created_at, updated_at
) VALUES (
    8, 'Conflit en Éthiopie',
    'Conflit dans la région du Tigré entre le gouvernement fédéral et le TPLF. Accord de paix de 2022 mais tensions persistantes.',
    2020, NULL, 'inactive',
    '["ethiopia", "eritrea"]',
    '{"total_casualties": "Plus de 600000", "displaced": "Plus de 2 millions", "famine_risk": "Plus de 5 millions", "sexual_violence": "Plus de 100000"}',
    'Crise humanitaire majeure, déstabilisation de la Corne de l''Afrique, questions de crimes de guerre, impact régional',
    ST_GeomFromText('POINT(39.0 14.0)', 4326), -- Région du Tigré
    'Cessez-le-feu fragile',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- 9. Conflit en Syrie (2011-présent)
INSERT INTO armed_conflict (
    id, name, description, startyear, endyear, status,
    involvedcountries, casualtyestimates, geopoliticalimpact,
    epicenter, statut, created_at, updated_at
) VALUES (
    9, 'Guerre civile syrienne',
    'Conflit civil complexe avec de multiples acteurs internationaux. Intensification récente avec la chute du régime Assad en décembre 2024.',
    2011, NULL, 'active',
    '["syria", "russia", "iran", "turkey", "usa"]',
    '{"total_casualties": "Plus de 500000", "displaced": "Plus de 13 millions", "refugees": "Plus de 6 millions", "humanitarian_need": "Plus de 15 millions"}',
    'Chute du régime Assad (décembre 2024), restructuration géopolitique majeure, crise des réfugiés, intervention multinationale',
    ST_GeomFromText('POINT(36.0 35.0)', 4326), -- Centre de la Syrie
    'En cours - nouvelle phase',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- 10. Conflit en Somalie (1991-présent)
INSERT INTO armed_conflict (
    id, name, description, startyear, endyear, status,
    involvedcountries, casualtyestimates, geopoliticalimpact,
    epicenter, statut, created_at, updated_at
) VALUES (
    10, 'Conflit en Somalie',
    'Conflit chronique impliquant Al-Shabaab et forces gouvernementales. Terrorisme et instabilité persistants.',
    1991, NULL, 'active',
    '["somalia", "kenya", "ethiopia", "uganda"]',
    '{"total_casualties": "Plus de 500000", "terrorist_attacks_yearly": "Plus de 1000", "displaced": "Plus de 3 millions", "humanitarian_need": "Plus de 7 millions"}',
    'Terrorisme islamiste régional, piraterie maritime, crise humanitaire chronique, intervention AMISOM/ATMIS',
    ST_GeomFromText('POINT(45.0 2.0)', 4326), -- Centre de la Somalie
    'En cours',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- =====================================================
-- INSERTION DES RELATIONS PAYS-CONFLITS
-- =====================================================

-- Ukraine War
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('ukraine', '1', 'Pays attaqué', '2022-02-24', NULL),
('russia', '1', 'Pays agresseur', '2022-02-24', NULL);

-- Gaza Conflict
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('israel', '2', 'Belligérant', '2023-10-07', NULL),
('palestine', '2', 'Territoire occupé', '2023-10-07', NULL);

-- Sudan Civil War
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('sudan', '3', 'Guerre civile', '2023-04-15', NULL);

-- Myanmar Conflict
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('myanmar', '4', 'Guerre civile', '2021-02-01', NULL);

-- Yemen War
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('yemen', '5', 'Guerre civile', '2014-09-21', NULL),
('saudi-arabia', '5', 'Intervention militaire', '2015-03-26', NULL),
('iran', '5', 'Soutien proxy', '2014-09-21', NULL);

-- Sahel Conflict
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('mali', '6', 'Conflit interne', '2012-01-17', NULL),
('burkina-faso', '6', 'Conflit interne', '2015-01-01', NULL),
('niger', '6', 'Conflit interne', '2017-01-01', NULL),
('chad', '6', 'Conflit transfrontalier', '2020-01-01', NULL);

-- DRC Conflict
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('democratic-republic-of-congo', '7', 'Conflit interne', '1996-10-01', NULL),
('rwanda', '7', 'Intervention étrangère', '1996-10-01', NULL),
('uganda', '7', 'Intervention étrangère', '1998-08-01', NULL);

-- Ethiopia Conflict
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('ethiopia', '8', 'Guerre civile', '2020-11-04', NULL),
('eritrea', '8', 'Soutien militaire', '2020-11-04', NULL);

-- Syria Conflict
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('syria', '9', 'Guerre civile', '2011-03-15', NULL),
('russia', '9', 'Intervention militaire', '2015-09-30', '2024-12-08'),
('iran', '9', 'Soutien militaire', '2013-01-01', '2024-12-08'),
('turkey', '9', 'Intervention limitée', '2016-08-24', NULL),
('usa', '9', 'Intervention anti-ISIS', '2014-09-23', NULL);

-- Somalia Conflict
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('somalia', '10', 'Guerre civile', '1991-01-26', NULL),
('kenya', '10', 'Intervention AMISOM', '2011-10-16', NULL),
('ethiopia', '10', 'Intervention régionale', '2006-12-24', NULL),
('uganda', '10', 'Forces de paix', '2007-03-06', NULL);

-- =====================================================
-- INSERTION DES RELATIONS CONFLITS-RESSOURCES
-- =====================================================

-- Ukraine - Ressources énergétiques
INSERT INTO conflict_resource (conflict_id, resource_id, importance) VALUES
('1', 'natural-gas', 'Critique - Approvisionnement européen'),
('1', 'oil', 'Importante - Prix mondiaux'),
('1', 'wheat', 'Critique - Sécurité alimentaire mondiale');

-- Gaza - Ressources énergétiques offshore
INSERT INTO conflict_resource (conflict_id, resource_id, importance) VALUES
('2', 'natural-gas', 'Importante - Gisements offshore Gaza'),
('2', 'oil', 'Modérée - Tensions régionales');

-- Soudan - Or et pétrole
INSERT INTO conflict_resource (conflict_id, resource_id, importance) VALUES
('3', 'gold', 'Critique - Financement conflit'),
('3', 'oil', 'Importante - Contrôle territorial');

-- DRC - Minerais critiques
INSERT INTO conflict_resource (conflict_id, resource_id, importance) VALUES
('7', 'rare-earth-elements', 'Critique - Cobalt mondial'),
('7', 'gold', 'Importante - Financement groupes armés');

-- Yémen - Pétrole et position stratégique
INSERT INTO conflict_resource (conflict_id, resource_id, importance) VALUES
('5', 'oil', 'Critique - Routes commerciales'),
('5', 'natural-gas', 'Importante - Géopolitique régionale');

-- =====================================================
-- INSERTION DES RELATIONS CONFLITS-ROUTES COMMERCIALES
-- =====================================================

-- Ukraine - Impact sur routes terrestres européennes
INSERT INTO conflict_trade_route (conflict_id, trade_route_id, impact) VALUES
('1', 'europe-asia-land', 'Impact majeur - Sanctions Russie');

-- Gaza/Suez - Impact sur Suez
INSERT INTO conflict_trade_route (conflict_id, trade_route_id, impact) VALUES
('2', 'suez-canal', 'Impact critique - Attaques Houthis mer Rouge');

-- Yémen - Impact majeur détroit de Bab el-Mandeb
INSERT INTO conflict_trade_route (conflict_id, trade_route_id, impact) VALUES
('5', 'red-sea-route', 'Impact critique - Attaques navires'),
('5', 'suez-canal', 'Impact majeur - Détournements');

-- Somalie - Impact historique piraterie
INSERT INTO conflict_trade_route (conflict_id, trade_route_id, impact) VALUES
('10', 'indian-ocean-route', 'Impact modéré - Piraterie résiduelle');

-- =====================================================
-- MISE À JOUR DES STATISTIQUES DE CONFLIT
-- =====================================================

-- Mise à jour des timestamps
UPDATE armed_conflict SET updated_at = CURRENT_TIMESTAMP;

-- Vérification des données insérées
SELECT 
    'Conflits armés' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_conflicts,
    COUNT(CASE WHEN status = 'inactive' THEN 1 END) as inactive_conflicts
FROM armed_conflict

UNION ALL

SELECT 
    'Relations pays-conflits' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT countryid) as unique_countries,
    COUNT(DISTINCT conflictid) as unique_conflicts
FROM conflict_country

UNION ALL

SELECT 
    'Relations conflits-ressources' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT conflict_id) as conflicts_with_resources,
    COUNT(DISTINCT resource_id) as unique_resources
FROM conflict_resource

UNION ALL

SELECT 
    'Relations conflits-routes' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT conflict_id) as conflicts_affecting_trade,
    COUNT(DISTINCT trade_route_id) as unique_trade_routes
FROM conflict_trade_route;

-- =====================================================
-- COMMENTAIRES ET MÉTADONNÉES
-- =====================================================

COMMENT ON TABLE armed_conflict IS 'Conflits armés actuels avec données réelles 2024-2025 basées sur ACLED, ONU, et sources académiques';
COMMENT ON COLUMN armed_conflict.casualtyestimates IS 'Estimations de victimes en format JSONB avec données détaillées par catégorie';
COMMENT ON COLUMN armed_conflict.epicenter IS 'Point géographique central du conflit en coordonnées WGS84';
COMMENT ON COLUMN armed_conflict.geopoliticalimpact IS 'Impact géopolitique détaillé incluant dimensions humanitaires, économiques et sécuritaires';

-- Fin du script de mise à jour
-- Dernière mise à jour: Janvier 2025
-- Source: Données compilées de ACLED, UN OCHA, Crisis Group, SIPRI