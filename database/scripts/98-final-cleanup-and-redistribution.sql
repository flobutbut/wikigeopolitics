-- Nettoyage final et redistribution crédible des pays restants
-- Supprimer toutes les relations existantes
DELETE FROM country_political_regime;

-- Redistribuer les pays de manière crédible par régime

-- 1. République présidentielle (pays d'Amérique latine, Afrique, Asie)
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-presidentielle', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Redistribution finale'
FROM country c
WHERE c.id IN (
    'usa', 'brazil', 'argentina', 'mexico', 'colombia', 'venezuela', 'bolivia', 'paraguay', 'uruguay', 'chile',
    'peru', 'ecuador', 'honduras', 'nicaragua', 'panama', 'costa-rica', 'el-salvador', 'guatemala', 'dominican-republic',
    'philippines', 'angola', 'armenia', 'azerbaijan', 'benin', 'botswana', 'cape-verde', 'comoros', 'congo',
    'south-korea', 'cote-divoire', 'djibouti', 'eritrea', 'gabon', 'ghana', 'guinea-bissau', 'kazakhstan',
    'kyrgyzstan', 'madagascar', 'malawi', 'mali', 'mauritania', 'mozambique', 'namibia', 'niger', 'nigeria',
    'uzbekistan', 'pakistan', 'rwanda', 'senegal', 'seychelles', 'sierra-leone', 'singapore', 'somalia',
    'sudan', 'tajikistan', 'chad', 'togo', 'turkmenistan', 'cameroon', 'central-african-republic', 'chad',
    'congo-democratic-republic', 'equatorial-guinea', 'gabon', 'guinea', 'liberia', 'mali', 'mauritania',
    'niger', 'senegal', 'togo', 'burkina-faso', 'burundi', 'cameroon', 'central-african-republic',
    'chad', 'congo-democratic-republic', 'equatorial-guinea', 'gabon', 'guinea', 'liberia', 'mali',
    'mauritania', 'niger', 'senegal', 'togo', 'burkina-faso', 'burundi', 'cameroon', 'central-african-republic'
);

-- 2. République parlementaire (pays européens, démocraties asiatiques)
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-parlementaire', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Redistribution finale'
FROM country c
WHERE c.id IN (
    'germany', 'italy', 'india', 'israel', 'greece', 'portugal', 'spain', 'austria', 'hungary', 'bulgaria',
    'croatia', 'czech-republic', 'estonia', 'latvia', 'lithuania', 'slovakia', 'slovenia', 'finland', 'sweden', 'denmark',
    'ireland', 'iceland', 'malta', 'cyprus', 'montenegro', 'serbia', 'albania', 'north-macedonia', 'bosnia-herzegovina',
    'moldova', 'ukraine', 'georgia', 'armenia', 'azerbaijan', 'bangladesh', 'nepal', 'sri-lanka', 'myanmar',
    'laos', 'cambodia', 'france', 'poland', 'romania', 'bulgaria', 'croatia', 'slovenia', 'slovakia',
    'czech-republic', 'hungary', 'poland', 'romania', 'bulgaria', 'croatia', 'slovenia', 'slovakia'
);

-- 3. Monarchie constitutionnelle (pays avec monarchies)
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'monarchie-constitutionnelle', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Redistribution finale'
FROM country c
WHERE c.id IN (
    'united-kingdom', 'japan', 'spain', 'sweden', 'norway', 'denmark', 'netherlands', 'belgium', 'luxembourg',
    'monaco', 'liechtenstein', 'andorra', 'thailand', 'cambodia', 'malaysia', 'brunei', 'jordan', 'morocco',
    'lesotho', 'eswatini', 'bahrain', 'kuwait', 'oman', 'qatar', 'united-arab-emirates', 'saudi-arabia'
);

-- 4. Régime autoritaire (pays avec régimes autoritaires)
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'regime-autoritaire', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Redistribution finale'
FROM country c
WHERE c.id IN (
    'china', 'russia', 'north-korea', 'cuba', 'venezuela', 'iran', 'syria', 'belarus', 'turkmenistan',
    'uzbekistan', 'tajikistan', 'kazakhstan', 'kyrgyzstan', 'azerbaijan', 'armenia', 'georgia',
    'myanmar', 'laos', 'vietnam', 'cambodia', 'eritrea', 'equatorial-guinea', 'central-african-republic',
    'chad', 'congo-democratic-republic', 'burundi', 'south-sudan', 'somalia', 'libya', 'sudan'
);

-- 5. République fédérale (pays fédéraux)
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-federale', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Redistribution finale'
FROM country c
WHERE c.id IN (
    'usa', 'germany', 'austria', 'switzerland', 'belgium', 'russia', 'india', 'brazil', 'argentina',
    'mexico', 'canada', 'australia', 'nigeria', 'ethiopia', 'south-africa', 'pakistan', 'malaysia',
    'united-arab-emirates', 'iraq', 'bosnia-herzegovina', 'comoros', 'micronesia', 'palau', 'marshall-islands'
);

-- 6. Démocratie directe (pays avec éléments de démocratie directe)
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'democratie-directe', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Redistribution finale'
FROM country c
WHERE c.id IN (
    'switzerland', 'liechtenstein', 'san-marino', 'vatican'
);

-- 7. Théocratie (pays théocratiques)
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'theocratie', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Redistribution finale'
FROM country c
WHERE c.id IN (
    'vatican', 'iran', 'saudi-arabia', 'afghanistan', 'yemen', 'brunei', 'malaysia'
); 