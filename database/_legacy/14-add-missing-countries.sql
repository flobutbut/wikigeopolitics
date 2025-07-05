-- Ajout des pays manquants
-- Script: 14-add-missing-countries.sql

-- Ajout des pays manquants pour les données agricoles, industrielles, etc.
INSERT INTO country (id, nom, capitale, langue, monnaie, coordonnees) VALUES
-- Pays pour les données agricoles
('indonesia', 'Indonésie', 'Jakarta', 'Indonésien', 'Roupie indonésienne (IDR)', ST_SetSRID(ST_MakePoint(120.0, -2.0), 4326)),
('bangladesh', 'Bangladesh', 'Dhaka', 'Bengali', 'Taka (BDT)', ST_SetSRID(ST_MakePoint(90.0, 24.0), 4326)),
('vietnam', 'Vietnam', 'Hanoï', 'Vietnamien', 'Dong (VND)', ST_SetSRID(ST_MakePoint(108.0, 16.0), 4326)),
('egypt', 'Égypte', 'Le Caire', 'Arabe', 'Livre égyptienne (EGP)', ST_SetSRID(ST_MakePoint(30.0, 26.0), 4326)),
('algeria', 'Algérie', 'Alger', 'Arabe', 'Dinar algérien (DZD)', ST_SetSRID(ST_MakePoint(3.0, 28.0), 4326)),
('morocco', 'Maroc', 'Rabat', 'Arabe', 'Dirham marocain (MAD)', ST_SetSRID(ST_MakePoint(-5.0, 32.0), 4326)),
('mexico', 'Mexique', 'Mexico', 'Espagnol', 'Peso mexicain (MXN)', ST_SetSRID(ST_MakePoint(-102.0, 23.0), 4326)),
('argentina', 'Argentine', 'Buenos Aires', 'Espagnol', 'Peso argentin (ARS)', ST_SetSRID(ST_MakePoint(-64.0, -34.0), 4326)),
('ukraine', 'Ukraine', 'Kiev', 'Ukrainien', 'Hryvnia (UAH)', ST_SetSRID(ST_MakePoint(32.0, 49.0), 4326)),

-- Pays pour les données technologiques
('taiwan', 'Taïwan', 'TWN', 23816775, 36193, 'Taipei', 'Mandarin', 'Dollar taïwanais (TWD)', 'République démocratique', 775.4, 32528.1, 0.916, 80.7, 98.5, 'Asie', 'Asie de l''Est', '{"lat": 23.5, "lng": 121.0}'),
('switzerland', 'Suisse', 'CHE', 8654622, 41284, 'Berne', 'Allemand, Français, Italien', 'Franc suisse (CHF)', 'République fédérale', 731.0, 84475.0, 0.962, 83.8, 99.0, 'Europe', 'Europe de l''Ouest', '{"lat": 47.0, "lng": 8.0}'),
('singapore', 'Singapour', 'SGP', 5850342, 728, 'Singapour', 'Anglais, Mandarin, Malais, Tamoul', 'Dollar de Singapour (SGD)', 'République parlementaire', 396.9, 67857.0, 0.939, 83.5, 97.5, 'Asie', 'Asie du Sud-Est', '{"lat": 1.3, "lng": 103.8}'),
('netherlands', 'Pays-Bas', 'NLD', 17134872, 41543, 'Amsterdam', 'Néerlandais', 'Euro (EUR)', 'Monarchie constitutionnelle', 1012.8, 59127.0, 0.941, 82.2, 99.0, 'Europe', 'Europe de l''Ouest', '{"lat": 52.0, "lng": 5.5}'),
('uae', 'Émirats arabes unis', 'ARE', 9890402, 83600, 'Abu Dhabi', 'Arabe', 'Dirham des Émirats (AED)', 'Fédération monarchique', 410.0, 41448.0, 0.911, 78.0, 93.8, 'Asie', 'Moyen-Orient', '{"lat": 24.0, "lng": 54.0}'),

-- Pays pour les données démographiques
('pakistan', 'Pakistan', 'PAK', 220892340, 796095, 'Islamabad', 'Ourdou, Anglais', 'Roupie pakistanaise (PKR)', 'République fédérale parlementaire', 348.3, 1576.9, 0.544, 67.3, 58.0, 'Asie', 'Asie du Sud', '{"lat": 30.0, "lng": 70.0}'),
('nigeria', 'Nigeria', 'NGA', 206139589, 923768, 'Abuja', 'Anglais', 'Naira (NGN)', 'République fédérale présidentielle', 440.8, 2137.5, 0.539, 54.7, 62.0, 'Afrique', 'Afrique de l''Ouest', '{"lat": 10.0, "lng": 8.0}'),

