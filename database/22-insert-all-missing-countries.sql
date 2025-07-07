-- Ajout de tous les pays manquants pour une couverture mondiale complète
-- Organisé par continents

-- EUROPE (pays manquants)
INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id) VALUES
('italy', 'Italie', 'https://flagcdn.com/it.svg', 'Rome', 'Italien', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(12.4964, 41.9028), 4326), 'republique-parlementaire'),
('spain', 'Espagne', 'https://flagcdn.com/es.svg', 'Madrid', 'Espagnol', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(-3.7492, 40.4168), 4326), 'monarchie-constitutionnelle'),
('portugal', 'Portugal', 'https://flagcdn.com/pt.svg', 'Lisbonne', 'Portugais', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(-9.1393, 38.7223), 4326), 'republique-parlementaire'),
('belgium', 'Belgique', 'https://flagcdn.com/be.svg', 'Bruxelles', 'Néerlandais, Français, Allemand', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(4.3517, 50.8503), 4326), 'monarchie-constitutionnelle'),
('austria', 'Autriche', 'https://flagcdn.com/at.svg', 'Vienne', 'Allemand', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(16.3738, 48.2082), 4326), 'republique-parlementaire'),
('sweden', 'Suède', 'https://flagcdn.com/se.svg', 'Stockholm', 'Suédois', 'Couronne suédoise (SEK)', 'Europe', ST_SetSRID(ST_MakePoint(18.0686, 59.3293), 4326), 'monarchie-constitutionnelle'),
('norway', 'Norvège', 'https://flagcdn.com/no.svg', 'Oslo', 'Norvégien', 'Couronne norvégienne (NOK)', 'Europe', ST_SetSRID(ST_MakePoint(10.7522, 59.9139), 4326), 'monarchie-constitutionnelle'),
('denmark', 'Danemark', 'https://flagcdn.com/dk.svg', 'Copenhague', 'Danois', 'Couronne danoise (DKK)', 'Europe', ST_SetSRID(ST_MakePoint(12.5683, 55.6761), 4326), 'monarchie-constitutionnelle'),
('finland', 'Finlande', 'https://flagcdn.com/fi.svg', 'Helsinki', 'Finnois, Suédois', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(24.9384, 60.1699), 4326), 'republique-parlementaire'),
('ireland', 'Irlande', 'https://flagcdn.com/ie.svg', 'Dublin', 'Anglais, Irlandais', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(-6.2603, 53.3498), 4326), 'republique-parlementaire'),
('greece', 'Grèce', 'https://flagcdn.com/gr.svg', 'Athènes', 'Grec', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(23.7275, 37.9838), 4326), 'republique-parlementaire'),
('czech-republic', 'République tchèque', 'https://flagcdn.com/cz.svg', 'Prague', 'Tchèque', 'Couronne tchèque (CZK)', 'Europe', ST_SetSRID(ST_MakePoint(14.4208, 50.0755), 4326), 'republique-parlementaire'),
('slovakia', 'Slovaquie', 'https://flagcdn.com/sk.svg', 'Bratislava', 'Slovaque', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(17.1077, 48.1486), 4326), 'republique-parlementaire'),
('romania', 'Roumanie', 'https://flagcdn.com/ro.svg', 'Bucarest', 'Roumain', 'Leu roumain (RON)', 'Europe', ST_SetSRID(ST_MakePoint(26.1025, 44.4268), 4326), 'republique-parlementaire'),
('bulgaria', 'Bulgarie', 'https://flagcdn.com/bg.svg', 'Sofia', 'Bulgare', 'Lev bulgare (BGN)', 'Europe', ST_SetSRID(ST_MakePoint(23.3219, 42.6977), 4326), 'republique-parlementaire'),
('latvia', 'Lettonie', 'https://flagcdn.com/lv.svg', 'Riga', 'Letton', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(24.1052, 56.9496), 4326), 'republique-parlementaire'),
('lithuania', 'Lituanie', 'https://flagcdn.com/lt.svg', 'Vilnius', 'Lituanien', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(25.2797, 54.6872), 4326), 'republique-parlementaire'),
('estonia', 'Estonie', 'https://flagcdn.com/ee.svg', 'Tallinn', 'Estonien', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(24.7536, 59.4370), 4326), 'republique-parlementaire'),
('slovenia', 'Slovénie', 'https://flagcdn.com/si.svg', 'Ljubljana', 'Slovène', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(14.5058, 46.0569), 4326), 'republique-parlementaire'),
('luxembourg', 'Luxembourg', 'https://flagcdn.com/lu.svg', 'Luxembourg', 'Luxembourgeois, Français, Allemand', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(6.1296, 49.6116), 4326), 'monarchie-constitutionnelle'),
('malta', 'Malte', 'https://flagcdn.com/mt.svg', 'La Valette', 'Maltais, Anglais', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(14.5146, 35.8989), 4326), 'republique-parlementaire'),
('iceland', 'Islande', 'https://flagcdn.com/is.svg', 'Reykjavik', 'Islandais', 'Couronne islandaise (ISK)', 'Europe', ST_SetSRID(ST_MakePoint(-21.9426, 64.1466), 4326), 'republique-parlementaire'),
('cyprus', 'Chypre', 'https://flagcdn.com/cy.svg', 'Nicosie', 'Grec, Turc', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(33.3823, 35.1856), 4326), 'republique-presidentielle');

