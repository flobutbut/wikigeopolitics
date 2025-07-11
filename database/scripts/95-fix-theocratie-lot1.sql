-- Correction du lot 1 : Théocratie (pays appropriés)
DELETE FROM country_political_regime WHERE country_id IN (
    'vatican', 'iran', 'saudi-arabia', 'afghanistan', 'yemen', 'brunei', 'malaysia'
);

INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'theocratie', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Correction crédible lot 1'
FROM country c
WHERE c.id IN (
    'vatican', 'iran', 'saudi-arabia', 'afghanistan', 'yemen', 'brunei', 'malaysia'
); 