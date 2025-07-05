-- =====================================================
-- Insertion de données d'exemple pour WikiGeopolitics
-- Basé sur les fichiers JSON existants dans src/data/
-- =====================================================

-- =====================================================
-- INSERTION DES PAYS (COUNTRY)
-- =====================================================
INSERT INTO country (id, nom, capitale, langue, monnaie, continent, coordonnees) VALUES
('france', 'France', 'Paris', 'Français', 'Euro', 'Europe', ST_SetSRID(ST_MakePoint(2.2137, 46.2276), 4326)),
('usa', 'États-Unis', 'Washington D.C.', 'Anglais', 'Dollar américain', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-95.7129, 37.0902), 4326)),
('china', 'Chine', 'Pékin', 'Chinois', 'Yuan', 'Asie', ST_SetSRID(ST_MakePoint(104.1954, 35.8617), 4326)),
('russia', 'Russie', 'Moscou', 'Russe', 'Rouble', 'Europe', ST_SetSRID(ST_MakePoint(105.3188, 61.5240), 4326)),
('germany', 'Allemagne', 'Berlin', 'Allemand', 'Euro', 'Europe', ST_SetSRID(ST_MakePoint(10.4515, 51.1657), 4326)),
('uk', 'Royaume-Uni', 'Londres', 'Anglais', 'Livre sterling', 'Europe', ST_SetSRID(ST_MakePoint(-0.1276, 51.5074), 4326)),
('japan', 'Japon', 'Tokyo', 'Japonais', 'Yen', 'Asie', ST_SetSRID(ST_MakePoint(138.2529, 36.2048), 4326)),
('india', 'Inde', 'New Delhi', 'Hindi', 'Roupie indienne', 'Asie', ST_SetSRID(ST_MakePoint(78.9629, 20.5937), 4326)),
('brazil', 'Brésil', 'Brasília', 'Portugais', 'Real', 'Amérique du Sud', ST_SetSRID(ST_MakePoint(-51.9253, -14.2350), 4326)),
('australia', 'Australie', 'Canberra', 'Anglais', 'Dollar australien', 'Océanie', ST_SetSRID(ST_MakePoint(133.7751, -25.2744), 4326)),
('canada', 'Canada', 'Ottawa', 'Anglais, Français', 'Dollar canadien', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-106.3468, 56.1304), 4326)),
('south-africa', 'Afrique du Sud', 'Pretoria', 'Afrikaans, Anglais', 'Rand', 'Afrique', ST_SetSRID(ST_MakePoint(24.9916, -30.5595), 4326)),
('iran', 'Iran', 'Téhéran', 'Persan', 'Rial', 'Asie', ST_SetSRID(ST_MakePoint(53.6880, 32.4279), 4326)),
('saudi-arabia', 'Arabie Saoudite', 'Riyad', 'Arabe', 'Riyal', 'Asie', ST_SetSRID(ST_MakePoint(45.0792, 23.8859), 4326)),
('south-korea', 'Corée du Sud', 'Séoul', 'Coréen', 'Won', 'Asie', ST_SetSRID(ST_MakePoint(127.7669, 35.9078), 4326)),
('north-korea', 'Corée du Nord', 'Pyongyang', 'Coréen', 'Won nord-coréen', 'Asie', ST_SetSRID(ST_MakePoint(127.5101, 40.3399), 4326)),
('thailand', 'Thaïlande', 'Bangkok', 'Thaï', 'Baht', 'Asie', ST_SetSRID(ST_MakePoint(100.9925, 15.8700), 4326)),
('fiji', 'Fidji', 'Suva', 'Anglais, Fidjien', 'Dollar fidjien', 'Océanie', ST_SetSRID(ST_MakePoint(178.0650, -17.7134), 4326)),
('new-zealand', 'Nouvelle-Zélande', 'Wellington', 'Anglais, Maori', 'Dollar néo-zélandais', 'Océanie', ST_SetSRID(ST_MakePoint(174.7762, -40.9006), 4326)),
('vanuatu', 'Vanuatu', 'Port-Vila', 'Bichelamar, Anglais, Français', 'Vatu', 'Océanie', ST_SetSRID(ST_MakePoint(166.9594, -15.3767), 4326)),
('samoa', 'Samoa', 'Apia', 'Samoan, Anglais', 'Tala', 'Océanie', ST_SetSRID(ST_MakePoint(-171.7669, -13.8508), 4326)),
('tonga', 'Tonga', 'Nuku''alofa', 'Anglais, Tongan', 'Pa''anga', 'Océanie', ST_SetSRID(ST_MakePoint(-175.1982, -21.1790), 4326)),
('tuvalu', 'Tuvalu', 'Funafuti', 'Tuvaluan, Anglais', 'Dollar tuvaluan', 'Océanie', ST_SetSRID(ST_MakePoint(178.1165, -7.1095), 4326)),
('kiribati', 'Kiribati', 'Tarawa', 'Gilbertese, Anglais', 'Dollar australien', 'Océanie', ST_SetSRID(ST_MakePoint(173.6641, 1.3382), 4326)),
('marshall-islands', 'Îles Marshall', 'Majuro', 'Marshallese, Anglais', 'Dollar américain', 'Océanie', ST_SetSRID(ST_MakePoint(168.7344, 7.1315), 4326)),
('micronesia', 'Micronésie', 'Palikir', 'Anglais', 'Dollar américain', 'Océanie', ST_SetSRID(ST_MakePoint(158.1618, 6.9248), 4326)),
('nauru', 'Nauru', 'Yaren', 'Nauruan, Anglais', 'Dollar australien', 'Océanie', ST_SetSRID(ST_MakePoint(166.9315, -0.5228), 4326)),
('palau', 'Palaos', 'Ngerulmud', 'Anglais, Palauan', 'Dollar américain', 'Océanie', ST_SetSRID(ST_MakePoint(134.5825, 7.5150), 4326)),
('papua-new-guinea', 'Papouasie-Nouvelle-Guinée', 'Port Moresby', 'Anglais, Tok Pisin', 'Kina', 'Océanie', ST_SetSRID(ST_MakePoint(143.9555, -6.3150), 4326)),
('solomon-islands', 'Îles Salomon', 'Honiara', 'Anglais', 'Dollar des Îles Salomon', 'Océanie', ST_SetSRID(ST_MakePoint(160.1564, -9.6457), 4326));

