-- Résumé final de la migration des régimes politiques
-- État après correction et redistribution crédible

-- 1. Structure de la table political_regime
SELECT 'Structure de political_regime:' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'political_regime' 
ORDER BY ordinal_position;

-- 2. Régimes politiques disponibles
SELECT 'Régimes politiques disponibles:' as info;
SELECT id, name, description FROM political_regime ORDER BY name;

-- 3. Répartition finale des pays par régime
SELECT 'Répartition finale des pays par régime:' as info;
SELECT 
    pr.name as regime_name,
    COUNT(*) as country_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM country_political_regime WHERE current_regime = true), 1) as percentage
FROM country_political_regime cpr
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true
GROUP BY pr.id, pr.name
ORDER BY country_count DESC;

-- 4. Exemples de pays par régime (top 5)
SELECT 'Exemples par régime (top 5):' as info;
SELECT 
    pr.name as regime,
    STRING_AGG(c.nom, ', ' ORDER BY c.nom) as examples
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true
GROUP BY pr.id, pr.name
ORDER BY COUNT(*) DESC;

-- 5. Vérification de cohérence
SELECT 'Vérification de cohérence:' as info;
SELECT 
    'Total des pays avec régime' as check_type,
    COUNT(*) as count
FROM country_political_regime 
WHERE current_regime = true
UNION ALL
SELECT 
    'Pays sans régime' as check_type,
    COUNT(*) as count
FROM country c
LEFT JOIN country_political_regime cpr ON c.id = cpr.country_id AND cpr.current_regime = true
WHERE cpr.country_id IS NULL; 