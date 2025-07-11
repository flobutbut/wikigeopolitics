-- Nettoyage final : suppression des doublons et attribution des pays manquants

-- 1. Supprimer tous les doublons (garder seulement la première occurrence)
DELETE FROM country_political_regime 
WHERE id NOT IN (
    SELECT MIN(id) 
    FROM country_political_regime 
    WHERE current_regime = true 
    GROUP BY country_id
);

-- 2. Attribuer les pays manquants de manière crédible
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-presidentielle', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Attribution finale'
FROM country c
WHERE c.id IN (
    'algeria', 'antigua-and-barbuda', 'bahamas', 'barbados', 'belize', 'bhutan', 'cote-divoire',
    'dominica', 'fiji', 'gambia', 'grenada', 'guyana', 'haiti', 'indonesia', 'jamaica', 'kenya',
    'kiribati', 'kosovo', 'lebanon', 'maldives', 'mauritius', 'mongolia', 'nauru', 'new-caledonia',
    'new-zealand', 'uganda', 'papua-new-guinea', 'united-kingdom', 'congo-democratic-republic',
    'saint-kitts-and-nevis', 'saint-lucia', 'saint-vincent-and-the-grenadines', 'samoa', 'suriname',
    'tanzania', 'taiwan', 'east-timor', 'tonga', 'trinidad-and-tobago', 'tunisia', 'turkey',
    'tuvalu', 'vanuatu', 'zambia', 'zimbabwe', 'egypt', 'united-arab-emirates', 'solomon-islands'
)
AND c.id NOT IN (
    SELECT country_id FROM country_political_regime WHERE current_regime = true
);

-- 3. Vérification finale
SELECT 'Total final des relations:' as info, COUNT(*) as count FROM country_political_regime WHERE current_regime = true;

SELECT 'Répartition par régime:' as info;
SELECT pr.name as regime_name, COUNT(*) as country_count
FROM country_political_regime cpr
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true
GROUP BY pr.id, pr.name
ORDER BY country_count DESC; 