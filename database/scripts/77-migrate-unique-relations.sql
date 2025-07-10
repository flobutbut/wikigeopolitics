-- Script pour migrer les relations uniques vers organization
-- Date: 2025-01-XX

-- Vérification des organisations manquantes
SELECT '=== ORGANISATIONS MANQUANTES ===' as info;

-- Liste des organisations qui devraient être ajoutées
SELECT 'Organisations à ajouter:' as info;
SELECT 
  'Accord de libre-échange nord-américain' as nom,
  'Organisation commerciale' as type,
  'Zone de libre-échange entre Canada, États-Unis et Mexique' as description
UNION ALL
SELECT 
  'Accord États-Unis-Mexique-Canada' as nom,
  'Organisation commerciale' as type,
  'Remplace l''ALENA, accord commercial trinational' as description
UNION ALL
SELECT 
  'Conseil de coopération du Golfe' as nom,
  'Organisation diplomatique' as type,
  'Organisation des États arabes du Golfe Persique' as description
UNION ALL
SELECT 
  'Organisation des États américains' as nom,
  'Organisation diplomatique' as type,
  'Organisation panaméricaine' as description
UNION ALL
SELECT 
  'Organisation du Traité de sécurité collective' as nom,
  'Alliance militaire' as type,
  'Alliance militaire eurasienne' as description;

-- Insertion des organisations manquantes
SELECT '=== INSERTION DES ORGANISATIONS MANQUANTES ===' as info;

INSERT INTO organization (id, nom, type, description, datecreation, siege)
VALUES 
  ('rel_accord_libre_echange_na', 'Accord de libre-échange nord-américain', 'Organisation commerciale', 'Zone de libre-échange entre Canada, États-Unis et Mexique', CURRENT_DATE, 'Washington, États-Unis'),
  ('rel_accord_etats_unis_mexique_canada', 'Accord États-Unis-Mexique-Canada', 'Organisation commerciale', 'Remplace l''ALENA, accord commercial trinational', CURRENT_DATE, 'Washington, États-Unis'),
  ('rel_conseil_cooperation_golfe', 'Conseil de coopération du Golfe', 'Organisation diplomatique', 'Organisation des États arabes du Golfe Persique', CURRENT_DATE, 'Riyad, Arabie saoudite'),
  ('rel_organisation_etats_americains', 'Organisation des États américains', 'Organisation diplomatique', 'Organisation panaméricaine', CURRENT_DATE, 'Washington, États-Unis'),
  ('rel_organisation_traite_securite_collective', 'Organisation du Traité de sécurité collective', 'Alliance militaire', 'Alliance militaire eurasienne', CURRENT_DATE, 'Moscou, Russie');

-- Vérification des insertions
SELECT '=== VÉRIFICATION DES INSERTIONS ===' as info;
SELECT 'Nouvelles organisations ajoutées:' as info;
SELECT id, nom, type, description FROM organization WHERE id LIKE 'rel_%' ORDER BY nom;

-- Ajout de quelques relations pays pour les nouvelles organisations
SELECT '=== AJOUT DE RELATIONS PAYS ===' as info;

-- Relations pour l'Accord États-Unis-Mexique-Canada
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion)
VALUES 
  ('usa', 'rel_accord_etats_unis_mexique_canada', 'membre', CURRENT_DATE),
  ('canada', 'rel_accord_etats_unis_mexique_canada', 'membre', CURRENT_DATE),
  ('mexique', 'rel_accord_etats_unis_mexique_canada', 'membre', CURRENT_DATE);

-- Relations pour le Conseil de coopération du Golfe
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion)
VALUES 
  ('saudi-arabia', 'rel_conseil_cooperation_golfe', 'membre', CURRENT_DATE),
  ('kuwait', 'rel_conseil_cooperation_golfe', 'membre', CURRENT_DATE),
  ('qatar', 'rel_conseil_cooperation_golfe', 'membre', CURRENT_DATE),
  ('bahrain', 'rel_conseil_cooperation_golfe', 'membre', CURRENT_DATE),
  ('oman', 'rel_conseil_cooperation_golfe', 'membre', CURRENT_DATE),
  ('uae', 'rel_conseil_cooperation_golfe', 'membre', CURRENT_DATE);

-- Relations pour l'Organisation des États américains
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion)
VALUES 
  ('usa', 'rel_organisation_etats_americains', 'membre', CURRENT_DATE),
  ('canada', 'rel_organisation_etats_americains', 'membre', CURRENT_DATE),
  ('mexique', 'rel_organisation_etats_americains', 'membre', CURRENT_DATE),
  ('brazil', 'rel_organisation_etats_americains', 'membre', CURRENT_DATE),
  ('argentina', 'rel_organisation_etats_americains', 'membre', CURRENT_DATE);

-- Relations pour l'Organisation du Traité de sécurité collective
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion)
VALUES 
  ('russia', 'rel_organisation_traite_securite_collective', 'membre', CURRENT_DATE),
  ('belarus', 'rel_organisation_traite_securite_collective', 'membre', CURRENT_DATE),
  ('kazakhstan', 'rel_organisation_traite_securite_collective', 'membre', CURRENT_DATE),
  ('kyrgyzstan', 'rel_organisation_traite_securite_collective', 'membre', CURRENT_DATE),
  ('tajikistan', 'rel_organisation_traite_securite_collective', 'membre', CURRENT_DATE),
  ('armenia', 'rel_organisation_traite_securite_collective', 'membre', CURRENT_DATE);

-- Vérification finale
SELECT '=== VÉRIFICATION FINALE ===' as info;

SELECT 'Total des organisations:' as info, COUNT(*) as nombre FROM organization;

SELECT 'Total des relations pays:' as info, COUNT(*) as nombre FROM country_organization;

-- Statistiques des nouvelles organisations
SELECT '=== STATISTIQUES DES NOUVELLES ORGANISATIONS ===' as info;
SELECT 
  o.nom as organisation,
  o.type,
  COUNT(co.countryid) as nombre_pays
FROM organization o
LEFT JOIN country_organization co ON o.id = co.organizationid
WHERE o.id LIKE 'rel_%'
GROUP BY o.id, o.nom, o.type
ORDER BY nombre_pays DESC, o.nom;

-- Vérification que les tables redondantes ont bien été supprimées
SELECT '=== VÉRIFICATION SUPPRESSION TABLES ===' as info;
SELECT 'Tables international_relation existantes:' as info, COUNT(*) as nombre 
FROM information_schema.tables 
WHERE table_name LIKE '%international_relation%';

SELECT 'Migration des relations uniques terminée avec succès' as status; 