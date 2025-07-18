-- =====================================================
-- Migration finale : Unification conflict -> armed_conflict
-- Objectif : Migrer les données de conflict vers armed_conflict
-- Date : 2025-01-XX
-- =====================================================

-- 1. SAUVEGARDE AVANT MIGRATION
-- =====================================================

-- Créer une sauvegarde de la table conflict
CREATE TABLE conflict_backup AS SELECT * FROM conflict;

-- 2. MIGRATION DES DONNÉES MANQUANTES
-- =====================================================

-- Ajouter les conflits présents dans conflict mais pas dans armed_conflict
INSERT INTO armed_conflict (id, name, description, status, startyear, endyear, involvedcountries, statut, created_at, updated_at)
SELECT 
    nextval('armed_conflict_id_seq'),
    c.nom,
    'Migré depuis la table conflict legacy',
    CASE 
        WHEN c.statut = 'En cours' THEN 'active'
        ELSE 'inactive'
    END,
    EXTRACT(YEAR FROM c.datedebut),
    EXTRACT(YEAR FROM c.datefin),
    '[]'::jsonb,
    c.statut,
    c.created_at,
    CURRENT_TIMESTAMP
FROM conflict c
WHERE NOT EXISTS (
    SELECT 1 FROM armed_conflict ac 
    WHERE LOWER(ac.name) = LOWER(c.nom)
    OR (ac.name LIKE '%' || c.nom || '%' OR c.nom LIKE '%' || ac.name || '%')
);

-- 3. MISE À JOUR DES RÉFÉRENCES DANS CONFLICT_COUNTRY
-- =====================================================

-- Créer une table de mapping des IDs
CREATE TEMP TABLE conflict_id_mapping AS
SELECT 
    c.id as old_id,
    ac.id as new_id,
    c.nom as conflict_name
FROM conflict c
JOIN armed_conflict ac ON (
    LOWER(ac.name) = LOWER(c.nom)
    OR (ac.name LIKE '%' || c.nom || '%' OR c.nom LIKE '%' || ac.name || '%')
);

-- Mettre à jour conflict_country avec les nouveaux IDs
UPDATE conflict_country 
SET conflictid = mapping.new_id::text
FROM conflict_id_mapping mapping
WHERE conflict_country.conflictid = mapping.old_id;

-- 4. VÉRIFICATION DE LA MIGRATION
-- =====================================================

-- Compter les conflits après migration
SELECT 'armed_conflict après migration' as table_name, COUNT(*) as total FROM armed_conflict;

-- Vérifier les relations mises à jour
SELECT 
    'conflict_country après migration' as table_name,
    COUNT(*) as total_relations,
    COUNT(DISTINCT countryid) as unique_countries,
    COUNT(DISTINCT conflictid) as unique_conflicts
FROM conflict_country;

-- 5. NETTOYAGE DES TABLES LEGACY
-- =====================================================

-- Supprimer les tables de relations legacy (après vérification)
DROP TABLE IF EXISTS conflict_resource CASCADE;
DROP TABLE IF EXISTS conflict_trade_route CASCADE;

-- Supprimer la table conflict legacy (après vérification)
DROP TABLE IF EXISTS conflict CASCADE;

-- 6. MISE À JOUR DES COMMENTAIRES
-- =====================================================

COMMENT ON TABLE armed_conflict IS 'Table unifiée pour tous les conflits armés - Migration 2025';
COMMENT ON COLUMN armed_conflict.name IS 'Nom du conflit en anglais';
COMMENT ON COLUMN armed_conflict.statut IS 'Statut du conflit en français';
COMMENT ON COLUMN armed_conflict.involvedcountries IS 'Liste des pays impliqués au format JSONB';
COMMENT ON COLUMN armed_conflict.epicenter IS 'Point géographique central du conflit';

-- 7. VÉRIFICATION FINALE
-- =====================================================

-- Lister tous les conflits unifiés
SELECT 
    id,
    name,
    status,
    statut,
    startyear,
    endyear,
    created_at
FROM armed_conflict 
ORDER BY id;

-- Vérifier qu'il n'y a plus de références orphelines
SELECT DISTINCT conflictid
FROM conflict_country cc
WHERE NOT EXISTS (
    SELECT 1 FROM armed_conflict ac WHERE ac.id::text = cc.conflictid
);

-- =====================================================
-- FIN DE LA MIGRATION
-- ===================================================== 