-- =====================================================
-- INSERTION DES ORGANISATIONS (ORGANIZATION)
-- =====================================================
INSERT INTO organization (id, nom, type, description, date_creation, siege) VALUES
('onu', 'Organisation des Nations Unies', 'Organisation internationale', 'Organisation internationale pour la paix et la sécurité', '1945-10-24', 'New York, États-Unis'),
('otan', 'Organisation du Traité de l''Atlantique Nord', 'Alliance militaire', 'Alliance militaire occidentale', '1949-04-04', 'Bruxelles, Belgique'),
('ue', 'Union européenne', 'Union politique et économique', 'Union politique et économique européenne', '1993-11-01', 'Bruxelles, Belgique'),
('g7', 'Groupe des Sept', 'Forum économique', 'Forum des sept pays les plus industrialisés', '1975-01-01', 'Rotation annuelle'),
('g20', 'Groupe des Vingt', 'Forum économique', 'Forum des vingt principales économies', '1999-01-01', 'Rotation annuelle'),
('apec', 'Coopération économique Asie-Pacifique', 'Forum économique', 'Forum de coopération économique Asie-Pacifique', '1989-01-01', 'Singapour'),
('mercosur', 'Mercosur', 'Union douanière', 'Marché commun du Sud', '1991-03-26', 'Montevideo, Uruguay'),
('asean', 'Association des nations de l''Asie du Sud-Est', 'Organisation régionale', 'Association des nations de l''Asie du Sud-Est', '1967-08-08', 'Jakarta, Indonésie');

-- =====================================================
-- INSERTION DES RELATIONS (RELATION)
-- =====================================================
INSERT INTO relation (id, type, description, date_debut, statut) VALUES
('alliance-otan', 'Alliance militaire', 'Alliance militaire occidentale', '1949-04-04', 'Actif'),
('alliance-ue', 'Union politique', 'Union politique et économique européenne', '1993-11-01', 'Actif'),
('conflit-ukraine', 'Conflit armé', 'Conflit en Ukraine', '2022-02-24', 'En cours'),
('accord-paris', 'Accord climatique', 'Accord de Paris sur le climat', '2015-12-12', 'Actif'),
('sanctions-russie', 'Sanctions économiques', 'Sanctions contre la Russie', '2022-02-24', 'Actif'),
('commerce-chine-usa', 'Relations commerciales', 'Relations commerciales Chine-États-Unis', '1979-01-01', 'Actif');

