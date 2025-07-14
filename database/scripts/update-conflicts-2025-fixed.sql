-- =====================================================
-- Mise à jour des données de conflits armés 2025 - VERSION CORRIGÉE
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
-- Table armed_conflict (pour l'API)
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
-- INSERTION DES CONFLITS DANS LA TABLE CONFLICT
-- Pour les relations géographiques et les liens
-- =====================================================

-- 1. Ukraine War
INSERT INTO conflict (
    id, nom, type, statut, datedebut, datefin, intensite,
    localisation, victimes, timeline, effortspaix, consequences
) VALUES (
    'ukraine-war-2022', 'Guerre en Ukraine', 'Conflit interétatique', 'En cours',
    '2022-02-24', NULL, 'Haute',
    ST_GeomFromText('POLYGON((22 45, 40 45, 40 52, 22 52, 22 45))', 4326),
    '{"total_deaths_2024": 67000, "civilian_casualties": 12000, "refugees": 8000000}',
    '[{"date": "2022-02-24", "event": "Invasion russe"}, {"date": "2022-04-01", "event": "Massacre de Bucha"}, {"date": "2023-06-06", "event": "Destruction barrage Kakhovka"}, {"date": "2024-02-24", "event": "2 ans de guerre"}]',
    '[{"type": "Cessez-le-feu", "status": "Échec", "date": "2022-03-01"}, {"type": "Négociations Istanbul", "status": "Échec", "date": "2022-03-29"}]',
    '{"humanitarian": "8M réfugiés, 6M déplacés", "economic": "PIB Ukraine -30%, sanctions Russie", "geopolitical": "Renforcement OTAN, nouvelle guerre froide"}'
);

-- 2. Gaza Conflict  
INSERT INTO conflict (
    id, nom, type, statut, datedebut, datefin, intensite,
    localisation, victimes, timeline, effortspaix, consequences
) VALUES (
    'gaza-israel-2023', 'Conflit Gaza-Israël', 'Conflit asymétrique', 'En cours',
    '2023-10-07', NULL, 'Très haute',
    ST_GeomFromText('POLYGON((34.2 31.2, 34.6 31.2, 34.6 31.6, 34.2 31.6, 34.2 31.2))', 4326),
    '{"total_deaths_2024": 35000, "palestinian_casualties": 50000, "israeli_casualties": 1400}',
    '[{"date": "2023-10-07", "event": "Attaque Hamas"}, {"date": "2023-10-27", "event": "Début opération terrestre"}, {"date": "2024-01-26", "event": "Arrêt CIJ"}, {"date": "2024-05-20", "event": "Mandat CPI"}]',
    '[{"type": "Cessez-le-feu humanitaire", "status": "Temporaire", "date": "2023-11-24"}, {"type": "Négociations Qatar/Égypte", "status": "En cours", "date": "2024-01-01"}]',
    '{"humanitarian": "1.9M déplacés Gaza, crise humanitaire majeure", "regional": "Tensions Liban/Iran", "international": "Division ONU, manifestations mondiales"}'
);

-- 3. Sudan Civil War
INSERT INTO conflict (
    id, nom, type, statut, datedebut, datefin, intensite,
    localisation, victimes, timeline, effortspaix, consequences
) VALUES (
    'sudan-civil-war-2023', 'Guerre civile au Soudan', 'Guerre civile', 'En cours',
    '2023-04-15', NULL, 'Très haute',
    ST_GeomFromText('POLYGON((21 8, 39 8, 39 23, 21 23, 21 8))', 4326),
    '{"total_casualties": 20000, "displaced": 12000000, "refugees": 2000000}',
    '[{"date": "2023-04-15", "event": "Début combats SAF-RSF"}, {"date": "2023-06-01", "event": "Bataille de Khartoum"}, {"date": "2023-10-01", "event": "Extension Darfour"}, {"date": "2024-04-15", "event": "1 an de guerre"}]',
    '[{"type": "Négociations Djeddah", "status": "Échec", "date": "2023-05-06"}, {"type": "Initiative IGAD", "status": "En cours", "date": "2024-01-01"}]',
    '{"humanitarian": "25M en besoin aide, famine imminente", "regional": "Déstabilisation Tchad/Soudan Sud", "international": "Intervention UAE/Égypte"}'
);

-- 4. Myanmar Conflict
INSERT INTO conflict (
    id, nom, type, statut, datedebut, datefin, intensite,
    localisation, victimes, timeline, effortspaix, consequences
) VALUES (
    'myanmar-civil-war-2021', 'Conflit au Myanmar', 'Guerre civile', 'En cours',
    '2021-02-01', NULL, 'Haute',
    ST_GeomFromText('POLYGON((92 9, 102 9, 102 29, 92 29, 92 9))', 4326),
    '{"total_casualties": 10000, "displaced": 2500000, "rohingya_refugees": 1500000}',
    '[{"date": "2021-02-01", "event": "Coup État militaire"}, {"date": "2021-03-03", "event": "Répression manifestations"}, {"date": "2022-01-01", "event": "Formation NUG"}, {"date": "2024-10-27", "event": "Offensive Three Brotherhood"}]',
    '[{"type": "Plan ASEAN 5 points", "status": "Échec", "date": "2021-04-24"}, {"type": "Envoyé spécial ONU", "status": "Accès refusé", "date": "2022-01-01"}]',
    '{"humanitarian": "18M en besoin aide, génocide Rohingyas", "regional": "Déstabilisation ASEAN", "international": "Sanctions occidentales, soutien Chine/Russie"}'
);

-- 5. Yemen War
INSERT INTO conflict (
    id, nom, type, statut, datedebut, datefin, intensite,
    localisation, victimes, timeline, effortspaix, consequences
) VALUES (
    'yemen-civil-war-2014', 'Guerre civile au Yémen', 'Guerre civile/proxy', 'En cours',
    '2014-09-21', NULL, 'Haute',
    ST_GeomFromText('POLYGON((42 12, 54 12, 54 19, 42 19, 42 12))', 4326),
    '{"total_deaths_2024": 2000, "total_casualties": 380000, "humanitarian_crisis": 21000000}',
    '[{"date": "2014-09-21", "event": "Prise Sanaa Houthis"}, {"date": "2015-03-26", "event": "Intervention saoudienne"}, {"date": "2022-04-02", "event": "Trêve ONU"}, {"date": "2023-11-19", "event": "Attaques mer Rouge"}]',
    '[{"type": "Trêve ONU", "status": "Expirée", "date": "2022-04-02"}, {"type": "Négociations directes", "status": "En cours", "date": "2023-09-01"}]',
    '{"humanitarian": "21M en besoin aide, famine", "maritime": "Attaques navires mer Rouge", "regional": "Guerre proxy Iran-Arabie"}'
);

-- =====================================================
-- INSERTION DES RELATIONS PAYS-CONFLITS
-- =====================================================

-- Ukraine War
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('ukraine', 'ukraine-war-2022', 'Pays attaqué', '2022-02-24', NULL),
('russia', 'ukraine-war-2022', 'Pays agresseur', '2022-02-24', NULL);

-- Gaza Conflict
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('israel', 'gaza-israel-2023', 'Belligérant', '2023-10-07', NULL);

-- Sudan Civil War
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('sudan', 'sudan-civil-war-2023', 'Guerre civile', '2023-04-15', NULL);

-- Myanmar Conflict
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('myanmar', 'myanmar-civil-war-2021', 'Guerre civile', '2021-02-01', NULL);

-- Yemen War
INSERT INTO conflict_country (countryid, conflictid, role, dateentree, datesortie) VALUES
('yemen', 'yemen-civil-war-2014', 'Guerre civile', '2014-09-21', NULL),
('saudi-arabia', 'yemen-civil-war-2014', 'Intervention militaire', '2015-03-26', NULL);

-- =====================================================
-- INSERTION DES RELATIONS CONFLITS-RESSOURCES
-- =====================================================

-- Ukraine - Ressources énergétiques
INSERT INTO conflict_resource (conflict_id, resource_id, importance) VALUES
('ukraine-war-2022', 'natural-gas', 'Critique - Approvisionnement européen'),
('ukraine-war-2022', 'oil', 'Importante - Prix mondiaux'),
('ukraine-war-2022', 'wheat', 'Critique - Sécurité alimentaire mondiale');

-- Gaza - Ressources énergétiques offshore
INSERT INTO conflict_resource (conflict_id, resource_id, importance) VALUES
('gaza-israel-2023', 'natural-gas', 'Importante - Gisements offshore Gaza');

-- Soudan - Or et pétrole
INSERT INTO conflict_resource (conflict_id, resource_id, importance) VALUES
('sudan-civil-war-2023', 'gold', 'Critique - Financement conflit'),
('sudan-civil-war-2023', 'oil', 'Importante - Contrôle territorial');

-- Yémen - Pétrole et position stratégique
INSERT INTO conflict_resource (conflict_id, resource_id, importance) VALUES
('yemen-civil-war-2014', 'oil', 'Critique - Routes commerciales'),
('yemen-civil-war-2014', 'natural-gas', 'Importante - Géopolitique régionale');

-- =====================================================
-- INSERTION DES RELATIONS CONFLITS-ROUTES COMMERCIALES
-- =====================================================

-- Ukraine - Impact sur routes terrestres européennes
INSERT INTO conflict_trade_route (conflict_id, trade_route_id, impact) VALUES
('ukraine-war-2022', 'europe-asia-land', 'Impact majeur - Sanctions Russie');

-- Gaza/Suez - Impact sur Suez
INSERT INTO conflict_trade_route (conflict_id, trade_route_id, impact) VALUES
('gaza-israel-2023', 'suez-canal', 'Impact critique - Attaques Houthis mer Rouge');

-- Yémen - Impact majeur détroit de Bab el-Mandeb
INSERT INTO conflict_trade_route (conflict_id, trade_route_id, impact) VALUES
('yemen-civil-war-2014', 'red-sea-route', 'Impact critique - Attaques navires'),
('yemen-civil-war-2014', 'suez-canal', 'Impact majeur - Détournements');

-- =====================================================
-- MISE À JOUR DES STATISTIQUES DE CONFLIT
-- =====================================================

-- Mise à jour des timestamps
UPDATE armed_conflict SET updated_at = CURRENT_TIMESTAMP;

-- Vérification des données insérées
SELECT 
    'Conflits armés (armed_conflict)' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_conflicts,
    COUNT(CASE WHEN status = 'inactive' THEN 1 END) as inactive_conflicts
FROM armed_conflict

UNION ALL

SELECT 
    'Conflits géographiques (conflict)' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN statut LIKE '%cours%' THEN 1 END) as active_conflicts,
    COUNT(CASE WHEN statut NOT LIKE '%cours%' THEN 1 END) as inactive_conflicts
FROM conflict

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
COMMENT ON TABLE conflict IS 'Conflits avec données géographiques détaillées et timeline';
COMMENT ON COLUMN armed_conflict.casualtyestimates IS 'Estimations de victimes en format JSONB avec données détaillées par catégorie';
COMMENT ON COLUMN armed_conflict.epicenter IS 'Point géographique central du conflit en coordonnées WGS84';
COMMENT ON COLUMN conflict.localisation IS 'Polygone géographique couvrant la zone de conflit';
COMMENT ON COLUMN conflict.timeline IS 'Chronologie détaillée des événements majeurs du conflit';

-- Fin du script de mise à jour
-- Dernière mise à jour: Janvier 2025
-- Source: Données compilées de ACLED, UN OCHA, Crisis Group, SIPRI