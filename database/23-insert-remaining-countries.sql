-- Ajout des 45 pays manquants pour atteindre 196 pays souverains

-- EUROPE (pays manquants)
INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id) VALUES
('albania', 'Albanie', 'https://flagcdn.com/al.svg', 'Tirana', 'Albanais', 'Lek (ALL)', 'Europe', ST_SetSRID(ST_MakePoint(19.8187, 41.3275), 4326), 'republique-parlementaire'),
('andorra', 'Andorre', 'https://flagcdn.com/ad.svg', 'Andorre-la-Vieille', 'Catalan', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(1.5218, 42.5063), 4326), 'monarchie-constitutionnelle'),
('armenia', 'Arménie', 'https://flagcdn.com/am.svg', 'Erevan', 'Arménien', 'Dram (AMD)', 'Europe', ST_SetSRID(ST_MakePoint(44.5035, 40.1872), 4326), 'republique-presidentielle'),
('azerbaijan', 'Azerbaïdjan', 'https://flagcdn.com/az.svg', 'Bakou', 'Azéri', 'Manat (AZN)', 'Europe', ST_SetSRID(ST_MakePoint(49.8671, 40.3777), 4326), 'republique-presidentielle'),
('belarus', 'Biélorussie', 'https://flagcdn.com/by.svg', 'Minsk', 'Biélorusse, Russe', 'Rouble biélorusse (BYN)', 'Europe', ST_SetSRID(ST_MakePoint(27.5615, 53.9023), 4326), 'regime-autoritaire'),
('georgia', 'Géorgie', 'https://flagcdn.com/ge.svg', 'Tbilissi', 'Géorgien', 'Lari (GEL)', 'Europe', ST_SetSRID(ST_MakePoint(44.7833, 41.7151), 4326), 'republique-presidentielle'),
('moldova', 'Moldavie', 'https://flagcdn.com/md.svg', 'Chișinău', 'Roumain', 'Leu moldave (MDL)', 'Europe', ST_SetSRID(ST_MakePoint(28.8577, 47.0105), 4326), 'republique-parlementaire'),
('montenegro', 'Monténégro', 'https://flagcdn.com/me.svg', 'Podgorica', 'Monténégrin', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(19.2594, 42.4304), 4326), 'republique-presidentielle'),
('north-macedonia', 'Macédoine du Nord', 'https://flagcdn.com/mk.svg', 'Skopje', 'Macédonien', 'Denar (MKD)', 'Europe', ST_SetSRID(ST_MakePoint(21.4314, 42.0027), 4326), 'republique-parlementaire'),
('monaco', 'Monaco', 'https://flagcdn.com/mc.svg', 'Monaco', 'Français', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(7.4167, 43.7333), 4326), 'monarchie-constitutionnelle'),
('san-marino', 'Saint-Marin', 'https://flagcdn.com/sm.svg', 'Saint-Marin', 'Italien', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(12.4467, 43.9367), 4326), 'republique-parlementaire'),
('vatican', 'Vatican', 'https://flagcdn.com/va.svg', 'Cité du Vatican', 'Italien, Latin', 'Euro (EUR)', 'Europe', ST_SetSRID(ST_MakePoint(12.4534, 41.9029), 4326), 'theocratie'),
('liechtenstein', 'Liechtenstein', 'https://flagcdn.com/li.svg', 'Vaduz', 'Allemand', 'Franc suisse (CHF)', 'Europe', ST_SetSRID(ST_MakePoint(9.5219, 47.1411), 4326), 'monarchie-constitutionnelle');