-- ASIE (pays manquants)
INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id) VALUES
('malaysia', 'Malaisie', 'https://flagcdn.com/my.svg', 'Kuala Lumpur', 'Malais', 'Ringgit malaisien (MYR)', 'Asie', ST_SetSRID(ST_MakePoint(101.6869, 3.1390), 4326), 'monarchie-constitutionnelle'),
('myanmar', 'Myanmar', 'https://flagcdn.com/mm.svg', 'Naypyidaw', 'Birman', 'Kyat (MMK)', 'Asie', ST_SetSRID(ST_MakePoint(96.1345, 19.7633), 4326), 'regime-autoritaire'),
('cambodia', 'Cambodge', 'https://flagcdn.com/kh.svg', 'Phnom Penh', 'Khmer', 'Riel (KHR)', 'Asie', ST_SetSRID(ST_MakePoint(104.9160, 11.5564), 4326), 'monarchie-constitutionnelle'),
('laos', 'Laos', 'https://flagcdn.com/la.svg', 'Vientiane', 'Lao', 'Kip (LAK)', 'Asie', ST_SetSRID(ST_MakePoint(102.6333, 17.9757), 4326), 'regime-autoritaire'),
('mongolia', 'Mongolie', 'https://flagcdn.com/mn.svg', 'Oulan-Bator', 'Mongol', 'Tugrik (MNT)', 'Asie', ST_SetSRID(ST_MakePoint(106.9057, 47.8864), 4326), 'republique-parlementaire'),
('nepal', 'Népal', 'https://flagcdn.com/np.svg', 'Katmandou', 'Népalais', 'Roupie népalaise (NPR)', 'Asie', ST_SetSRID(ST_MakePoint(85.3240, 27.7172), 4326), 'republique-federale'),
('bhutan', 'Bhoutan', 'https://flagcdn.com/bt.svg', 'Thimphou', 'Dzongkha', 'Ngultrum (BTN)', 'Asie', ST_SetSRID(ST_MakePoint(89.6380, 27.4716), 4326), 'monarchie-constitutionnelle'),
('brunei', 'Brunei', 'https://flagcdn.com/bn.svg', 'Bandar Seri Begawan', 'Malais', 'Dollar de Brunei (BND)', 'Asie', ST_SetSRID(ST_MakePoint(114.9403, 4.8903), 4326), 'monarchie-absolue'),
('east-timor', 'Timor oriental', 'https://flagcdn.com/tl.svg', 'Dili', 'Tétoum, Portugais', 'Dollar américain (USD)', 'Asie', ST_SetSRID(ST_MakePoint(125.5736, -8.5586), 4326), 'republique-presidentielle'),
('maldives', 'Maldives', 'https://flagcdn.com/mv.svg', 'Malé', 'Divehi', 'Rufiyaa (MVR)', 'Asie', ST_SetSRID(ST_MakePoint(73.2207, 3.2028), 4326), 'republique-presidentielle');

