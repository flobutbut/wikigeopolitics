-- Correction du lot 1 : Monarchie constitutionnelle (20 pays)
DELETE FROM country_political_regime WHERE country_id IN (
    'united-kingdom', 'japan', 'spain', 'sweden', 'norway', 'denmark', 'netherlands', 'belgium', 'luxembourg',
    'monaco', 'liechtenstein', 'andorra', 'thailand', 'cambodia', 'malaysia', 'brunei', 'jordan', 'morocco',
    'lesotho', 'eswatini'
);

INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'monarchie-constitutionnelle', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Correction crédible lot 1'
FROM country c
WHERE c.id IN (
    'united-kingdom', 'japan', 'spain', 'sweden', 'norway', 'denmark', 'netherlands', 'belgium', 'luxembourg',
    'monaco', 'liechtenstein', 'andorra', 'thailand', 'cambodia', 'malaysia', 'brunei', 'jordan', 'morocco',
    'lesotho', 'eswatini'
); 