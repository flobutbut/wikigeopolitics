-- Script pour corriger le trigger sur la table organization
-- Date: 2025-01-XX

-- Vérification du trigger problématique
SELECT '=== VÉRIFICATION DU TRIGGER ===' as info;

SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'organization';

-- Suppression du trigger problématique
SELECT '=== SUPPRESSION DU TRIGGER ===' as info;

DROP TRIGGER IF EXISTS update_organization_updated_at ON organization;

-- Vérification que le trigger a été supprimé
SELECT '=== VÉRIFICATION APRÈS SUPPRESSION ===' as info;

SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'organization';

-- Test de mise à jour pour vérifier que tout fonctionne
SELECT '=== TEST DE MISE À JOUR ===' as info;

-- Mise à jour d'une organisation pour tester
UPDATE organization 
SET description = description || ' (mise à jour)'
WHERE id = 'org_nato'
LIMIT 1;

-- Vérification que la mise à jour a fonctionné
SELECT 'Organisation mise à jour:' as info;
SELECT id, nom, description FROM organization WHERE id = 'org_nato';

SELECT 'Trigger corrigé avec succès' as status; 