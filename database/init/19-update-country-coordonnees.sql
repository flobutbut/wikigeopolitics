-- =====================================================
-- Script pour corriger le champ coordonnees (geometry, SRID 4326)
-- pour les pays où ce champ est NULL
-- =====================================================

-- Exemple : ST_GeomFromText('POINT(long lat)', 4326)

UPDATE country SET coordonnees = ST_GeomFromText('POINT(-79.3832 43.6532)', 4326) WHERE id = 'jamaica'; -- Kingston
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-61.7486 17.1274)', 4326) WHERE id = 'antigua-and-barbuda'; -- Saint John's
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-77.0369 38.9072)', 4326) WHERE id = 'bahamas'; -- Nassau
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-59.6167 13.0975)', 4326) WHERE id = 'barbados'; -- Bridgetown
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-88.7731 17.2514)', 4326) WHERE id = 'belize'; -- Belmopan
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-61.3881 15.3014)', 4326) WHERE id = 'dominica'; -- Roseau
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-61.7486 12.0561)', 4326) WHERE id = 'grenada'; -- Saint George's
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-90.5133 14.6349)', 4326) WHERE id = 'guatemala'; -- Guatemala
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-72.3450 18.5392)', 4326) WHERE id = 'haiti'; -- Port-au-Prince
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-87.2068 14.0723)', 4326) WHERE id = 'honduras'; -- Tegucigalpa
UPDATE country SET coordonnees = ST_GeomFromText('POINT(10.1658 36.8188)', 4326) WHERE id = 'tunisia'; -- Tunis
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-89.2182 13.6929)', 4326) WHERE id = 'el-salvador'; -- San Salvador
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-61.5227 10.6667)', 4326) WHERE id = 'trinidad-and-tobago'; -- Port d'Espagne
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-79.5167 8.9833)', 4326) WHERE id = 'panama'; -- Panama
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-62.7177 17.3026)', 4326) WHERE id = 'saint-kitts-and-nevis'; -- Basseterre
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-60.9875 13.9957)', 4326) WHERE id = 'saint-lucia'; -- Castries
UPDATE country SET coordonnees = ST_GeomFromText('POINT(50.5832 26.2235)', 4326) WHERE id = 'bahrain'; -- Manama
UPDATE country SET coordonnees = ST_GeomFromText('POINT(35.2137 31.7683)', 4326) WHERE id = 'israel'; -- Jérusalem
UPDATE country SET coordonnees = ST_GeomFromText('POINT(74.6059 42.8746)', 4326) WHERE id = 'kyrgyzstan'; -- Bichkek
UPDATE country SET coordonnees = ST_GeomFromText('POINT(47.9783 29.3759)', 4326) WHERE id = 'kuwait'; -- Koweït
UPDATE country SET coordonnees = ST_GeomFromText('POINT(35.5018 33.8938)', 4326) WHERE id = 'lebanon'; -- Beyrouth
UPDATE country SET coordonnees = ST_GeomFromText('POINT(36.2765 33.5138)', 4326) WHERE id = 'syria'; -- Damas
UPDATE country SET coordonnees = ST_GeomFromText('POINT(58.3838 37.9509)', 4326) WHERE id = 'turkmenistan'; -- Achgabat
UPDATE country SET coordonnees = ST_GeomFromText('POINT(44.2075 15.3694)', 4326) WHERE id = 'yemen'; -- Sanaa
UPDATE country SET coordonnees = ST_GeomFromText('POINT(29.9246 -3.4264)', 4326) WHERE id = 'burundi'; -- Gitega
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-84.0833 9.9333)', 4326) WHERE id = 'costa-rica'; -- San José
UPDATE country SET coordonnees = ST_GeomFromText('POINT(68.7739 38.5737)', 4326) WHERE id = 'tajikistan'; -- Douchanbé
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-76.7920 17.9712)', 4326) WHERE id = 'jamaica'; -- Kingston
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-69.9312 18.4861)', 4326) WHERE id = 'dominican-republic'; -- Saint-Domingue
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-61.2248 13.1600)', 4326) WHERE id = 'saint-vincent-and-the-grenadines'; -- Kingstown
UPDATE country SET coordonnees = ST_GeomFromText('POINT(35.9304 31.9516)', 4326) WHERE id = 'jordan'; -- Amman
UPDATE country SET coordonnees = ST_GeomFromText('POINT(58.5922 23.6139)', 4326) WHERE id = 'oman'; -- Mascate
UPDATE country SET coordonnees = ST_GeomFromText('POINT(-86.2901 12.1140)', 4326) WHERE id = 'nicaragua'; -- Managua 