-- Script pour corriger les incohérences dans les types d'organisations
-- Date: 2025-01-XX

-- Vérification avant correction
SELECT '=== VÉRIFICATION AVANT CORRECTION ===' as info;

SELECT 'Organisations avec types incorrects:' as info;
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
    WHEN nom ILIKE '%libre-échange%' AND nom ILIKE '%africain%' THEN 'Organisation commerciale'
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
    WHEN nom ILIKE '%libre-échange%' AND nom ILIKE '%africain%' THEN 'Organisation commerciale'
    WHEN nom ILIKE '%Commonwealth%' THEN 'Organisation intergouvernementale'
    WHEN nom ILIKE '%Nations Unies%' OR nom ILIKE '%ONU%' THEN 'Organisation internationale'
    WHEN nom ILIKE '%Groupe des%' OR nom ILIKE '%G7%' OR nom ILIKE '%G20%' THEN 'Forum économique'
    ELSE type
  END
ORDER BY nom;

-- Correction des types d'organisations
SELECT '=== CORRECTION DES TYPES ===' as info;

-- 1. Correction du Conseil de coopération du Golfe (CCG)
UPDATE organization 
SET type = 'Organisation diplomatique'
WHERE id = 'org_gulf_cooperation';

-- 2. Correction des communautés économiques africaines
UPDATE organization 
SET type = 'Organisation économique'
WHERE id IN ('org_sadc', 'org_ecowas');

-- 3. Correction de la CAE (plus politique qu'économique)
UPDATE organization 
SET type = 'Union politique et économique'
WHERE id = 'org_eac';

-- 4. Correction de l'APEC
UPDATE organization 
SET type = 'Organisation économique'
WHERE id = 'apec';

-- 5. Correction de la ZLECAf
UPDATE organization 
SET type = 'Organisation commerciale'
WHERE id = 'org_afcfta';

-- Vérification après correction
SELECT '=== VÉRIFICATION APRÈS CORRECTION ===' as info;

SELECT 'Types d''organisations après correction:' as info;
SELECT 
  type,
  COUNT(*) as nombre_organisations,
  array_agg(nom ORDER BY nom) as organisations
FROM organization 
GROUP BY type 
ORDER BY nombre_organisations DESC, type;

-- Vérification qu'il n'y a plus d'incohérences
SELECT '=== VÉRIFICATION FINALE ===' as info;

SELECT 'Organisations avec types incorrects restantes:' as info;
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
    WHEN nom ILIKE '%libre-échange%' AND nom ILIKE '%africain%' THEN 'Organisation commerciale'
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
    WHEN nom ILIKE '%libre-échange%' AND nom ILIKE '%africain%' THEN 'Organisation commerciale'
    WHEN nom ILIKE '%Commonwealth%' THEN 'Organisation intergouvernementale'
    WHEN nom ILIKE '%Nations Unies%' OR nom ILIKE '%ONU%' THEN 'Organisation internationale'
    WHEN nom ILIKE '%Groupe des%' OR nom ILIKE '%G7%' OR nom ILIKE '%G20%' THEN 'Forum économique'
    ELSE type
  END
ORDER BY nom;

-- Statistiques finales
SELECT '=== STATISTIQUES FINALES ===' as info;
SELECT 
  'Total des organisations:' as info,
  COUNT(*) as nombre
FROM organization;

SELECT 
  'Nombre de types différents:' as info,
  COUNT(DISTINCT type) as nombre
FROM organization;

SELECT 'Correction des types d''organisations terminée avec succès' as status; 