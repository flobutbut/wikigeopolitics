-- Ajout des pays manquants (version simplifiée)
-- Script: 14-add-missing-countries-simple.sql

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
('taiwan', 'Taïwan', 'Taipei', 'Mandarin', 'Dollar taïwanais (TWD)', ST_SetSRID(ST_MakePoint(121.0, 23.5), 4326)),
('switzerland', 'Suisse', 'Berne', 'Allemand, Français, Italien', 'Franc suisse (CHF)', ST_SetSRID(ST_MakePoint(8.0, 47.0), 4326)),
('singapore', 'Singapour', 'Singapour', 'Anglais, Mandarin, Malais, Tamoul', 'Dollar de Singapour (SGD)', ST_SetSRID(ST_MakePoint(103.8, 1.3), 4326)),
('netherlands', 'Pays-Bas', 'Amsterdam', 'Néerlandais', 'Euro (EUR)', ST_SetSRID(ST_MakePoint(5.5, 52.0), 4326)),
('uae', 'Émirats arabes unis', 'Abu Dhabi', 'Arabe', 'Dirham des Émirats (AED)', ST_SetSRID(ST_MakePoint(54.0, 24.0), 4326)),

-- Pays pour les données démographiques
('pakistan', 'Pakistan', 'Islamabad', 'Ourdou, Anglais', 'Roupie pakistanaise (PKR)', ST_SetSRID(ST_MakePoint(70.0, 30.0), 4326)),
('nigeria', 'Nigeria', 'Abuja', 'Anglais', 'Naira (NGN)', ST_SetSRID(ST_MakePoint(8.0, 10.0), 4326)),

-- Pays pour les données de ressources naturelles
('qatar', 'Qatar', 'Doha', 'Arabe', 'Riyal qatari (QAR)', ST_SetSRID(ST_MakePoint(51.3, 25.5), 4326)),
('kazakhstan', 'Kazakhstan', 'Nour-Soultan', 'Kazakh, Russe', 'Tenge (KZT)', ST_SetSRID(ST_MakePoint(68.0, 48.0), 4326)),
('namibia', 'Namibie', 'Windhoek', 'Anglais', 'Dollar namibien (NAD)', ST_SetSRID(ST_MakePoint(17.0, -22.0), 4326)),
('uzbekistan', 'Ouzbékistan', 'Tachkent', 'Ouzbek', 'Sum (UZS)', ST_SetSRID(ST_MakePoint(64.0, 41.0), 4326)),
('chile', 'Chili', 'Santiago', 'Espagnol', 'Peso chilien (CLP)', ST_SetSRID(ST_MakePoint(-71.0, -30.0), 4326)),
('bolivia', 'Bolivie', 'La Paz', 'Espagnol', 'Boliviano (BOB)', ST_SetSRID(ST_MakePoint(-65.0, -17.0), 4326)),
('peru', 'Pérou', 'Lima', 'Espagnol', 'Sol (PEN)', ST_SetSRID(ST_MakePoint(-76.0, -10.0), 4326)),
('botswana', 'Botswana', 'Gaborone', 'Anglais, Tswana', 'Pula (BWP)', ST_SetSRID(ST_MakePoint(24.0, -22.0), 4326)),
('drc', 'République démocratique du Congo', 'Kinshasa', 'Français', 'Franc congolais (CDF)', ST_SetSRID(ST_MakePoint(25.0, 0.0), 4326)),
('congo', 'République du Congo', 'Brazzaville', 'Français', 'Franc CFA (XAF)', ST_SetSRID(ST_MakePoint(15.0, -1.0), 4326)),
('philippines', 'Philippines', 'Manille', 'Filipino, Anglais', 'Peso philippin (PHP)', ST_SetSRID(ST_MakePoint(122.0, 13.0), 4326)),
('new-caledonia', 'Nouvelle-Calédonie', 'Nouméa', 'Français', 'Franc CFP (XPF)', ST_SetSRID(ST_MakePoint(165.5, -21.5), 4326)),
('cuba', 'Cuba', 'La Havane', 'Espagnol', 'Peso cubain (CUP)', ST_SetSRID(ST_MakePoint(-80.0, 21.5), 4326)),

-- Pays pour les données industrielles
('turkey', 'Turquie', 'Ankara', 'Turc', 'Livre turque (TRY)', ST_SetSRID(ST_MakePoint(35.0, 39.0), 4326)),

