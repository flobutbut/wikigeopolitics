-- Insertion des données détaillées des pays
-- Script: 08-insert-detailed-countries.sql

-- Mise à jour des pays existants avec des données détaillées
UPDATE country SET 
    flag = '🇫🇷',
    capital = 'Paris',
    language = 'Français',
    currency = 'Euro (EUR)',
    government_type = 'République unitaire semi-présidentielle',
    head_of_state = 'Emmanuel Macron',
    gdp = 2639.0,
    gdp_unit = 'milliards d''euros',
    population = 68373433,
    area = 551695,
    area_unit = 'km²',
    hdi = 0.903,
    life_expectancy = 82.7,
    literacy_rate = 99.0
WHERE id = 'france';

UPDATE country SET 
    flag = '🇺🇸',
    capital = 'Washington D.C.',
    language = 'Anglais',
    currency = 'Dollar américain (USD)',
    government_type = 'République fédérale présidentielle',
    head_of_state = 'Joe Biden',
    gdp = 23000.0,
    gdp_unit = 'milliards USD',
    population = 331002651,
    area = 9833517,
    area_unit = 'km²',
    hdi = 0.921,
    life_expectancy = 78.9,
    literacy_rate = 99.0
WHERE id = 'usa';

UPDATE country SET 
    flag = '🇨🇳',
    capital = 'Pékin',
    language = 'Mandarin',
    currency = 'Yuan (CNY)',
    government_type = 'République populaire',
    head_of_state = 'Xi Jinping',
    gdp = 17734.0,
    gdp_unit = 'milliards USD',
    population = 1439323776,
    area = 9596961,
    area_unit = 'km²',
    hdi = 0.768,
    life_expectancy = 76.9,
    literacy_rate = 96.8
WHERE id = 'china';

UPDATE country SET 
    flag = '🇷🇺',
    capital = 'Moscou',
    language = 'Russe',
    currency = 'Rouble (RUB)',
    government_type = 'République fédérale semi-présidentielle',
    head_of_state = 'Vladimir Poutine',
    gdp = 1778.0,
    gdp_unit = 'milliards USD',
    population = 145912025,
    area = 17098246,
    area_unit = 'km²',
    hdi = 0.822,
    life_expectancy = 72.6,
    literacy_rate = 99.7
WHERE id = 'russia';

UPDATE country SET 
    flag = '🇩🇪',
    capital = 'Berlin',
    language = 'Allemand',
    currency = 'Euro (EUR)',
    government_type = 'République fédérale parlementaire',
    head_of_state = 'Frank-Walter Steinmeier',
    gdp = 4223.0,
    gdp_unit = 'milliards USD',
    population = 83783942,
    area = 357022,
    area_unit = 'km²',
    hdi = 0.942,
    life_expectancy = 81.3,
    literacy_rate = 99.0
WHERE id = 'germany';

UPDATE country SET 
    flag = '🇯🇵',
    capital = 'Tokyo',
    language = 'Japonais',
    currency = 'Yen (JPY)',
    government_type = 'Monarchie constitutionnelle parlementaire',
    head_of_state = 'Naruhito',
    gdp = 4231.0,
    gdp_unit = 'milliards USD',
    population = 125836021,
    area = 377975,
    area_unit = 'km²',
    hdi = 0.919,
    life_expectancy = 84.6,
    literacy_rate = 99.0
WHERE id = 'japan';

UPDATE country SET 
    flag = '🇬🇧',
    capital = 'Londres',
    language = 'Anglais',
    currency = 'Livre sterling (GBP)',
    government_type = 'Monarchie constitutionnelle parlementaire',
    head_of_state = 'Charles III',
    gdp = 3070.0,
    gdp_unit = 'milliards USD',
    population = 67886011,
    area = 242495,
    area_unit = 'km²',
    hdi = 0.929,
    life_expectancy = 81.2,
    literacy_rate = 99.0
WHERE id = 'uk';

UPDATE country SET 
    flag = '🇨🇦',
    capital = 'Ottawa',
    language = 'Anglais, Français',
    currency = 'Dollar canadien (CAD)',
    government_type = 'Monarchie constitutionnelle parlementaire',
    head_of_state = 'Charles III',
    gdp = 2139.0,
    gdp_unit = 'milliards USD',
    population = 37742154,
    area = 9984670,
    area_unit = 'km²',
    hdi = 0.936,
    life_expectancy = 82.4,
    literacy_rate = 99.0
WHERE id = 'canada';

UPDATE country SET 
    flag = '🇧🇷',
    capital = 'Brasília',
    language = 'Portugais',
    currency = 'Real (BRL)',
    government_type = 'République fédérale présidentielle',
    head_of_state = 'Luiz Inácio Lula da Silva',
    gdp = 1920.0,
    gdp_unit = 'milliards USD',
    population = 212559417,
    area = 8515767,
    area_unit = 'km²',
    hdi = 0.754,
    life_expectancy = 75.9,
    literacy_rate = 93.2
WHERE id = 'brazil';

