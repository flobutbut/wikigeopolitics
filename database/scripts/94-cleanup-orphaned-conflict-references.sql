-- =====================================================
-- Nettoyage des références orphelines dans conflict_country
-- Objectif : Supprimer les références vers des conflits inexistants
-- =====================================================

-- 1. IDENTIFIER LES RÉFÉRENCES ORPHELINES
-- =====================================================

-- Lister les conflits référencés dans conflict_country mais inexistants dans armed_conflict
SELECT DISTINCT conflictid, COUNT(*) as reference_count
FROM conflict_country cc
WHERE NOT EXISTS (
    SELECT 1 FROM armed_conflict ac WHERE ac.id::text = cc.conflictid
)
GROUP BY conflictid
ORDER BY conflictid;

-- 2. SUPPRIMER LES RÉFÉRENCES ORPHELINES
-- =====================================================

-- Supprimer les relations vers des conflits inexistants
DELETE FROM conflict_country 
WHERE conflictid IN (
    SELECT DISTINCT conflictid
    FROM conflict_country cc
    WHERE NOT EXISTS (
        SELECT 1 FROM armed_conflict ac WHERE ac.id::text = cc.conflictid
    )
);

-- 3. VÉRIFICATION APRÈS NETTOYAGE
-- =====================================================

-- Compter les relations restantes
SELECT 
    'conflict_country après nettoyage' as table_name,
    COUNT(*) as total_relations,
    COUNT(DISTINCT countryid) as unique_countries,
    COUNT(DISTINCT conflictid) as unique_conflicts
FROM conflict_country;

-- Vérifier qu'il n'y a plus de références orphelines
SELECT 
    'Références orphelines restantes' as check_type,
    COUNT(*) as count
FROM conflict_country cc
WHERE NOT EXISTS (
    SELECT 1 FROM armed_conflict ac WHERE ac.id::text = cc.conflictid
);

-- 4. STATISTIQUES FINALES
-- =====================================================

-- Statistiques des conflits armés
SELECT 
    'armed_conflict' as table_name,
    COUNT(*) as total_conflicts,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_conflicts,
    COUNT(CASE WHEN status != 'active' THEN 1 END) as inactive_conflicts
FROM armed_conflict;

-- Statistiques des relations pays-conflits
SELECT 
    'Relations pays-conflits' as description,
    COUNT(*) as total_relations,
    COUNT(DISTINCT countryid) as pays_impliqués,
    COUNT(DISTINCT conflictid) as conflits_avec_pays
FROM conflict_country;

-- =====================================================
-- FIN DU NETTOYAGE
-- ===================================================== 