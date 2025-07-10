-- Script pour nettoyer les anciennes tables de relations redondantes
-- Date: 2025-01-XX

-- Vérification des tables à supprimer
SELECT '=== VÉRIFICATION DES TABLES À SUPPRIMER ===' as info;

-- Contenu des anciennes tables
SELECT 'Table relation - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM relation;
SELECT 'Table country_relation - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM country_relation;
SELECT 'Table relation_country - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM relation_country;
SELECT 'Table organization_relation - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM organization_relation;

-- Vérification que les nouvelles tables sont bien en place
SELECT '=== VÉRIFICATION DES NOUVELLES TABLES ===' as info;

SELECT 'Table international_relation - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM international_relation;
SELECT 'Table international_relation_country - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM international_relation_country;

-- Affichage des dépendances des anciennes tables
SELECT '=== DÉPENDANCES DES ANCIENNES TABLES ===' as info;

SELECT 'Contraintes de clés étrangères vers relation:' as info;
SELECT tc.table_name, kcu.column_name, ccu.table_name AS foreign_table_name, ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name 
JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name 
WHERE constraint_type = 'FOREIGN KEY' AND ccu.table_name = 'relation';

-- Nettoyage des anciennes tables
SELECT '=== SUPPRESSION DES ANCIENNES TABLES ===' as info;

-- Suppression des tables de liaison (dans l'ordre pour éviter les erreurs de contraintes)
DROP TABLE IF EXISTS organization_relation CASCADE;
DROP TABLE IF EXISTS country_relation CASCADE;
DROP TABLE IF EXISTS relation_country CASCADE;

-- Suppression de la table principale relation
DROP TABLE IF EXISTS relation CASCADE;

-- Vérification que les nouvelles tables sont toujours présentes
SELECT '=== VÉRIFICATION FINALE ===' as info;

SELECT 'Table international_relation - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM international_relation;
SELECT 'Table international_relation_country - Nombre d''enregistrements:' as table_name, COUNT(*) as count FROM international_relation_country;

-- Liste des tables restantes liées aux relations
SELECT 'Tables restantes liées aux relations:' as info;
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE '%relation%'
ORDER BY table_name;

-- Test de requête sur la nouvelle structure
SELECT '=== TEST DE REQUÊTE SUR LA NOUVELLE STRUCTURE ===' as info;

SELECT 'Relations par type:' as info;
SELECT type, sous_type, COUNT(*) as nombre 
FROM international_relation 
GROUP BY type, sous_type 
ORDER BY type, sous_type;

SELECT 'Exemples de relations avec pays:' as info;
SELECT ir.nom, ir.type, ir.sous_type, c.nom as pays, irc.role, irc.statut
FROM international_relation ir
JOIN international_relation_country irc ON ir.id = irc.relationId
JOIN country c ON irc.countryId = c.id
ORDER BY ir.type, ir.nom, c.nom
LIMIT 10;

SELECT 'Nettoyage des anciennes tables terminé avec succès' as status; 