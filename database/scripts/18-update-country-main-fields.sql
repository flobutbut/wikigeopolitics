-- =====================================================
-- Script pour corriger capitale, langue et monnaie (valeur principale)
-- pour les pays où ces champs sont NULL
-- =====================================================

UPDATE country SET capitale = 'Tunis', langue = 'Arabe', monnaie = 'Dinar tunisien' WHERE id = 'tunisia';
UPDATE country SET capitale = 'Saint John''s', langue = 'Anglais', monnaie = 'Dollar des Caraïbes orientales' WHERE id = 'antigua-and-barbuda';
UPDATE country SET capitale = 'Nassau', langue = 'Anglais', monnaie = 'Dollar bahaméen' WHERE id = 'bahamas';
UPDATE country SET capitale = 'Bridgetown', langue = 'Anglais', monnaie = 'Dollar barbadien' WHERE id = 'barbados';
UPDATE country SET capitale = 'Belmopan', langue = 'Anglais', monnaie = 'Dollar bélizien' WHERE id = 'belize';
UPDATE country SET capitale = 'Roseau', langue = 'Anglais', monnaie = 'Dollar des Caraïbes orientales' WHERE id = 'dominica';
UPDATE country SET capitale = 'Saint George''s', langue = 'Anglais', monnaie = 'Dollar des Caraïbes orientales' WHERE id = 'grenada';
UPDATE country SET capitale = 'Guatemala', langue = 'Espagnol', monnaie = 'Quetzal guatémaltèque' WHERE id = 'guatemala';
UPDATE country SET capitale = 'Port-au-Prince', langue = 'Français', monnaie = 'Gourde haïtienne' WHERE id = 'haiti';
UPDATE country SET capitale = 'Tegucigalpa', langue = 'Espagnol', monnaie = 'Lempira hondurien' WHERE id = 'honduras';
UPDATE country SET capitale = 'Kingston', langue = 'Anglais', monnaie = 'Dollar jamaïcain' WHERE id = 'jamaica';
UPDATE country SET capitale = 'Managua', langue = 'Espagnol', monnaie = 'Córdoba oro' WHERE id = 'nicaragua';
UPDATE country SET capitale = 'Panama', langue = 'Espagnol', monnaie = 'Balboa' WHERE id = 'panama';
UPDATE country SET capitale = 'Saint-Domingue', langue = 'Espagnol', monnaie = 'Peso dominicain' WHERE id = 'dominican-republic';
UPDATE country SET capitale = 'Basseterre', langue = 'Anglais', monnaie = 'Dollar des Caraïbes orientales' WHERE id = 'saint-kitts-and-nevis';
UPDATE country SET capitale = 'Castries', langue = 'Anglais', monnaie = 'Dollar des Caraïbes orientales' WHERE id = 'saint-lucia';
UPDATE country SET capitale = 'Kingstown', langue = 'Anglais', monnaie = 'Dollar des Caraïbes orientales' WHERE id = 'saint-vincent-and-the-grenadines';
UPDATE country SET capitale = 'San Salvador', langue = 'Espagnol', monnaie = 'Dollar américain' WHERE id = 'el-salvador';
UPDATE country SET capitale = 'Port d''Espagne', langue = 'Anglais', monnaie = 'Dollar de Trinité-et-Tobago' WHERE id = 'trinidad-and-tobago';
UPDATE country SET capitale = 'Manama', langue = 'Arabe', monnaie = 'Dinar bahreïni' WHERE id = 'bahrain';
UPDATE country SET capitale = 'Jérusalem', langue = 'Hébreu', monnaie = 'Nouveau shekel israélien' WHERE id = 'israel';
UPDATE country SET capitale = 'Amman', langue = 'Arabe', monnaie = 'Dinar jordanien' WHERE id = 'jordan';
UPDATE country SET capitale = 'Bichkek', langue = 'Kirghiz', monnaie = 'Som kirghize' WHERE id = 'kyrgyzstan';
UPDATE country SET capitale = 'Koweït', langue = 'Arabe', monnaie = 'Dinar koweïtien' WHERE id = 'kuwait';
UPDATE country SET capitale = 'Beyrouth', langue = 'Arabe', monnaie = 'Livre libanaise' WHERE id = 'lebanon';
UPDATE country SET capitale = 'Mascate', langue = 'Arabe', monnaie = 'Rial omanais' WHERE id = 'oman';
UPDATE country SET capitale = 'Damas', langue = 'Arabe', monnaie = 'Livre syrienne' WHERE id = 'syria';
UPDATE country SET capitale = 'Achgabat', langue = 'Turkmène', monnaie = 'Manat turkmène' WHERE id = 'turkmenistan';
UPDATE country SET capitale = 'Sanaa', langue = 'Arabe', monnaie = 'Rial yéménite' WHERE id = 'yemen';
UPDATE country SET capitale = 'Gitega', langue = 'Kirundi', monnaie = 'Franc burundais' WHERE id = 'burundi';
UPDATE country SET capitale = 'San José', langue = 'Espagnol', monnaie = 'Colón costaricien' WHERE id = 'costa-rica';
UPDATE country SET capitale = 'Douchanbé', langue = 'Tadjik', monnaie = 'Somoni' WHERE id = 'tajikistan'; 