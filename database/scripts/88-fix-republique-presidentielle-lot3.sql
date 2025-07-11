-- Correction du lot 3 : République présidentielle (20 pays)
DELETE FROM country_political_regime WHERE country_id IN (
    'mauritania', 'moldova', 'mozambique', 'namibia', 'niger', 'nigeria', 'uzbekistan', 'pakistan', 'paraguay', 'rwanda',
    'senegal', 'seychelles', 'sierra-leone', 'singapore', 'somalia', 'sudan', 'tajikistan', 'chad', 'togo', 'turkmenistan'
);

INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-presidentielle', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Correction crédible lot 3'
FROM country c
WHERE c.id IN (
    'mauritania', 'moldova', 'mozambique', 'namibia', 'niger', 'nigeria', 'uzbekistan', 'pakistan', 'paraguay', 'rwanda',
    'senegal', 'seychelles', 'sierra-leone', 'singapore', 'somalia', 'sudan', 'tajikistan', 'chad', 'togo', 'turkmenistan'
);

-- Vérification
SELECT c.nom as country, pr.name as regime
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true AND cpr.regime_id = 'republique-presidentielle'
ORDER BY c.nom; 