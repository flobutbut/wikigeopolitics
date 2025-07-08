-- =====================================================
-- Migration de la table trade_route vers le schéma cible
-- =====================================================

-- Renommer les colonnes pour harmoniser avec le schéma cible
ALTER TABLE trade_route RENAME COLUMN geo_json_ref TO geoJsonRef;

-- Vérifier que la migration s'est bien passée
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'trade_route' 
ORDER BY ordinal_position; 