-- Pays pour les données de transport
('iraq', 'Irak', 'Bagdad', 'Arabe', 'Dinar irakien (IQD)', ST_SetSRID(ST_MakePoint(44.0, 33.0), 4326)),
('ethiopia', 'Éthiopie', 'Addis-Abeba', 'Amharique', 'Birr (ETB)', ST_SetSRID(ST_MakePoint(40.0, 9.0), 4326)),
('eritrea', 'Érythrée', 'Asmara', 'Tigrinya', 'Nakfa (ERN)', ST_SetSRID(ST_MakePoint(39.0, 15.0), 4326)),
('libya', 'Libye', 'Tripoli', 'Arabe', 'Dinar libyen (LYD)', ST_SetSRID(ST_MakePoint(17.0, 25.0), 4326)),
('mali', 'Mali', 'Bamako', 'Français', 'Franc CFA (XOF)', ST_SetSRID(ST_MakePoint(-4.0, 17.0), 4326)),
('niger', 'Niger', 'Niamey', 'Français', 'Franc CFA (XOF)', ST_SetSRID(ST_MakePoint(8.0, 18.0), 4326)),
('burkina-faso', 'Burkina Faso', 'Ouagadougou', 'Français', 'Franc CFA (XOF)', ST_SetSRID(ST_MakePoint(-2.0, 12.0), 4326)),
('chad', 'Tchad', 'N''Djamena', 'Français, Arabe', 'Franc CFA (XAF)', ST_SetSRID(ST_MakePoint(19.0, 15.0), 4326)),
('somalia', 'Somalie', 'Mogadiscio', 'Somali, Arabe', 'Shilling somalien (SOS)', ST_SetSRID(ST_MakePoint(49.0, 10.0), 4326)),
('central-african-republic', 'République centrafricaine', 'Bangui', 'Français', 'Franc CFA (XAF)', ST_SetSRID(ST_MakePoint(21.0, 7.0), 4326)),
('south-sudan', 'Soudan du Sud', 'Djouba', 'Anglais', 'Livre sud-soudanaise (SSP)', ST_SetSRID(ST_MakePoint(30.0, 7.0), 4326)),
('democratic-republic-of-congo', 'République démocratique du Congo', 'Kinshasa', 'Français', 'Franc congolais (CDF)', ST_SetSRID(ST_MakePoint(25.0, 0.0), 4326)),
('rwanda', 'Rwanda', 'Kigali', 'Kinyarwanda, Français, Anglais', 'Franc rwandais (RWF)', ST_SetSRID(ST_MakePoint(30.0, -2.0), 4326)),
('uganda', 'Ouganda', 'Kampala', 'Anglais', 'Shilling ougandais (UGX)', ST_SetSRID(ST_MakePoint(32.0, 1.0), 4326)),
('sri-lanka', 'Sri Lanka', 'Colombo', 'Cingalais, Tamoul', 'Roupie srilankaise (LKR)', ST_SetSRID(ST_MakePoint(81.0, 7.0), 4326)),
('serbia', 'Serbie', 'Belgrade', 'Serbe', 'Dinar serbe (RSD)', ST_SetSRID(ST_MakePoint(21.0, 44.0), 4326)),
('croatia', 'Croatie', 'Zagreb', 'Croate', 'Kuna (HRK)', ST_SetSRID(ST_MakePoint(15.0, 45.0), 4326)),
('bosnia-herzegovina', 'Bosnie-Herzégovine', 'Sarajevo', 'Bosniaque, Croate, Serbe', 'Mark convertible (BAM)', ST_SetSRID(ST_MakePoint(18.0, 44.0), 4326)),
('kosovo', 'Kosovo', 'Pristina', 'Albanais, Serbe', 'Euro (EUR)', ST_SetSRID(ST_MakePoint(21.0, 42.6), 4326)),
('afghanistan', 'Afghanistan', 'Kaboul', 'Pachto, Dari', 'Afghani (AFN)', ST_SetSRID(ST_MakePoint(65.0, 33.0), 4326)),
('poland', 'Pologne', 'Varsovie', 'Polonais', 'Zloty (PLN)', ST_SetSRID(ST_MakePoint(19.0, 52.0), 4326)),
('hungary', 'Hongrie', 'Budapest', 'Hongrois', 'Forint (HUF)', ST_SetSRID(ST_MakePoint(20.0, 47.0), 4326));

-- Vérification des pays ajoutés
SELECT 'Pays ajoutés avec succès' as status;
SELECT COUNT(*) as total_countries FROM country; 