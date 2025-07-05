-- Insertion des données agricoles
-- Script: 05-insert-agricultural-data.sql

-- Insertion des produits agricoles
INSERT INTO agricultural_product (id, name, category, description, global_production_value, global_production_unit, global_production_year) VALUES
('ble', 'Blé', 'Céréales', 'Céréale la plus cultivée au monde, base de l''alimentation de nombreuses populations.', 776.0, 'millions de tonnes', 2021),
('riz', 'Riz', 'Céréales', 'Aliment de base pour plus de la moitié de la population mondiale.', 520.0, 'millions de tonnes', 2021),
('mais', 'Maïs', 'Céréales', 'Céréale la plus produite au monde, utilisée pour l''alimentation humaine, animale et les biocarburants.', 1162.0, 'millions de tonnes', 2021),
('soja', 'Soja', 'Légumineuses', 'Légumineuse riche en protéines, utilisée pour l''alimentation animale et humaine.', 372.0, 'millions de tonnes', 2021),
('coton', 'Coton', 'Fibres', 'Fibre naturelle la plus utilisée dans l''industrie textile mondiale.', 25.0, 'millions de tonnes', 2021),
('cafe', 'Café', 'Stimulants', 'Boisson stimulante la plus consommée au monde après l''eau.', 10.5, 'millions de tonnes', 2021),
('the', 'Thé', 'Stimulants', 'Deuxième boisson la plus consommée au monde.', 6.5, 'millions de tonnes', 2021),
('sucre', 'Sucre', 'Édulcorants', 'Produit sucrant extrait de la canne à sucre et de la betterave.', 180.0, 'millions de tonnes', 2021);

-- Insertion des productions par pays pour le blé
INSERT INTO country_agricultural_production (country_id, product_id, production_value, production_unit, production_year, percentage_of_global) VALUES
('china', 'ble', 136.9, 'millions de tonnes', 2021, 17.6),
('india', 'ble', 109.5, 'millions de tonnes', 2021, 14.1),
('russia', 'ble', 85.9, 'millions de tonnes', 2021, 11.1),
('usa', 'ble', 44.8, 'millions de tonnes', 2021, 5.8),
('france', 'ble', 35.0, 'millions de tonnes', 2021, 4.5),
('uk', 'ble', 15.6, 'millions de tonnes', 2021, 2.0),
('germany', 'ble', 22.2, 'millions de tonnes', 2021, 2.9),
('canada', 'ble', 32.3, 'millions de tonnes', 2021, 4.2);

-- Insertion des productions par pays pour le riz
INSERT INTO country_agricultural_production (country_id, product_id, production_value, production_unit, production_year, percentage_of_global) VALUES
('china', 'riz', 212.8, 'millions de tonnes', 2021, 40.9),
('india', 'riz', 178.3, 'millions de tonnes', 2021, 34.3),
('indonesia', 'riz', 54.4, 'millions de tonnes', 2021, 10.5),
('bangladesh', 'riz', 54.7, 'millions de tonnes', 2021, 10.5),
('vietnam', 'riz', 43.4, 'millions de tonnes', 2021, 8.3),
('thailand', 'riz', 21.3, 'millions de tonnes', 2021, 4.1);

-- Insertion des productions par pays pour le maïs
INSERT INTO country_agricultural_production (country_id, product_id, production_value, production_unit, production_year, percentage_of_global) VALUES
('usa', 'mais', 383.9, 'millions de tonnes', 2021, 33.0),
('china', 'mais', 272.6, 'millions de tonnes', 2021, 23.5),
('brazil', 'mais', 87.0, 'millions de tonnes', 2021, 7.5),
('argentina', 'mais', 51.0, 'millions de tonnes', 2021, 4.4),
('ukraine', 'mais', 42.1, 'millions de tonnes', 2021, 3.6),
('india', 'mais', 31.0, 'millions de tonnes', 2021, 2.7);

-- Insertion des exportations agricoles
INSERT INTO agricultural_export (country_id, product_id, export_value, export_unit, export_year, percentage_of_global) VALUES
('russia', 'ble', 33.0, 'millions de tonnes', 2021, 20.0),
('usa', 'ble', 26.1, 'millions de tonnes', 2021, 15.8),
('canada', 'ble', 23.0, 'millions de tonnes', 2021, 13.9),
('france', 'ble', 18.0, 'millions de tonnes', 2021, 10.9),
('ukraine', 'ble', 16.5, 'millions de tonnes', 2021, 10.0),
('india', 'riz', 21.5, 'millions de tonnes', 2021, 40.6),
('thailand', 'riz', 6.1, 'millions de tonnes', 2021, 11.5),
('vietnam', 'riz', 6.3, 'millions de tonnes', 2021, 11.9),
('usa', 'mais', 69.0, 'millions de tonnes', 2021, 35.0),
('argentina', 'mais', 39.0, 'millions de tonnes', 2021, 19.8),
('brazil', 'mais', 20.0, 'millions de tonnes', 2021, 10.2);

-- Insertion des importations agricoles
INSERT INTO agricultural_import (country_id, product_id, import_value, import_unit, import_year) VALUES
('egypt', 'ble', 12.5, 'millions de tonnes', 2021),
('indonesia', 'ble', 10.3, 'millions de tonnes', 2021),
('algeria', 'ble', 8.5, 'millions de tonnes', 2021),
('morocco', 'ble', 7.2, 'millions de tonnes', 2021),
('china', 'riz', 4.5, 'millions de tonnes', 2021),
('iran', 'riz', 1.8, 'millions de tonnes', 2021),
('japan', 'riz', 7.8, 'millions de tonnes', 2021),
('mexico', 'mais', 17.0, 'millions de tonnes', 2021),
('japan', 'mais', 15.0, 'millions de tonnes', 2021),
('south-korea', 'mais', 10.5, 'millions de tonnes', 2021); 