UPDATE country SET 
    flag = '🇮🇳',
    capital = 'New Delhi',
    language = 'Hindi, Anglais',
    currency = 'Roupie indienne (INR)',
    government_type = 'République fédérale parlementaire',
    head_of_state = 'Droupadi Murmu',
    gdp = 3176.0,
    gdp_unit = 'milliards USD',
    population = 1380004385,
    area = 3287263,
    area_unit = 'km²',
    hdi = 0.633,
    life_expectancy = 69.4,
    literacy_rate = 74.4
WHERE id = 'india';

UPDATE country SET 
    flag = '🇦🇺',
    capital = 'Canberra',
    language = 'Anglais',
    currency = 'Dollar australien (AUD)',
    government_type = 'Monarchie constitutionnelle parlementaire',
    head_of_state = 'Charles III',
    gdp = 1542.0,
    gdp_unit = 'milliards USD',
    population = 25499884,
    area = 7692024,
    area_unit = 'km²',
    hdi = 0.951,
    life_expectancy = 83.2,
    literacy_rate = 99.0
WHERE id = 'australia';

UPDATE country SET 
    flag = '🇰🇷',
    capital = 'Séoul',
    language = 'Coréen',
    currency = 'Won sud-coréen (KRW)',
    government_type = 'République présidentielle',
    head_of_state = 'Yoon Suk-yeol',
    gdp = 1631.0,
    gdp_unit = 'milliards USD',
    population = 51269185,
    area = 100210,
    area_unit = 'km²',
    hdi = 0.925,
    life_expectancy = 83.0,
    literacy_rate = 99.0
WHERE id = 'south-korea';

UPDATE country SET 
    flag = '🇿🇦',
    capital = 'Pretoria',
    language = 'Afrikaans, Anglais, Zoulou',
    currency = 'Rand (ZAR)',
    government_type = 'République parlementaire',
    head_of_state = 'Cyril Ramaphosa',
    gdp = 419.0,
    gdp_unit = 'milliards USD',
    population = 59308690,
    area = 1221037,
    area_unit = 'km²',
    hdi = 0.709,
    life_expectancy = 64.1,
    literacy_rate = 87.0
WHERE id = 'south-africa';

UPDATE country SET 
    flag = '🇸🇦',
    capital = 'Riyad',
    language = 'Arabe',
    currency = 'Riyal saoudien (SAR)',
    government_type = 'Monarchie absolue',
    head_of_state = 'Salmane ben Abdelaziz Al Saoud',
    gdp = 1011.0,
    gdp_unit = 'milliards USD',
    population = 34813871,
    area = 2149690,
    area_unit = 'km²',
    hdi = 0.875,
    life_expectancy = 75.1,
    literacy_rate = 95.3
WHERE id = 'saudi-arabia';

UPDATE country SET 
    flag = '🇹🇭',
    capital = 'Bangkok',
    language = 'Thaï',
    currency = 'Baht (THB)',
    government_type = 'Monarchie constitutionnelle parlementaire',
    head_of_state = 'Maha Vajiralongkorn',
    gdp = 505.0,
    gdp_unit = 'milliards USD',
    population = 69799978,
    area = 513120,
    area_unit = 'km²',
    hdi = 0.800,
    life_expectancy = 77.7,
    literacy_rate = 93.8
WHERE id = 'thailand';

UPDATE country SET 
    flag = '🇮🇷',
    capital = 'Téhéran',
    language = 'Persan',
    currency = 'Rial iranien (IRR)',
    government_type = 'République islamique',
    head_of_state = 'Ali Khamenei',
    gdp = 367.0,
    gdp_unit = 'milliards USD',
    population = 83992949,
    area = 1648195,
    area_unit = 'km²',
    hdi = 0.774,
    life_expectancy = 76.7,
    literacy_rate = 85.5
WHERE id = 'iran';

UPDATE country SET 
    flag = '🇰🇵',
    capital = 'Pyongyang',
    language = 'Coréen',
    currency = 'Won nord-coréen (KPW)',
    government_type = 'République socialiste',
    head_of_state = 'Kim Jong-un',
    gdp = 28.0,
    gdp_unit = 'milliards USD',
    population = 25778816,
    area = 120538,
    area_unit = 'km²',
    hdi = 0.733,
    life_expectancy = 72.3,
    literacy_rate = 100.0
WHERE id = 'north-korea';