-- AMÉRIQUE (pays manquants)
INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id) VALUES
('colombia', 'Colombie', 'https://flagcdn.com/co.svg', 'Bogota', 'Espagnol', 'Peso colombien (COP)', 'Amérique du Sud', ST_SetSRID(ST_MakePoint(-74.0721, 4.7110), 4326), 'republique-presidentielle'),
('venezuela', 'Venezuela', 'https://flagcdn.com/ve.svg', 'Caracas', 'Espagnol', 'Bolivar (VES)', 'Amérique du Sud', ST_SetSRID(ST_MakePoint(-66.9036, 10.4806), 4326), 'regime-autoritaire'),
('ecuador', 'Équateur', 'https://flagcdn.com/ec.svg', 'Quito', 'Espagnol', 'Dollar américain (USD)', 'Amérique du Sud', ST_SetSRID(ST_MakePoint(-78.4678, -0.2299), 4326), 'republique-presidentielle'),
('uruguay', 'Uruguay', 'https://flagcdn.com/uy.svg', 'Montevideo', 'Espagnol', 'Peso uruguayen (UYU)', 'Amérique du Sud', ST_SetSRID(ST_MakePoint(-56.1645, -34.9011), 4326), 'republique-presidentielle'),
('paraguay', 'Paraguay', 'https://flagcdn.com/py.svg', 'Asunción', 'Espagnol, Guarani', 'Guarani (PYG)', 'Amérique du Sud', ST_SetSRID(ST_MakePoint(-57.6333, -25.2637), 4326), 'republique-presidentielle'),
('guyana', 'Guyana', 'https://flagcdn.com/gy.svg', 'Georgetown', 'Anglais', 'Dollar de Guyana (GYD)', 'Amérique du Sud', ST_SetSRID(ST_MakePoint(-58.1553, 6.8013), 4326), 'republique-presidentielle'),
('suriname', 'Suriname', 'https://flagcdn.com/sr.svg', 'Paramaribo', 'Néerlandais', 'Dollar du Suriname (SRD)', 'Amérique du Sud', ST_SetSRID(ST_MakePoint(-55.2038, 5.8520), 4326), 'republique-presidentielle');

