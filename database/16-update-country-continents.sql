-- Mise à jour des continents pour les pays manquants

-- Afrique
UPDATE country SET continent = 'Afrique' WHERE id IN ('algeria', 'botswana', 'burkina-faso', 'central-african-republic', 'chad', 'congo', 'democratic-republic-of-congo', 'eritrea', 'ethiopia', 'libya', 'mali', 'morocco', 'namibia', 'niger', 'nigeria', 'rwanda', 'somalia', 'south-sudan', 'uganda');

-- Amérique du Sud
UPDATE country SET continent = 'Amérique du Sud' WHERE id IN ('argentina', 'bolivia', 'chile', 'peru');

-- Amérique du Nord
UPDATE country SET continent = 'Amérique du Nord' WHERE id IN ('cuba', 'mexico', 'new-caledonia');

-- Asie
UPDATE country SET continent = 'Asie' WHERE id IN ('afghanistan', 'bangladesh', 'indonesia', 'iraq', 'kazakhstan', 'pakistan', 'philippines', 'qatar', 'singapore', 'sri-lanka', 'taiwan', 'turkey', 'uae', 'uzbekistan', 'vietnam');

-- Europe
UPDATE country SET continent = 'Europe' WHERE id IN ('bosnia-herzegovina', 'croatia', 'hungary', 'kosovo', 'netherlands', 'poland', 'serbia', 'switzerland', 'ukraine'); 