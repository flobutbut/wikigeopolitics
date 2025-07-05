-- Insertion des données de transport et marchandises
-- Script: 12-insert-transport-data.sql

-- Insertion des données de transport par pays
INSERT INTO transport_data (country_id, transport_type, volume_value, volume_unit, volume_year, routes, infrastructure_data) VALUES
-- Transport maritime
('china', 'maritime', 2500.0, 'millions de TEU', 2021, '["Shanghai", "Ningbo", "Shenzhen", "Guangzhou"]', '{"ports": ["Shanghai", "Ningbo", "Shenzhen"], "fleet": "Plus de 6000 navires"}'),
('singapore', 'maritime', 3750.0, 'millions de TEU', 2021, '["Port de Singapour", "Jurong Island"]', '{"ports": ["Port de Singapour"], "hub": "Hub maritime majeur"}'),
('usa', 'maritime', 2200.0, 'millions de TEU', 2021, '["Los Angeles", "Long Beach", "New York", "Savannah"]', '{"ports": ["Los Angeles", "Long Beach", "New York"], "fleet": "Plus de 2000 navires"}'),
('netherlands', 'maritime', 1500.0, 'millions de TEU', 2021, '["Rotterdam", "Amsterdam"]', '{"ports": ["Rotterdam"], "hub": "Hub européen"}'),
('uae', 'maritime', 1400.0, 'millions de TEU', 2021, '["Dubai", "Abu Dhabi"]', '{"ports": ["Jebel Ali", "Port Rashid"], "hub": "Hub du Moyen-Orient"}'),

-- Transport aérien
('usa', 'aerien', 850.0, 'millions de passagers', 2021, '["Atlanta", "Los Angeles", "Chicago", "Dallas"]', '{"airports": ["Hartsfield-Jackson", "LAX", "O''Hare"], "fleet": "Plus de 5000 avions"}'),
('china', 'aerien', 660.0, 'millions de passagers', 2021, '["Beijing", "Shanghai", "Guangzhou", "Chengdu"]', '{"airports": ["Capital", "Pudong", "Baiyun"], "fleet": "Plus de 4000 avions"}'),
('uk', 'aerien', 150.0, 'millions de passagers', 2021, '["London", "Manchester", "Edinburgh"]', '{"airports": ["Heathrow", "Gatwick", "Stansted"], "fleet": "Plus de 500 avions"}'),
('germany', 'aerien', 120.0, 'millions de passagers', 2021, '["Frankfurt", "Munich", "Berlin"]', '{"airports": ["Frankfurt", "Munich"], "fleet": "Plus de 400 avions"}'),
('france', 'aerien', 100.0, 'millions de passagers', 2021, '["Paris", "Lyon", "Nice"]', '{"airports": ["Charles de Gaulle", "Orly"], "fleet": "Plus de 300 avions"}'),

-- Transport ferroviaire
('china', 'ferroviaire', 3500.0, 'milliards de tonnes-km', 2021, '["Beijing-Shanghai", "Beijing-Guangzhou", "Lanzhou-Xinjiang"]', '{"high_speed": "38000 km", "total_network": "146000 km"}'),
('usa', 'ferroviaire', 2500.0, 'milliards de tonnes-km', 2021, '["Chicago", "Los Angeles", "New York"]', '{"freight": "Principal usage", "passenger": "Amtrak"}'),
('russia', 'ferroviaire', 2300.0, 'milliards de tonnes-km', 2021, '["Transsibérien", "Moscou-Saint-Pétersbourg"]', '{"network": "87000 km", "gauge": "1520 mm"}'),
('india', 'ferroviaire', 1200.0, 'milliards de tonnes-km', 2021, '["Delhi-Mumbai", "Kolkata-Delhi", "Chennai-Bangalore"]', '{"network": "68000 km", "passengers": "8 milliards/an"}'),
('germany', 'ferroviaire', 120.0, 'milliards de tonnes-km', 2021, '["Berlin-Munich", "Hambourg-Frankfurt"]', '{"network": "43000 km", "high_speed": "3300 km"}'),

