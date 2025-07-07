-- Mise à jour des régimes politiques uniquement pour les pays sans régime (current_regime_id IS NULL)

-- Démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative'
WHERE current_regime_id IS NULL AND id IN ('france', 'germany', 'canada', 'australia', 'new-zealand', 'switzerland', 'netherlands', 'poland', 'hungary', 'croatia', 'bosnia-herzegovina', 'kosovo', 'serbia', 'ukraine', 'south-korea', 'south-africa', 'fiji', 'papua_new_guinea', 'samoa', 'tonga', 'vanuatu', 'kiribati', 'marshall_islands', 'micronesia', 'nauru', 'palau', 'tuvalu', 'solomon_islands');

-- Monarchie constitutionnelle
UPDATE country SET current_regime_id = 'monarchie-constitutionnelle'
WHERE current_regime_id IS NULL AND id IN ('uk', 'japan', 'thailand', 'australia', 'new-zealand', 'fiji', 'papua_new_guinea', 'samoa', 'tonga', 'vanuatu', 'kiribati', 'marshall_islands', 'micronesia', 'nauru', 'palau', 'tuvalu', 'solomon_islands');

-- République fédérale
UPDATE country SET current_regime_id = 'republique-federale'
WHERE current_regime_id IS NULL AND id IN ('usa', 'germany', 'brazil', 'india', 'australia', 'russia', 'nigeria', 'ethiopia', 'south-africa', 'pakistan');

-- Régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire'
WHERE current_regime_id IS NULL AND id IN ('china', 'russia', 'north-korea', 'iran', 'saudi-arabia');

-- Démocratie directe
UPDATE country SET current_regime_id = 'democratie-directe'
WHERE current_regime_id IS NULL AND id IN ('switzerland');

-- République parlementaire
UPDATE country SET current_regime_id = 'republique-parlementaire'
WHERE current_regime_id IS NULL AND id IN ('germany', 'italy', 'india', 'south-africa');

-- République présidentielle
UPDATE country SET current_regime_id = 'republique-presidentielle'
WHERE current_regime_id IS NULL AND id IN ('usa', 'brazil', 'france', 'russia');

-- Monarchie absolue
UPDATE country SET current_regime_id = 'monarchie-absolue'
WHERE current_regime_id IS NULL AND id IN ('saudi-arabia', 'brunei', 'oman');

-- Régime hybride
UPDATE country SET current_regime_id = 'regime-hybride'
WHERE current_regime_id IS NULL AND id IN ('russia', 'turkey', 'hungary', 'poland');

-- Théocratie
UPDATE country SET current_regime_id = 'theocratie'
WHERE current_regime_id IS NULL AND id IN ('iran', 'vatican'); 