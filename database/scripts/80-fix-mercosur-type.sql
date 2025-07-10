-- Script pour corriger la classification du Mercosur
-- Date: 2025-01-XX

-- Vérification avant correction
SELECT '=== VÉRIFICATION AVANT CORRECTION ===' as info;

SELECT 'Mercosur actuel:' as info;
SELECT id, nom, type, description FROM organization WHERE nom LIKE '%Mercosur%';

-- Comparaison avec les autres unions politiques et économiques
SELECT '=== COMPARAISON AVEC LES AUTRES UNIONS ===' as info;

SELECT 'Unions politiques et économiques existantes:' as info;
SELECT id, nom, type, description FROM organization WHERE type = 'Union politique et économique' ORDER BY nom;

SELECT 'Organisations commerciales:' as info;
SELECT id, nom, type FROM organization WHERE type = 'Organisation commerciale' ORDER BY nom;

-- Correction de la classification du Mercosur
SELECT '=== CORRECTION DE LA CLASSIFICATION ===' as info;

UPDATE organization 
SET type = 'Union politique et économique'
WHERE id = 'org_mercosur';

-- Vérification après correction
SELECT '=== VÉRIFICATION APRÈS CORRECTION ===' as info;

SELECT 'Mercosur après correction:' as info;
SELECT id, nom, type, description FROM organization WHERE nom LIKE '%Mercosur%';

-- Vérification des unions politiques et économiques
SELECT '=== UNIONS POLITIQUES ET ÉCONOMIQUES FINALES ===' as info;

SELECT 
  id,
  nom,
  type,
  description
FROM organization 
WHERE type = 'Union politique et économique' 
ORDER BY nom;

-- Statistiques des types après correction
SELECT '=== STATISTIQUES DES TYPES ===' as info;

SELECT 
  type,
  COUNT(*) as nombre_organisations,
  array_agg(nom ORDER BY nom) as organisations
FROM organization 
GROUP BY type 
ORDER BY nombre_organisations DESC, type;

-- Vérification de la cohérence générale
SELECT '=== VÉRIFICATION DE COHÉRENCE ===' as info;

SELECT 'Organisations avec aspects politiques et économiques:' as info;
SELECT 
  id,
  nom,
  type
FROM organization 
WHERE nom ILIKE '%marché commun%' 
   OR nom ILIKE '%union%' 
   OR nom ILIKE '%communauté%'
   OR nom ILIKE '%Mercosur%'
ORDER BY type, nom;

SELECT 'Correction de la classification du Mercosur terminée avec succès' as status; 