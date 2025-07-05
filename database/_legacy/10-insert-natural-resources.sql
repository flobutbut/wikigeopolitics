-- Insertion des données de ressources naturelles
-- Script: 10-insert-natural-resources.sql

-- Insertion des ressources naturelles
INSERT INTO natural_resource (id, name, category, description, global_reserves_value, global_reserves_unit, global_reserves_year) VALUES
('petrole', 'Pétrole', 'Énergie fossile', 'Ressource énergétique fossile principale, utilisée pour le transport et l''industrie.', 1734.0, 'milliards de barils', 2021),
('gaz-naturel', 'Gaz naturel', 'Énergie fossile', 'Combustible fossile gazeux, utilisé pour le chauffage et la production d''électricité.', 7213.0, 'milliards de mètres cubes', 2021),
('charbon', 'Charbon', 'Énergie fossile', 'Combustible fossile solide, principalement utilisé pour la production d''électricité.', 1074.0, 'milliards de tonnes', 2021),
('uranium', 'Uranium', 'Énergie nucléaire', 'Élément radioactif utilisé comme combustible dans les centrales nucléaires.', 6.1, 'millions de tonnes', 2021),
('lithium', 'Lithium', 'Métal stratégique', 'Métal léger utilisé dans les batteries lithium-ion pour véhicules électriques.', 22.0, 'millions de tonnes', 2021),
('cobalt', 'Cobalt', 'Métal stratégique', 'Métal utilisé dans les batteries et les alliages à haute température.', 7.1, 'millions de tonnes', 2021),
('nickel', 'Nickel', 'Métal stratégique', 'Métal utilisé dans les aciers inoxydables et les batteries.', 94.0, 'millions de tonnes', 2021),
('cuivre', 'Cuivre', 'Métal industriel', 'Métal conducteur utilisé dans l''électricité et l''électronique.', 880.0, 'millions de tonnes', 2021),
('aluminium', 'Aluminium', 'Métal industriel', 'Métal léger utilisé dans l''industrie aéronautique et l''emballage.', 30000.0, 'millions de tonnes', 2021),
('fer', 'Fer', 'Métal industriel', 'Métal principal utilisé dans la production d''acier.', 180000.0, 'millions de tonnes', 2021),
('or', 'Or', 'Métal précieux', 'Métal précieux utilisé comme réserve de valeur et en joaillerie.', 54000.0, 'tonnes', 2021),
('argent', 'Argent', 'Métal précieux', 'Métal précieux utilisé en joaillerie et en électronique.', 530000.0, 'tonnes', 2021),
('platine', 'Platine', 'Métal précieux', 'Métal précieux utilisé en joaillerie et dans les catalyseurs automobiles.', 6900.0, 'tonnes', 2021),
('diamants', 'Diamants', 'Pierre précieuse', 'Pierre précieuse utilisée en joaillerie et dans l''industrie.', 1.2, 'milliards de carats', 2021),
('eau-douce', 'Eau douce', 'Ressource vitale', 'Ressource essentielle pour la vie et l''agriculture.', 3500000.0, 'kilomètres cubes', 2021);

-- Insertion des ressources par pays
INSERT INTO country_natural_resource (country_id, resource_id, abundance_level, locations, production_value, production_unit, production_year) VALUES
-- Pétrole
('saudi-arabia', 'petrole', 'Très élevé', '["Ghawar", "Safaniya", "Khurais"]', 10.8, 'millions de barils/jour', 2021),
('russia', 'petrole', 'Très élevé', '["Sibérie occidentale", "Caspienne", "Arctique"]', 10.5, 'millions de barils/jour', 2021),
('usa', 'petrole', 'Élevé', '["Texas", "Alaska", "Golfe du Mexique"]', 11.2, 'millions de barils/jour', 2021),
('iraq', 'petrole', 'Élevé', '["Kirkuk", "Rumaila", "West Qurna"]', 4.1, 'millions de barils/jour', 2021),
('iran', 'petrole', 'Élevé', '["Ahvaz", "Gachsaran", "Marun"]', 2.4, 'millions de barils/jour', 2021),
('canada', 'petrole', 'Élevé', '["Alberta", "Sables bitumineux"]', 4.6, 'millions de barils/jour', 2021),
('china', 'petrole', 'Modéré', '["Daqing", "Shengli", "Mer de Chine"]', 4.0, 'millions de barils/jour', 2021),
('brazil', 'petrole', 'Modéré', '["Pré-sel", "Campos", "Santos"]', 2.9, 'millions de barils/jour', 2021),

-- Gaz naturel
('russia', 'gaz-naturel', 'Très élevé', '["Sibérie", "Yamal", "Arctique"]', 701.7, 'milliards de m³', 2021),
('usa', 'gaz-naturel', 'Très élevé', '["Texas", "Pennsylvanie", "Louisiane"]', 934.2, 'milliards de m³', 2021),
('iran', 'gaz-naturel', 'Très élevé', '["South Pars", "North Pars"]', 256.7, 'milliards de m³', 2021),
('qatar', 'gaz-naturel', 'Très élevé', '["North Field"]', 171.3, 'milliards de m³', 2021),
('china', 'gaz-naturel', 'Modéré', '["Sichuan", "Xinjiang", "Mer de Chine"]', 209.2, 'milliards de m³', 2021),
('canada', 'gaz-naturel', 'Modéré', '["Alberta", "Colombie-Britannique"]', 172.3, 'milliards de m³', 2021),

