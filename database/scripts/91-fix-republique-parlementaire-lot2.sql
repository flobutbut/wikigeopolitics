-- Correction du lot 2 : République parlementaire (20 pays)
DELETE FROM country_political_regime WHERE country_id IN (
    'ireland', 'iceland', 'malta', 'cyprus', 'montenegro', 'serbia', 'albania', 'north-macedonia', 'bosnia-herzegovina',
    'moldova', 'ukraine', 'georgia', 'armenia', 'azerbaijan', 'bangladesh', 'nepal', 'sri-lanka', 'myanmar',
    'laos', 'cambodia'
);

INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-parlementaire', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Correction crédible lot 2'
FROM country c
WHERE c.id IN (
    'ireland', 'iceland', 'malta', 'cyprus', 'montenegro', 'serbia', 'albania', 'north-macedonia', 'bosnia-herzegovina',
    'moldova', 'ukraine', 'georgia', 'armenia', 'azerbaijan', 'bangladesh', 'nepal', 'sri-lanka', 'myanmar',
    'laos', 'cambodia'
); 