-- Script pour supprimer les tables international_relation redondantes
-- Date: 2025-01-XX

-- Vérification des données avant suppression
SELECT '=== VÉRIFICATION AVANT SUPPRESSION ===' as info;

SELECT 'Données dans international_relation:' as info;
SELECT type, sous_type, nom, description FROM international_relation ORDER BY type, nom;

SELECT 'Données dans international_relation_country:' as info;
SELECT COUNT(*) as total_relations_pays FROM international_relation_country;

-- Identification des relations qui n'existent pas dans organization
SELECT '=== RELATIONS UNIQUES À MIGRER ===' as info;

WITH relations_uniques AS (
  SELECT ir.*
  FROM international_relation ir
  LEFT JOIN organization o ON LOWER(ir.nom) = LOWER(o.nom)
  WHERE o.id IS NULL
)
SELECT 
  nom,
  type,
  sous_type,
  description,
  'À migrer vers organization' as action
FROM relations_uniques
ORDER BY type, nom;

-- Migration des relations uniques vers organization
SELECT '=== MIGRATION VERS ORGANIZATION ===' as info;

-- Insertion des relations uniques dans organization
INSERT INTO organization (id, nom, type, description, datecreation, siege)
SELECT 
  'rel_' || LOWER(REPLACE(REPLACE(nom, ' ', '_'), '-', '_')) as id,
  nom,
  CASE 
    WHEN type = 'commercial' THEN 'Organisation commerciale'
    WHEN type = 'diplomatic' THEN 'Organisation diplomatique'
    WHEN type = 'military' THEN 'Alliance militaire'
    ELSE 'Organisation internationale'
  END as type,
  description,
  CURRENT_DATE as datecreation,
  'À déterminer' as siege
FROM international_relation ir
LEFT JOIN organization o ON LOWER(ir.nom) = LOWER(o.nom)
WHERE o.id IS NULL;

-- Vérification des insertions
SELECT '=== VÉRIFICATION DES INSERTIONS ===' as info;
SELECT 'Nouvelles organisations ajoutées:' as info;
SELECT id, nom, type FROM organization WHERE id LIKE 'rel_%' ORDER BY nom;

-- Migration des relations pays vers country_organization
SELECT '=== MIGRATION DES RELATIONS PAYS ===' as info;

-- Insertion des relations pays pour les nouvelles organisations
INSERT INTO country_organization (countryid, organizationid, role, statut, dateadhesion)
SELECT 
  irc.countryId,
  'rel_' || LOWER(REPLACE(REPLACE(ir.nom, ' ', '_'), '-', '_')) as organizationid,
  irc.role,
  irc.statut,
  CURRENT_DATE as dateadhesion
FROM international_relation_country irc
JOIN international_relation ir ON irc.relationId = ir.id
LEFT JOIN organization o ON LOWER(ir.nom) = LOWER(o.nom)
WHERE o.id IS NULL OR o.id LIKE 'rel_%';

-- Vérification des relations pays migrées
SELECT '=== VÉRIFICATION DES RELATIONS PAYS ===' as info;
SELECT 'Relations pays migrées:' as info, COUNT(*) as nombre 
FROM country_organization 
WHERE organizationid LIKE 'rel_%';

-- Suppression des tables redondantes
SELECT '=== SUPPRESSION DES TABLES REDONDANTES ===' as info;

-- Suppression des tables de liaison d'abord
DROP TABLE IF EXISTS international_relation_country CASCADE;

-- Suppression de la table principale
DROP TABLE IF EXISTS international_relation CASCADE;

-- Vérification finale
SELECT '=== VÉRIFICATION FINALE ===' as info;

SELECT 'Organisations totales après nettoyage:' as info, COUNT(*) as nombre FROM organization;

SELECT 'Relations pays totales après nettoyage:' as info, COUNT(*) as nombre FROM country_organization;

-- Vérification des nouvelles organisations ajoutées
SELECT '=== NOUVELLES ORGANISATIONS AJOUTÉES ===' as info;
SELECT 
  id,
  nom,
  type,
  description
FROM organization 
WHERE id LIKE 'rel_%'
ORDER BY nom;

-- Statistiques des organisations par type
SELECT '=== STATISTIQUES PAR TYPE ===' as info;
SELECT 
  type,
  COUNT(*) as nombre
FROM organization 
GROUP BY type 
ORDER BY nombre DESC;

-- Test de requête pour vérifier l'intégrité
SELECT '=== TEST DE REQUÊTE ===' as info;
SELECT 
  o.nom as organisation,
  o.type,
  COUNT(co.countryid) as nombre_pays
FROM organization o
LEFT JOIN country_organization co ON o.id = co.organizationid
GROUP BY o.id, o.nom, o.type
ORDER BY nombre_pays DESC, o.nom
LIMIT 10;

SELECT 'Nettoyage des tables redondantes terminé avec succès' as status; 