-- Charbon
('china', 'charbon', 'Très élevé', '["Shanxi", "Inner Mongolia", "Xinjiang"]', 4113.0, 'millions de tonnes', 2021),
('india', 'charbon', 'Élevé', '["Jharkhand", "Chhattisgarh", "Odisha"]', 756.0, 'millions de tonnes', 2021),
('usa', 'charbon', 'Élevé', '["Wyoming", "West Virginia", "Kentucky"]', 535.0, 'millions de tonnes', 2021),
('australia', 'charbon', 'Élevé', '["Queensland", "New South Wales"]', 478.0, 'millions de tonnes', 2021),
('indonesia', 'charbon', 'Élevé', '["Kalimantan", "Sumatra"]', 562.0, 'millions de tonnes', 2021),
('russia', 'charbon', 'Modéré', '["Kuzbass", "Krasnoyarsk"]', 433.0, 'millions de tonnes', 2021),

-- Uranium
('kazakhstan', 'uranium', 'Très élevé', '["Inkai", "Tortkuduk", "Mynkuduk"]', 21819.0, 'tonnes', 2021),
('australia', 'uranium', 'Élevé', '["Olympic Dam", "Ranger", "Beverley"]', 6192.0, 'tonnes', 2021),
('namibia', 'uranium', 'Élevé', '["Rössing", "Langer Heinrich"]', 5753.0, 'tonnes', 2021),
('canada', 'uranium', 'Élevé', '["McArthur River", "Cigar Lake"]', 4933.0, 'tonnes', 2021),
('uzbekistan', 'uranium', 'Modéré', '["Navoi"]', 3500.0, 'tonnes', 2021),

-- Lithium
('australia', 'lithium', 'Très élevé', '["Greenbushes", "Pilgangoora", "Wodgina"]', 55000.0, 'tonnes', 2021),
('chile', 'lithium', 'Très élevé', '["Salar de Atacama", "Salar de Maricunga"]', 26000.0, 'tonnes', 2021),
('china', 'lithium', 'Élevé', '["Qinghai", "Tibet", "Sichuan"]', 14000.0, 'tonnes', 2021),
('argentina', 'lithium', 'Élevé', '["Salar del Hombre Muerto", "Salar de Olaroz"]', 6200.0, 'tonnes', 2021),
('bolivia', 'lithium', 'Élevé', '["Salar de Uyuni"]', 540.0, 'tonnes', 2021),

-- Cobalt
('drc', 'cobalt', 'Très élevé', '["Katanga", "Lualaba"]', 120000.0, 'tonnes', 2021),
('russia', 'cobalt', 'Modéré', '["Norilsk"]', 7600.0, 'tonnes', 2021),
('australia', 'cobalt', 'Modéré', '["Murrin Murrin", "Ravensthorpe"]', 5600.0, 'tonnes', 2021),
('philippines', 'cobalt', 'Modéré', '["Nickel mines"]', 4500.0, 'tonnes', 2021),
('cuba', 'cobalt', 'Modéré', '["Moa"]', 3500.0, 'tonnes', 2021),

-- Nickel
('indonesia', 'nickel', 'Très élevé', '["Sulawesi", "Maluku"]', 1000000.0, 'tonnes', 2021),
('philippines', 'nickel', 'Élevé', '["Palawan", "Surigao"]', 370000.0, 'tonnes', 2021),
('russia', 'nickel', 'Élevé', '["Norilsk", "Kola Peninsula"]', 250000.0, 'tonnes', 2021),
('new-caledonia', 'nickel', 'Élevé', '["Goro", "Koniambo"]', 200000.0, 'tonnes', 2021),
('australia', 'nickel', 'Modéré', '["Ravensthorpe", "Murrin Murrin"]', 170000.0, 'tonnes', 2021),

-- Cuivre
('chile', 'cuivre', 'Très élevé', '["Escondida", "Collahuasi", "El Teniente"]', 5600000.0, 'tonnes', 2021),
('peru', 'cuivre', 'Élevé', '["Antamina", "Cerro Verde", "Las Bambas"]', 2300000.0, 'tonnes', 2021),
('china', 'cuivre', 'Modéré', '["Tibet", "Xinjiang", "Inner Mongolia"]', 1800000.0, 'tonnes', 2021),
('usa', 'cuivre', 'Modéré', '["Arizona", "Utah", "New Mexico"]', 1200000.0, 'tonnes', 2021),
('congo', 'cuivre', 'Modéré', '["Katanga"]', 1800000.0, 'tonnes', 2021),

-- Or
('china', 'or', 'Très élevé', '["Shandong", "Henan", "Yunnan"]', 368.3, 'tonnes', 2021),
('australia', 'or', 'Élevé', '["Western Australia", "Victoria"]', 327.8, 'tonnes', 2021),
('russia', 'or', 'Élevé', '["Siberia", "Far East"]', 305.1, 'tonnes', 2021),
('usa', 'or', 'Élevé', '["Nevada", "Alaska", "California"]', 186.2, 'tonnes', 2021),
('canada', 'or', 'Modéré', '["Ontario", "Quebec", "British Columbia"]', 170.6, 'tonnes', 2021),

-- Diamants
('russia', 'diamants', 'Très élevé', '["Yakutia", "Arkhangelsk"]', 39.0, 'millions de carats', 2021),
('botswana', 'diamants', 'Très élevé', '["Orapa", "Jwaneng", "Letlhakane"]', 23.0, 'millions de carats', 2021),
('drc', 'diamants', 'Élevé', '["Kasai", "Kasaï-Oriental"]', 12.0, 'millions de carats', 2021),
('australia', 'diamants', 'Modéré', '["Argyle", "Ellendale"]', 12.0, 'millions de carats', 2021),
('canada', 'diamants', 'Modéré', '["Northwest Territories", "Ontario"]', 10.0, 'millions de carats', 2021); 