-- Insertion de données géographiques détaillées
INSERT INTO geographic_detail (country_id, coastline_length, coastline_unit, terrain_types, climate_types, major_cities, natural_features) VALUES
('france', 3427, 'km', '["Plaines", "Collines", "Montagnes"]', '["Océanique", "Méditerranéen", "Continental"]', '["Paris", "Marseille", "Lyon", "Toulouse", "Nice"]', '["Alpes", "Pyrénées", "Massif central", "Littoral méditerranéen"]'),
('usa', 19924, 'km', '["Plaines", "Montagnes", "Déserts", "Forêts"]', '["Tropical", "Désertique", "Tempéré", "Arctique"]', '["New York", "Los Angeles", "Chicago", "Houston", "Phoenix"]', '["Montagnes Rocheuses", "Grand Canyon", "Everglades", "Alaska"]'),
('china', 14500, 'km', '["Montagnes", "Plateaux", "Plaines", "Déserts"]', '["Tropical", "Tempéré", "Désertique", "Alpin"]', '["Shanghai", "Beijing", "Guangzhou", "Shenzhen", "Tianjin"]', '["Himalaya", "Désert de Gobi", "Fleuve Yangtze", "Grande Muraille"]'),
('russia', 37653, 'km', '["Toundra", "Taïga", "Steppes", "Montagnes"]', '["Arctique", "Subarctique", "Tempéré", "Continental"]', '["Moscou", "Saint-Pétersbourg", "Novossibirsk", "Ekaterinbourg", "Kazan"]', '["Oural", "Sibérie", "Lac Baïkal", "Volga"]'),
('germany', 2389, 'km', '["Plaines", "Collines", "Montagnes"]', '["Tempéré", "Océanique", "Continental"]', '["Berlin", "Hambourg", "Munich", "Cologne", "Francfort"]', '["Alpes bavaroises", "Forêt noire", "Rhin", "Mer du Nord"]'),
('japan', 29751, 'km', '["Montagnes", "Plaines côtières", "Volcans"]', '["Tempéré", "Subtropical", "Tropical"]', '["Tokyo", "Yokohama", "Osaka", "Nagoya", "Sapporo"]', '["Mont Fuji", "Alpes japonaises", "Archipel", "Sources thermales"]'),
('uk', 12429, 'km', '["Collines", "Plaines", "Montagnes"]', '["Océanique", "Tempéré"]', '["Londres", "Birmingham", "Manchester", "Glasgow", "Liverpool"]', '["Highlands écossais", "Lacs du District", "Falaises de Douvres", "Îles britanniques"]'),
('canada', 202080, 'km', '["Toundra", "Taïga", "Plaines", "Montagnes"]', '["Arctique", "Subarctique", "Tempéré", "Continental"]', '["Toronto", "Montréal", "Vancouver", "Calgary", "Edmonton"]', '["Rocheuses canadiennes", "Grands Lacs", "Baie d''Hudson", "Territoires du Nord"]'),
('brazil', 7491, 'km', '["Amazonie", "Plateaux", "Plaines côtières"]', '["Tropical", "Équatorial", "Subtropical"]', '["São Paulo", "Rio de Janeiro", "Brasília", "Salvador", "Fortaleza"]', '["Amazonie", "Pantanal", "Chutes d''Iguazu", "Côte atlantique"]'),
('india', 7516, 'km', '["Himalaya", "Plaines", "Plateaux", "Déserts"]', '["Tropical", "Subtropical", "Alpin", "Désertique"]', '["Mumbai", "Delhi", "Bangalore", "Hyderabad", "Chennai"]', '["Himalaya", "Gange", "Thar", "Côte de Malabar"]');

-- Insertion de données touristiques
INSERT INTO tourism_data (country_id, annual_visitors, visitors_year, major_attractions, economic_impact, economic_impact_unit) VALUES
('france', 89000000, 2019, '["Tour Eiffel", "Louvre", "Château de Versailles", "Côte d''Azur", "Mont Saint-Michel"]', 60.7, 'milliards EUR'),
('usa', 79400000, 2019, '["Statue de la Liberté", "Grand Canyon", "Disney World", "Times Square", "Golden Gate Bridge"]', 214.0, 'milliards USD'),
('china', 145000000, 2019, '["Grande Muraille", "Cité interdite", "Armée de terre cuite", "Shanghai", "Guilin"]', 131.0, 'milliards USD'),
('japan', 31800000, 2019, '["Mont Fuji", "Temples de Kyoto", "Tokyo", "Hiroshima", "Osaka"]', 46.0, 'milliards USD'),
('uk', 40900000, 2019, '["Big Ben", "Tower Bridge", "Stonehenge", "Edinburgh Castle", "Lake District"]', 28.0, 'milliards GBP'),
('canada', 22100000, 2019, '["Chutes du Niagara", "Banff National Park", "CN Tower", "Vancouver", "Montréal"]', 22.0, 'milliards CAD'),
('brazil', 6600000, 2019, '["Christ Rédempteur", "Chutes d''Iguazu", "Copacabana", "Amazonie", "Salvador"]', 6.0, 'milliards USD'),
('australia', 9500000, 2019, '["Sydney Opera House", "Great Barrier Reef", "Uluru", "Melbourne", "Gold Coast"]', 60.8, 'milliards AUD'),
('south-korea', 17500000, 2019, '["Palais de Gyeongbokgung", "Jeju Island", "Busan", "Seoul Tower", "DMZ"]', 15.0, 'milliards USD'),
('thailand', 39800000, 2019, '["Temples de Bangkok", "Phuket", "Chiang Mai", "Koh Samui", "Ayutthaya"]', 60.0, 'milliards THB'); 