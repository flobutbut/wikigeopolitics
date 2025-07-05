-- Exécution de tous les scripts d'extension de la base de données
-- Script: 13-run-all-extensions.sql

-- Ce script exécute tous les scripts d'extension dans l'ordre
-- Il doit être exécuté après les scripts de base (01 et 02)

-- Extension du schéma
\i 03-extend-schema.sql

-- Insertion des données politiques
\i 04-insert-political-regimes.sql

-- Ajout des pays manquants
\i 14-add-missing-countries-simple.sql

-- Insertion des données agricoles
\i 05-insert-agricultural-data.sql

-- Insertion des données technologiques
\i 06-insert-technology-data.sql

-- Insertion des données démographiques
\i 07-insert-demographic-data.sql

-- Insertion des données détaillées des pays
\i 08-insert-detailed-countries.sql

-- Insertion des données de conflits
\i 09-insert-conflicts-data.sql

-- Insertion des données de ressources naturelles
\i 10-insert-natural-resources.sql

-- Insertion des données industrielles
\i 11-insert-industrial-data.sql

-- Insertion des données de transport
\i 12-insert-transport-data.sql

-- Vérification des données insérées
SELECT 'Extension de la base de données terminée avec succès' as status;

-- Statistiques des données insérées
SELECT 
    'Pays avec données détaillées' as category,
    COUNT(*) as count
FROM country 
WHERE flag IS NOT NULL;

SELECT 
    'Régimes politiques' as category,
    COUNT(*) as count
FROM political_regime;

SELECT 
    'Produits agricoles' as category,
    COUNT(*) as count
FROM agricultural_product;

SELECT 
    'Secteurs technologiques' as category,
    COUNT(*) as count
FROM technology_sector;

SELECT 
    'Conflits armés' as category,
    COUNT(*) as count
FROM armed_conflict;

SELECT 
    'Ressources naturelles' as category,
    COUNT(*) as count
FROM natural_resource;

SELECT 
    'Industries' as category,
    COUNT(*) as count
FROM industry; 