-- AFRIQUE (pays manquants)
INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id) VALUES
('senegal', 'Sénégal', 'https://flagcdn.com/sn.svg', 'Dakar', 'Français', 'Franc CFA (XOF)', 'Afrique', ST_SetSRID(ST_MakePoint(-17.4441, 14.7167), 4326), 'republique-presidentielle'),
('ghana', 'Ghana', 'https://flagcdn.com/gh.svg', 'Accra', 'Anglais', 'Cedi (GHS)', 'Afrique', ST_SetSRID(ST_MakePoint(-0.1869, 5.5600), 4326), 'republique-presidentielle'),
('cameroon', 'Cameroun', 'https://flagcdn.com/cm.svg', 'Yaoundé', 'Français, Anglais', 'Franc CFA (XAF)', 'Afrique', ST_SetSRID(ST_MakePoint(11.5021, 3.8480), 4326), 'republique-presidentielle'),
('gabon', 'Gabon', 'https://flagcdn.com/ga.svg', 'Libreville', 'Français', 'Franc CFA (XAF)', 'Afrique', ST_SetSRID(ST_MakePoint(9.4673, 0.4162), 4326), 'republique-presidentielle'),
('equatorial-guinea', 'Guinée équatoriale', 'https://flagcdn.com/gq.svg', 'Malabo', 'Espagnol, Français, Portugais', 'Franc CFA (XAF)', 'Afrique', ST_SetSRID(ST_MakePoint(8.7833, 3.7523), 4326), 'regime-autoritaire'),
('guinea', 'Guinée', 'https://flagcdn.com/gn.svg', 'Conakry', 'Français', 'Franc guinéen (GNF)', 'Afrique', ST_SetSRID(ST_MakePoint(-13.7126, 9.5370), 4326), 'regime-autoritaire'),
('sierra-leone', 'Sierra Leone', 'https://flagcdn.com/sl.svg', 'Freetown', 'Anglais', 'Leone (SLL)', 'Afrique', ST_SetSRID(ST_MakePoint(-13.2317, 8.4606), 4326), 'republique-presidentielle'),
('liberia', 'Libéria', 'https://flagcdn.com/lr.svg', 'Monrovia', 'Anglais', 'Dollar libérien (LRD)', 'Afrique', ST_SetSRID(ST_MakePoint(-10.7979, 6.3004), 4326), 'republique-presidentielle'),
('togo', 'Togo', 'https://flagcdn.com/tg.svg', 'Lomé', 'Français', 'Franc CFA (XOF)', 'Afrique', ST_SetSRID(ST_MakePoint(1.2228, 6.1375), 4326), 'republique-presidentielle'),
('benin', 'Bénin', 'https://flagcdn.com/bj.svg', 'Porto-Novo', 'Français', 'Franc CFA (XOF)', 'Afrique', ST_SetSRID(ST_MakePoint(2.6042, 6.4969), 4326), 'republique-presidentielle'),
('gambia', 'Gambie', 'https://flagcdn.com/gm.svg', 'Banjul', 'Anglais', 'Dalasi (GMD)', 'Afrique', ST_SetSRID(ST_MakePoint(-16.5790, 13.4432), 4326), 'republique-presidentielle'),
('guinea-bissau', 'Guinée-Bissau', 'https://flagcdn.com/gw.svg', 'Bissau', 'Portugais', 'Franc CFA (XOF)', 'Afrique', ST_SetSRID(ST_MakePoint(-15.5846, 11.8636), 4326), 'republique-presidentielle'),
('cape-verde', 'Cap-Vert', 'https://flagcdn.com/cv.svg', 'Praia', 'Portugais', 'Escudo cap-verdien (CVE)', 'Afrique', ST_SetSRID(ST_MakePoint(-23.5087, 14.9318), 4326), 'republique-presidentielle'),
('mauritania', 'Mauritanie', 'https://flagcdn.com/mr.svg', 'Nouakchott', 'Arabe', 'Ouguiya (MRU)', 'Afrique', ST_SetSRID(ST_MakePoint(-15.9582, 18.0799), 4326), 'republique-presidentielle'),
('djibouti', 'Djibouti', 'https://flagcdn.com/dj.svg', 'Djibouti', 'Français, Arabe', 'Franc de Djibouti (DJF)', 'Afrique', ST_SetSRID(ST_MakePoint(43.1453, 11.5721), 4326), 'republique-presidentielle'),
('comoros', 'Comores', 'https://flagcdn.com/km.svg', 'Moroni', 'Arabe, Français, Comorien', 'Franc comorien (KMF)', 'Afrique', ST_SetSRID(ST_MakePoint(43.2439, -11.6455), 4326), 'republique-presidentielle'),
('seychelles', 'Seychelles', 'https://flagcdn.com/sc.svg', 'Victoria', 'Français, Anglais, Créole seychellois', 'Roupie seychelloise (SCR)', 'Afrique', ST_SetSRID(ST_MakePoint(55.4544, -4.6191), 4326), 'republique-presidentielle'),
('mauritius', 'Maurice', 'https://flagcdn.com/mu.svg', 'Port-Louis', 'Anglais, Français', 'Roupie mauricienne (MUR)', 'Afrique', ST_SetSRID(ST_MakePoint(57.5522, -20.1609), 4326), 'republique-presidentielle'),
('madagascar', 'Madagascar', 'https://flagcdn.com/mg.svg', 'Antananarivo', 'Malgache, Français', 'Ariary (MGA)', 'Afrique', ST_SetSRID(ST_MakePoint(47.5361, -18.8792), 4326), 'republique-presidentielle'),
('mozambique', 'Mozambique', 'https://flagcdn.com/mz.svg', 'Maputo', 'Portugais', 'Metical (MZN)', 'Afrique', ST_SetSRID(ST_MakePoint(32.5732, -25.9692), 4326), 'republique-presidentielle'),
('zimbabwe', 'Zimbabwe', 'https://flagcdn.com/zw.svg', 'Harare', 'Anglais, Shona, Ndebele', 'Dollar zimbabwéen (ZWL)', 'Afrique', ST_SetSRID(ST_MakePoint(31.0335, -17.8252), 4326), 'regime-autoritaire'),
('zambia', 'Zambie', 'https://flagcdn.com/zm.svg', 'Lusaka', 'Anglais', 'Kwacha zambien (ZMW)', 'Afrique', ST_SetSRID(ST_MakePoint(28.2937, -15.3875), 4326), 'republique-presidentielle'),
('malawi', 'Malawi', 'https://flagcdn.com/mw.svg', 'Lilongwe', 'Anglais, Chichewa', 'Kwacha malawite (MWK)', 'Afrique', ST_SetSRID(ST_MakePoint(33.7873, -13.9626), 4326), 'republique-presidentielle'),
('lesotho', 'Lesotho', 'https://flagcdn.com/ls.svg', 'Maseru', 'Anglais, Sotho', 'Loti (LSL)', 'Afrique', ST_SetSRID(ST_MakePoint(27.4786, -29.3142), 4326), 'monarchie-constitutionnelle'),
('eswatini', 'Eswatini', 'https://flagcdn.com/sz.svg', 'Mbabane', 'Anglais, Swati', 'Lilangeni (SZL)', 'Afrique', ST_SetSRID(ST_MakePoint(31.4659, -26.5225), 4326), 'monarchie-absolue');

