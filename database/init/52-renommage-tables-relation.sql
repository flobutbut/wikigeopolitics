-- =====================================================
-- Renommage des tables de relation selon le schéma cible
-- =====================================================

-- Renommer les tables de relation pour correspondre au schéma cible
ALTER TABLE country_conflict RENAME TO conflict_country;
ALTER TABLE country_resource RENAME TO resource_country;
ALTER TABLE country_industry RENAME TO industry_country;

-- Vérifier que les tables ont été renommées
SELECT table_name 
FROM information_schema.tables 
WHERE table_name IN ('conflict_country', 'resource_country', 'industry_country')
ORDER BY table_name; 