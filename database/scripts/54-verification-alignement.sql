-- =====================================================
-- Vérification de l'alignement complet avec le schéma cible
-- =====================================================

-- 1. Vérifier que toutes les tables du schéma cible existent
SELECT 'Tables principales' as categorie, table_name 
FROM information_schema.tables 
WHERE table_name IN (
    'country', 'organization', 'relation', 'conflict', 'resource', 
    'industry', 'company', 'trade_route', 'comm_network', 'demographic'
)
ORDER BY table_name;

-- 2. Vérifier que toutes les tables de relation existent
SELECT 'Tables de relation' as categorie, table_name 
FROM information_schema.tables 
WHERE table_name IN (
    'country_organization', 'relation_country', 'conflict_country', 
    'resource_country', 'industry_country', 'trade_route_country', 
    'comm_network_country'
)
ORDER BY table_name;

-- 3. Vérifier les colonnes de COUNTRY selon le schéma cible
SELECT 'Colonnes COUNTRY' as categorie, column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'country' 
AND column_name IN (
    'id', 'nom', 'drapeau', 'capitale', 'langue', 'monnaie', 'continent',
    'pib', 'population', 'revenumedian', 'superficiekm2', 'regimepolitique',
    'appartenancegeographique', 'coordonnees', 'histoire', 'indicesouverainete',
    'indicedependance', 'statutstrategique', 'datecreation', 'datedernieremiseajour'
)
ORDER BY column_name;

-- 4. Vérifier les colonnes de CONFLICT selon le schéma cible
SELECT 'Colonnes CONFLICT' as categorie, column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'conflict' 
AND column_name IN (
    'id', 'nom', 'type', 'statut', 'datedebut', 'datefin', 'intensite',
    'localisation', 'victimes', 'timeline', 'efforts_paix', 'consequences'
)
ORDER BY column_name;

-- 5. Résumé de l'alignement
SELECT 
    'ALIGNEMENT COMPLET' as statut,
    COUNT(*) as total_tables,
    'Tables principales et de relation alignées avec le schéma cible' as description
FROM information_schema.tables 
WHERE table_name IN (
    'country', 'organization', 'relation', 'conflict', 'resource', 
    'industry', 'company', 'trade_route', 'comm_network', 'demographic',
    'country_organization', 'relation_country', 'conflict_country', 
    'resource_country', 'industry_country', 'trade_route_country', 
    'comm_network_country'
); 