-- ASIE (pays manquants)
INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id) VALUES
('kyrgyzstan', 'Kirghizistan', 'https://flagcdn.com/kg.svg', 'Bichkek', 'Kirghize, Russe', 'Som (KGS)', 'Asie', ST_SetSRID(ST_MakePoint(74.6041, 42.8746), 4326), 'republique-presidentielle'),
('tajikistan', 'Tadjikistan', 'https://flagcdn.com/tj.svg', 'Douchanbé', 'Tadjik, Russe', 'Somoni (TJS)', 'Asie', ST_SetSRID(ST_MakePoint(68.7738, 38.5358), 4326), 'republique-presidentielle'),
('turkmenistan', 'Turkménistan', 'https://flagcdn.com/tm.svg', 'Achgabat', 'Turkmène', 'Manat turkmène (TMT)', 'Asie', ST_SetSRID(ST_MakePoint(58.3833, 37.9608), 4326), 'regime-autoritaire'),
('jordan', 'Jordanie', 'https://flagcdn.com/jo.svg', 'Amman', 'Arabe', 'Dinar jordanien (JOD)', 'Asie', ST_SetSRID(ST_MakePoint(35.9450, 31.9539), 4326), 'monarchie-constitutionnelle'),
('lebanon', 'Liban', 'https://flagcdn.com/lb.svg', 'Beyrouth', 'Arabe', 'Livre libanaise (LBP)', 'Asie', ST_SetSRID(ST_MakePoint(35.5018, 33.8935), 4326), 'republique-parlementaire'),
('syria', 'Syrie', 'https://flagcdn.com/sy.svg', 'Damas', 'Arabe', 'Livre syrienne (SYP)', 'Asie', ST_SetSRID(ST_MakePoint(36.2765, 33.5138), 4326), 'regime-autoritaire'),
('yemen', 'Yémen', 'https://flagcdn.com/ye.svg', 'Sanaa', 'Arabe', 'Riyal yéménite (YER)', 'Asie', ST_SetSRID(ST_MakePoint(44.2075, 15.3694), 4326), 'regime-autoritaire'),
('oman', 'Oman', 'https://flagcdn.com/om.svg', 'Mascate', 'Arabe', 'Riyal omanais (OMR)', 'Asie', ST_SetSRID(ST_MakePoint(58.5453, 23.5880), 4326), 'monarchie-absolue'),
('kuwait', 'Koweït', 'https://flagcdn.com/kw.svg', 'Koweït', 'Arabe', 'Dinar koweïtien (KWD)', 'Asie', ST_SetSRID(ST_MakePoint(47.9783, 29.3759), 4326), 'monarchie-constitutionnelle'),
('bahrain', 'Bahreïn', 'https://flagcdn.com/bh.svg', 'Manama', 'Arabe', 'Dinar bahreïni (BHD)', 'Asie', ST_SetSRID(ST_MakePoint(50.5850, 26.2285), 4326), 'monarchie-constitutionnelle'),
('qatar', 'Qatar', 'https://flagcdn.com/qa.svg', 'Doha', 'Arabe', 'Riyal qatari (QAR)', 'Asie', ST_SetSRID(ST_MakePoint(51.5310, 25.2854), 4326), 'monarchie-absolue'),
('uae', 'Émirats arabes unis', 'https://flagcdn.com/ae.svg', 'Abu Dhabi', 'Arabe', 'Dirham des Émirats (AED)', 'Asie', ST_SetSRID(ST_MakePoint(54.3773, 24.4539), 4326), 'monarchie-constitutionnelle');

