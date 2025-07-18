-- =====================================================
-- Correction de la table country_political_regime
-- Objectif : Éliminer les doublons et ajouter les pays manquants
-- =====================================================

-- 1. SAUVEGARDE AVANT CORRECTION
-- =====================================================

-- Créer une sauvegarde de la table
CREATE TABLE country_political_regime_backup AS SELECT * FROM country_political_regime;

-- 2. IDENTIFICATION DES DOUBLONS
-- =====================================================

-- Créer une table temporaire avec les doublons identifiés
CREATE TEMP TABLE duplicates AS
SELECT 
    cpr.country_id,
    cpr.regime_id,
    cpr.start_year,
    cpr.end_year,
    cpr.current_regime,
    cpr.notes,
    cpr.chef_etat,
    cpr.date_prise_poste,
    ROW_NUMBER() OVER (PARTITION BY cpr.country_id ORDER BY cpr.current_regime DESC, cpr.start_year DESC) as rn
FROM country_political_regime cpr
WHERE EXISTS (
    SELECT 1 
    FROM country_political_regime cpr2 
    WHERE cpr2.country_id = cpr.country_id 
    GROUP BY cpr2.country_id 
    HAVING COUNT(*) > 1
);

-- 3. SUPPRESSION DES DOUBLONS
-- =====================================================

-- Supprimer les doublons en gardant seulement le premier (le plus récent ou actuel)
DELETE FROM country_political_regime 
WHERE (country_id, regime_id, start_year) IN (
    SELECT country_id, regime_id, start_year 
    FROM duplicates 
    WHERE rn > 1
);

-- 4. IDENTIFICATION DES PAYS SANS RÉGIME
-- =====================================================

-- Pays qui n'ont pas de régime politique assigné
SELECT 
    c.id,
    c.nom,
    c.continent
FROM country c
WHERE NOT EXISTS (
    SELECT 1 FROM country_political_regime cpr WHERE cpr.country_id = c.id
)
ORDER BY c.nom;

-- 5. AJOUT DES RÉGIMES MANQUANTS
-- =====================================================

-- Côte d'Ivoire - République présidentielle
INSERT INTO country_political_regime (country_id, regime_id, start_year, current_regime, chef_etat, date_prise_poste)
VALUES ('ivory-coast', 'republique-presidentielle', 2011, true, 'Alassane Ouattara', '2011-05-21');

-- Royaume-Uni - Monarchie constitutionnelle
INSERT INTO country_political_regime (country_id, regime_id, start_year, current_regime, chef_etat, date_prise_poste)
VALUES ('uk', 'monarchie-constitutionnelle', 1952, true, 'Charles III', '2022-09-08');

-- République démocratique du Congo - République présidentielle
INSERT INTO country_political_regime (country_id, regime_id, start_year, current_regime, chef_etat, date_prise_poste)
VALUES ('democratic-republic-of-congo', 'republique-presidentielle', 2019, true, 'Félix Tshisekedi', '2019-01-24');

-- Émirats arabes unis - Monarchie constitutionnelle
INSERT INTO country_political_regime (country_id, regime_id, start_year, current_regime, chef_etat, date_prise_poste)
VALUES ('uae', 'monarchie-constitutionnelle', 1971, true, 'Mohammed ben Zayed Al Nahyane', '2022-05-14');

-- 6. VÉRIFICATION DES RÉGIMES DISPONIBLES
-- =====================================================

-- Lister les régimes politiques disponibles
SELECT 
    pr.id,
    pr.name as regime_name,
    COUNT(cpr.country_id) as assigned_countries
FROM political_regime pr
LEFT JOIN country_political_regime cpr ON pr.id = cpr.regime_id
GROUP BY pr.id, pr.name
ORDER BY assigned_countries DESC, pr.name;

-- 7. VÉRIFICATION FINALE
-- =====================================================

-- Statistiques après correction
SELECT 
    'Pays dans country' as metric, COUNT(*) as value FROM country

UNION ALL

SELECT 
    'Relations dans country_political_regime' as metric, COUNT(*) as value FROM country_political_regime

UNION ALL

SELECT 
    'Pays uniques avec régime' as metric, COUNT(DISTINCT country_id) as value FROM country_political_regime

UNION ALL

SELECT 
    'Pays sans régime' as problem_type, COUNT(*) as value
FROM country c
WHERE NOT EXISTS (
    SELECT 1 FROM country_political_regime cpr WHERE cpr.country_id = c.id
)

UNION ALL

SELECT 
    'Pays avec doublons' as problem_type, COUNT(*) as value
FROM (
    SELECT cpr.country_id
    FROM country_political_regime cpr
    GROUP BY cpr.country_id
    HAVING COUNT(*) > 1
) as duplicates;

-- 8. DISTRIBUTION PAR CONTINENT
-- =====================================================

-- Distribution des régimes par continent après correction
SELECT 
    c.continent,
    pr.name as regime_name,
    COUNT(*) as country_count
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
GROUP BY c.continent, pr.name
ORDER BY c.continent, country_count DESC;

-- 9. NETTOYAGE
-- =====================================================

-- Supprimer la table temporaire
DROP TABLE duplicates;

-- =====================================================
-- FIN DE LA CORRECTION
-- ===================================================== 