-- =====================================================
-- INSERTION DES CONFLITS (CONFLICT)
-- =====================================================
INSERT INTO conflict (id, nom, type, statut, date_debut, intensite, localisation) VALUES
('conflit-ukraine-2022', 'Guerre en Ukraine', 'Guerre interétatique', 'En cours', '2022-02-24', 'Élevée', 
 ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[22.1371,51.1455],[22.1371,52.3795],[40.1789,52.3795],[40.1789,51.1455],[22.1371,51.1455]]]}')),
('conflit-syrie', 'Guerre civile syrienne', 'Guerre civile', 'En cours', '2011-03-15', 'Élevée',
 ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[35.6123,32.3111],[35.6123,37.5439],[42.3853,37.5439],[42.3853,32.3111],[35.6123,32.3111]]]}')),
('conflit-yemen', 'Guerre au Yémen', 'Guerre civile', 'En cours', '2014-09-19', 'Moyenne',
 ST_GeomFromGeoJSON('{"type":"Polygon","coordinates":[[[42.6043,12.5850],[42.6043,18.9997],[54.7382,18.9997],[54.7382,12.5850],[42.6043,12.5850]]]}'));

-- =====================================================
-- INSERTION DES RESSOURCES (RESOURCE)
-- =====================================================
INSERT INTO resource (id, nom, categorie, description, impact_environnemental, enjeux_geopolitiques) VALUES
('petrole', 'Pétrole', 'Énergie fossile', 'Ressource énergétique principale', 'Élevé - émissions CO2', 'Contrôle des routes maritimes, dépendance énergétique'),
('gaz-naturel', 'Gaz naturel', 'Énergie fossile', 'Ressource énergétique en croissance', 'Moyen - émissions CO2', 'Routes d''approvisionnement, diversification énergétique'),
('uranium', 'Uranium', 'Énergie nucléaire', 'Ressource pour énergie nucléaire', 'Faible - déchets radioactifs', 'Prolifération nucléaire, sécurité'),
('lithium', 'Lithium', 'Métal rare', 'Ressource pour batteries', 'Moyen - extraction minière', 'Transition énergétique, contrôle des chaînes d''approvisionnement'),
('terres-rares', 'Terres rares', 'Métaux rares', 'Ressources pour technologies', 'Élevé - extraction polluante', 'Monopole chinois, technologies vertes'),
('eau', 'Eau douce', 'Ressource vitale', 'Ressource essentielle à la vie', 'Faible - gestion durable', 'Conflits d''usage, changement climatique'),
('poissons', 'Ressources halieutiques', 'Ressource alimentaire', 'Ressources marines pour alimentation', 'Moyen - surpêche', 'Zones économiques exclusives, surpêche'),
('bois', 'Bois', 'Ressource renouvelable', 'Ressource forestière', 'Faible - gestion durable', 'Déforestation, puits de carbone');

-- =====================================================
-- INSERTION DES INDUSTRIES (INDUSTRY)
-- =====================================================
INSERT INTO industry (id, nom, categorie, description) VALUES
('automobile', 'Industrie automobile', 'Transport', 'Fabrication de véhicules automobiles'),
('aerospatial', 'Industrie aérospatiale', 'Transport', 'Fabrication d''avions et satellites'),
('pharmaceutique', 'Industrie pharmaceutique', 'Santé', 'Fabrication de médicaments'),
('informatique', 'Industrie informatique', 'Technologie', 'Fabrication d''ordinateurs et logiciels'),
('textile', 'Industrie textile', 'Consommation', 'Fabrication de vêtements et tissus'),
('agroalimentaire', 'Industrie agroalimentaire', 'Alimentation', 'Transformation des produits agricoles'),
('chimie', 'Industrie chimique', 'Matériaux', 'Fabrication de produits chimiques'),
('energie', 'Industrie énergétique', 'Énergie', 'Production et distribution d''énergie');

