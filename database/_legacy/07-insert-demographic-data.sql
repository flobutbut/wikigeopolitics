-- Insertion des données démographiques
-- Script: 07-insert-demographic-data.sql

-- Insertion des tendances démographiques mondiales
INSERT INTO global_demographic_trends (trend_name, description, statistics, regional_differences, implications) VALUES
('Vieillissement', 'Augmentation de la proportion de personnes âgées dans la population mondiale.', 
'{"over65": {"value": 9.3, "unit": "% de la population mondiale", "year": 2020, "projection2050": 16.0}, "medianAge": {"value": 30.9, "unit": "ans", "year": 2020, "projection2050": 36.2}}',
'[{"region": "Europe", "medianAge": 42.5, "elderlyPercentage": 19.1}, {"region": "Afrique", "medianAge": 19.7, "elderlyPercentage": 3.5}]',
'["Pression sur les systèmes de santé et de retraite", "Diminution de la population active", "Changements dans les marchés de consommation", "Migrations de main-d''œuvre"]'),

('Urbanisation', 'Migration continue des populations vers les zones urbaines.',
'{"urbanPopulation": {"value": 56.2, "unit": "% de la population mondiale", "year": 2021, "projection2050": 68.0}}',
'[{"region": "Asie", "urbanizationRate": 50.9}, {"region": "Afrique", "urbanizationRate": 43.8}]',
'["Pression sur les infrastructures urbaines", "Défis environnementaux", "Nouvelles formes d''organisation sociale"]'),

('Baisse de la fécondité', 'Diminution du nombre d''enfants par femme à l''échelle mondiale.',
'{"globalFertilityRate": {"value": 2.4, "unit": "enfants par femme", "year": 2020, "projection2050": 2.2}}',
'[{"region": "Afrique subsaharienne", "rate": 4.7}, {"region": "Europe", "rate": 1.6}, {"region": "Asie de l''Est", "rate": 1.5}]',
'["Déclin démographique dans certains pays", "Changements dans les structures familiales", "Impact sur les systèmes de retraite"]');

-- Insertion des mégapoles
INSERT INTO megacity (name, country_id, population, unit, year) VALUES
('Tokyo', 'japan', 37.4, 'millions', 2021),
('Delhi', 'india', 31.4, 'millions', 2021),
('Shanghai', 'china', 28.2, 'millions', 2021),
('São Paulo', 'brazil', 22.4, 'millions', 2021),
('Mexico', 'mexico', 22.1, 'millions', 2021),
('Cairo', 'egypt', 21.3, 'millions', 2021),
('Mumbai', 'india', 20.4, 'millions', 2021),
('Beijing', 'china', 20.4, 'millions', 2021),
('Dhaka', 'bangladesh', 20.2, 'millions', 2021),
('Osaka', 'japan', 19.2, 'millions', 2021);

-- Insertion des données démographiques par pays (exemples pour les principaux pays)
INSERT INTO demographic_data (country_id, year, population, median_age, fertility_rate, life_expectancy, urbanization_rate, elderly_percentage, gdp_per_capita, hdi_index, literacy_rate, data_source) VALUES
-- Chine
('china', 2021, 1439323776, 38.4, 1.3, 76.9, 61.4, 11.5, 12556.3, 0.768, 96.8, 'UN World Population Prospects'),
('china', 2020, 1439323776, 38.4, 1.3, 76.9, 60.8, 11.2, 10500.4, 0.761, 96.8, 'UN World Population Prospects'),

-- Inde
('india', 2021, 1380004385, 28.4, 2.2, 69.4, 35.4, 6.8, 2256.6, 0.633, 74.4, 'UN World Population Prospects'),
('india', 2020, 1380004385, 28.4, 2.2, 69.4, 34.9, 6.7, 1900.7, 0.645, 74.4, 'UN World Population Prospects'),

-- États-Unis
('usa', 2021, 331002651, 38.5, 1.8, 78.9, 82.7, 16.5, 69287.5, 0.921, 99.0, 'UN World Population Prospects'),
('usa', 2020, 331002651, 38.5, 1.8, 78.9, 82.5, 16.2, 63416.2, 0.926, 99.0, 'UN World Population Prospects'),

