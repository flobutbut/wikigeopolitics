-- Vérification finale de l'état du système
-- Après migration de political_regime et génération des relations

-- 1. Vérifier la structure de political_regime
SELECT 'Structure political_regime:' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'political_regime' 
ORDER BY ordinal_position;

-- 2. Compter les régimes politiques
SELECT 'Nombre de régimes politiques:' as info, COUNT(*) as count FROM political_regime;

-- 3. Vérifier la structure de country_political_regime
SELECT 'Structure country_political_regime:' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'country_political_regime' 
ORDER BY ordinal_position;

-- 4. Compter les relations pays-régimes
SELECT 'Relations pays-régimes:' as info, COUNT(*) as total_relations FROM country_political_regime;

-- 5. Distribution des pays par régime politique
SELECT 'Distribution des pays par régime:' as info;
SELECT 
    pr.name as regime_name,
    COUNT(cpr.country_id) as country_count,
    ROUND(COUNT(cpr.country_id) * 100.0 / (SELECT COUNT(*) FROM country_political_regime), 1) as percentage
FROM political_regime pr
LEFT JOIN country_political_regime cpr ON pr.id = cpr.regime_id
WHERE cpr.current_regime = true
GROUP BY pr.id, pr.name
ORDER BY country_count DESC;

-- 6. Vérifier quelques exemples de relations
SELECT 'Exemples de relations (10 premiers):' as info;
SELECT 
    c.nom as country_name,
    pr.name as regime_name,
    cpr.start_year,
    cpr.current_regime
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true
ORDER BY c.nom
LIMIT 10;

-- 7. Vérifier qu'il n'y a pas de doublons
SELECT 'Vérification des doublons:' as info;
SELECT 
    country_id,
    COUNT(*) as relation_count
FROM country_political_regime
WHERE current_regime = true
GROUP BY country_id
HAVING COUNT(*) > 1
ORDER BY relation_count DESC;

-- 8. Vérifier les pays sans régime politique
SELECT 'Pays sans régime politique:' as info;
SELECT COUNT(*) as countries_without_regime
FROM country c
LEFT JOIN country_political_regime cpr ON c.id = cpr.country_id AND cpr.current_regime = true
WHERE cpr.country_id IS NULL; 