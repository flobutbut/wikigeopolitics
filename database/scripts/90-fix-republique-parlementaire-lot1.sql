-- Correction du lot 1 : République parlementaire (20 pays)
DELETE FROM country_political_regime WHERE country_id IN (
    'germany', 'italy', 'india', 'israel', 'greece', 'portugal', 'spain', 'austria', 'hungary', 'bulgaria',
    'croatia', 'czech-republic', 'estonia', 'latvia', 'lithuania', 'slovakia', 'slovenia', 'finland', 'sweden', 'denmark'
);

INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-parlementaire', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Correction crédible lot 1'
FROM country c
WHERE c.id IN (
    'germany', 'italy', 'india', 'israel', 'greece', 'portugal', 'spain', 'austria', 'hungary', 'bulgaria',
    'croatia', 'czech-republic', 'estonia', 'latvia', 'lithuania', 'slovakia', 'slovenia', 'finland', 'sweden', 'denmark'
); 