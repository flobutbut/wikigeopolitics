-- =====================================================
-- Analyse des données de conflits avant migration
-- Objectif : Comparer les données entre conflict et armed_conflict
-- =====================================================

-- 1. STRUCTURE DES TABLES
-- =====================================================

-- Structure de armed_conflict
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'armed_conflict' 
ORDER BY ordinal_position;

-- Structure de conflict
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'conflict' 
ORDER BY ordinal_position;

-- 2. DONNÉES DANS ARMED_CONFLICT
-- =====================================================

SELECT 
    id,
    name,
    status,
    startyear,
    endyear,
    statut,
    created_at
FROM armed_conflict 
ORDER BY id;

-- 3. DONNÉES DANS CONFLICT
-- =====================================================

SELECT 
    id,
    nom,
    statut,
    date_debut,
    date_fin,
    type,
    intensite,
    created_at
FROM conflict 
ORDER BY id;

-- 4. COMPARAISON DES NOMS
-- =====================================================

-- Conflits présents dans armed_conflict
SELECT 'armed_conflict' as source, name as conflict_name, id
FROM armed_conflict
ORDER BY name;

-- Conflits présents dans conflict
SELECT 'conflict' as source, nom as conflict_name, id
FROM conflict
ORDER BY nom;

-- 5. RELATIONS PAYS-CONFLITS
-- =====================================================

-- Relations dans conflict_country
SELECT 
    'conflict_country' as table_name,
    COUNT(*) as total_relations,
    COUNT(DISTINCT countryid) as unique_countries,
    COUNT(DISTINCT conflictid) as unique_conflicts
FROM conflict_country;

-- 6. STATISTIQUES GÉNÉRALES
-- =====================================================

SELECT 
    'armed_conflict' as table_name,
    COUNT(*) as total_conflicts,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_conflicts,
    COUNT(CASE WHEN status != 'active' THEN 1 END) as inactive_conflicts
FROM armed_conflict

UNION ALL

SELECT 
    'conflict' as table_name,
    COUNT(*) as total_conflicts,
    COUNT(CASE WHEN statut = 'En cours' THEN 1 END) as active_conflicts,
    COUNT(CASE WHEN statut != 'En cours' THEN 1 END) as inactive_conflicts
FROM conflict;

-- 7. VÉRIFICATION DES RÉFÉRENCES
-- =====================================================

-- Vérifier si conflict_country référence des conflits inexistants
SELECT DISTINCT conflictid
FROM conflict_country cc
WHERE NOT EXISTS (
    SELECT 1 FROM armed_conflict ac WHERE ac.id::text = cc.conflictid
)
AND NOT EXISTS (
    SELECT 1 FROM conflict c WHERE c.id = cc.conflictid
);

-- =====================================================
-- FIN DE L'ANALYSE
-- ===================================================== 