-- Ajout des pays manquants dans la table country (coordonnées, continent, monnaie, langue, drapeau, capitale, nom, current_regime_id)

INSERT INTO country (id, nom, drapeau, capitale, langue, monnaie, continent, coordonnees, current_regime_id)
VALUES
-- Soudan
('sudan', 'Soudan', 'https://flagcdn.com/sd.svg', 'Khartoum', 'Arabe, Anglais', 'Livre soudanaise (SDG)', 'Afrique', ST_SetSRID(ST_MakePoint(32.5599, 15.5007), 4326), 'regime-autoritaire'),
-- Angola
('angola', 'Angola', 'https://flagcdn.com/ao.svg', 'Luanda', 'Portugais', 'Kwanza (AOA)', 'Afrique', ST_SetSRID(ST_MakePoint(13.2344, -8.8383), 4326), 'republique-presidentielle'),
-- Tanzanie
('tanzania', 'Tanzanie', 'https://flagcdn.com/tz.svg', 'Dodoma', 'Swahili, Anglais', 'Shilling tanzanien (TZS)', 'Afrique', ST_SetSRID(ST_MakePoint(35.7460, -6.1630), 4326), 'republique-presidentielle'),
-- Côte d''Ivoire
('ivory-coast', 'Côte d''Ivoire', 'https://flagcdn.com/ci.svg', 'Yamoussoukro', 'Français', 'Franc CFA (XOF)', 'Afrique', ST_SetSRID(ST_MakePoint(-5.2767, 6.8276), 4326), 'republique-presidentielle'),
-- Kenya
('kenya', 'Kenya', 'https://flagcdn.com/ke.svg', 'Nairobi', 'Swahili, Anglais', 'Shilling kényan (KES)', 'Afrique', ST_SetSRID(ST_MakePoint(36.8219, -1.2921), 4326), 'republique-presidentielle'); 