-- Script de vérification de la cohérence des types d'organisations
-- Date: 2025-01-XX

-- 1. Analyse générale des types
SELECT '=== ANALYSE GÉNÉRALE DES TYPES ===' as info;

SELECT 
  type,
  COUNT(*) as nombre_organisations,
  array_agg(nom ORDER BY nom) as organisations
FROM organization 
GROUP BY type 
ORDER BY nombre_organisations DESC, type;

-- 2. Vérification des types problématiques
SELECT '=== VÉRIFICATION DES TYPES PROBLÉMATIQUES ===' as info;

-- Organisations avec des types qui ne correspondent pas à leur nature
SELECT 
  id,
  nom,
  type as type_actuel,
  CASE 
    WHEN nom ILIKE '%militaire%' OR nom ILIKE '%OTAN%' OR nom ILIKE '%NATO%' OR nom ILIKE '%sécurité%' THEN 'Alliance militaire'
    WHEN nom ILIKE '%commerce%' OR nom ILIKE '%libre-échange%' OR nom ILIKE '%accord%' THEN 'Organisation commerciale'
    WHEN nom ILIKE '%diplomatique%' OR nom ILIKE '%États américains%' OR nom ILIKE '%Golfe%' THEN 'Organisation diplomatique'
    WHEN nom ILIKE '%régional%' OR nom ILIKE '%région%' THEN 'Organisation régionale'
    WHEN nom ILIKE '%économique%' OR nom ILIKE '%développement%' THEN 'Organisation économique'
    WHEN nom ILIKE '%financier%' OR nom ILIKE '%monétaire%' OR nom ILIKE '%banque%' THEN 'Institution financière'
    WHEN nom ILIKE '%pétrole%' OR nom ILIKE '%OPEP%' THEN 'Cartel pétrolier'
    WHEN nom ILIKE '%gaz%' OR nom ILIKE '%FPEG%' THEN 'Organisation gazière'
    WHEN nom ILIKE '%énergie%' OR nom ILIKE '%AIE%' OR nom ILIKE '%IRENA%' THEN 'Organisation énergétique'
    WHEN nom ILIKE '%spécialisé%' OR nom ILIKE '%aviation%' OR nom ILIKE '%maritime%' OR nom ILIKE '%santé%' THEN 'Organisation spécialisée'
    WHEN nom ILIKE '%normalisation%' OR nom ILIKE '%ISO%' THEN 'Organisation de normalisation'
    WHEN nom ILIKE '%culturel%' OR nom ILIKE '%Francophonie%' OR nom ILIKE '%OIF%' THEN 'Organisation culturelle'
    WHEN nom ILIKE '%Union européenne%' OR nom ILIKE '%UE%' THEN 'Union politique et économique'
    WHEN nom ILIKE '%Mercosur%' THEN 'Union douanière'
    WHEN nom ILIKE '%libre-échange%' AND nom ILIKE '%africain%' THEN 'Zone de libre-échange'
    WHEN nom ILIKE '%Commonwealth%' THEN 'Organisation intergouvernementale'
    WHEN nom ILIKE '%Nations Unies%' OR nom ILIKE '%ONU%' THEN 'Organisation internationale'
    WHEN nom ILIKE '%Groupe des%' OR nom ILIKE '%G7%' OR nom ILIKE '%G20%' THEN 'Forum économique'
    ELSE type
  END as type_suggere
FROM organization
WHERE type != CASE 
    WHEN nom ILIKE '%militaire%' OR nom ILIKE '%OTAN%' OR nom ILIKE '%NATO%' OR nom ILIKE '%sécurité%' THEN 'Alliance militaire'
    WHEN nom ILIKE '%commerce%' OR nom ILIKE '%libre-échange%' OR nom ILIKE '%accord%' THEN 'Organisation commerciale'
    WHEN nom ILIKE '%diplomatique%' OR nom ILIKE '%États américains%' OR nom ILIKE '%Golfe%' THEN 'Organisation diplomatique'
    WHEN nom ILIKE '%régional%' OR nom ILIKE '%région%' THEN 'Organisation régionale'
    WHEN nom ILIKE '%économique%' OR nom ILIKE '%développement%' THEN 'Organisation économique'
    WHEN nom ILIKE '%financier%' OR nom ILIKE '%monétaire%' OR nom ILIKE '%banque%' THEN 'Institution financière'
    WHEN nom ILIKE '%pétrole%' OR nom ILIKE '%OPEP%' THEN 'Cartel pétrolier'
    WHEN nom ILIKE '%gaz%' OR nom ILIKE '%FPEG%' THEN 'Organisation gazière'
    WHEN nom ILIKE '%énergie%' OR nom ILIKE '%AIE%' OR nom ILIKE '%IRENA%' THEN 'Organisation énergétique'
    WHEN nom ILIKE '%spécialisé%' OR nom ILIKE '%aviation%' OR nom ILIKE '%maritime%' OR nom ILIKE '%santé%' THEN 'Organisation spécialisée'
    WHEN nom ILIKE '%normalisation%' OR nom ILIKE '%ISO%' THEN 'Organisation de normalisation'
    WHEN nom ILIKE '%culturel%' OR nom ILIKE '%Francophonie%' OR nom ILIKE '%OIF%' THEN 'Organisation culturelle'
    WHEN nom ILIKE '%Union européenne%' OR nom ILIKE '%UE%' THEN 'Union politique et économique'
    WHEN nom ILIKE '%Mercosur%' THEN 'Union douanière'
    WHEN nom ILIKE '%libre-échange%' AND nom ILIKE '%africain%' THEN 'Zone de libre-échange'
    WHEN nom ILIKE '%Commonwealth%' THEN 'Organisation intergouvernementale'
    WHEN nom ILIKE '%Nations Unies%' OR nom ILIKE '%ONU%' THEN 'Organisation internationale'
    WHEN nom ILIKE '%Groupe des%' OR nom ILIKE '%G7%' OR nom ILIKE '%G20%' THEN 'Forum économique'
    ELSE type
  END
