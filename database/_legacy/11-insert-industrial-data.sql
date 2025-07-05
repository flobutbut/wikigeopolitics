-- Insertion des données industrielles
-- Script: 11-insert-industrial-data.sql

-- Insertion des industries
INSERT INTO industry (id, name, sector, description, global_market_value, global_market_unit, global_market_year) VALUES
('automobile', 'Automobile', 'Transport', 'Industrie de fabrication de véhicules automobiles.', 2800.0, 'milliards USD', 2021),
('aerospatiale', 'Aérospatiale', 'Transport', 'Industrie de fabrication d''avions et de satellites.', 838.0, 'milliards USD', 2021),
('pharmaceutique', 'Pharmaceutique', 'Santé', 'Industrie de développement et fabrication de médicaments.', 1400.0, 'milliards USD', 2021),
('electronique', 'Électronique', 'Technologie', 'Industrie de fabrication de composants électroniques.', 3500.0, 'milliards USD', 2021),
('textile', 'Textile', 'Consommation', 'Industrie de fabrication de vêtements et tissus.', 1000.0, 'milliards USD', 2021),
('alimentaire', 'Alimentaire', 'Consommation', 'Industrie de transformation et conditionnement alimentaire.', 8000.0, 'milliards USD', 2021),
('chimique', 'Chimique', 'Industrie', 'Industrie de production de produits chimiques.', 4000.0, 'milliards USD', 2021),
('acier', 'Acier', 'Métallurgie', 'Industrie de production d''acier et d''alliages.', 1000.0, 'milliards USD', 2021),
('ciment', 'Ciment', 'Construction', 'Industrie de production de ciment et matériaux de construction.', 300.0, 'milliards USD', 2021),
('papier', 'Papier', 'Consommation', 'Industrie de production de papier et carton.', 350.0, 'milliards USD', 2021),
('armement', 'Armement', 'Défense', 'Industrie de fabrication d''armes et systèmes militaires.', 2000.0, 'milliards USD', 2021),
('navale', 'Navale', 'Transport', 'Industrie de construction navale.', 150.0, 'milliards USD', 2021),
('ferroviaire', 'Ferroviaire', 'Transport', 'Industrie de fabrication de matériel ferroviaire.', 200.0, 'milliards USD', 2021),
('machines-outils', 'Machines-outils', 'Industrie', 'Industrie de fabrication de machines industrielles.', 800.0, 'milliards USD', 2021),
('robotique', 'Robotique', 'Technologie', 'Industrie de fabrication de robots industriels.', 50.0, 'milliards USD', 2021);

-- Insertion des industries par pays
INSERT INTO country_industry (country_id, industry_id, significance, companies, production_value, production_unit, production_year) VALUES
-- Automobile
('china', 'automobile', 'Premier producteur mondial', '["SAIC", "FAW", "Dongfeng", "Geely", "BYD"]', 2608.0, 'milliers de véhicules', 2021),
('usa', 'automobile', 'Troisième producteur mondial', '["General Motors", "Ford", "Tesla", "Chrysler"]', 1747.0, 'milliers de véhicules', 2021),
('japan', 'automobile', 'Quatrième producteur mondial', '["Toyota", "Nissan", "Honda", "Mazda", "Subaru"]', 784.0, 'milliers de véhicules', 2021),
('germany', 'automobile', 'Cinquième producteur mondial', '["Volkswagen", "BMW", "Mercedes-Benz", "Audi", "Porsche"]', 314.0, 'milliers de véhicules', 2021),
('south-korea', 'automobile', 'Sixième producteur mondial', '["Hyundai", "Kia", "Genesis"]', 346.0, 'milliers de véhicules', 2021),
('india', 'automobile', 'Cinquième producteur mondial', '["Maruti Suzuki", "Tata Motors", "Mahindra", "Hero"]', 439.0, 'milliers de véhicules', 2021),
('france', 'automobile', 'Producteur européen majeur', '["Renault", "Peugeot", "Citroën"]', 135.0, 'milliers de véhicules', 2021),
('uk', 'automobile', 'Producteur européen', '["Jaguar Land Rover", "Bentley", "Rolls-Royce"]', 86.0, 'milliers de véhicules', 2021),

-- Aérospatiale
('usa', 'aerospatiale', 'Leader mondial', '["Boeing", "Lockheed Martin", "Northrop Grumman", "SpaceX"]', 400.0, 'milliards USD', 2021),
('france', 'aerospatiale', 'Leader européen', '["Airbus", "Dassault", "Safran", "Thales"]', 80.0, 'milliards USD', 2021),
('germany', 'aerospatiale', 'Partenaire Airbus', '["Airbus Germany", "MTU Aero Engines"]', 60.0, 'milliards USD', 2021),
('uk', 'aerospatiale', 'Partenaire Airbus', '["BAE Systems", "Rolls-Royce", "Airbus UK"]', 50.0, 'milliards USD', 2021),
('china', 'aerospatiale', 'Développement rapide', '["COMAC", "AVIC", "CASC"]', 30.0, 'milliards USD', 2021),
('russia', 'aerospatiale', 'Héritage soviétique', '["United Aircraft Corporation", "Roscosmos"]', 25.0, 'milliards USD', 2021),

