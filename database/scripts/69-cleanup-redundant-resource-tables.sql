-- Script pour nettoyer les tables redondantes liées aux ressources
-- Date: 2025-01-XX

-- Vérification du contenu des tables avant suppression
SELECT '=== VÉRIFICATION DU CONTENU DES TABLES ===' as info;

-- Contenu de natural_resource
SELECT 'Table natural_resource - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM natural_resource;

-- Contenu de country_natural_resource
SELECT 'Table country_natural_resource - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM country_natural_resource;

-- Contenu de resource (table moderne)
SELECT 'Table resource - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM resource;

-- Contenu de resource_country (table moderne)
SELECT 'Table resource_country - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM resource_country;

-- Affichage de quelques exemples de natural_resource
SELECT 'Exemples de natural_resource:' as info;
SELECT id, name, category FROM natural_resource LIMIT 5;

-- Affichage de quelques exemples de country_natural_resource
SELECT 'Exemples de country_natural_resource:' as info;
SELECT country_id, resource_id, abundance_level FROM country_natural_resource LIMIT 5;

-- Nettoyage des tables redondantes
SELECT '=== SUPPRESSION DES TABLES REDONDANTES ===' as info;

-- Suppression de la table de liaison country_natural_resource
DROP TABLE IF EXISTS country_natural_resource CASCADE;

-- Suppression de la table principale natural_resource
DROP TABLE IF EXISTS natural_resource CASCADE;

-- Vérification que les tables modernes sont toujours présentes
SELECT '=== VÉRIFICATION DES TABLES MODERNES ===' as info;

-- Vérification de resource
SELECT 'Table resource - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM resource;

-- Vérification de resource_country
SELECT 'Table resource_country - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM resource_country;

-- Liste des tables restantes liées aux ressources
SELECT 'Tables restantes liées aux ressources:' as info;
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE '%resource%'
ORDER BY table_name;

SELECT 'Nettoyage terminé avec succès' as status; 