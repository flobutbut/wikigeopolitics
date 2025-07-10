-- Script d'analyse des redondances dans la table organization
-- Date: 2025-01-XX

-- 1. Analyse générale de la table
SELECT '=== ANALYSE GÉNÉRALE ===' as info;
SELECT COUNT(*) as total_organizations FROM organization;

-- 2. Recherche de doublons par nom (exact)
SELECT '=== DOUBLONS PAR NOM EXACT ===' as info;
SELECT nom, COUNT(*) as doublons, array_agg(id) as ids
FROM organization 
GROUP BY nom 
HAVING COUNT(*) > 1 
ORDER BY doublons DESC;

-- 3. Recherche de doublons par nom similaire (avec variations)
SELECT '=== DOUBLONS PAR NOM SIMILAIRE ===' as info;
WITH normalized_names AS (
  SELECT 
    id,
    nom,
    type,
    -- Normalisation pour la comparaison
    LOWER(REPLACE(REPLACE(REPLACE(nom, '(', ''), ')', ''), ' ', '')) as nom_normalise
  FROM organization
)
SELECT 
  n1.nom as nom1,
  n1.id as id1,
  n1.type as type1,
  n2.nom as nom2,
  n2.id as id2,
  n2.type as type2
FROM normalized_names n1
JOIN normalized_names n2 ON n1.id < n2.id
WHERE n1.nom_normalise = n2.nom_normalise
ORDER BY n1.nom;

-- 4. Recherche de doublons par nom contenant les mêmes mots-clés
SELECT '=== DOUBLONS PAR MOTS-CLÉS ===' as info;
WITH keywords AS (
  SELECT 
    id,
    nom,
    type,
    -- Extraction des mots-clés principaux
    CASE 
      WHEN nom ILIKE '%OTAN%' OR nom ILIKE '%NATO%' OR nom ILIKE '%Atlantique Nord%' THEN 'OTAN'
      WHEN nom ILIKE '%ASEAN%' OR nom ILIKE '%Asie du Sud-Est%' THEN 'ASEAN'
      WHEN nom ILIKE '%OPEP%' OR nom ILIKE '%pays exportateurs de pétrole%' THEN 'OPEP'
      WHEN nom ILIKE '%G7%' OR nom ILIKE '%Groupe des Sept%' THEN 'G7'
      WHEN nom ILIKE '%G20%' OR nom ILIKE '%Groupe des Vingt%' THEN 'G20'
      WHEN nom ILIKE '%ONU%' OR nom ILIKE '%Nations Unies%' THEN 'ONU'
      WHEN nom ILIKE '%Commonwealth%' THEN 'Commonwealth'
      WHEN nom ILIKE '%Francophonie%' OR nom ILIKE '%OIF%' THEN 'Francophonie'
      WHEN nom ILIKE '%Banque mondiale%' OR nom ILIKE '%World Bank%' THEN 'Banque mondiale'
      WHEN nom ILIKE '%FMI%' OR nom ILIKE '%Fonds monétaire%' OR nom ILIKE '%IMF%' THEN 'FMI'
      WHEN nom ILIKE '%OMC%' OR nom ILIKE '%Organisation mondiale du commerce%' OR nom ILIKE '%WTO%' THEN 'OMC'
      WHEN nom ILIKE '%ISO%' OR nom ILIKE '%normalisation%' THEN 'ISO'
      WHEN nom ILIKE '%FPEG%' OR nom ILIKE '%exportateurs de gaz%' THEN 'FPEG'
      ELSE 'AUTRE'
    END as keyword
  FROM organization
)
SELECT 
  keyword,
  COUNT(*) as nombre,
  array_agg(nom) as noms,
  array_agg(id) as ids
FROM keywords 
WHERE keyword != 'AUTRE'
GROUP BY keyword 
HAVING COUNT(*) > 1
ORDER BY nombre DESC;

-- 5. Analyse des types d'organisations
SELECT '=== ANALYSE DES TYPES ===' as info;
SELECT 
  type,
  COUNT(*) as nombre,
  array_agg(nom) as exemples
FROM organization 
GROUP BY type 
ORDER BY nombre DESC;

-- 6. Recherche d'organisations avec des noms très similaires
SELECT '=== NOMS TRÈS SIMILAIRES ===' as info;
WITH similarity AS (
  SELECT 
    o1.id as id1,
    o1.nom as nom1,
    o1.type as type1,
    o2.id as id2,
    o2.nom as nom2,
    o2.type as type2,
    -- Calcul de similarité simple
    CASE 
      WHEN LENGTH(o1.nom) > LENGTH(o2.nom) 
      THEN LENGTH(o2.nom)::float / LENGTH(o1.nom)
      ELSE LENGTH(o1.nom)::float / LENGTH(o2.nom)
    END as similarity_ratio
  FROM organization o1
  CROSS JOIN organization o2
  WHERE o1.id < o2.id
)
SELECT 
  nom1,
  id1,
  type1,
  nom2,
  id2,
  type2,
  ROUND(similarity_ratio * 100, 1) as similarite_pourcentage
FROM similarity
WHERE similarity_ratio > 0.7
ORDER BY similarity_ratio DESC;

-- 7. Résumé des problèmes identifiés
SELECT '=== RÉSUMÉ DES PROBLÈMES ===' as info;
SELECT 
  'Organisations avec doublons potentiels:' as probleme,
  COUNT(DISTINCT nom) as nombre
FROM (
  SELECT nom FROM organization GROUP BY nom HAVING COUNT(*) > 1
) as doublons;

SELECT 
  'Types d''organisations différents pour la même entité:' as probleme,
  COUNT(*) as nombre
FROM (
  SELECT 
    CASE 
      WHEN nom ILIKE '%OTAN%' OR nom ILIKE '%NATO%' OR nom ILIKE '%Atlantique Nord%' THEN 'OTAN'
      WHEN nom ILIKE '%ASEAN%' OR nom ILIKE '%Asie du Sud-Est%' THEN 'ASEAN'
      WHEN nom ILIKE '%OPEP%' OR nom ILIKE '%pays exportateurs de pétrole%' THEN 'OPEP'
      ELSE NULL
    END as entite
  FROM organization
  WHERE nom ILIKE '%OTAN%' OR nom ILIKE '%NATO%' OR nom ILIKE '%Atlantique Nord%'
     OR nom ILIKE '%ASEAN%' OR nom ILIKE '%Asie du Sud-Est%'
     OR nom ILIKE '%OPEP%' OR nom ILIKE '%pays exportateurs de pétrole%'
) as entites
WHERE entite IS NOT NULL
GROUP BY entite
HAVING COUNT(*) > 1; 