-- Transport routier
('usa', 'routier', 4500.0, 'milliards de tonnes-km', 2021, '["Interstate Highway System", "US Routes"]', '{"highways": "78000 km", "trucks": "Plus de 2 millions"}'),
('china', 'routier', 3500.0, 'milliards de tonnes-km', 2021, '["National Highways", "Expressways"]', '{"highways": "161000 km", "trucks": "Plus de 3 millions"}'),
('germany', 'routier', 400.0, 'milliards de tonnes-km', 2021, '["Autobahn", "Bundesstraßen"]', '{"autobahn": "13000 km", "trucks": "Plus de 500000"}'),
('france', 'routier', 350.0, 'milliards de tonnes-km', 2021, '["Autoroutes", "Routes nationales"]', '{"autoroutes": "12000 km", "trucks": "Plus de 400000"}'),
('japan', 'routier', 300.0, 'milliards de tonnes-km', 2021, '["Expressways", "National highways"]', '{"expressways": "10000 km", "trucks": "Plus de 300000"}'),

-- Transport par pipeline
('russia', 'pipeline', 800.0, 'milliards de m³', 2021, '["Gazprom pipelines", "Transneft"]', '{"gas_pipelines": "170000 km", "oil_pipelines": "47000 km"}'),
('usa', 'pipeline', 700.0, 'milliards de m³', 2021, '["Interstate pipelines", "Gulf Coast"]', '{"gas_pipelines": "500000 km", "oil_pipelines": "100000 km"}'),
('canada', 'pipeline', 200.0, 'milliards de m³', 2021, '["TransCanada", "Enbridge"]', '{"gas_pipelines": "84000 km", "oil_pipelines": "23000 km"}'),
('china', 'pipeline', 150.0, 'milliards de m³', 2021, '["West-East Gas Pipeline", "Central Asia-China"]', '{"gas_pipelines": "85000 km", "oil_pipelines": "25000 km"}'),
('iran', 'pipeline', 100.0, 'milliards de m³', 2021, '["Iran Gas Trunkline", "IGAT"]', '{"gas_pipelines": "40000 km", "oil_pipelines": "8000 km"}'),

-- Transport fluvial
('china', 'fluvial', 300.0, 'milliards de tonnes-km', 2021, '["Yangtze", "Pearl River", "Yellow River"]', '{"navigable": "125000 km", "ports": "Plus de 200"}'),
('usa', 'fluvial', 200.0, 'milliards de tonnes-km', 2021, '["Mississippi", "Ohio", "Missouri"]', '{"navigable": "41000 km", "locks": "Plus de 200"}'),
('russia', 'fluvial', 150.0, 'milliards de tonnes-km', 2021, '["Volga", "Yenisei", "Lena"]', '{"navigable": "102000 km", "ports": "Plus de 100"}'),
('germany', 'fluvial', 50.0, 'milliards de tonnes-km', 2021, '["Rhin", "Danube", "Elbe"]', '{"navigable": "7500 km", "ports": "Plus de 50"}'),
('france', 'fluvial', 40.0, 'milliards de tonnes-km', 2021, '["Seine", "Rhône", "Loire"]', '{"navigable": "8500 km", "ports": "Plus de 40"}'),

-- Transport multimodal
('usa', 'multimodal', 5000.0, 'milliards de tonnes-km', 2021, '["Intermodal terminals", "Logistics hubs"]', '{"terminals": "Plus de 100", "hubs": "Principaux ports"}'),
('china', 'multimodal', 4000.0, 'milliards de tonnes-km', 2021, '["Belt and Road", "Logistics centers"]', '{"terminals": "Plus de 200", "hubs": "Ports majeurs"}'),
('germany', 'multimodal', 600.0, 'milliards de tonnes-km', 2021, '["Logistics hubs", "Intermodal centers"]', '{"terminals": "Plus de 50", "hubs": "Ports européens"}'),
('france', 'multimodal', 500.0, 'milliards de tonnes-km', 2021, '["Logistics centers", "Port terminals"]', '{"terminals": "Plus de 40", "hubs": "Ports français"}'),
('netherlands', 'multimodal', 400.0, 'milliards de tonnes-km', 2021, '["Rotterdam hub", "Amsterdam"]', '{"terminals": "Plus de 30", "hub": "Rotterdam"}'); 