ORDER BY nom;

-- 3. Analyse des types par catégorie
SELECT '=== ANALYSE PAR CATÉGORIE ===' as info;

-- Organisations militaires
SELECT 'Organisations militaires:' as categorie;
SELECT id, nom, type FROM organization 
WHERE nom ILIKE '%militaire%' OR nom ILIKE '%OTAN%' OR nom ILIKE '%NATO%' OR nom ILIKE '%sécurité%'
ORDER BY nom;

-- Organisations commerciales
SELECT 'Organisations commerciales:' as categorie;
SELECT id, nom, type FROM organization 
WHERE nom ILIKE '%commerce%' OR nom ILIKE '%libre-échange%' OR nom ILIKE '%accord%' OR nom ILIKE '%Mercosur%'
ORDER BY nom;

-- Organisations diplomatiques
SELECT 'Organisations diplomatiques:' as categorie;
SELECT id, nom, type FROM organization 
WHERE nom ILIKE '%diplomatique%' OR nom ILIKE '%États américains%' OR nom ILIKE '%Golfe%'
ORDER BY nom;

-- Organisations régionales
SELECT 'Organisations régionales:' as categorie;
SELECT id, nom, type FROM organization 
WHERE nom ILIKE '%régional%' OR nom ILIKE '%région%' OR nom ILIKE '%Union Africaine%' OR nom ILIKE '%ASEAN%'
ORDER BY nom;

-- Organisations économiques
SELECT 'Organisations économiques:' as categorie;
SELECT id, nom, type FROM organization 
WHERE nom ILIKE '%économique%' OR nom ILIKE '%développement%' OR nom ILIKE '%OCDE%'
ORDER BY nom;

-- Institutions financières
SELECT 'Institutions financières:' as categorie;
SELECT id, nom, type FROM organization 
WHERE nom ILIKE '%financier%' OR nom ILIKE '%monétaire%' OR nom ILIKE '%banque%' OR nom ILIKE '%FMI%'
ORDER BY nom;

-- Organisations énergétiques
SELECT 'Organisations énergétiques:' as categorie;
SELECT id, nom, type FROM organization 
WHERE nom ILIKE '%énergie%' OR nom ILIKE '%pétrole%' OR nom ILIKE '%gaz%' OR nom ILIKE '%OPEP%'
ORDER BY nom;

-- 4. Suggestions de corrections
SELECT '=== SUGGESTIONS DE CORRECTIONS ===' as info;

SELECT 
  'Corrections suggérées:' as action,
  COUNT(*) as nombre_organisations
FROM organization
WHERE type != CASE 
    WHEN nom ILIKE '%militaire%' OR nom ILIKE '%OTAN%' OR nom ILIKE '%NATO%' OR nom ILIKE '%sécurité%' THEN 'Alliance militaire'
    WHEN nom ILIKE '%commerce%' OR nom ILIKE '%libre-échange%' OR nom ILIKE '%accord%' THEN 'Organisation commerciale'
    WHEN nom ILIKE '%diplomatique%' OR nom ILIKE '%États américains%' OR nom ILIKE '%Golfe%' THEN 'Organisation diplomatique'
    WHEN nom ILIKE '%régional%' OR nom ILIKE '%région%' THEN 'Organisation régionale'
    WHEN nom ILIKE '%économique%' OR nom ILIKE '%développement%' THEN 'Organisation économique'
    WHEN nom ILIKE '%financier%' OR nom ILIKE '%monétaire%' OR nom ILIKE '%banque%' THEN 'Institution financière'
    WHEN nom ILIKE '%pétrole%' OR nom ILIKE '%OPEP%' THEN 'Cartel pétrolier'
    WHEN nom ILIKE '%gaz%' OR nom ILIKE '%FPEG%' THEN 'Organisation gazière'
    WHEN nom ILIKE '%énergie%' OR nom ILIKE '%AIE%' OR nom ILIKE '%IRENA%' THEN 'Organisation énergétique'
    WHEN nom ILIKE '%spécialisé%' OR nom ILIKE '%aviation%' OR nom ILIKE '%maritime%' OR nom ILIKE '%santé%' THEN 'Organisation spécialisée'
    WHEN nom ILIKE '%normalisation%' OR nom ILIKE '%ISO%' THEN 'Organisation de normalisation'
    WHEN nom ILIKE '%culturel%' OR nom ILIKE '%Francophonie%' OR nom ILIKE '%OIF%' THEN 'Organisation culturelle'
    WHEN nom ILIKE '%Union européenne%' OR nom ILIKE '%UE%' THEN 'Union politique et économique'
    WHEN nom ILIKE '%Mercosur%' THEN 'Union douanière'
    WHEN nom ILIKE '%libre-échange%' AND nom ILIKE '%africain%' THEN 'Zone de libre-échange'
    WHEN nom ILIKE '%Commonwealth%' THEN 'Organisation intergouvernementale'
    WHEN nom ILIKE '%Nations Unies%' OR nom ILIKE '%ONU%' THEN 'Organisation internationale'
    WHEN nom ILIKE '%Groupe des%' OR nom ILIKE '%G7%' OR nom ILIKE '%G20%' THEN 'Forum économique'
    ELSE type
  END;

SELECT 'Vérification de la cohérence des types terminée' as status; 