-- Pays pour les données de ressources naturelles
('qatar', 'Qatar', 'QAT', 2881053, 11586, 'Doha', 'Arabe', 'Riyal qatari (QAR)', 'Monarchie absolue', 179.6, 62340.0, 0.855, 80.2, 97.8, 'Asie', 'Moyen-Orient', '{"lat": 25.5, "lng": 51.3}'),
('kazakhstan', 'Kazakhstan', 'KAZ', 18776707, 2724900, 'Nour-Soultan', 'Kazakh, Russe', 'Tenge (KZT)', 'République présidentielle', 190.8, 10166.0, 0.802, 73.6, 99.8, 'Asie', 'Asie centrale', '{"lat": 48.0, "lng": 68.0}'),
('namibia', 'Namibie', 'NAM', 2540905, 825615, 'Windhoek', 'Anglais', 'Dollar namibien (NAD)', 'République présidentielle', 12.6, 4958.0, 0.615, 63.7, 91.5, 'Afrique', 'Afrique australe', '{"lat": -22.0, "lng": 17.0}'),
('uzbekistan', 'Ouzbékistan', 'UZB', 33469203, 447400, 'Tachkent', 'Ouzbek', 'Sum (UZS)', 'République présidentielle', 69.2, 2067.0, 0.727, 72.0, 99.9, 'Asie', 'Asie centrale', '{"lat": 41.0, "lng": 64.0}'),
('chile', 'Chili', 'CHL', 19116201, 756102, 'Santiago', 'Espagnol', 'Peso chilien (CLP)', 'République présidentielle', 301.0, 15755.0, 0.855, 80.2, 96.4, 'Amérique', 'Amérique du Sud', '{"lat": -30.0, "lng": -71.0}'),
('bolivia', 'Bolivie', 'BOL', 11673021, 1098581, 'La Paz', 'Espagnol', 'Boliviano (BOB)', 'République présidentielle', 40.7, 3487.0, 0.718, 71.5, 92.5, 'Amérique', 'Amérique du Sud', '{"lat": -17.0, "lng": -65.0}'),
('peru', 'Pérou', 'PER', 32971854, 1285216, 'Lima', 'Espagnol', 'Sol (PEN)', 'République présidentielle', 223.2, 6773.0, 0.777, 76.7, 94.5, 'Amérique', 'Amérique du Sud', '{"lat": -10.0, "lng": -76.0}'),
('botswana', 'Botswana', 'BWA', 2351627, 581730, 'Gaborone', 'Anglais, Tswana', 'Pula (BWP)', 'République parlementaire', 17.6, 7488.0, 0.735, 69.6, 88.5, 'Afrique', 'Afrique australe', '{"lat": -22.0, "lng": 24.0}'),
('drc', 'République démocratique du Congo', 'COD', 89561403, 2344858, 'Kinshasa', 'Français', 'Franc congolais (CDF)', 'République présidentielle', 55.4, 618.0, 0.479, 60.7, 77.0, 'Afrique', 'Afrique centrale', '{"lat": 0.0, "lng": 25.0}'),
('congo', 'République du Congo', 'COG', 5518087, 342000, 'Brazzaville', 'Français', 'Franc CFA (XAF)', 'République présidentielle', 12.5, 2264.0, 0.571, 64.6, 80.3, 'Afrique', 'Afrique centrale', '{"lat": -1.0, "lng": 15.0}'),
('philippines', 'Philippines', 'PHL', 109581078, 300000, 'Manille', 'Filipino, Anglais', 'Peso philippin (PHP)', 'République présidentielle', 394.1, 3595.0, 0.699, 71.2, 96.3, 'Asie', 'Asie du Sud-Est', '{"lat": 13.0, "lng": 122.0}'),
('new-caledonia', 'Nouvelle-Calédonie', 'NCL', 285498, 18575, 'Nouméa', 'Français', 'Franc CFP (XPF)', 'Territoire français', 11.1, 38877.0, 0.939, 77.5, 96.9, 'Océanie', 'Mélanésie', '{"lat": -21.5, "lng": 165.5}'),
('cuba', 'Cuba', 'CUB', 11326616, 109884, 'La Havane', 'Espagnol', 'Peso cubain (CUP)', 'République socialiste', 107.4, 9482.0, 0.764, 78.8, 99.8, 'Amérique', 'Caraïbes', '{"lat": 21.5, "lng": -80.0}'),