-- Pharmaceutique
('usa', 'pharmaceutique', 'Leader mondial', '["Pfizer", "Johnson & Johnson", "Merck", "Moderna"]', 500.0, 'milliards USD', 2021),
('switzerland', 'pharmaceutique', 'Leader européen', '["Roche", "Novartis"]', 80.0, 'milliards USD', 2021),
('germany', 'pharmaceutique', 'Producteur majeur', '["Bayer", "Merck KGaA", "Boehringer Ingelheim"]', 60.0, 'milliards USD', 2021),
('france', 'pharmaceutique', 'Producteur européen', '["Sanofi", "Servier", "Ipsen"]', 40.0, 'milliards USD', 2021),
('uk', 'pharmaceutique', 'Producteur européen', '["GSK", "AstraZeneca"]', 35.0, 'milliards USD', 2021),
('japan', 'pharmaceutique', 'Producteur asiatique', '["Takeda", "Astellas", "Daiichi Sankyo"]', 80.0, 'milliards USD', 2021),

-- Électronique
('china', 'electronique', 'Premier producteur mondial', '["Huawei", "Xiaomi", "Oppo", "Vivo", "Lenovo"]', 800.0, 'milliards USD', 2021),
('usa', 'electronique', 'Leader technologique', '["Apple", "Microsoft", "Intel", "Qualcomm", "AMD"]', 600.0, 'milliards USD', 2021),
('south-korea', 'electronique', 'Leader asiatique', '["Samsung", "LG", "SK Hynix"]', 200.0, 'milliards USD', 2021),
('japan', 'electronique', 'Producteur majeur', '["Sony", "Panasonic", "Toshiba", "Canon"]', 150.0, 'milliards USD', 2021),
('taiwan', 'electronique', 'Fabrication de puces', '["TSMC", "ASUS", "Acer", "HTC"]', 100.0, 'milliards USD', 2021),

-- Textile
('china', 'textile', 'Premier producteur mondial', '["Ningbo", "Shaoxing", "Guangzhou"]', 300.0, 'milliards USD', 2021),
('india', 'textile', 'Deuxième producteur mondial', '["Reliance", "Arvind", "Raymond"]', 150.0, 'milliards USD', 2021),
('bangladesh', 'textile', 'Exportateur majeur', '["Garment factories"]', 40.0, 'milliards USD', 2021),
('vietnam', 'textile', 'Exportateur en croissance', '["Garment factories"]', 35.0, 'milliards USD', 2021),
('turkey', 'textile', 'Producteur européen', '["Textile factories"]', 25.0, 'milliards USD', 2021),

-- Alimentaire
('usa', 'alimentaire', 'Leader mondial', '["Cargill", "ADM", "Bunge", "Kraft Heinz"]', 800.0, 'milliards USD', 2021),
('china', 'alimentaire', 'Deuxième producteur', '["COFCO", "New Hope", "Wens"]', 600.0, 'milliards USD', 2021),
('brazil', 'alimentaire', 'Exportateur majeur', '["JBS", "BRF", "Marfrig"]', 200.0, 'milliards USD', 2021),
('france', 'alimentaire', 'Leader européen', '["Danone", "Lactalis", "Nestlé France"]', 180.0, 'milliards USD', 2021),
('germany', 'alimentaire', 'Producteur européen', '["Nestlé Germany", "Unilever Germany"]', 150.0, 'milliards USD', 2021),

-- Chimique
('usa', 'chimique', 'Leader mondial', '["Dow", "DuPont", "BASF USA", "ExxonMobil Chemical"]', 500.0, 'milliards USD', 2021),
('china', 'chimique', 'Deuxième producteur', '["Sinopec", "CNPC", "ChemChina"]', 400.0, 'milliards USD', 2021),
('germany', 'chimique', 'Leader européen', '["BASF", "Bayer", "Evonik", "Covestro"]', 200.0, 'milliards USD', 2021),
('japan', 'chimique', 'Producteur asiatique', '["Mitsubishi Chemical", "Sumitomo Chemical", "Toray"]', 150.0, 'milliards USD', 2021),
('france', 'chimique', 'Producteur européen', '["Arkema", "Solvay", "Air Liquide"]', 100.0, 'milliards USD', 2021),

-- Acier
('china', 'acier', 'Premier producteur mondial', '["Baosteel", "Hebei Steel", "Shagang"]', 1030.0, 'millions de tonnes', 2021),
('india', 'acier', 'Deuxième producteur', '["Tata Steel", "JSW Steel", "SAIL"]', 118.0, 'millions de tonnes', 2021),
('japan', 'acier', 'Troisième producteur', '["Nippon Steel", "JFE Steel", "Kobe Steel"]', 96.0, 'millions de tonnes', 2021),
('usa', 'acier', 'Quatrième producteur', '["Nucor", "US Steel", "Cleveland-Cliffs"]', 86.0, 'millions de tonnes', 2021),
('russia', 'acier', 'Cinquième producteur', '["NLMK", "Severstal", "Evraz"]', 76.0, 'millions de tonnes', 2021),

-- Armement
('usa', 'armement', 'Leader mondial', '["Lockheed Martin", "Boeing Defense", "Raytheon", "Northrop Grumman"]', 400.0, 'milliards USD', 2021),
('russia', 'armement', 'Deuxième exportateur', '["Almaz-Antey", "Uralvagonzavod", "Rostec"]', 150.0, 'milliards USD', 2021),
('france', 'armement', 'Exportateur européen', '["Thales", "Dassault Aviation", "Naval Group"]', 30.0, 'milliards USD', 2021),
('germany', 'armement', 'Producteur européen', '["Rheinmetall", "Krauss-Maffei Wegmann"]', 25.0, 'milliards USD', 2021),
('uk', 'armement', 'Producteur européen', '["BAE Systems", "Rolls-Royce Defense"]', 20.0, 'milliards USD', 2021); 