-- =====================================================
-- INSERTION DES ENTREPRISES (COMPANY)
-- =====================================================
INSERT INTO company (id, nom, pays, secteur, indicateurs) VALUES
('tesla', 'Tesla', 'usa', 'Automobile', '{"chiffre_affaires": "538.23 milliards USD", "employes": 127855}'),
('toyota', 'Toyota', 'japan', 'Automobile', '{"chiffre_affaires": "279.515 milliards USD", "employes": 372817}'),
('volkswagen', 'Volkswagen', 'germany', 'Automobile', '{"chiffre_affaires": "295.819 milliards USD", "employes": 662575}'),
('apple', 'Apple', 'usa', 'Informatique', '{"chiffre_affaires": "394.328 milliards USD", "employes": 164000}'),
('samsung', 'Samsung', 'south-korea', 'Informatique', '{"chiffre_affaires": "234.2 milliards USD", "employes": 267937}'),
('pfizer', 'Pfizer', 'usa', 'Pharmaceutique', '{"chiffre_affaires": "100.33 milliards USD", "employes": 83000}'),
('novartis', 'Novartis', 'germany', 'Pharmaceutique', '{"chiffre_affaires": "51.6 milliards USD", "employes": 108000}'),
('shell', 'Shell', 'uk', 'Énergie', '{"chiffre_affaires": "386.201 milliards USD", "employes": 87000}');

-- =====================================================
-- INSERTION DES ROUTES COMMERCIALES (TRADE_ROUTE)
-- =====================================================
INSERT INTO trade_route (id, nom, type, endpoints, volume, biens_transportes, geo_json_ref) VALUES
('route-suez', 'Route de Suez', 'Maritime', '{"depart": "Méditerranée", "arrivee": "Océan Indien"}', '{"volume": "12% du commerce mondial"}', '["Pétrole", "Conteneurs", "Céréales"]', 'trade-routes.geo.json#Suez'),
('route-malacca', 'Détroit de Malacca', 'Maritime', '{"depart": "Océan Indien", "arrivee": "Pacifique"}', '{"volume": "25% du commerce mondial"}', '["Pétrole", "Conteneurs", "Matières premières"]', 'trade-routes.geo.json#Malacca'),
('route-hormuz', 'Détroit d''Ormuz', 'Maritime', '{"depart": "Golfe Persique", "arrivee": "Océan Indien"}', '{"volume": "21% du pétrole mondial"}', '["Pétrole", "Gaz naturel"]', 'trade-routes.geo.json#Hormuz'),
('route-panama', 'Canal de Panama', 'Maritime', '{"depart": "Atlantique", "arrivee": "Pacifique"}', '{"volume": "5% du commerce mondial"}', '["Conteneurs", "Céréales", "Produits manufacturés"]', 'trade-routes.geo.json#Panama');

-- =====================================================
-- INSERTION DES RELATIONS DE JONCTION
-- =====================================================

-- Relations Country-Organization
INSERT INTO country_organization (country_id, organization_id, role, date_adhesion) VALUES
('france', 'onu', 'Membre permanent', '1945-10-24'),
('usa', 'onu', 'Membre permanent', '1945-10-24'),
('china', 'onu', 'Membre permanent', '1971-10-25'),
('russia', 'onu', 'Membre permanent', '1945-10-24'),
('uk', 'onu', 'Membre permanent', '1945-10-24'),
('france', 'otan', 'Membre fondateur', '1949-04-04'),
('usa', 'otan', 'Membre fondateur', '1949-04-04'),
('germany', 'otan', 'Membre', '1955-05-09'),
('uk', 'otan', 'Membre fondateur', '1949-04-04'),
('france', 'ue', 'Membre fondateur', '1957-03-25'),
('germany', 'ue', 'Membre fondateur', '1957-03-25'),
('usa', 'g7', 'Membre', '1975-01-01'),
('japan', 'g7', 'Membre', '1975-01-01'),
('china', 'g20', 'Membre', '1999-01-01'),
('india', 'g20', 'Membre', '1999-01-01'),
('brazil', 'g20', 'Membre', '1999-01-01');

-- Relations Country-Conflict
INSERT INTO country_conflict (country_id, conflict_id, role) VALUES
('russia', 'conflit-ukraine-2022', 'Agresseur'),
('usa', 'conflit-ukraine-2022', 'Soutien militaire'),
('france', 'conflit-ukraine-2022', 'Soutien militaire'),
('germany', 'conflit-ukraine-2022', 'Soutien militaire'),
('uk', 'conflit-ukraine-2022', 'Soutien militaire');

-- Relations Country-Resource
INSERT INTO country_resource (country_id, resource_id, production_volume, reserves) VALUES
('saudi-arabia', 'petrole', '{"volume": "10.8 millions b/j", "rang": 2}', '{"reserves": "267 milliards barils", "rang": 2}'),
('russia', 'petrole', '{"volume": "10.1 millions b/j", "rang": 3}', '{"reserves": "80 milliards barils", "rang": 8}'),
('usa', 'petrole', '{"volume": "11.6 millions b/j", "rang": 1}', '{"reserves": "69 milliards barils", "rang": 9}'),
('china', 'lithium', '{"volume": "14 000 tonnes", "rang": 3}', '{"reserves": "1.5 millions tonnes", "rang": 4}'),
('australia', 'lithium', '{"volume": "55 000 tonnes", "rang": 1}', '{"reserves": "6.2 millions tonnes", "rang": 1}'),
('china', 'terres-rares', '{"volume": "168 000 tonnes", "rang": 1}', '{"reserves": "44 millions tonnes", "rang": 1}');

