-- Script de vérification de l'intégrité des références organization
-- Date: 2025-01-XX

-- Vérification générale des références
SELECT '=== VÉRIFICATION GÉNÉRALE ===' as info;

SELECT 'Total des références country_organization:' as info, COUNT(*) as nombre FROM country_organization;

-- Vérification des références orphelines (qui pointent vers des organisations inexistantes)
SELECT '=== RÉFÉRENCES ORPHELINES ===' as info;

SELECT 
    co.organizationid,
    COUNT(*) as nombre_references
FROM country_organization co
LEFT JOIN organization o ON co.organizationid = o.id
WHERE o.id IS NULL
GROUP BY co.organizationid
ORDER BY nombre_references DESC;

-- Vérification des organisations sans références
SELECT '=== ORGANISATIONS SANS RÉFÉRENCES ===' as info;

SELECT 
    o.id,
    o.nom,
    o.type
FROM organization o
LEFT JOIN country_organization co ON o.id = co.organizationid
WHERE co.organizationid IS NULL
ORDER BY o.type, o.nom;

-- Statistiques par organisation
SELECT '=== STATISTIQUES PAR ORGANISATION ===' as info;

SELECT 
    o.id,
    o.nom,
    o.type,
    COUNT(co.countryid) as nombre_pays
FROM organization o
LEFT JOIN country_organization co ON o.id = co.organizationid
GROUP BY o.id, o.nom, o.type
ORDER BY nombre_pays DESC, o.nom;

-- Vérification des types d'organisations les plus référencées
SELECT '=== TYPES D''ORGANISATIONS LES PLUS RÉFÉRENCÉES ===' as info;

SELECT 
    o.type,
    COUNT(co.countryid) as nombre_references,
    COUNT(DISTINCT o.id) as nombre_organisations
FROM organization o
LEFT JOIN country_organization co ON o.id = co.organizationid
GROUP BY o.type
ORDER BY nombre_references DESC;

-- Vérification des pays les plus impliqués dans les organisations
SELECT '=== PAYS LES PLUS IMPLIQUÉS ===' as info;

SELECT 
    c.nom as pays,
    COUNT(co.organizationid) as nombre_organisations
FROM country c
JOIN country_organization co ON c.id = co.countryid
GROUP BY c.id, c.nom
ORDER BY nombre_organisations DESC
LIMIT 10;

-- Vérification des organisations supprimées qui auraient encore des références
SELECT '=== VÉRIFICATION DES ORGANISATIONS SUPPRIMÉES ===' as info;

SELECT 
    'otan' as organisation_supprimee,
    COUNT(*) as references_restantes
FROM country_organization 
WHERE organizationid = 'otan';

SELECT 
    'asean' as organisation_supprimee,
    COUNT(*) as references_restantes
FROM country_organization 
WHERE organizationid = 'asean';

SELECT 
    'org_opec_plus' as organisation_supprimee,
    COUNT(*) as references_restantes
FROM country_organization 
WHERE organizationid = 'org_opec_plus';

-- Test de requête complexe pour vérifier l'intégrité
SELECT '=== TEST DE REQUÊTE COMPLEXE ===' as info;

SELECT 
    'Organisations avec le plus de pays membres:' as test,
    o.nom,
    o.type,
    COUNT(co.countryid) as nombre_pays
FROM organization o
JOIN country_organization co ON o.id = co.organizationid
GROUP BY o.id, o.nom, o.type
HAVING COUNT(co.countryid) >= 5
ORDER BY nombre_pays DESC, o.nom;

SELECT 'Vérification de l''intégrité terminée avec succès' as status; 