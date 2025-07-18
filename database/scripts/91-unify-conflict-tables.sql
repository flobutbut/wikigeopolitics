-- =====================================================
-- Migration : Unification des tables de conflits
-- Objectif : Unifier conflict et armed_conflict vers armed_conflict
-- Date : 2025-01-XX
-- =====================================================

-- 1. ANALYSE DES DONNÉES EXISTANTES
-- =====================================================

-- Vérifier les conflits dans armed_conflict
SELECT 'ARMED_CONFLICT' as table_name, id, name, status, startyear 
FROM armed_conflict 
ORDER BY id;

-- Vérifier les conflits dans conflict
SELECT 'CONFLICT' as table_name, id, nom, statut, date_debut 
FROM conflict 
ORDER BY id;

-- 2. MIGRATION DES DONNÉES MANQUANTES
-- =====================================================

-- Identifier les conflits présents dans conflict mais pas dans armed_conflict
-- et les ajouter à armed_conflict

-- Exemple de migration (à adapter selon les données réelles)
-- INSERT INTO armed_conflict (id, name, description, status, startyear, endyear, involvedcountries, statut)
-- SELECT 
--     nextval('armed_conflict_id_seq'),
--     c.nom,
--     c.description,
--     c.statut,
--     EXTRACT(YEAR FROM c.date_debut),
--     EXTRACT(YEAR FROM c.date_fin),
--     '[]'::jsonb,
--     c.statut
-- FROM conflict c
-- WHERE NOT EXISTS (
--     SELECT 1 FROM armed_conflict ac 
--     WHERE LOWER(ac.name) = LOWER(c.nom)
-- );

-- 3. MISE À JOUR DES RÉFÉRENCES
-- =====================================================

-- Mettre à jour les références dans conflict_country
-- (si nécessaire, selon la structure actuelle)

-- 4. VÉRIFICATION DE LA MIGRATION
-- =====================================================

-- Compter les conflits dans chaque table
SELECT 'armed_conflict' as table_name, COUNT(*) as total FROM armed_conflict
UNION ALL
SELECT 'conflict' as table_name, COUNT(*) as total FROM conflict;

-- 5. NETTOYAGE (À EXÉCUTER APRÈS VÉRIFICATION)
-- =====================================================

-- Supprimer la table conflict legacy (après vérification)
-- DROP TABLE IF EXISTS conflict CASCADE;

-- Supprimer les tables de relations legacy si elles ne sont plus utilisées
-- DROP TABLE IF EXISTS conflict_resource CASCADE;
-- DROP TABLE IF EXISTS conflict_trade_route CASCADE;

-- 6. COMMENTAIRES FINAUX
-- =====================================================

COMMENT ON TABLE armed_conflict IS 'Table unifiée pour tous les conflits armés - Migration 2025';
COMMENT ON COLUMN armed_conflict.name IS 'Nom du conflit en anglais';
COMMENT ON COLUMN armed_conflict.statut IS 'Statut du conflit en français';
COMMENT ON COLUMN armed_conflict.involvedcountries IS 'Liste des pays impliqués au format JSONB';

-- =====================================================
-- FIN DE LA MIGRATION
-- ===================================================== 