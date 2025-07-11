-- Correction du lot 1 : République fédérale (pays appropriés)
DELETE FROM country_political_regime WHERE country_id IN (
    'usa', 'germany', 'austria', 'switzerland', 'belgium', 'russia', 'india', 'brazil', 'argentina',
    'mexico', 'canada', 'australia', 'nigeria', 'ethiopia', 'south-africa', 'pakistan', 'malaysia',
    'united-arab-emirates', 'iraq', 'bosnia-herzegovina'
);

INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-federale', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Correction crédible lot 1'
FROM country c
WHERE c.id IN (
    'usa', 'germany', 'austria', 'switzerland', 'belgium', 'russia', 'india', 'brazil', 'argentina',
    'mexico', 'canada', 'australia', 'nigeria', 'ethiopia', 'south-africa', 'pakistan', 'malaysia',
    'united-arab-emirates', 'iraq', 'bosnia-herzegovina'
); 