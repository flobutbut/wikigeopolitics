-- =====================================================
-- Mise à jour des zones de combat réelles pour les conflits armés
-- Ajout de plusieurs marqueurs par conflit pour les zones actives
-- =====================================================

-- Créer une nouvelle table pour les zones de combat spécifiques
CREATE TABLE IF NOT EXISTS armed_conflict_combat_zone (
    id SERIAL PRIMARY KEY,
    conflict_id INTEGER REFERENCES armed_conflict(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    location GEOMETRY(Point, 4326) NOT NULL,
    status VARCHAR(50) DEFAULT 'active', -- active, inactive, disputed
    intensity VARCHAR(50) DEFAULT 'medium', -- low, medium, high, very_high
    zone_type VARCHAR(100), -- urban, rural, border, strategic, capital
    description TEXT,
    last_activity DATE DEFAULT CURRENT_DATE,
    civilian_impact VARCHAR(100), -- low, medium, high, critical
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index spatial pour optimiser les requêtes géographiques
CREATE INDEX IF NOT EXISTS idx_combat_zone_location ON armed_conflict_combat_zone USING GIST (location);
CREATE INDEX IF NOT EXISTS idx_combat_zone_conflict ON armed_conflict_combat_zone (conflict_id);
CREATE INDEX IF NOT EXISTS idx_combat_zone_status ON armed_conflict_combat_zone (status);

-- Supprimer les anciennes zones s'il y en a
DELETE FROM armed_conflict_combat_zone;

-- =====================================================
-- ZONES DE COMBAT UKRAINE (ID: 1)
-- =====================================================

-- Front Est - Donetsk
INSERT INTO armed_conflict_combat_zone (conflict_id, name, location, status, intensity, zone_type, description, civilian_impact) VALUES
(1, 'Bakhmut', ST_GeomFromText('POINT(38.0 48.6)', 4326), 'active', 'very_high', 'urban', 'Ville stratégique, combats urbains intenses', 'critical'),
(1, 'Avdiivka', ST_GeomFromText('POINT(37.8 48.1)', 4326), 'active', 'high', 'urban', 'Ville industrielle près de Donetsk', 'high'),
(1, 'Mariupol', ST_GeomFromText('POINT(37.5 47.1)', 4326), 'inactive', 'medium', 'urban', 'Port stratégique de la mer d''Azov', 'critical'),
(1, 'Kramatorsk', ST_GeomFromText('POINT(37.6 48.7)', 4326), 'active', 'medium', 'urban', 'Centre administratif du Donbass', 'medium'),

-- Front Sud - Zaporizhzhia et Kherson  
(1, 'Zaporizhzhia (centrale nucléaire)', ST_GeomFromText('POINT(34.6 47.5)', 4326), 'active', 'high', 'strategic', 'Plus grande centrale nucléaire d''Europe', 'critical'),
(1, 'Kherson', ST_GeomFromText('POINT(32.6 46.6)', 4326), 'active', 'medium', 'urban', 'Ville portuaire sur le Dniepr', 'high'),
(1, 'Nova Kakhovka', ST_GeomFromText('POINT(33.4 46.8)', 4326), 'inactive', 'low', 'strategic', 'Barrage détruit en juin 2023', 'critical'),

-- Front Nord - Kharkiv
(1, 'Kharkiv', ST_GeomFromText('POINT(36.2 50.0)', 4326), 'active', 'medium', 'urban', 'Deuxième plus grande ville d''Ukraine', 'high'),
(1, 'Kupiansk', ST_GeomFromText('POINT(37.6 49.7)', 4326), 'active', 'medium', 'strategic', 'Nœud ferroviaire important', 'medium');

-- =====================================================
-- ZONES DE COMBAT GAZA-ISRAËL (ID: 2) 
-- =====================================================

-- Bande de Gaza
INSERT INTO armed_conflict_combat_zone (conflict_id, name, location, status, intensity, zone_type, description, civilian_impact) VALUES
(2, 'Gaza Nord', ST_GeomFromText('POINT(34.5 31.6)', 4326), 'active', 'very_high', 'urban', 'Zone densément peuplée, hôpital Al-Shifa', 'critical'),
(2, 'Gaza Centre', ST_GeomFromText('POINT(34.4 31.5)', 4326), 'active', 'very_high', 'urban', 'Camps de réfugiés, tunnels du Hamas', 'critical'),
(2, 'Khan Younis', ST_GeomFromText('POINT(34.3 31.3)', 4326), 'active', 'very_high', 'urban', 'Deuxième plus grande ville de Gaza', 'critical'),
(2, 'Rafah', ST_GeomFromText('POINT(34.2 31.3)', 4326), 'active', 'high', 'border', 'Frontière avec l''Égypte, tunnels de contrebande', 'critical'),

-- Israël (attaques et ripostes)
(2, 'Sderot', ST_GeomFromText('POINT(34.6 31.5)', 4326), 'active', 'medium', 'urban', 'Ville israélienne proche de Gaza', 'high'),
(2, 'Ashkelon', ST_GeomFromText('POINT(34.6 31.7)', 4326), 'active', 'medium', 'urban', 'Port et ville côtière', 'medium'),
(2, 'Kibboutz près de Gaza', ST_GeomFromText('POINT(34.5 31.5)', 4326), 'inactive', 'low', 'rural', 'Zone de l''attaque du 7 octobre', 'critical');

-- =====================================================
-- ZONES DE COMBAT SOUDAN (ID: 3)
-- =====================================================

-- Bataille pour le contrôle du pays
INSERT INTO armed_conflict_combat_zone (conflict_id, name, location, status, intensity, zone_type, description, civilian_impact) VALUES
(3, 'Khartoum (centre)', ST_GeomFromText('POINT(32.5 15.6)', 4326), 'active', 'very_high', 'capital', 'Capitale, combats pour le contrôle du pouvoir', 'critical'),
(3, 'Omdurman', ST_GeomFromText('POINT(32.5 15.6)', 4326), 'active', 'high', 'urban', 'Ville jumelle de Khartoum', 'critical'), 
(3, 'Bahri (Khartoum Nord)', ST_GeomFromText('POINT(32.5 15.7)', 4326), 'active', 'high', 'urban', 'Zone industrielle et résidentielle', 'high'),
(3, 'El Fasher (Darfour Nord)', ST_GeomFromText('POINT(25.3 13.6)', 4326), 'active', 'very_high', 'urban', 'Capitale du Darfour Nord, assiégée', 'critical'),
(3, 'Nyala (Darfour Sud)', ST_GeomFromText('POINT(24.9 12.0)', 4326), 'active', 'high', 'urban', 'Deuxième plus grande ville du Darfour', 'critical'),
(3, 'Port Sudan', ST_GeomFromText('POINT(37.2 19.6)', 4326), 'active', 'medium', 'strategic', 'Principal port du pays', 'medium');

-- =====================================================
-- ZONES DE COMBAT MYANMAR (ID: 4)
-- =====================================================

-- Révolution de printemps et résistance
INSERT INTO armed_conflict_combat_zone (conflict_id, name, location, status, intensity, zone_type, description, civilian_impact) VALUES
(4, 'Naypyidaw', ST_GeomFromText('POINT(96.1 19.7)', 4326), 'active', 'medium', 'capital', 'Capitale administrative, contrôlée par la junte', 'high'),
(4, 'Yangon', ST_GeomFromText('POINT(96.2 16.8)', 4326), 'active', 'medium', 'urban', 'Plus grande ville, manifestations réprimées', 'high'),
(4, 'Mandalay', ST_GeomFromText('POINT(96.1 21.9)', 4326), 'active', 'medium', 'urban', 'Deuxième plus grande ville', 'medium'),
(4, 'État Shan (Nord)', ST_GeomFromText('POINT(97.4 23.7)', 4326), 'active', 'high', 'rural', 'Territoire contrôlé par l''alliance Three Brotherhood', 'high'),
(4, 'État Rakhine', ST_GeomFromText('POINT(92.9 20.1)', 4326), 'active', 'high', 'rural', 'Région des Rohingyas, violence ethnique', 'critical'),
(4, 'État Chin', ST_GeomFromText('POINT(93.6 22.3)', 4326), 'active', 'high', 'rural', 'Résistance armée contre la junte', 'high'),
(4, 'État Kayah', ST_GeomFromText('POINT(97.2 19.3)', 4326), 'active', 'high', 'rural', 'Zone de guérilla intense', 'high');

-- =====================================================
-- ZONES DE COMBAT YÉMEN (ID: 5)
-- =====================================================

-- Guerre civile et intervention saoudienne
INSERT INTO armed_conflict_combat_zone (conflict_id, name, location, status, intensity, zone_type, description, civilian_impact) VALUES
(5, 'Sanaa', ST_GeomFromText('POINT(44.2 15.4)', 4326), 'active', 'medium', 'capital', 'Capitale contrôlée par les Houthis', 'high'),
(5, 'Aden', ST_GeomFromText('POINT(45.0 12.8)', 4326), 'active', 'medium', 'urban', 'Capitale temporaire du gouvernement', 'medium'),
(5, 'Hodeida', ST_GeomFromText('POINT(42.9 14.8)', 4326), 'active', 'high', 'strategic', 'Port vital sur la mer Rouge', 'critical'),
(5, 'Marib', ST_GeomFromText('POINT(45.3 15.5)', 4326), 'active', 'high', 'strategic', 'Ville pétrolière stratégique', 'high'),
(5, 'Taez', ST_GeomFromText('POINT(44.0 13.6)', 4326), 'active', 'high', 'urban', 'Ville assiégée depuis 2015', 'critical'),
(5, 'Détroit de Bab el-Mandeb', ST_GeomFromText('POINT(43.4 12.6)', 4326), 'active', 'high', 'strategic', 'Passage maritime crucial, attaques Houthis', 'low');

-- =====================================================
-- ZONES DE COMBAT SAHEL (ID: 6)
-- =====================================================

-- Terrorism et instabilité régionale
INSERT INTO armed_conflict_combat_zone (conflict_id, name, location, status, intensity, zone_type, description, civilian_impact) VALUES
(6, 'Gao (Mali)', ST_GeomFromText('POINT(-0.0 16.3)', 4326), 'active', 'high', 'urban', 'Ville du nord Mali, attaques fréquentes', 'high'),
(6, 'Tombouctou (Mali)', ST_GeomFromText('POINT(-3.0 16.8)', 4326), 'active', 'medium', 'urban', 'Ville historique, présence djihadiste', 'medium'),
(6, 'Kidal (Mali)', ST_GeomFromText('POINT(1.4 18.4)', 4326), 'active', 'high', 'rural', 'Nord Mali, zone de non-droit', 'high'),
(6, 'Ouagadougou (Burkina Faso)', ST_GeomFromText('POINT(-1.5 12.4)', 4326), 'active', 'medium', 'capital', 'Capitale, attaques terroristes récurrentes', 'medium'),
(6, 'Nord Burkina Faso', ST_GeomFromText('POINT(-0.5 14.0)', 4326), 'active', 'very_high', 'rural', 'Zone incontrôlée, déplacements massifs', 'critical'),
(6, 'Diffa (Niger)', ST_GeomFromText('POINT(12.6 13.3)', 4326), 'active', 'high', 'border', 'Frontière Nigeria, Boko Haram', 'high'),
(6, 'Lac Tchad', ST_GeomFromText('POINT(14.1 13.0)', 4326), 'active', 'high', 'rural', 'Zone insulaire, base Boko Haram', 'critical');

-- =====================================================
-- ZONES DE COMBAT RDC (ID: 7)
-- =====================================================

-- Conflits miniers et ethniques à l'Est
INSERT INTO armed_conflict_combat_zone (conflict_id, name, location, status, intensity, zone_type, description, civilian_impact) VALUES
(7, 'Goma (Nord-Kivu)', ST_GeomFromText('POINT(29.2 -1.7)', 4326), 'active', 'high', 'urban', 'Ville frontalière avec le Rwanda', 'high'),
(7, 'Beni (Nord-Kivu)', ST_GeomFromText('POINT(29.5 0.5)', 4326), 'active', 'very_high', 'urban', 'Massacres ADF, mines d''or', 'critical'),
(7, 'Butembo (Nord-Kivu)', ST_GeomFromText('POINT(29.3 0.1)', 4326), 'active', 'high', 'urban', 'Centre commercial, tensions ethniques', 'high'),
(7, 'Bukavu (Sud-Kivu)', ST_GeomFromText('POINT(28.9 -2.5)', 4326), 'active', 'medium', 'urban', 'Chef-lieu Sud-Kivu', 'medium'),
(7, 'Uvira (Sud-Kivu)', ST_GeomFromText('POINT(29.1 -3.4)', 4326), 'active', 'high', 'border', 'Frontière Burundi, conflits communautaires', 'high'),
(7, 'Ituri (mines d''or)', ST_GeomFromText('POINT(30.8 1.4)', 4326), 'active', 'very_high', 'rural', 'Exploitation aurifère, violences', 'critical'),
(7, 'Kasaï (mines de diamant)', ST_GeomFromText('POINT(24.4 -4.3)', 4326), 'active', 'medium', 'rural', 'Mines de diamants, milices locales', 'high');

-- =====================================================
-- ZONES DE COMBAT ÉTHIOPIE (ID: 8)
-- =====================================================

-- Guerre du Tigré (cessez-le-feu fragile)
INSERT INTO armed_conflict_combat_zone (conflict_id, name, location, status, intensity, zone_type, description, civilian_impact) VALUES
(8, 'Mekele (Tigré)', ST_GeomFromText('POINT(39.5 13.5)', 4326), 'inactive', 'low', 'capital', 'Capitale du Tigré, accord de paix 2022', 'medium'),
(8, 'Axum (Tigré)', ST_GeomFromText('POINT(38.7 14.1)', 4326), 'inactive', 'low', 'urban', 'Ville historique, massacres civils', 'high'),
(8, 'Shire (Tigré)', ST_GeomFromText('POINT(38.3 14.1)', 4326), 'inactive', 'low', 'urban', 'Ville de réfugiés érythréens', 'high'),
(8, 'Frontière Érythrée-Tigré', ST_GeomFromText('POINT(38.9 14.5)', 4326), 'inactive', 'low', 'border', 'Zone démilitarisée depuis l''accord', 'medium');

-- =====================================================
-- ZONES DE COMBAT SYRIE (ID: 9)
-- =====================================================

-- Nouvelle phase post-Assad (décembre 2024)
INSERT INTO armed_conflict_combat_zone (conflict_id, name, location, status, intensity, zone_type, description, civilian_impact) VALUES
(9, 'Damas', ST_GeomFromText('POINT(36.3 33.5)', 4326), 'active', 'medium', 'capital', 'Capitale, transition post-Assad', 'medium'),
(9, 'Alep', ST_GeomFromText('POINT(37.2 36.2)', 4326), 'active', 'medium', 'urban', 'Plus grande ville, reconstruction', 'medium'),
(9, 'Idlib', ST_GeomFromText('POINT(36.6 35.9)', 4326), 'active', 'high', 'rural', 'Dernière poche rebelle, HTS au pouvoir', 'high'),
(9, 'Hassakeh (Kurdistan syrien)', ST_GeomFromText('POINT(40.7 36.5)', 4326), 'active', 'medium', 'urban', 'Zone kurde, tensions turques', 'medium'),
(9, 'Daraa (Sud)', ST_GeomFromText('POINT(36.1 32.6)', 4326), 'active', 'medium', 'urban', 'Berceau de la révolution 2011', 'medium'),
(9, 'Palmyre', ST_GeomFromText('POINT(38.3 34.6)', 4326), 'inactive', 'low', 'strategic', 'Site historique, libéré de Daech', 'low');

-- =====================================================
-- ZONES DE COMBAT SOMALIE (ID: 10)
-- =====================================================

-- Terrorisme Al-Shabaab
INSERT INTO armed_conflict_combat_zone (conflict_id, name, location, status, intensity, zone_type, description, civilian_impact) VALUES
(10, 'Mogadiscio', ST_GeomFromText('POINT(45.3 2.0)', 4326), 'active', 'high', 'capital', 'Capitale, attaques terroristes fréquentes', 'high'),
(10, 'Kismayo', ST_GeomFromText('POINT(42.5 -0.4)', 4326), 'active', 'high', 'urban', 'Port stratégique, bastion Al-Shabaab', 'high'),
(10, 'Baidoa', ST_GeomFromText('POINT(43.6 3.1)', 4326), 'active', 'medium', 'urban', 'Centre agricole, opérations AMISOM', 'medium'),
(10, 'Bosaso (Puntland)', ST_GeomFromText('POINT(49.2 11.3)', 4326), 'active', 'medium', 'urban', 'Port autonome, piraterie maritime', 'low'),
(10, 'Hargeisa (Somaliland)', ST_GeomFromText('POINT(44.1 9.6)', 4326), 'inactive', 'low', 'urban', 'Capitale autoproclamée, stable', 'low'),
(10, 'Frontière Kenya-Somalie', ST_GeomFromText('POINT(41.9 -0.1)', 4326), 'active', 'high', 'border', 'Infiltrations Al-Shabaab au Kenya', 'medium');

-- =====================================================
-- STATISTIQUES FINALES
-- =====================================================

-- Afficher un résumé des zones de combat créées
SELECT 
    'Résumé zones de combat' as statistic,
    COUNT(*) as total_zones,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_zones,
    COUNT(CASE WHEN status = 'inactive' THEN 1 END) as inactive_zones,
    COUNT(CASE WHEN intensity = 'very_high' THEN 1 END) as very_high_intensity,
    COUNT(CASE WHEN civilian_impact = 'critical' THEN 1 END) as critical_civilian_impact
FROM armed_conflict_combat_zone

UNION ALL

SELECT 
    'Zones par conflit' as statistic,
    (SELECT COUNT(*) FROM armed_conflict_combat_zone WHERE conflict_id = 1) as ukraine,
    (SELECT COUNT(*) FROM armed_conflict_combat_zone WHERE conflict_id = 2) as gaza,
    (SELECT COUNT(*) FROM armed_conflict_combat_zone WHERE conflict_id = 3) as sudan,
    (SELECT COUNT(*) FROM armed_conflict_combat_zone WHERE conflict_id = 4) as myanmar,
    (SELECT COUNT(*) FROM armed_conflict_combat_zone WHERE conflict_id = 5) as yemen;

-- Commentaires sur la table
COMMENT ON TABLE armed_conflict_combat_zone IS 'Zones de combat spécifiques avec coordonnées réelles des fronts de guerre actifs';
COMMENT ON COLUMN armed_conflict_combat_zone.location IS 'Coordonnées précises des zones de combat (WGS84)';
COMMENT ON COLUMN armed_conflict_combat_zone.intensity IS 'Intensité des combats: low, medium, high, very_high';
COMMENT ON COLUMN armed_conflict_combat_zone.civilian_impact IS 'Impact sur les civils: low, medium, high, critical';
COMMENT ON COLUMN armed_conflict_combat_zone.zone_type IS 'Type de zone: urban, rural, border, strategic, capital';

-- Fin du script - Zones de combat réelles 2025
-- Sources: ACLED, UN OCHA, ISW (Institute for the Study of War), CSIS