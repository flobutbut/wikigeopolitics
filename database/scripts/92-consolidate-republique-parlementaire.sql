-- Consolidation : République parlementaire
-- 1. Suppression de toutes les relations actuelles pour ce régime
DELETE FROM country_political_regime WHERE regime_id = 'republique-parlementaire';

-- 2. Réinsertion de la liste consolidée (lots 1 et 2)
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-parlementaire', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Consolidation crédible'
FROM country c
WHERE c.id IN (
    -- Lot 1
    'germany', 'italy', 'india', 'israel', 'greece', 'portugal', 'spain', 'austria', 'hungary', 'bulgaria',
    'croatia', 'czech-republic', 'estonia', 'latvia', 'lithuania', 'slovakia', 'slovenia', 'finland', 'sweden', 'denmark',
    -- Lot 2
    'ireland', 'iceland', 'malta', 'cyprus', 'montenegro', 'serbia', 'albania', 'north-macedonia', 'bosnia-herzegovina',
    'moldova', 'ukraine', 'georgia', 'armenia', 'azerbaijan', 'bangladesh', 'nepal', 'sri-lanka', 'myanmar',
    'laos', 'cambodia'
); 