-- Indonésie
('indonesia', 2021, 273523615, 29.7, 2.3, 71.7, 56.7, 6.3, 4349.6, 0.705, 95.7, 'UN World Population Prospects'),
('indonesia', 2020, 273523615, 29.7, 2.3, 71.7, 56.4, 6.2, 3876.3, 0.705, 95.7, 'UN World Population Prospects'),

-- Pakistan
('pakistan', 2021, 220892340, 23.6, 3.6, 67.3, 37.1, 4.2, 1193.7, 0.544, 58.0, 'UN World Population Prospects'),
('pakistan', 2020, 220892340, 23.6, 3.6, 67.3, 36.9, 4.1, 1193.7, 0.544, 58.0, 'UN World Population Prospects'),

-- Brésil
('brazil', 2021, 212559417, 33.5, 1.7, 75.9, 87.1, 9.6, 6791.0, 0.754, 93.2, 'UN World Population Prospects'),
('brazil', 2020, 212559417, 33.5, 1.7, 75.9, 86.8, 9.5, 6791.0, 0.765, 93.2, 'UN World Population Prospects'),

-- Nigéria
('nigeria', 2021, 206139589, 18.1, 5.4, 54.7, 51.2, 2.9, 2086.6, 0.539, 62.0, 'UN World Population Prospects'),
('nigeria', 2020, 206139589, 18.1, 5.4, 54.7, 50.9, 2.9, 2086.6, 0.539, 62.0, 'UN World Population Prospects'),

-- Bangladesh
('bangladesh', 2021, 164689383, 27.6, 2.1, 72.6, 38.2, 5.3, 2227.8, 0.661, 74.7, 'UN World Population Prospects'),
('bangladesh', 2020, 164689383, 27.6, 2.1, 72.6, 37.9, 5.2, 2227.8, 0.661, 74.7, 'UN World Population Prospects'),

-- Russie
('russia', 2021, 145912025, 40.3, 1.8, 72.6, 74.8, 15.5, 10126.7, 0.822, 99.7, 'UN World Population Prospects'),
('russia', 2020, 145912025, 40.3, 1.8, 72.6, 74.6, 15.3, 10126.7, 0.824, 99.7, 'UN World Population Prospects'),

-- Mexique
('mexico', 2021, 128932753, 29.3, 2.1, 75.1, 80.4, 7.3, 8346.2, 0.758, 95.2, 'UN World Population Prospects'),
('mexico', 2020, 128932753, 29.3, 2.1, 75.1, 80.2, 7.2, 8346.2, 0.779, 95.2, 'UN World Population Prospects'),

-- Japon
('japan', 2021, 125836021, 48.6, 1.4, 84.6, 91.8, 28.4, 39312.2, 0.919, 99.0, 'UN World Population Prospects'),
('japan', 2020, 125836021, 48.6, 1.4, 84.6, 91.7, 28.2, 39312.2, 0.919, 99.0, 'UN World Population Prospects'),

-- Allemagne
('germany', 2021, 83783942, 45.7, 1.6, 81.3, 77.3, 21.5, 45723.6, 0.942, 99.0, 'UN World Population Prospects'),
('germany', 2020, 83783942, 45.7, 1.6, 81.3, 77.2, 21.4, 45723.6, 0.947, 99.0, 'UN World Population Prospects'),

-- France
('france', 2021, 65273511, 41.4, 1.9, 82.7, 80.7, 20.3, 43658.9, 0.903, 99.0, 'UN World Population Prospects'),
('france', 2020, 65273511, 41.4, 1.9, 82.7, 80.6, 20.2, 43658.9, 0.903, 99.0, 'UN World Population Prospects'),

-- Royaume-Uni
('uk', 2021, 67886011, 40.5, 1.8, 81.2, 83.9, 18.6, 42330.7, 0.929, 99.0, 'UN World Population Prospects'),
('uk', 2020, 67886011, 40.5, 1.8, 81.2, 83.8, 18.5, 42330.7, 0.929, 99.0, 'UN World Population Prospects'),

-- Canada
('canada', 2021, 37742154, 41.1, 1.5, 82.4, 81.4, 17.8, 43241.8, 0.936, 99.0, 'UN World Population Prospects'),
('canada', 2020, 37742154, 41.1, 1.5, 82.4, 81.3, 17.7, 43241.8, 0.936, 99.0, 'UN World Population Prospects'); 