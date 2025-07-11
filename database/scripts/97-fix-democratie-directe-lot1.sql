-- Correction du lot 1 : Démocratie directe (pays appropriés)
DELETE FROM country_political_regime WHERE country_id IN (
    'switzerland', 'liechtenstein', 'san-marino', 'vatican'
);

INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'democratie-directe', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Correction crédible lot 1'
FROM country c
WHERE c.id IN (
    'switzerland', 'liechtenstein', 'san-marino', 'vatican'
); 