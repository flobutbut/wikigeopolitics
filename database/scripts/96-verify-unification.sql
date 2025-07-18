-- =====================================================
-- Vérification de l'unification des tables de conflits
-- Objectif : S'assurer que tout fonctionne correctement après migration
-- =====================================================

-- 1. VÉRIFICATION DES TABLES
-- =====================================================

-- Vérifier que la table conflict n'existe plus
SELECT 
    'Table conflict existe' as check_type,
    COUNT(*) as result
FROM information_schema.tables 
WHERE table_name = 'conflict';

-- Vérifier que armed_conflict existe et contient des données
SELECT 
    'Table armed_conflict' as check_type,
    COUNT(*) as total_conflicts,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_conflicts
FROM armed_conflict;

-- 2. VÉRIFICATION DES RELATIONS
-- =====================================================

-- Vérifier les relations pays-conflits
SELECT 
    'Relations pays-conflits' as check_type,
    COUNT(*) as total_relations,
    COUNT(DISTINCT countryid) as unique_countries,
    COUNT(DISTINCT conflictid) as unique_conflicts
FROM conflict_country;

-- Vérifier qu'il n'y a pas de références orphelines
SELECT 
    'Références orphelines' as check_type,
    COUNT(*) as count
FROM conflict_country cc
WHERE NOT EXISTS (
    SELECT 1 FROM armed_conflict ac WHERE ac.id::text = cc.conflictid
);

-- 3. VÉRIFICATION DES DONNÉES DE CONFLITS
-- =====================================================

-- Lister tous les conflits avec leurs détails
SELECT 
    id,
    name,
    status,
    statut,
    startyear,
    endyear,
    CASE 
        WHEN epicenter IS NOT NULL THEN 'Avec coordonnées'
        ELSE 'Sans coordonnées'
    END as has_coordinates
FROM armed_conflict 
ORDER BY id;

-- 4. VÉRIFICATION DES PAYS IMPLIQUÉS
-- =====================================================

-- Lister les conflits avec leurs pays impliqués
SELECT 
    ac.name as conflict_name,
    ac.status,
    COUNT(cc.countryid) as pays_impliqués,
    STRING_AGG(c.nom, ', ' ORDER BY c.nom) as pays
FROM armed_conflict ac
LEFT JOIN conflict_country cc ON ac.id::text = cc.conflictid
LEFT JOIN country c ON cc.countryid = c.id
GROUP BY ac.id, ac.name, ac.status
ORDER BY ac.id;

-- 5. VÉRIFICATION DES GRANDES PUISSANCES
-- =====================================================

-- Vérifier l'implication des grandes puissances
SELECT 
    c.nom as pays,
    COUNT(cc.conflictid) as conflits_impliqués,
    STRING_AGG(ac.name, ', ' ORDER BY ac.name) as conflits
FROM country c
JOIN conflict_country cc ON c.id = cc.countryid
JOIN armed_conflict ac ON cc.conflictid = ac.id::text
WHERE c.id IN ('usa', 'china', 'russia', 'france', 'uk', 'germany')
GROUP BY c.id, c.nom
ORDER BY conflits_impliqués DESC;

-- 6. VÉRIFICATION DE L'API
-- =====================================================

-- Simuler une requête API pour un conflit spécifique
SELECT 
    'Test API conflit 1' as test_name,
    ac.id,
    ac.name,
    ac.status,
    ac.startyear,
    ac.endyear,
    ac.involvedcountries,
    ac.casualtyestimates
FROM armed_conflict ac
WHERE ac.id = 1;

-- 7. STATISTIQUES FINALES
-- =====================================================

-- Résumé de l'unification
SELECT 
    'RÉSUMÉ UNIFICATION' as section,
    'Conflits armés' as metric,
    COUNT(*) as value
FROM armed_conflict

UNION ALL

SELECT 
    'RÉSUMÉ UNIFICATION' as section,
    'Conflits actifs' as metric,
    COUNT(*) as value
FROM armed_conflict
WHERE status = 'active'

UNION ALL

SELECT 
    'RÉSUMÉ UNIFICATION' as section,
    'Relations pays-conflits' as metric,
    COUNT(*) as value
FROM conflict_country

UNION ALL

SELECT 
    'RÉSUMÉ UNIFICATION' as section,
    'Pays impliqués' as metric,
    COUNT(DISTINCT countryid) as value
FROM conflict_country;

-- =====================================================
-- FIN DE LA VÉRIFICATION
-- ===================================================== 