-- Pays pour les données industrielles
('turkey', 'Turquie', 'TUR', 84339067, 783562, 'Ankara', 'Turc', 'Livre turque (TRY)', 'République présidentielle', 720.1, 8538.0, 0.838, 77.7, 96.7, 'Asie', 'Moyen-Orient', '{"lat": 39.0, "lng": 35.0}'),
('vietnam', 'Vietnam', 'VNM', 97338579, 331212, 'Hanoï', 'Vietnamien', 'Dong (VND)', 'République socialiste', 366.1, 3758.3, 0.703, 75.4, 95.8, 'Asie', 'Asie du Sud-Est', '{"lat": 16.0, "lng": 108.0}'),
('bangladesh', 'Bangladesh', 'BGD', 164689383, 147570, 'Dhaka', 'Bengali', 'Taka (BDT)', 'République parlementaire', 416.3, 2527.4, 0.661, 72.6, 74.7, 'Asie', 'Asie du Sud', '{"lat": 24.0, "lng": 90.0}'),

-- Pays pour les données de transport
('iraq', 'Irak', 'IRQ', 40462701, 438317, 'Bagdad', 'Arabe', 'Dinar irakien (IQD)', 'République parlementaire', 190.8, 4717.0, 0.686, 75.3, 85.6, 'Asie', 'Moyen-Orient', '{"lat": 33.0, "lng": 44.0}'),
('ethiopia', 'Éthiopie', 'ETH', 114963588, 1104300, 'Addis-Abeba', 'Amharique', 'Birr (ETB)', 'République fédérale', 111.3, 968.0, 0.485, 67.1, 51.8, 'Afrique', 'Afrique de l''Est', '{"lat": 9.0, "lng": 40.0}'),
('eritrea', 'Érythrée', 'ERI', 3546421, 117600, 'Asmara', 'Tigrinya', 'Nakfa (ERN)', 'République présidentielle', 2.1, 592.0, 0.459, 66.3, 76.6, 'Afrique', 'Afrique de l''Est', '{"lat": 15.0, "lng": 39.0}'),
('libya', 'Libye', 'LBY', 6871292, 1759540, 'Tripoli', 'Arabe', 'Dinar libyen (LYD)', 'Gouvernement de transition', 40.9, 5953.0, 0.718, 72.9, 91.0, 'Afrique', 'Afrique du Nord', '{"lat": 25.0, "lng": 17.0}'),
('mali', 'Mali', 'MLI', 20250833, 1240192, 'Bamako', 'Français', 'Franc CFA (XOF)', 'République présidentielle', 19.1, 943.0, 0.428, 59.3, 35.5, 'Afrique', 'Afrique de l''Ouest', '{"lat": 17.0, "lng": -4.0}'),
('niger', 'Niger', 'NER', 24206644, 1267000, 'Niamey', 'Français', 'Franc CFA (XOF)', 'République présidentielle', 14.9, 615.0, 0.400, 62.4, 35.1, 'Afrique', 'Afrique de l''Ouest', '{"lat": 18.0, "lng": 8.0}'),
('burkina-faso', 'Burkina Faso', 'BFA', 21497096, 274200, 'Ouagadougou', 'Français', 'Franc CFA (XOF)', 'République présidentielle', 19.7, 916.0, 0.452, 61.6, 41.2, 'Afrique', 'Afrique de l''Ouest', '{"lat": 12.0, "lng": -2.0}'),
('chad', 'Tchad', 'TCD', 16425864, 1284000, 'N''Djamena', 'Français, Arabe', 'Franc CFA (XAF)', 'République présidentielle', 11.8, 718.0, 0.398, 54.2, 22.3, 'Afrique', 'Afrique centrale', '{"lat": 15.0, "lng": 19.0}'),
('somalia', 'Somalie', 'SOM', 15893222, 637657, 'Mogadiscio', 'Somali, Arabe', 'Shilling somalien (SOS)', 'République fédérale', 7.6, 478.0, 0.361, 57.4, 37.8, 'Afrique', 'Afrique de l''Est', '{"lat": 10.0, "lng": 49.0}'),
('central-african-republic', 'République centrafricaine', 'CAF', 4829767, 622984, 'Bangui', 'Français', 'Franc CFA (XAF)', 'République présidentielle', 2.5, 517.0, 0.397, 53.3, 37.4, 'Afrique', 'Afrique centrale', '{"lat": 7.0, "lng": 21.0}'),
('south-sudan', 'Soudan du Sud', 'SSD', 11193725, 619745, 'Djouba', 'Anglais', 'Livre sud-soudanaise (SSP)', 'République présidentielle', 3.7, 330.0, 0.385, 57.6, 27.0, 'Afrique', 'Afrique de l''Est', '{"lat": 7.0, "lng": 30.0}'),
('democratic-republic-of-congo', 'République démocratique du Congo', 'COD', 89561403, 2344858, 'Kinshasa', 'Français', 'Franc congolais (CDF)', 'République présidentielle', 55.4, 618.0, 0.479, 60.7, 77.0, 'Afrique', 'Afrique centrale', '{"lat": 0.0, "lng": 25.0}'),
('rwanda', 'Rwanda', 'RWA', 12952218, 26338, 'Kigali', 'Kinyarwanda, Français, Anglais', 'Franc rwandais (RWF)', 'République présidentielle', 13.3, 1027.0, 0.543, 69.0, 73.2, 'Afrique', 'Afrique de l''Est', '{"lat": -2.0, "lng": 30.0}'),
('uganda', 'Ouganda', 'UGA', 45741007, 241550, 'Kampala', 'Anglais', 'Shilling ougandais (UGX)', 'République présidentielle', 42.7, 933.0, 0.544, 63.4, 76.5, 'Afrique', 'Afrique de l''Est', '{"lat": 1.0, "lng": 32.0}'),
('sri-lanka', 'Sri Lanka', 'LKA', 21413249, 65610, 'Colombo', 'Cingalais, Tamoul', 'Roupie srilankaise (LKR)', 'République présidentielle', 84.5, 3945.0, 0.782, 77.0, 92.3, 'Asie', 'Asie du Sud', '{"lat": 7.0, "lng": 81.0}'),
('serbia', 'Serbie', 'SRB', 8737371, 88361, 'Belgrade', 'Serbe', 'Dinar serbe (RSD)', 'République parlementaire', 63.1, 7223.0, 0.802, 76.1, 98.3, 'Europe', 'Europe du Sud-Est', '{"lat": 44.0, "lng": 21.0}'),
('croatia', 'Croatie', 'HRV', 4105267, 56594, 'Zagreb', 'Croate', 'Kuna (HRK)', 'République parlementaire', 70.9, 17278.0, 0.858, 78.5, 99.3, 'Europe', 'Europe du Sud-Est', '{"lat": 45.0, "lng": 15.0}'),
('bosnia-herzegovina', 'Bosnie-Herzégovine', 'BIH', 3280819, 51209, 'Sarajevo', 'Bosniaque, Croate, Serbe', 'Mark convertible (BAM)', 'République fédérale', 22.1, 6738.0, 0.78, 77.4, 98.5, 'Europe', 'Europe du Sud-Est', '{"lat": 44.0, "lng": 18.0}'),
('kosovo', 'Kosovo', 'XKX', 1932774, 10887, 'Pristina', 'Albanais, Serbe', 'Euro (EUR)', 'République parlementaire', 9.4, 4863.0, 0.742, 72.5, 97.4, 'Europe', 'Europe du Sud-Est', '{"lat": 42.6, "lng": 21.0}'),
('afghanistan', 'Afghanistan', 'AFG', 38928346, 652230, 'Kaboul', 'Pachto, Dari', 'Afghani (AFN)', 'République islamique', 20.1, 516.0, 0.478, 64.8, 43.0, 'Asie', 'Asie du Sud', '{"lat": 33.0, "lng": 65.0}'),
('poland', 'Pologne', 'POL', 37846611, 312696, 'Varsovie', 'Polonais', 'Zloty (PLN)', 'République parlementaire', 688.2, 18187.0, 0.876, 78.7, 99.8, 'Europe', 'Europe centrale', '{"lat": 52.0, "lng": 19.0}'),
('hungary', 'Hongrie', 'HUN', 9660351, 93028, 'Budapest', 'Hongrois', 'Forint (HUF)', 'République parlementaire', 178.8, 18508.0, 0.846, 76.9, 99.1, 'Europe', 'Europe centrale', '{"lat": 47.0, "lng": 20.0}');

-- Vérification des pays ajoutés
SELECT 'Pays ajoutés avec succès' as status;
SELECT COUNT(*) as total_countries FROM country; 