-- AMÉRIQUE (pays manquants)
INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id) VALUES
('belize', 'Belize', 'https://flagcdn.com/bz.svg', 'Belmopan', 'Anglais', 'Dollar de Belize (BZD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-88.7675, 17.2534), 4326), 'monarchie-constitutionnelle'),
('costa-rica', 'Costa Rica', 'https://flagcdn.com/cr.svg', 'San José', 'Espagnol', 'Colón costaricain (CRC)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-84.0907, 9.9281), 4326), 'republique-presidentielle'),
('el-salvador', 'El Salvador', 'https://flagcdn.com/sv.svg', 'San Salvador', 'Espagnol', 'Dollar américain (USD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-89.1872, 13.6929), 4326), 'republique-presidentielle'),
('guatemala', 'Guatemala', 'https://flagcdn.com/gt.svg', 'Guatemala', 'Espagnol', 'Quetzal (GTQ)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-90.5069, 14.6349), 4326), 'republique-presidentielle'),
('honduras', 'Honduras', 'https://flagcdn.com/hn.svg', 'Tegucigalpa', 'Espagnol', 'Lempira (HNL)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-87.2068, 14.0723), 4326), 'republique-presidentielle'),
('nicaragua', 'Nicaragua', 'https://flagcdn.com/ni.svg', 'Managua', 'Espagnol', 'Córdoba (NIO)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-86.2514, 12.1364), 4326), 'republique-presidentielle'),
('panama', 'Panama', 'https://flagcdn.com/pa.svg', 'Panama', 'Espagnol', 'Balboa (PAB)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-79.5342, 8.5380), 4326), 'republique-presidentielle'),
('haiti', 'Haïti', 'https://flagcdn.com/ht.svg', 'Port-au-Prince', 'Français, Créole haïtien', 'Gourde (HTG)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-72.2852, 18.5944), 4326), 'republique-presidentielle'),
('dominican-republic', 'République dominicaine', 'https://flagcdn.com/do.svg', 'Saint-Domingue', 'Espagnol', 'Peso dominicain (DOP)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-69.9312, 18.4861), 4326), 'republique-presidentielle'),
('jamaica', 'Jamaïque', 'https://flagcdn.com/jm.svg', 'Kingston', 'Anglais', 'Dollar jamaïcain (JMD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-76.7930, 17.9712), 4326), 'monarchie-constitutionnelle'),
('trinidad-tobago', 'Trinité-et-Tobago', 'https://flagcdn.com/tt.svg', 'Port-d''Espagne', 'Anglais', 'Dollar de Trinité-et-Tobago (TTD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-61.5170, 10.6598), 4326), 'republique-presidentielle'),
('barbados', 'Barbade', 'https://flagcdn.com/bb.svg', 'Bridgetown', 'Anglais', 'Dollar de la Barbade (BBD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-59.6132, 13.1132), 4326), 'monarchie-constitutionnelle'),
('bahamas', 'Bahamas', 'https://flagcdn.com/bs.svg', 'Nassau', 'Anglais', 'Dollar des Bahamas (BSD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-77.3390, 25.0343), 4326), 'monarchie-constitutionnelle'),
('cuba', 'Cuba', 'https://flagcdn.com/cu.svg', 'La Havane', 'Espagnol', 'Peso cubain (CUP)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-82.3666, 23.1136), 4326), 'regime-autoritaire'),
('dominica', 'Dominique', 'https://flagcdn.com/dm.svg', 'Roseau', 'Anglais', 'Dollar des Caraïbes orientales (XCD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-61.3750, 15.3010), 4326), 'republique-presidentielle'),
('grenada', 'Grenade', 'https://flagcdn.com/gd.svg', 'Saint-Georges', 'Anglais', 'Dollar des Caraïbes orientales (XCD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-61.7494, 12.0564), 4326), 'monarchie-constitutionnelle'),
('saint-lucia', 'Sainte-Lucie', 'https://flagcdn.com/lc.svg', 'Castries', 'Anglais', 'Dollar des Caraïbes orientales (XCD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-61.0069, 14.0101), 4326), 'monarchie-constitutionnelle'),
('saint-vincent', 'Saint-Vincent-et-les-Grenadines', 'https://flagcdn.com/vc.svg', 'Kingstown', 'Anglais', 'Dollar des Caraïbes orientales (XCD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-61.2274, 13.1587), 4326), 'monarchie-constitutionnelle'),
('antigua-barbuda', 'Antigua-et-Barbuda', 'https://flagcdn.com/ag.svg', 'Saint John''s', 'Anglais', 'Dollar des Caraïbes orientales (XCD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-61.8433, 17.1185), 4326), 'monarchie-constitutionnelle'),
('saint-kitts-nevis', 'Saint-Kitts-et-Nevis', 'https://flagcdn.com/kn.svg', 'Basseterre', 'Anglais', 'Dollar des Caraïbes orientales (XCD)', 'Amérique du Nord', ST_SetSRID(ST_MakePoint(-62.7250, 17.2955), 4326), 'monarchie-constitutionnelle');

-- AFRIQUE (pays manquants)
INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id) VALUES
('burundi', 'Burundi', 'https://flagcdn.com/bi.svg', 'Gitega', 'Kirundi, Français', 'Franc burundais (BIF)', 'Afrique', ST_SetSRID(ST_MakePoint(29.9187, -3.3731), 4326), 'republique-presidentielle'),
('central-african-republic', 'République centrafricaine', 'https://flagcdn.com/cf.svg', 'Bangui', 'Français, Sango', 'Franc CFA (XAF)', 'Afrique', ST_SetSRID(ST_MakePoint(18.5544, 4.3947), 4326), 'republique-presidentielle'),
('south-sudan', 'Soudan du Sud', 'https://flagcdn.com/ss.svg', 'Djouba', 'Anglais', 'Livre sud-soudanaise (SSP)', 'Afrique', ST_SetSRID(ST_MakePoint(31.5825, 4.8594), 4326), 'republique-presidentielle'),
('democratic-republic-of-congo', 'République démocratique du Congo', 'https://flagcdn.com/cd.svg', 'Kinshasa', 'Français', 'Franc congolais (CDF)', 'Afrique', ST_SetSRID(ST_MakePoint(15.2663, -4.3223), 4326), 'republique-presidentielle'),
('congo', 'République du Congo', 'https://flagcdn.com/cg.svg', 'Brazzaville', 'Français', 'Franc CFA (XAF)', 'Afrique', ST_SetSRID(ST_MakePoint(15.2832, -4.2634), 4326), 'republique-presidentielle'),
('somalia', 'Somalie', 'https://flagcdn.com/so.svg', 'Mogadiscio', 'Somali, Arabe', 'Shilling somalien (SOS)', 'Afrique', ST_SetSRID(ST_MakePoint(45.3182, 2.0469), 4326), 'republique-presidentielle'),
('ethiopia', 'Éthiopie', 'https://flagcdn.com/et.svg', 'Addis-Abeba', 'Amharique', 'Birr (ETB)', 'Afrique', ST_SetSRID(ST_MakePoint(38.7468, 9.0320), 4326), 'republique-presidentielle'),
('eritrea', 'Érythrée', 'https://flagcdn.com/er.svg', 'Asmara', 'Tigrinya, Arabe', 'Nakfa (ERN)', 'Afrique', ST_SetSRID(ST_MakePoint(38.9318, 15.3229), 4326), 'regime-autoritaire'),
('egypt', 'Égypte', 'https://flagcdn.com/eg.svg', 'Le Caire', 'Arabe', 'Livre égyptienne (EGP)', 'Afrique', ST_SetSRID(ST_MakePoint(31.2357, 30.0444), 4326), 'republique-presidentielle');

-- OCÉANIE (pays manquants)
INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id) VALUES
('kiribati', 'Kiribati', 'https://flagcdn.com/ki.svg', 'Tarawa', 'Kiribati, Anglais', 'Dollar australien (AUD)', 'Océanie', ST_SetSRID(ST_MakePoint(173.0176, 1.3382), 4326), 'republique-presidentielle'),
('marshall-islands', 'Îles Marshall', 'https://flagcdn.com/mh.svg', 'Majuro', 'Marshallais, Anglais', 'Dollar américain (USD)', 'Océanie', ST_SetSRID(ST_MakePoint(171.3805, 7.0897), 4326), 'republique-presidentielle'),
('micronesia', 'Micronésie', 'https://flagcdn.com/fm.svg', 'Palikir', 'Anglais', 'Dollar américain (USD)', 'Océanie', ST_SetSRID(ST_MakePoint(158.1618, 6.9248), 4326), 'republique-presidentielle'),
('nauru', 'Nauru', 'https://flagcdn.com/nr.svg', 'Yaren', 'Nauruan, Anglais', 'Dollar australien (AUD)', 'Océanie', ST_SetSRID(ST_MakePoint(166.9315, -0.5228), 4326), 'republique-presidentielle'),
('palau', 'Palaos', 'https://flagcdn.com/pw.svg', 'Ngerulmud', 'Paluan, Anglais', 'Dollar américain (USD)', 'Océanie', ST_SetSRID(ST_MakePoint(134.5825, 7.5150), 4326), 'republique-presidentielle'),
('samoa', 'Samoa', 'https://flagcdn.com/ws.svg', 'Apia', 'Samoan, Anglais', 'Tala (WST)', 'Océanie', ST_SetSRID(ST_MakePoint(-171.7511, -13.8506), 4326), 'republique-presidentielle'),
('tonga', 'Tonga', 'https://flagcdn.com/to.svg', 'Nuku''alofa', 'Tongien, Anglais', 'Pa''anga (TOP)', 'Océanie', ST_SetSRID(ST_MakePoint(-175.1982, -21.1390), 4326), 'monarchie-constitutionnelle'),
('tuvalu', 'Tuvalu', 'https://flagcdn.com/tv.svg', 'Funafuti', 'Tuvaluan, Anglais', 'Dollar tuvaluan (TVD)', 'Océanie', ST_SetSRID(ST_MakePoint(179.1983, -8.5213), 4326), 'monarchie-constitutionnelle'); 