-- Correction du lot 1 : Régime autoritaire (20 pays)
DELETE FROM country_political_regime WHERE country_id IN (
    'china', 'russia', 'north-korea', 'cuba', 'venezuela', 'iran', 'syria', 'belarus', 'turkmenistan',
    'uzbekistan', 'tajikistan', 'kazakhstan', 'kyrgyzstan', 'azerbaijan', 'armenia', 'georgia',
    'myanmar', 'laos', 'vietnam', 'cambodia'
);

INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'regime-autoritaire', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Correction crédible lot 1'
FROM country c
WHERE c.id IN (
    'china', 'russia', 'north-korea', 'cuba', 'venezuela', 'iran', 'syria', 'belarus', 'turkmenistan',
    'uzbekistan', 'tajikistan', 'kazakhstan', 'kyrgyzstan', 'azerbaijan', 'armenia', 'georgia',
    'myanmar', 'laos', 'vietnam', 'cambodia'
); 