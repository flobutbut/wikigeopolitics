-- Correction du lot 1 : République présidentielle (20 pays majeurs)
-- Suppression des relations actuelles pour ces pays
DELETE FROM country_political_regime WHERE country_id IN (
    'usa', 'brazil', 'argentina', 'mexico', 'colombia', 'venezuela', 'bolivia', 'paraguay', 'uruguay', 'chile',
    'peru', 'ecuador', 'honduras', 'nicaragua', 'panama', 'costa-rica', 'el-salvador', 'guatemala', 'dominican-republic', 'philippines'
);

-- Insertion des relations crédibles
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-presidentielle', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Correction crédible lot 1'
FROM country c
WHERE c.id IN (
    'usa', 'brazil', 'argentina', 'mexico', 'colombia', 'venezuela', 'bolivia', 'paraguay', 'uruguay', 'chile',
    'peru', 'ecuador', 'honduras', 'nicaragua', 'panama', 'costa-rica', 'el-salvador', 'guatemala', 'dominican-republic', 'philippines'
);

-- Vérification
SELECT c.nom as country, pr.name as regime
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true AND cpr.regime_id = 'republique-presidentielle'
ORDER BY c.nom; 