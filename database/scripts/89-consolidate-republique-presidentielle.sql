-- Consolidation : République présidentielle
-- 1. Suppression de toutes les relations actuelles pour ce régime
DELETE FROM country_political_regime WHERE regime_id = 'republique-presidentielle';

-- 2. Réinsertion de la liste consolidée (lots 1 à 3)
INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
SELECT c.id, 'republique-presidentielle', true, EXTRACT(YEAR FROM CURRENT_DATE), 'Consolidation crédible'
FROM country c
WHERE c.id IN (
    -- Lot 1
    'usa', 'brazil', 'argentina', 'mexico', 'colombia', 'venezuela', 'bolivia', 'paraguay', 'uruguay', 'chile',
    'peru', 'ecuador', 'honduras', 'nicaragua', 'panama', 'costa-rica', 'el-salvador', 'guatemala', 'dominican-republic', 'philippines',
    -- Lot 2
    'angola', 'armenia', 'azerbaijan', 'benin', 'botswana', 'cape-verde', 'comoros', 'congo', 'south-korea', 'cote-divoire',
    'djibouti', 'eritrea', 'gabon', 'ghana', 'guinea-bissau', 'kazakhstan', 'kyrgyzstan', 'madagascar', 'malawi', 'mali',
    -- Lot 3
    'mauritania', 'moldova', 'mozambique', 'namibia', 'niger', 'nigeria', 'uzbekistan', 'pakistan', 'paraguay', 'rwanda',
    'senegal', 'seychelles', 'sierra-leone', 'singapore', 'somalia', 'sudan', 'tajikistan', 'chad', 'togo', 'turkmenistan'
);

-- 3. Vérification
SELECT c.nom as country, pr.name as regime
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true AND cpr.regime_id = 'republique-presidentielle'
ORDER BY c.nom; 