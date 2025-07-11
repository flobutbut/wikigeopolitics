-- Correction du lot 2 : République présidentielle (20 pays)
DELETE FROM country_political_regime WHERE country_id IN (
    'angola', 'armenia', 'azerbaijan', 'benin', 'botswana', 'cape-verde', 'comoros', 'congo', 'south-korea', 'cote-divoire',
    'djibouti', 'eritrea', 'gabon', 'ghana', 'guinea-bissau', 'kazakhstan', 'kyrgyzstan', 'madagascar', 'malawi', 'mali'
);

INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-presidentielle', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Correction crédible lot 2'
FROM country c
WHERE c.id IN (
    'angola', 'armenia', 'azerbaijan', 'benin', 'botswana', 'cape-verde', 'comoros', 'congo', 'south-korea', 'cote-divoire',
    'djibouti', 'eritrea', 'gabon', 'ghana', 'guinea-bissau', 'kazakhstan', 'kyrgyzstan', 'madagascar', 'malawi', 'mali'
);

-- Vérification
SELECT c.nom as country, pr.name as regime
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true AND cpr.regime_id = 'republique-presidentielle'
ORDER BY c.nom; 