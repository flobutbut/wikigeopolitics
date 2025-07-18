-- =====================================================
-- Vérification finale de la correction country_political_regime
-- Objectif : Confirmer que tous les problèmes sont résolus
-- =====================================================

-- 1. STATISTIQUES FINALES
-- =====================================================

-- Résumé complet
SELECT 
    'RÉSUMÉ FINAL' as section,
    'Pays dans country' as metric, COUNT(*) as value FROM country

UNION ALL

SELECT 
    'RÉSUMÉ FINAL' as section,
    'Relations dans country_political_regime' as metric, COUNT(*) as value FROM country_political_regime

UNION ALL

SELECT 
    'RÉSUMÉ FINAL' as section,
    'Pays uniques avec régime' as metric, COUNT(DISTINCT country_id) as value FROM country_political_regime

UNION ALL

SELECT 
    'RÉSUMÉ FINAL' as section,
    'Pays sans régime' as problem_type, COUNT(*) as value
FROM country c
WHERE NOT EXISTS (
    SELECT 1 FROM country_political_regime cpr WHERE cpr.country_id = c.id
)

UNION ALL

SELECT 
    'RÉSUMÉ FINAL' as section,
    'Pays avec doublons' as problem_type, COUNT(*) as value
FROM (
    SELECT cpr.country_id
    FROM country_political_regime cpr
    GROUP BY cpr.country_id
    HAVING COUNT(*) > 1
) as duplicates;

-- 2. VÉRIFICATION DES PAYS AJOUTÉS
-- =====================================================

-- Vérifier que les 4 pays manquants ont bien été ajoutés
SELECT 
    cpr.country_id,
    c.nom as country_name,
    pr.name as regime_name,
    cpr.chef_etat,
    cpr.date_prise_poste
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.country_id IN ('ivory-coast', 'uk', 'democratic-republic-of-congo', 'uae')
ORDER BY c.nom;

-- 3. DISTRIBUTION PAR RÉGIME
-- =====================================================

-- Distribution finale des régimes politiques
SELECT 
    pr.name as regime_name,
    COUNT(cpr.country_id) as country_count,
    ROUND(COUNT(cpr.country_id) * 100.0 / (SELECT COUNT(*) FROM country), 1) as percentage
FROM political_regime pr
LEFT JOIN country_political_regime cpr ON pr.id = cpr.regime_id
GROUP BY pr.id, pr.name
ORDER BY country_count DESC;

-- 4. VÉRIFICATION PAR CONTINENT
-- =====================================================

-- Distribution par continent
SELECT 
    c.continent,
    COUNT(*) as total_countries,
    COUNT(cpr.country_id) as countries_with_regime,
    ROUND(COUNT(cpr.country_id) * 100.0 / COUNT(*), 1) as coverage_percentage
FROM country c
LEFT JOIN country_political_regime cpr ON c.id = cpr.country_id
GROUP BY c.continent
ORDER BY coverage_percentage DESC;

-- 5. VÉRIFICATION DES RÉFÉRENCES
-- =====================================================

-- Vérifier qu'il n'y a pas de références orphelines
SELECT 
    'Références orphelines pays' as check_type,
    COUNT(DISTINCT cpr.country_id) as count
FROM country_political_regime cpr
WHERE NOT EXISTS (
    SELECT 1 FROM country c WHERE c.id = cpr.country_id
)

UNION ALL

SELECT 
    'Références orphelines régimes' as check_type,
    COUNT(DISTINCT cpr.regime_id) as count
FROM country_political_regime cpr
WHERE NOT EXISTS (
    SELECT 1 FROM political_regime pr WHERE pr.id = cpr.regime_id
);

-- 6. EXEMPLES DE DONNÉES CORRIGÉES
-- =====================================================

-- Quelques exemples de pays avec leurs régimes
SELECT 
    c.nom as country_name,
    c.continent,
    pr.name as regime_name,
    cpr.chef_etat,
    cpr.date_prise_poste,
    cpr.current_regime
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true
ORDER BY c.continent, c.nom
LIMIT 20;

-- 7. VÉRIFICATION DE L'INTÉGRITÉ
-- =====================================================

-- Vérifier que chaque pays a exactement un régime actuel
SELECT 
    'Pays avec plusieurs régimes actuels' as check_type,
    COUNT(*) as count
FROM (
    SELECT cpr.country_id
    FROM country_political_regime cpr
    WHERE cpr.current_regime = true
    GROUP BY cpr.country_id
    HAVING COUNT(*) > 1
) as multiple_current;

-- 8. MÉTRIQUES DE QUALITÉ
-- =====================================================

-- Métriques de qualité des données
SELECT 
    'QUALITÉ DES DONNÉES' as section,
    'Pays avec chef d\'État' as metric,
    COUNT(*) as value
FROM country_political_regime cpr
WHERE cpr.chef_etat IS NOT NULL AND cpr.chef_etat != ''

UNION ALL

SELECT 
    'QUALITÉ DES DONNÉES' as section,
    'Pays avec date de prise de poste' as metric,
    COUNT(*) as value
FROM country_political_regime cpr
WHERE cpr.date_prise_poste IS NOT NULL

UNION ALL

SELECT 
    'QUALITÉ DES DONNÉES' as section,
    'Régimes actuels' as metric,
    COUNT(*) as value
FROM country_political_regime cpr
WHERE cpr.current_regime = true;

-- =====================================================
-- FIN DE LA VÉRIFICATION
-- ===================================================== 