-- Script de nettoyage des redondances dans la table organization
-- Date: 2025-01-XX

-- Vérification des données avant nettoyage
SELECT '=== VÉRIFICATION AVANT NETTOYAGE ===' as info;

SELECT 'Organisations OTAN:' as entite;
SELECT id, nom, type FROM organization WHERE nom LIKE '%OTAN%' OR nom LIKE '%Atlantique Nord%' ORDER BY nom;

SELECT 'Organisations ASEAN:' as entite;
SELECT id, nom, type FROM organization WHERE nom LIKE '%ASEAN%' OR nom LIKE '%Asie du Sud-Est%' ORDER BY nom;

SELECT 'Organisations OPEP:' as entite;
SELECT id, nom, type FROM organization WHERE nom LIKE '%OPEP%' OR nom LIKE '%pays exportateurs de pétrole%' ORDER BY nom;

-- Vérification des références dans country_organization
SELECT '=== VÉRIFICATION DES RÉFÉRENCES ===' as info;
SELECT 'Références vers otan:' as reference, COUNT(*) as nombre FROM country_organization WHERE organizationid = 'otan';
SELECT 'Références vers org_nato:' as reference, COUNT(*) as nombre FROM country_organization WHERE organizationid = 'org_nato';
SELECT 'Références vers asean:' as reference, COUNT(*) as nombre FROM country_organization WHERE organizationid = 'asean';
SELECT 'Références vers org_asean:' as reference, COUNT(*) as nombre FROM country_organization WHERE organizationid = 'org_asean';
SELECT 'Références vers org_opec:' as reference, COUNT(*) as nombre FROM country_organization WHERE organizationid = 'org_opec';
SELECT 'Références vers org_opec_plus:' as reference, COUNT(*) as nombre FROM country_organization WHERE organizationid = 'org_opec_plus';

-- Migration des références vers les entrées consolidées
SELECT '=== MIGRATION DES RÉFÉRENCES ===' as info;

-- Migration des références OTAN (vers org_nato qui a le nom complet)
UPDATE country_organization 
SET organizationid = 'org_nato' 
WHERE organizationid = 'otan';

-- Migration des références ASEAN (vers org_asean qui a le nom complet)
UPDATE country_organization 
SET organizationid = 'org_asean' 
WHERE organizationid = 'asean';

-- Migration des références OPEP (vers org_opec qui est l'entité principale)
UPDATE country_organization 
SET organizationid = 'org_opec' 
WHERE organizationid = 'org_opec_plus';

-- Vérification après migration
SELECT '=== VÉRIFICATION APRÈS MIGRATION ===' as info;
SELECT 'Références vers org_nato:' as reference, COUNT(*) as nombre FROM country_organization WHERE organizationid = 'org_nato';
SELECT 'Références vers org_asean:' as reference, COUNT(*) as nombre FROM country_organization WHERE organizationid = 'org_asean';
SELECT 'Références vers org_opec:' as reference, COUNT(*) as nombre FROM country_organization WHERE organizationid = 'org_opec';

-- Suppression des entrées redondantes
SELECT '=== SUPPRESSION DES ENTRÉES REDONDANTES ===' as info;

-- Suppression de l'ancienne entrée OTAN
DELETE FROM organization WHERE id = 'otan';

-- Suppression de l'ancienne entrée ASEAN
DELETE FROM organization WHERE id = 'asean';

-- Suppression de l'entrée OPEP+ (redondante avec OPEP)
DELETE FROM organization WHERE id = 'org_opec_plus';

-- Vérification finale
SELECT '=== VÉRIFICATION FINALE ===' as info;

SELECT 'Organisations restantes:' as info, COUNT(*) as nombre FROM organization;

SELECT 'Organisations OTAN:' as entite;
SELECT id, nom, type FROM organization WHERE nom LIKE '%OTAN%' OR nom LIKE '%Atlantique Nord%' ORDER BY nom;

SELECT 'Organisations ASEAN:' as entite;
SELECT id, nom, type FROM organization WHERE nom LIKE '%ASEAN%' OR nom LIKE '%Asie du Sud-Est%' ORDER BY nom;

SELECT 'Organisations OPEP:' as entite;
SELECT id, nom, type FROM organization WHERE nom LIKE '%OPEP%' OR nom LIKE '%pays exportateurs de pétrole%' ORDER BY nom;

-- Mise à jour des types pour plus de cohérence
SELECT '=== HARMONISATION DES TYPES ===' as info;

-- Mise à jour du type de l'OTAN pour être cohérent
UPDATE organization 
SET type = 'Alliance militaire' 
WHERE id = 'org_nato';

-- Mise à jour du type de l'ASEAN pour être cohérent
UPDATE organization 
SET type = 'Organisation régionale' 
WHERE id = 'org_asean';

-- Mise à jour du type de l'OPEP pour être cohérent
UPDATE organization 
SET type = 'Cartel pétrolier' 
WHERE id = 'org_opec';

-- Vérification des types après harmonisation
SELECT 'Types d''organisations après harmonisation:' as info;
SELECT type, COUNT(*) as nombre 
FROM organization 
GROUP BY type 
ORDER BY nombre DESC;

SELECT 'Nettoyage des redondances terminé avec succès' as status; 