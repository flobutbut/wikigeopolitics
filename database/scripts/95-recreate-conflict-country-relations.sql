-- =====================================================
-- Recréation des relations pays-conflits
-- Objectif : Recréer les relations basées sur les conflits armés existants
-- =====================================================

-- 1. RECRÉER LES RELATIONS POUR LES CONFLITS EXISTANTS
-- =====================================================

-- Guerre en Ukraine (Russie, Ukraine)
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('1', 'russia', 'Agresseur', '2022-02-24', NULL),
('1', 'ukraine', 'Défenseur', '2022-02-24', NULL);

-- Conflit Gaza-Israël (Israël, Palestine)
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('2', 'israel', 'Défenseur', '2023-10-07', NULL),
('2', 'palestine', 'Résistant', '2023-10-07', NULL);

-- Guerre civile au Soudan (Soudan)
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('3', 'sudan', 'Pays en conflit', '2023-04-15', NULL);

-- Conflit Éthiopie-Tigré (Éthiopie)
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('4', 'ethiopia', 'Pays en conflit', '2021-11-04', NULL);

-- Révolution au Myanmar (Myanmar)
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('5', 'myanmar', 'Pays en conflit', '2014-01-01', NULL);

-- Rébellion au Mali (Mali)
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('6', 'mali', 'Pays en conflit', '2012-01-01', NULL);

-- Guerre civile en Syrie (Syrie)
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('7', 'syria', 'Pays en conflit', '1996-01-01', NULL);

-- Guerre civile au Yémen (Yémen)
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('8', 'yemen', 'Pays en conflit', '2020-01-01', NULL);

-- Conflit Afghanistan-Taliban (Afghanistan)
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('9', 'afghanistan', 'Pays en conflit', '2011-01-01', NULL);

-- Conflit Somalie-Al-Shabaab (Somalie)
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('10', 'somalia', 'Pays en conflit', '1991-01-01', NULL);

-- 2. AJOUTER LES IMPLICATIONS DES GRANDES PUISSANCES
-- =====================================================

-- États-Unis impliqués dans plusieurs conflits
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('1', 'usa', 'Soutien militaire', '2022-02-24', NULL),
('2', 'usa', 'Soutien diplomatique', '2023-10-07', NULL),
('9', 'usa', 'Intervention militaire', '2011-01-01', '2021-08-30');

-- Chine impliquée dans certains conflits
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('1', 'china', 'Soutien diplomatique', '2022-02-24', NULL),
('5', 'china', 'Soutien économique', '2014-01-01', NULL);

-- Russie impliquée dans d'autres conflits
INSERT INTO conflict_country (conflictid, countryid, role, dateentree, datesortie) VALUES
('7', 'russia', 'Intervention militaire', '2015-09-30', NULL),
('9', 'russia', 'Soutien diplomatique', '2011-01-01', NULL);

-- 3. VÉRIFICATION DES RELATIONS CRÉÉES
-- =====================================================

-- Statistiques des relations pays-conflits
SELECT 
    'Relations pays-conflits recréées' as description,
    COUNT(*) as total_relations,
    COUNT(DISTINCT countryid) as pays_impliqués,
    COUNT(DISTINCT conflictid) as conflits_avec_pays
FROM conflict_country;

-- Lister les relations par conflit
SELECT 
    ac.name as conflict_name,
    COUNT(cc.countryid) as pays_impliqués,
    STRING_AGG(c.nom, ', ') as pays
FROM armed_conflict ac
LEFT JOIN conflict_country cc ON ac.id::text = cc.conflictid
LEFT JOIN country c ON cc.countryid = c.id
GROUP BY ac.id, ac.name
ORDER BY ac.id;

-- 4. VÉRIFICATION DE L'INTÉGRITÉ
-- =====================================================

-- Vérifier qu'il n'y a plus de références orphelines
SELECT 
    'Références orphelines' as check_type,
    COUNT(*) as count
FROM conflict_country cc
WHERE NOT EXISTS (
    SELECT 1 FROM armed_conflict ac WHERE ac.id::text = cc.conflictid
);

-- Vérifier que tous les conflits ont au moins un pays impliqué
SELECT 
    'Conflits sans pays' as check_type,
    COUNT(*) as count
FROM armed_conflict ac
WHERE NOT EXISTS (
    SELECT 1 FROM conflict_country cc WHERE cc.conflictid = ac.id::text
);

-- =====================================================
-- FIN DE LA RECRÉATION
-- ===================================================== 