-- OCÉANIE (pays manquants)
INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id) VALUES
('papua-new-guinea', 'Papouasie-Nouvelle-Guinée', 'https://flagcdn.com/pg.svg', 'Port Moresby', 'Anglais, Tok Pisin', 'Kina (PGK)', 'Océanie', ST_SetSRID(ST_MakePoint(147.1803, -9.4438), 4326), 'monarchie-constitutionnelle'),
('fiji', 'Fidji', 'https://flagcdn.com/fj.svg', 'Suva', 'Anglais, Fidjien', 'Dollar fidjien (FJD)', 'Océanie', ST_SetSRID(ST_MakePoint(178.4419, -18.1416), 4326), 'republique-presidentielle'),
('solomon-islands', 'Îles Salomon', 'https://flagcdn.com/sb.svg', 'Honiara', 'Anglais', 'Dollar des Îles Salomon (SBD)', 'Océanie', ST_SetSRID(ST_MakePoint(160.1564, -9.6457), 4326), 'monarchie-constitutionnelle'),
('vanuatu', 'Vanuatu', 'https://flagcdn.com/vu.svg', 'Port-Vila', 'Français, Anglais, Bichelamar', 'Vatu (VUV)', 'Océanie', ST_SetSRID(ST_MakePoint(168.3200, -17.7333), 4326), 'republique-presidentielle'),
('new-caledonia', 'Nouvelle-Calédonie', 'https://flagcdn.com/nc.svg', 'Nouméa', 'Français', 'Franc CFP (XPF)', 'Océanie', ST_SetSRID(ST_MakePoint(165.6180, -20.9043), 4326), 'territoire-francais'),
('french-polynesia', 'Polynésie française', 'https://flagcdn.com/pf.svg', 'Papeete', 'Français', 'Franc CFP (XPF)', 'Océanie', ST_SetSRID(ST_MakePoint(-149.5694, -17.6797), 4326), 'territoire-francais'),
('wallis-futuna', 'Wallis-et-Futuna', 'https://flagcdn.com/wf.svg', 'Mata-Utu', 'Français', 'Franc CFP (XPF)', 'Océanie', ST_SetSRID(ST_MakePoint(-178.1165, -14.2938), 4326), 'territoire-francais'); 