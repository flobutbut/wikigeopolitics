-- Script final pour ajouter les pays manquants restants
-- Excluant tous les pays déjà présents

-- Afrique
INSERT INTO country (id, nom, capitale, continent, monnaie, langue, drapeau, coordonnees, current_regime_id) VALUES
('burundi', 'Burundi', 'Gitega', 'Afrique', 'Franc burundais', 'Kirundi, Français', '🇧🇮', ST_SetSRID(ST_MakePoint(29.9189, -3.3731), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('comoros', 'Comores', 'Moroni', 'Afrique', 'Franc comorien', 'Comorien, Arabe, Français', '🇰🇲', ST_SetSRID(ST_MakePoint(43.3333, -11.6455), 4326), (SELECT id FROM political_regime WHERE name = 'République fédérale')),
('djibouti', 'Djibouti', 'Djibouti', 'Afrique', 'Franc de Djibouti', 'Arabe, Français', '🇩🇯', ST_SetSRID(ST_MakePoint(42.5903, 11.8251), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('equatorial-guinea', 'Guinée équatoriale', 'Malabo', 'Afrique', 'Franc CFA', 'Espagnol, Français, Portugais', '🇬🇶', ST_SetSRID(ST_MakePoint(10.2679, 1.6508), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('gambia', 'Gambie', 'Banjul', 'Afrique', 'Dalasi', 'Anglais', '🇬🇲', ST_SetSRID(ST_MakePoint(-15.3101, 13.4432), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('guinea-bissau', 'Guinée-Bissau', 'Bissau', 'Afrique', 'Franc CFA', 'Portugais', '🇬🇼', ST_SetSRID(ST_MakePoint(-15.1804, 11.8037), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('lesotho', 'Lesotho', 'Maseru', 'Afrique', 'Loti', 'Sesotho, Anglais', '🇱🇸', ST_SetSRID(ST_MakePoint(28.2336, -29.6099), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('liberia', 'Libéria', 'Monrovia', 'Afrique', 'Dollar libérien', 'Anglais', '🇱🇷', ST_SetSRID(ST_MakePoint(-9.4295, 6.4281), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('madagascar', 'Madagascar', 'Antananarivo', 'Afrique', 'Ariary', 'Malgache, Français', '🇲🇬', ST_SetSRID(ST_MakePoint(46.8691, -18.7669), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('malawi', 'Malawi', 'Lilongwe', 'Afrique', 'Kwacha', 'Anglais, Chichewa', '🇲🇼', ST_SetSRID(ST_MakePoint(34.3015, -13.2543), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('mali', 'Mali', 'Bamako', 'Afrique', 'Franc CFA', 'Français', '🇲🇱', ST_SetSRID(ST_MakePoint(-3.9962, 17.5707), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('mauritania', 'Mauritanie', 'Nouakchott', 'Afrique', 'Ouguiya', 'Arabe', '🇲🇷', ST_SetSRID(ST_MakePoint(-10.9408, 21.0079), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('mauritius', 'Maurice', 'Port-Louis', 'Afrique', 'Roupie mauricienne', 'Anglais, Français', '🇲🇺', ST_SetSRID(ST_MakePoint(57.5522, -20.3484), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('mozambique', 'Mozambique', 'Maputo', 'Afrique', 'Metical', 'Portugais', '🇲🇿', ST_SetSRID(ST_MakePoint(32.5732, -25.9692), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('namibia', 'Namibie', 'Windhoek', 'Afrique', 'Dollar namibien', 'Anglais', '🇳🇦', ST_SetSRID(ST_MakePoint(17.0658, -22.5609), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('niger', 'Niger', 'Niamey', 'Afrique', 'Franc CFA', 'Français', '🇳🇪', ST_SetSRID(ST_MakePoint(8.0817, 17.6078), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('rwanda', 'Rwanda', 'Kigali', 'Afrique', 'Franc rwandais', 'Kinyarwanda, Français, Anglais', '🇷🇼', ST_SetSRID(ST_MakePoint(30.0596, -1.9403), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('senegal', 'Sénégal', 'Dakar', 'Afrique', 'Franc CFA', 'Français', '🇸🇳', ST_SetSRID(ST_MakePoint(-14.4524, 14.4974), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('seychelles', 'Seychelles', 'Victoria', 'Afrique', 'Roupie seychelloise', 'Créole seychellois, Anglais, Français', '🇸🇨', ST_SetSRID(ST_MakePoint(55.4920, -4.6796), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('sierra-leone', 'Sierra Leone', 'Freetown', 'Afrique', 'Leone', 'Anglais', '🇸🇱', ST_SetSRID(ST_MakePoint(-11.7799, 8.4606), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('swaziland', 'Eswatini', 'Mbabane', 'Afrique', 'Lilangeni', 'Anglais, Swati', '🇸🇿', ST_SetSRID(ST_MakePoint(31.4659, -26.5225), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie absolue')),
('tanzania', 'Tanzanie', 'Dodoma', 'Afrique', 'Shilling tanzanien', 'Swahili, Anglais', '🇹🇿', ST_SetSRID(ST_MakePoint(35.0745, -6.1730), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('togo', 'Togo', 'Lomé', 'Afrique', 'Franc CFA', 'Français', '🇹🇬', ST_SetSRID(ST_MakePoint(0.8248, 8.6195), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('tunisia', 'Tunisie', 'Tunis', 'Afrique', 'Dinar tunisien', 'Arabe', '🇹🇳', ST_SetSRID(ST_MakePoint(10.1815, 36.8065), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('uganda', 'Ouganda', 'Kampala', 'Afrique', 'Shilling ougandais', 'Anglais, Swahili', '🇺🇬', ST_SetSRID(ST_MakePoint(32.2903, 1.3733), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('zambia', 'Zambie', 'Lusaka', 'Afrique', 'Kwacha zambien', 'Anglais', '🇿🇲', ST_SetSRID(ST_MakePoint(27.8493, -13.1339), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('zimbabwe', 'Zimbabwe', 'Harare', 'Afrique', 'Dollar zimbabwéen', 'Anglais', '🇿🇼', ST_SetSRID(ST_MakePoint(29.1549, -19.0154), 4326), (SELECT id FROM political_regime WHERE name = 'République'));

-- Asie
INSERT INTO country (id, nom, capitale, continent, monnaie, langue, drapeau, coordonnees, current_regime_id) VALUES
('afghanistan', 'Afghanistan', 'Kaboul', 'Asie', 'Afghani', 'Pachto, Dari', '🇦🇫', ST_SetSRID(ST_MakePoint(67.7100, 33.9391), 4326), (SELECT id FROM political_regime WHERE name = 'République islamique')),
('bangladesh', 'Bangladesh', 'Dacca', 'Asie', 'Taka', 'Bengali', '🇧🇩', ST_SetSRID(ST_MakePoint(90.3563, 23.6850), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('bhutan', 'Bhoutan', 'Thimphou', 'Asie', 'Ngultrum', 'Dzongkha', '🇧🇹', ST_SetSRID(ST_MakePoint(90.4336, 27.5142), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('brunei', 'Brunei', 'Bandar Seri Begawan', 'Asie', 'Dollar de Brunei', 'Malais', '🇧🇳', ST_SetSRID(ST_MakePoint(114.7277, 4.5353), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie absolue')),
('cambodia', 'Cambodge', 'Phnom Penh', 'Asie', 'Riel', 'Khmer', '🇰🇭', ST_SetSRID(ST_MakePoint(104.9910, 12.5657), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('laos', 'Laos', 'Vientiane', 'Asie', 'Kip', 'Lao', '🇱🇦', ST_SetSRID(ST_MakePoint(102.4955, 19.8563), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('mongolia', 'Mongolie', 'Oulan-Bator', 'Asie', 'Tugrik', 'Mongol', '🇲🇳', ST_SetSRID(ST_MakePoint(103.8467, 46.8625), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('myanmar', 'Myanmar', 'Naypyidaw', 'Asie', 'Kyat', 'Birman', '🇲🇲', ST_SetSRID(ST_MakePoint(95.9560, 21.9162), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('nepal', 'Népal', 'Katmandou', 'Asie', 'Roupie népalaise', 'Népalais', '🇳🇵', ST_SetSRID(ST_MakePoint(84.1240, 28.3949), 4326), (SELECT id FROM political_regime WHERE name = 'République fédérale')),
('sri-lanka', 'Sri Lanka', 'Colombo', 'Asie', 'Roupie srilankaise', 'Cingalais, Tamoul', '🇱🇰', ST_SetSRID(ST_MakePoint(80.7718, 7.8731), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('vietnam', 'Vietnam', 'Hanoï', 'Asie', 'Dong', 'Vietnamien', '🇻🇳', ST_SetSRID(ST_MakePoint(108.2772, 14.0583), 4326), (SELECT id FROM political_regime WHERE name = 'République'));

-- Europe
INSERT INTO country (id, nom, capitale, continent, monnaie, langue, drapeau, coordonnees, current_regime_id) VALUES
('albania', 'Albanie', 'Tirana', 'Europe', 'Lek', 'Albanais', '🇦🇱', ST_SetSRID(ST_MakePoint(19.8187, 41.3275), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('andorra', 'Andorre', 'Andorre-la-Vieille', 'Europe', 'Euro', 'Catalan', '🇦🇩', ST_SetSRID(ST_MakePoint(1.5218, 42.5063), 4326), (SELECT id FROM political_regime WHERE name = 'Principauté')),
('belarus', 'Biélorussie', 'Minsk', 'Europe', 'Rouble biélorusse', 'Biélorusse, Russe', '🇧🇾', ST_SetSRID(ST_MakePoint(27.9534, 53.7098), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('bosnia-herzegovina', 'Bosnie-Herzégovine', 'Sarajevo', 'Europe', 'Mark convertible', 'Bosniaque, Croate, Serbe', '🇧🇦', ST_SetSRID(ST_MakePoint(17.6791, 43.9159), 4326), (SELECT id FROM political_regime WHERE name = 'République fédérale')),
('bulgaria', 'Bulgarie', 'Sofia', 'Europe', 'Lev', 'Bulgare', '🇧🇬', ST_SetSRID(ST_MakePoint(25.4858, 42.7339), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('croatia', 'Croatie', 'Zagreb', 'Europe', 'Euro', 'Croate', '🇭🇷', ST_SetSRID(ST_MakePoint(15.9819, 45.8150), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('czech-republic', 'République tchèque', 'Prague', 'Europe', 'Couronne tchèque', 'Tchèque', '🇨🇿', ST_SetSRID(ST_MakePoint(15.4730, 49.8175), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('estonia', 'Estonie', 'Tallinn', 'Europe', 'Euro', 'Estonien', '🇪🇪', ST_SetSRID(ST_MakePoint(25.0136, 58.5953), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('hungary', 'Hongrie', 'Budapest', 'Europe', 'Forint', 'Hongrois', '🇭🇺', ST_SetSRID(ST_MakePoint(19.5033, 47.1625), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('iceland', 'Islande', 'Reykjavik', 'Europe', 'Couronne islandaise', 'Islandais', '🇮🇸', ST_SetSRID(ST_MakePoint(-19.0208, 64.9631), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('kosovo', 'Kosovo', 'Pristina', 'Europe', 'Euro', 'Albanais, Serbe', '🇽🇰', ST_SetSRID(ST_MakePoint(20.9030, 42.6026), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('latvia', 'Lettonie', 'Riga', 'Europe', 'Euro', 'Letton', '🇱🇻', ST_SetSRID(ST_MakePoint(24.6032, 56.8796), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('liechtenstein', 'Liechtenstein', 'Vaduz', 'Europe', 'Franc suisse', 'Allemand', '🇱🇮', ST_SetSRID(ST_MakePoint(9.5554, 47.1660), 4326), (SELECT id FROM political_regime WHERE name = 'Principauté')),
('lithuania', 'Lituanie', 'Vilnius', 'Europe', 'Euro', 'Lituanien', '🇱🇹', ST_SetSRID(ST_MakePoint(23.8813, 55.1694), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('luxembourg', 'Luxembourg', 'Luxembourg', 'Europe', 'Euro', 'Luxembourgeois, Français, Allemand', '🇱🇺', ST_SetSRID(ST_MakePoint(6.1296, 49.8153), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('malta', 'Malte', 'La Valette', 'Europe', 'Euro', 'Maltais, Anglais', '🇲🇹', ST_SetSRID(ST_MakePoint(14.3754, 35.9375), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('moldova', 'Moldavie', 'Chișinău', 'Europe', 'Leu moldave', 'Roumain', '🇲🇩', ST_SetSRID(ST_MakePoint(28.3699, 47.4116), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('montenegro', 'Monténégro', 'Podgorica', 'Europe', 'Euro', 'Monténégrin', '🇲🇪', ST_SetSRID(ST_MakePoint(19.3744, 42.7087), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('north-macedonia', 'Macédoine du Nord', 'Skopje', 'Europe', 'Denar', 'Macédonien', '🇲🇰', ST_SetSRID(ST_MakePoint(21.7453, 41.6086), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('poland', 'Pologne', 'Varsovie', 'Europe', 'Złoty', 'Polonais', '🇵🇱', ST_SetSRID(ST_MakePoint(19.1451, 51.9194), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('romania', 'Roumanie', 'Bucarest', 'Europe', 'Leu roumain', 'Roumain', '🇷🇴', ST_SetSRID(ST_MakePoint(24.9668, 45.9432), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('san-marino', 'Saint-Marin', 'Saint-Marin', 'Europe', 'Euro', 'Italien', '🇸🇲', ST_SetSRID(ST_MakePoint(12.4578, 43.9424), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('serbia', 'Serbie', 'Belgrade', 'Europe', 'Dinar serbe', 'Serbe', '🇷🇸', ST_SetSRID(ST_MakePoint(21.0059, 44.0165), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('slovakia', 'Slovaquie', 'Bratislava', 'Europe', 'Euro', 'Slovaque', '🇸🇰', ST_SetSRID(ST_MakePoint(19.6990, 48.6690), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('slovenia', 'Slovénie', 'Ljubljana', 'Europe', 'Euro', 'Slovène', '🇸🇮', ST_SetSRID(ST_MakePoint(14.5058, 46.0569), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('ukraine', 'Ukraine', 'Kiev', 'Europe', 'Hryvnia', 'Ukrainien', '🇺🇦', ST_SetSRID(ST_MakePoint(31.1656, 48.3794), 4326), (SELECT id FROM political_regime WHERE name = 'République'));

-- Amérique
INSERT INTO country (id, nom, capitale, continent, monnaie, langue, drapeau, coordonnees, current_regime_id) VALUES
('antigua-and-barbuda', 'Antigua-et-Barbuda', 'Saint John''s', 'Amérique', 'Dollar des Caraïbes orientales', 'Anglais', '🇦🇬', ST_SetSRID(ST_MakePoint(-61.7964, 17.0608), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('bahamas', 'Bahamas', 'Nassau', 'Amérique', 'Dollar bahaméen', 'Anglais', '🇧🇸', ST_SetSRID(ST_MakePoint(-77.3963, 25.0343), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('barbados', 'Barbade', 'Bridgetown', 'Amérique', 'Dollar barbadien', 'Anglais', '🇧🇧', ST_SetSRID(ST_MakePoint(-59.5432, 13.1939), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('belize', 'Belize', 'Belmopan', 'Amérique', 'Dollar bélizien', 'Anglais', '🇧🇿', ST_SetSRID(ST_MakePoint(-88.4976, 17.1899), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('dominica', 'Dominique', 'Roseau', 'Amérique', 'Dollar des Caraïbes orientales', 'Anglais', '🇩🇲', ST_SetSRID(ST_MakePoint(-61.3710, 15.4150), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('el-salvador', 'El Salvador', 'San Salvador', 'Amérique', 'Dollar américain', 'Espagnol', '🇸🇻', ST_SetSRID(ST_MakePoint(-88.8965, 13.7942), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('grenada', 'Grenade', 'Saint George''s', 'Amérique', 'Dollar des Caraïbes orientales', 'Anglais', '🇬🇩', ST_SetSRID(ST_MakePoint(-61.6790, 12.1165), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('guatemala', 'Guatemala', 'Guatemala', 'Amérique', 'Quetzal', 'Espagnol', '🇬🇹', ST_SetSRID(ST_MakePoint(-90.2308, 15.7835), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('haiti', 'Haïti', 'Port-au-Prince', 'Amérique', 'Gourde', 'Créole haïtien, Français', '🇭🇹', ST_SetSRID(ST_MakePoint(-72.2852, 18.9712), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('honduras', 'Honduras', 'Tegucigalpa', 'Amérique', 'Lempira', 'Espagnol', '🇭🇳', ST_SetSRID(ST_MakePoint(-86.2419, 15.1999), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('jamaica', 'Jamaïque', 'Kingston', 'Amérique', 'Dollar jamaïcain', 'Anglais', '🇯🇲', ST_SetSRID(ST_MakePoint(-77.2975, 18.1096), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('nicaragua', 'Nicaragua', 'Managua', 'Amérique', 'Córdoba', 'Espagnol', '🇳🇮', ST_SetSRID(ST_MakePoint(-85.2072, 12.8654), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('panama', 'Panama', 'Panama', 'Amérique', 'Balboa', 'Espagnol', '🇵🇦', ST_SetSRID(ST_MakePoint(-80.7821, 8.5380), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('paraguay', 'Paraguay', 'Asunción', 'Amérique', 'Guaraní', 'Espagnol, Guarani', '🇵🇾', ST_SetSRID(ST_MakePoint(-58.4438, -23.4425), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('saint-kitts-and-nevis', 'Saint-Kitts-et-Nevis', 'Basseterre', 'Amérique', 'Dollar des Caraïbes orientales', 'Anglais', '🇰🇳', ST_SetSRID(ST_MakePoint(-62.7830, 17.3578), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('saint-lucia', 'Sainte-Lucie', 'Castries', 'Amérique', 'Dollar des Caraïbes orientales', 'Anglais', '🇱🇨', ST_SetSRID(ST_MakePoint(-60.9789, 13.9094), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('saint-vincent-and-grenadines', 'Saint-Vincent-et-les-Grenadines', 'Kingstown', 'Amérique', 'Dollar des Caraïbes orientales', 'Anglais', '🇻🇨', ST_SetSRID(ST_MakePoint(-61.2872, 12.9843), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('suriname', 'Suriname', 'Paramaribo', 'Amérique', 'Dollar surinamais', 'Néerlandais', '🇸🇷', ST_SetSRID(ST_MakePoint(-56.0278, 3.9193), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('trinidad-and-tobago', 'Trinité-et-Tobago', 'Port of Spain', 'Amérique', 'Dollar de Trinité-et-Tobago', 'Anglais', '🇹🇹', ST_SetSRID(ST_MakePoint(-61.5190, 10.6598), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('uruguay', 'Uruguay', 'Montevideo', 'Amérique', 'Peso uruguayen', 'Espagnol', '🇺🇾', ST_SetSRID(ST_MakePoint(-55.7658, -32.5228), 4326), (SELECT id FROM political_regime WHERE name = 'République'));

-- Océanie
INSERT INTO country (id, nom, capitale, continent, monnaie, langue, drapeau, coordonnees, current_regime_id) VALUES
('fiji', 'Fidji', 'Suva', 'Océanie', 'Dollar fidjien', 'Anglais, Fidjien, Hindi', '🇫🇯', ST_SetSRID(ST_MakePoint(178.0650, -17.7134), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('marshall-islands', 'Îles Marshall', 'Majuro', 'Océanie', 'Dollar américain', 'Marshallais, Anglais', '🇲🇭', ST_SetSRID(ST_MakePoint(171.1845, 7.1315), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('micronesia', 'Micronésie', 'Palikir', 'Océanie', 'Dollar américain', 'Anglais', '🇫🇲', ST_SetSRID(ST_MakePoint(158.1618, 6.9248), 4326), (SELECT id FROM political_regime WHERE name = 'République fédérale')),
('nauru', 'Nauru', 'Yaren', 'Océanie', 'Dollar australien', 'Nauruan, Anglais', '🇳🇷', ST_SetSRID(ST_MakePoint(166.9315, -0.5228), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('palau', 'Palaos', 'Ngerulmud', 'Océanie', 'Dollar américain', 'Paluan, Anglais', '🇵🇼', ST_SetSRID(ST_MakePoint(134.5825, 7.5150), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('papua-new-guinea', 'Papouasie-Nouvelle-Guinée', 'Port Moresby', 'Océanie', 'Kina', 'Anglais, Tok Pisin, Hiri Motu', '🇵🇬', ST_SetSRID(ST_MakePoint(143.9555, -6.3150), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('samoa', 'Samoa', 'Apia', 'Océanie', 'Tala', 'Samoan, Anglais', '🇼🇸', ST_SetSRID(ST_MakePoint(-171.7514, -13.8508), 4326), (SELECT id FROM political_regime WHERE name = 'République')),
('solomon-islands', 'Îles Salomon', 'Honiara', 'Océanie', 'Dollar des Îles Salomon', 'Anglais', '🇸🇧', ST_SetSRID(ST_MakePoint(159.9498, -9.4438), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('tonga', 'Tonga', 'Nuku''alofa', 'Océanie', 'Pa''anga', 'Tongien, Anglais', '🇹🇴', ST_SetSRID(ST_MakePoint(-175.2020, -21.1390), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('tuvalu', 'Tuvalu', 'Funafuti', 'Océanie', 'Dollar australien', 'Tuvaluan, Anglais', '🇹🇻', ST_SetSRID(ST_MakePoint(177.6493, -7.1095), 4326), (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle')),
('vanuatu', 'Vanuatu', 'Port-Vila', 'Océanie', 'Vatu', 'Bichelamar, Anglais, Français', '🇻🇺', ST_SetSRID(ST_MakePoint(166.9592, -15.3767), 4326), (SELECT id FROM political_regime WHERE name = 'République'));

-- Vérification finale
SELECT COUNT(*) as total_pays FROM country; 