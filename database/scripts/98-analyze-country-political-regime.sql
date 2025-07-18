-- =====================================================
-- Analyse de la table country_political_regime
-- Objectif : Identifier les doublons et pays manquants
-- =====================================================

-- 1. STATISTIQUES GÉNÉRALES
-- =====================================================

-- Nombre total de pays
SELECT 'Pays dans country' as metric, COUNT(*) as value FROM country

UNION ALL

-- Nombre total de relations
SELECT 'Relations dans country_political_regime' as metric, COUNT(*) as value FROM country_political_regime

UNION ALL

-- Nombre de pays uniques avec régime
SELECT 'Pays uniques avec régime' as metric, COUNT(DISTINCT country_id) as value FROM country_political_regime;

-- 2. IDENTIFICATION DES DOUBLONS
-- =====================================================

-- Pays avec plusieurs relations (doublons)
SELECT 
    cpr.country_id,
    c.nom as country_name,
    COUNT(*) as relation_count,
    STRING_AGG(cpr.regime_id::text, ', ' ORDER BY cpr.regime_id) as regime_ids,
    STRING_AGG(pr.name, ', ' ORDER BY pr.name) as regime_names
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
GROUP BY cpr.country_id, c.nom
HAVING COUNT(*) > 1
ORDER BY relation_count DESC, c.nom;

-- 3. PAYS SANS RÉGIME POLITIQUE
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

-- 4. RÉGIMES POLITIQUES DISPONIBLES
-- =====================================================

-- Liste des régimes politiques avec leur nombre d'assignations
SELECT 
    pr.id,
    pr.nom as regime_name,
    COUNT(cpr.country_id) as assigned_countries
FROM political_regime pr
LEFT JOIN country_political_regime cpr ON pr.id = cpr.regime_id
GROUP BY pr.id, pr.nom
ORDER BY assigned_countries DESC, pr.nom;

-- 5. VÉRIFICATION DES RÉFÉRENCES
-- =====================================================

-- Relations avec des pays inexistants
SELECT DISTINCT cpr.country_id
FROM country_political_regime cpr
WHERE NOT EXISTS (
    SELECT 1 FROM country c WHERE c.id = cpr.country_id
);

-- Relations avec des régimes inexistants
SELECT DISTINCT cpr.regime_id
FROM country_political_regime cpr
WHERE NOT EXISTS (
    SELECT 1 FROM political_regime pr WHERE pr.id = cpr.regime_id
);

-- 6. DISTRIBUTION PAR CONTINENT
-- =====================================================

-- Distribution des régimes par continent
SELECT 
    c.continent,
    pr.nom as regime_name,
    COUNT(*) as country_count
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
GROUP BY c.continent, pr.nom
ORDER BY c.continent, country_count DESC;

-- 7. RÉSUMÉ DES PROBLÈMES
-- =====================================================

-- Résumé des problèmes identifiés
SELECT 
    'Pays avec doublons' as problem_type,
    COUNT(*) as count
FROM (
    SELECT cpr.country_id
    FROM country_political_regime cpr
    GROUP BY cpr.country_id
    HAVING COUNT(*) > 1
) as duplicates

UNION ALL

SELECT 
    'Pays sans régime' as problem_type,
    COUNT(*) as count
FROM country c
WHERE NOT EXISTS (
    SELECT 1 FROM country_political_regime cpr WHERE cpr.country_id = c.id
)

UNION ALL

SELECT 
    'Références orphelines pays' as problem_type,
    COUNT(DISTINCT cpr.country_id) as count
FROM country_political_regime cpr
WHERE NOT EXISTS (
    SELECT 1 FROM country c WHERE c.id = cpr.country_id
)

UNION ALL

SELECT 
    'Références orphelines régimes' as problem_type,
    COUNT(DISTINCT cpr.regime_id) as count
FROM country_political_regime cpr
WHERE NOT EXISTS (
    SELECT 1 FROM political_regime pr WHERE pr.id = cpr.regime_id
);

-- =====================================================
-- FIN DE L'ANALYSE
-- ===================================================== 