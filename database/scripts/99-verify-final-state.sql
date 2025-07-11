-- Vérification finale de la redistribution crédible des régimes politiques

-- 1. Compter le nombre total de relations
SELECT 'Total des relations pays-régimes:' as info, COUNT(*) as count FROM country_political_regime;

-- 2. Compter par régime
SELECT pr.name as regime_name, COUNT(*) as country_count
FROM country_political_regime cpr
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true
GROUP BY pr.id, pr.name
ORDER BY country_count DESC;

-- 3. Vérifier quelques exemples crédibles par régime
SELECT 'Exemples République présidentielle:' as info;
SELECT c.nom, pr.name 
FROM country_political_regime cpr 
JOIN country c ON cpr.country_id = c.id 
JOIN political_regime pr ON cpr.regime_id = pr.id 
WHERE pr.id = 'republique-presidentielle' AND cpr.current_regime = true 
ORDER BY c.nom LIMIT 10;

SELECT 'Exemples République parlementaire:' as info;
SELECT c.nom, pr.name 
FROM country_political_regime cpr 
JOIN country c ON cpr.country_id = c.id 
JOIN political_regime pr ON cpr.regime_id = pr.id 
WHERE pr.id = 'republique-parlementaire' AND cpr.current_regime = true 
ORDER BY c.nom LIMIT 10;

SELECT 'Exemples Monarchie constitutionnelle:' as info;
SELECT c.nom, pr.name 
FROM country_political_regime cpr 
JOIN country c ON cpr.country_id = c.id 
JOIN political_regime pr ON cpr.regime_id = pr.id 
WHERE pr.id = 'monarchie-constitutionnelle' AND cpr.current_regime = true 
ORDER BY c.nom LIMIT 10;

SELECT 'Exemples Régime autoritaire:' as info;
SELECT c.nom, pr.name 
FROM country_political_regime cpr 
JOIN country c ON cpr.country_id = c.id 
JOIN political_regime pr ON cpr.regime_id = pr.id 
WHERE pr.id = 'regime-autoritaire' AND cpr.current_regime = true 
ORDER BY c.nom LIMIT 10;

-- 4. Vérifier qu'il n'y a pas de doublons
SELECT 'Vérification des doublons:' as info;
SELECT country_id, COUNT(*) as count
FROM country_political_regime
WHERE current_regime = true
GROUP BY country_id
HAVING COUNT(*) > 1;

-- 5. Vérifier les pays sans régime
SELECT 'Pays sans régime politique:' as info;
SELECT c.nom
FROM country c
LEFT JOIN country_political_regime cpr ON c.id = cpr.country_id AND cpr.current_regime = true
WHERE cpr.country_id IS NULL
ORDER BY c.nom; 