-- Relations Country-Industry
INSERT INTO country_industry (country_id, industry_id, production_volume, importance) VALUES
('usa', 'automobile', '{"volume": "8.8 millions véhicules", "rang": 2}', 'Très importante'),
('china', 'automobile', '{"volume": "26.1 millions véhicules", "rang": 1}', 'Très importante'),
('japan', 'automobile', '{"volume": "7.8 millions véhicules", "rang": 3}', 'Très importante'),
('germany', 'automobile', '{"volume": "3.7 millions véhicules", "rang": 4}', 'Très importante'),
('usa', 'informatique', '{"volume": "Leader mondial", "rang": 1}', 'Très importante'),
('china', 'informatique', '{"volume": "Second producteur", "rang": 2}', 'Très importante'),
('usa', 'pharmaceutique', '{"volume": "Leader mondial", "rang": 1}', 'Très importante'),
('germany', 'pharmaceutique', '{"volume": "Second producteur", "rang": 2}', 'Très importante');

-- Relations Industry-Company
INSERT INTO industry_company (industry_id, company_id, role) VALUES
('automobile', 'tesla', 'Leader véhicules électriques'),
('automobile', 'toyota', 'Leader mondial'),
('automobile', 'volkswagen', 'Leader européen'),
('informatique', 'apple', 'Leader smartphones'),
('informatique', 'samsung', 'Leader électronique'),
('pharmaceutique', 'pfizer', 'Leader mondial'),
('pharmaceutique', 'novartis', 'Leader européen'),
('energie', 'shell', 'Major pétrolière');

-- Relations Conflict-Resource
INSERT INTO conflict_resource (conflict_id, resource_id, importance) VALUES
('conflit-ukraine-2022', 'gaz-naturel', 'Très importante'),
('conflit-ukraine-2022', 'petrole', 'Importante'),
('conflit-syrie', 'petrole', 'Importante'),
('conflit-yemen', 'petrole', 'Importante');

-- Relations Conflict-Trade_Route
INSERT INTO conflict_trade_route (conflict_id, trade_route_id, impact) VALUES
('conflit-ukraine-2022', 'route-suez', 'Impact limité'),
('conflit-yemen', 'route-hormuz', 'Impact majeur'),
('conflit-yemen', 'route-malacca', 'Impact mineur');

-- Relations Resource-Trade_Route
INSERT INTO resource_trade_route (resource_id, trade_route_id, volume) VALUES
('petrole', 'route-hormuz', '{"volume": "21 millions b/j"}'),
('gaz-naturel', 'route-hormuz', '{"volume": "LNG important"}'),
('petrole', 'route-malacca', '{"volume": "15 millions b/j"}'),
('petrole', 'route-suez', '{"volume": "5 millions b/j"}');

-- =====================================================
-- INSERTION DES DONNÉES DÉMOGRAPHIQUES (DEMOGRAPHIC)
-- =====================================================
INSERT INTO demographic (id, pays, population, tendances, indicateurs_sociaux) VALUES
('demo-france', 'france', '{"total": 67390000, "densite": 119, "croissance": 0.3}', '{"urbanisation": 80, "vieillissement": "Élevé"}', '{"esperance_vie": 82.7, "taux_alphab": 99}'),
('demo-usa', 'usa', '{"total": 331900000, "densite": 36, "croissance": 0.6}', '{"urbanisation": 83, "vieillissement": "Moyen"}', '{"esperance_vie": 78.9, "taux_alphab": 99}'),
('demo-china', 'china', '{"total": 1439000000, "densite": 153, "croissance": 0.4}', '{"urbanisation": 61, "vieillissement": "Accéléré"}', '{"esperance_vie": 76.9, "taux_alphab": 96}'),
('demo-india', 'india', '{"total": 1380000000, "densite": 464, "croissance": 1.1}', '{"urbanisation": 35, "vieillissement": "Faible"}', '{"esperance_vie": 69.4, "taux_alphab": 74}'); 