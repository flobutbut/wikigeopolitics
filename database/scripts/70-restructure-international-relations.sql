-- Script pour restructurer les relations internationales
-- Date: 2025-01-XX

-- Vérification du contenu actuel
SELECT '=== VÉRIFICATION DU CONTENU ACTUEL ===' as info;

-- Contenu de la table relation actuelle
SELECT 'Table relation - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM relation;

-- Contenu des tables de liaison
SELECT 'Table country_relation - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM country_relation;
SELECT 'Table relation_country - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM relation_country;
SELECT 'Table organization_relation - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM organization_relation;

-- Affichage des relations existantes
SELECT 'Relations existantes:' as info;
SELECT id, nom, type, description FROM relation;

-- Création de la nouvelle table international_relation
SELECT '=== CRÉATION DE LA NOUVELLE TABLE ===' as info;

CREATE TABLE international_relation (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL, -- 'diplomatic', 'commercial', 'military', 'mixed'
    sous_type VARCHAR(100), -- 'alliance', 'accord', 'traité', 'libre-échange', 'partenariat', 'coopération', 'défense'
    description TEXT,
    dateDebut DATE,
    dateFin DATE,
    statut VARCHAR(100),
    details JSONB, -- Pour stocker des informations spécifiques par type
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Création de la table de liaison
CREATE TABLE international_relation_country (
    relationId VARCHAR(50) REFERENCES international_relation(id) ON DELETE CASCADE,
    countryId VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    role VARCHAR(100), -- 'membre', 'observateur', 'partenaire', etc.
    statut VARCHAR(100), -- 'actif', 'inactif', 'suspendu'
    dateAdhesion DATE,
    dateSortie DATE,
    details JSONB, -- Informations spécifiques à la relation pays
    PRIMARY KEY (relationId, countryId)
);

-- Migration des données existantes
SELECT '=== MIGRATION DES DONNÉES ===' as info;

-- Insertion des relations existantes avec type par défaut 'diplomatic'
INSERT INTO international_relation (id, nom, type, sous_type, description, dateDebut, dateFin, statut)
SELECT 
    id,
    nom,
    'diplomatic' as type,
    CASE 
        WHEN type LIKE '%alliance%' THEN 'alliance'
        WHEN type LIKE '%accord%' THEN 'accord'
        WHEN type LIKE '%traité%' THEN 'traité'
        ELSE 'relation'
    END as sous_type,
    description,
    dateDebut,
    dateFin,
    statut
FROM relation;

-- Migration des relations pays
INSERT INTO international_relation_country (relationId, countryId, role, statut, dateAdhesion, dateSortie)
SELECT 
    relationid,
    countryid,
    'membre' as role,
    statut,
    dateadhesion,
    datesortie
FROM country_relation;

-- Ajout de relations internationales représentatives
SELECT '=== AJOUT DE RELATIONS REPRÉSENTATIVES ===' as info;

-- Relations diplomatiques
INSERT INTO international_relation (id, nom, type, sous_type, description, dateDebut, dateFin, statut) VALUES
('rel_ue', 'Union Européenne', 'diplomatic', 'alliance', 'Union politique et économique de 27 États membres européens', '1957-03-25', NULL, 'actif'),
('rel_nato', 'Organisation du Traité de l''Atlantique Nord', 'military', 'alliance', 'Alliance militaire de défense collective', '1949-04-04', NULL, 'actif'),
('rel_asean', 'Association des nations de l''Asie du Sud-Est', 'diplomatic', 'alliance', 'Organisation régionale de 10 pays d''Asie du Sud-Est', '1967-08-08', NULL, 'actif'),
('rel_mercosur', 'Mercosur', 'commercial', 'zone-libre-echange', 'Marché commun du Sud, union douanière en Amérique du Sud', '1991-03-26', NULL, 'actif'),
('rel_nafta', 'Accord de libre-échange nord-américain', 'commercial', 'libre-echange', 'Zone de libre-échange entre Canada, États-Unis et Mexique', '1994-01-01', '2020-07-01', 'remplace'),
('rel_usmca', 'Accord États-Unis-Mexique-Canada', 'commercial', 'libre-echange', 'Remplace l''ALENA, accord commercial trinational', '2020-07-01', NULL, 'actif'),
('rel_otsc', 'Organisation du Traité de sécurité collective', 'military', 'alliance', 'Alliance militaire eurasienne', '2002-05-15', NULL, 'actif'),
('rel_gcc', 'Conseil de coopération du Golfe', 'diplomatic', 'alliance', 'Organisation des États arabes du Golfe Persique', '1981-05-25', NULL, 'actif'),
('rel_au', 'Union Africaine', 'diplomatic', 'alliance', 'Organisation continentale africaine', '2002-07-09', NULL, 'actif'),
('rel_oas', 'Organisation des États américains', 'diplomatic', 'alliance', 'Organisation panaméricaine', '1948-04-30', NULL, 'actif');

-- Relations pays pour les nouvelles relations
INSERT INTO international_relation_country (relationId, countryId, role, statut, dateAdhesion) VALUES
-- UE
('rel_ue', 'france', 'membre', 'actif', '1957-03-25'),
('rel_ue', 'germany', 'membre', 'actif', '1957-03-25'),
('rel_ue', 'italy', 'membre', 'actif', '1957-03-25'),
('rel_ue', 'spain', 'membre', 'actif', '1986-01-01'),
('rel_ue', 'poland', 'membre', 'actif', '2004-05-01'),

-- OTAN
('rel_nato', 'usa', 'membre', 'actif', '1949-04-04'),
('rel_nato', 'france', 'membre', 'actif', '1949-04-04'),
('rel_nato', 'germany', 'membre', 'actif', '1955-05-06'),
('rel_nato', 'poland', 'membre', 'actif', '1999-03-12'),

-- ASEAN
('rel_asean', 'indonesia', 'membre', 'actif', '1967-08-08'),
('rel_asean', 'malaysia', 'membre', 'actif', '1967-08-08'),
('rel_asean', 'singapore', 'membre', 'actif', '1967-08-08'),
('rel_asean', 'thailand', 'membre', 'actif', '1967-08-08'),

-- Mercosur
('rel_mercosur', 'brazil', 'membre', 'actif', '1991-03-26'),
('rel_mercosur', 'argentina', 'membre', 'actif', '1991-03-26'),
('rel_mercosur', 'paraguay', 'membre', 'actif', '1991-03-26'),
('rel_mercosur', 'uruguay', 'membre', 'actif', '1991-03-26'),

-- USMCA
('rel_usmca', 'usa', 'membre', 'actif', '2020-07-01'),
('rel_usmca', 'canada', 'membre', 'actif', '2020-07-01'),
('rel_usmca', 'mexico', 'membre', 'actif', '2020-07-01');

-- Vérification des nouvelles données
SELECT '=== VÉRIFICATION DES NOUVELLES DONNÉES ===' as info;

SELECT 'Table international_relation - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM international_relation;
SELECT 'Table international_relation_country - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM international_relation_country;

-- Affichage des relations par type
SELECT 'Relations par type:' as info;
SELECT type, sous_type, COUNT(*) as nombre FROM international_relation GROUP BY type, sous_type ORDER BY type, sous_type;

-- Affichage des relations avec pays
SELECT 'Exemples de relations avec pays:' as info;
SELECT ir.nom, ir.type, ir.sous_type, c.nom as pays, irc.role, irc.statut
FROM international_relation ir
JOIN international_relation_country irc ON ir.id = irc.relationId
JOIN country c ON irc.countryId = c.id
ORDER BY ir.type, ir.nom, c.nom
LIMIT 15;

SELECT 'Restructuration terminée avec succès' as status; 