-- Script pour créer les tables de ressources naturelles
-- À exécuter dans Supabase si les tables n'existent pas

-- Table principale des ressources naturelles
CREATE TABLE IF NOT EXISTS natural_resource (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    description TEXT,
    global_reserves_value DECIMAL,
    global_reserves_unit VARCHAR(100),
    global_reserves_year INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table de liaison pays-ressources
CREATE TABLE IF NOT EXISTS country_natural_resource (
    country_id VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    resource_id VARCHAR(50) REFERENCES natural_resource(id) ON DELETE CASCADE,
    abundance_level VARCHAR(50),
    locations JSONB,
    production_value DECIMAL,
    production_unit VARCHAR(100),
    production_year INTEGER,
    PRIMARY KEY (country_id, resource_id)
);

-- Index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_natural_resource_category ON natural_resource(category);
CREATE INDEX IF NOT EXISTS idx_country_natural_resource_country ON country_natural_resource(country_id);
CREATE INDEX IF NOT EXISTS idx_country_natural_resource_resource ON country_natural_resource(resource_id);

-- Insertion des données de base (si la table est vide)
INSERT INTO natural_resource (id, name, category, description, global_reserves_value, global_reserves_unit, global_reserves_year) 
SELECT * FROM (VALUES
    ('petrole', 'Pétrole', 'Énergie fossile', 'Ressource énergétique fossile principale, utilisée pour le transport et l''industrie.', 1734.0, 'milliards de barils', 2021),
    ('gaz-naturel', 'Gaz naturel', 'Énergie fossile', 'Combustible fossile gazeux, utilisé pour le chauffage et la production d''électricité.', 7213.0, 'milliards de mètres cubes', 2021),
    ('charbon', 'Charbon', 'Énergie fossile', 'Combustible fossile solide, principalement utilisé pour la production d''électricité.', 1074.0, 'milliards de tonnes', 2021),
    ('uranium', 'Uranium', 'Énergie nucléaire', 'Élément radioactif utilisé comme combustible dans les centrales nucléaires.', 6.1, 'millions de tonnes', 2021),
    ('lithium', 'Lithium', 'Métal stratégique', 'Métal léger utilisé dans les batteries lithium-ion pour véhicules électriques.', 22.0, 'millions de tonnes', 2021),
    ('cobalt', 'Cobalt', 'Métal stratégique', 'Métal utilisé dans les batteries et les alliages à haute température.', 7.1, 'millions de tonnes', 2021),
    ('nickel', 'Nickel', 'Métal stratégique', 'Métal utilisé dans les aciers inoxydables et les batteries.', 94.0, 'millions de tonnes', 2021),
    ('cuivre', 'Cuivre', 'Métal industriel', 'Métal conducteur utilisé dans l''électricité et l''électronique.', 880.0, 'millions de tonnes', 2021),
    ('aluminium', 'Aluminium', 'Métal industriel', 'Métal léger utilisé dans l''industrie aéronautique et l''emballage.', 30000.0, 'millions de tonnes', 2021),
    ('fer', 'Fer', 'Métal industriel', 'Métal principal utilisé dans la production d''acier.', 180000.0, 'millions de tonnes', 2021),
    ('or', 'Or', 'Métal précieux', 'Métal précieux utilisé comme réserve de valeur et en joaillerie.', 54000.0, 'tonnes', 2021),
    ('argent', 'Argent', 'Métal précieux', 'Métal précieux utilisé en joaillerie et en électronique.', 530000.0, 'tonnes', 2021),
    ('platine', 'Platine', 'Métal précieux', 'Métal précieux utilisé en joaillerie et dans les catalyseurs automobiles.', 6900.0, 'tonnes', 2021),
    ('diamants', 'Diamants', 'Pierre précieuse', 'Pierre précieuse utilisée en joaillerie et dans l''industrie.', 1.2, 'milliards de carats', 2021),
    ('eau-douce', 'Eau douce', 'Ressource vitale', 'Ressource essentielle pour la vie et l''agriculture.', 3500000.0, 'kilomètres cubes', 2021)
) AS v(id, name, category, description, global_reserves_value, global_reserves_unit, global_reserves_year)
WHERE NOT EXISTS (SELECT 1 FROM natural_resource WHERE natural_resource.id = v.id); 