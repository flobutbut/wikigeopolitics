-- Insertion des données technologiques
-- Script: 06-insert-technology-data.sql

-- Insertion des secteurs technologiques
INSERT INTO technology_sector (id, name, description, global_market_value, global_market_unit, global_market_year, cagr) VALUES
('digital-technologies', 'Technologies numériques', 'Ensemble des technologies liées à l''informatique, l''internet et la digitalisation.', 5000.0, 'milliards USD', 2021, '12.5%'),
('energy-technologies', 'Technologies énergétiques', 'Technologies pour la production, le stockage et la distribution d''énergie.', 8000.0, 'milliards USD', 2021, '8.2%'),
('biotechnology', 'Biotechnologie', 'Technologies utilisant des systèmes biologiques pour développer des produits.', 3000.0, 'milliards USD', 2021, '15.3%'),
('nanotechnology', 'Nanotechnologie', 'Technologies manipulant la matière à l''échelle nanométrique.', 1500.0, 'milliards USD', 2021, '18.7%'),
('space-technology', 'Technologie spatiale', 'Technologies pour l''exploration et l''utilisation de l''espace.', 450.0, 'milliards USD', 2021, '6.8%');

-- Insertion des sous-secteurs technologiques
INSERT INTO technology_subsector (id, sector_id, name, description, status, applications, geopolitical_issues) VALUES
('artificial-intelligence', 'digital-technologies', 'Intelligence artificielle', 'Technologies permettant aux machines d''imiter l''intelligence humaine.', 'Émergent', '["Analyse de données", "Reconnaissance d''images", "Traitement du langage naturel", "Systèmes autonomes", "Aide à la décision"]', '[{"issue": "Course à la suprématie technologique", "description": "Compétition USA-Chine dans le développement de l''IA"}, {"issue": "Contrôle des exportations", "description": "Restrictions sur l''exportation de puces avancées et technologies d''IA"}]'),

('semiconductor', 'digital-technologies', 'Semi-conducteurs', 'Composants essentiels pour tous les appareils électroniques modernes.', 'Mature', '["Électronique grand public", "Informatique", "Télécommunications", "Automobile", "Industrie"]', '[{"issue": "Tensions autour de Taiwan", "description": "Taiwan produit 92% des puces avancées (< 10 nm) via TSMC"}, {"issue": "Souveraineté technologique", "description": "Efforts pour développer des capacités nationales"}]'),

('quantum-computing', 'digital-technologies', 'Informatique quantique', 'Calcul exploitant les propriétés de la mécanique quantique.', 'Émergent', '["Cryptographie", "Découverte de médicaments", "Optimisation logistique", "Simulation de matériaux"]', '[{"issue": "Potentiel de rupture", "description": "Potentiel de rupture en cryptographie et défense"}]'),

('renewable-energy', 'energy-technologies', 'Énergies renouvelables', 'Technologies exploitant des sources d''énergie naturelles et inépuisables.', 'En croissance', '["Production d''électricité", "Chauffage", "Transport", "Stockage"]', '[{"issue": "Chaînes d''approvisionnement", "description": "Dépendance aux minéraux critiques et composants"}, {"issue": "Transition énergétique", "description": "Reconfiguration des alliances et dépendances énergétiques"}]'),

('energy-storage', 'energy-technologies', 'Stockage d''énergie', 'Technologies permettant de stocker l''énergie pour une utilisation ultérieure.', 'En développement', '["Batteries", "Hydrogène", "Pompage hydraulique", "Air comprimé"]', '[{"issue": "Dépendance aux minéraux", "description": "Lithium, cobalt, nickel pour les batteries"}, {"issue": "Sécurité énergétique", "description": "Réduction de la dépendance aux combustibles fossiles"}]'),

('biopharmaceuticals', 'biotechnology', 'Biopharmaceutique', 'Médicaments produits à partir d''organismes vivants.', 'Mature', '["Traitement du cancer", "Maladies auto-immunes", "Thérapies géniques", "Vaccins"]', '[{"issue": "Propriété intellectuelle", "description": "Controverses sur les brevets de médicaments"}, {"issue": "Accès aux soins", "description": "Inégalités d''accès aux traitements innovants"}]'),

('genetic-engineering', 'biotechnology', 'Ingénierie génétique', 'Modification du matériel génétique des organismes.', 'Controversé', '["Agriculture", "Médecine", "Industrie", "Recherche"]', '[{"issue": "Éthique", "description": "Questions éthiques sur la modification du génome"}, {"issue": "Régulation", "description": "Différentes approches réglementaires selon les pays"}]');

-- Insertion des pays leaders en technologie
INSERT INTO technology_country_leadership (subsector_id, country_id, strengths, companies) VALUES
('artificial-intelligence', 'usa', '["Recherche fondamentale", "Entreprises leaders", "Investissements"]', '["Google/DeepMind", "Microsoft", "OpenAI", "Meta AI"]'),
('artificial-intelligence', 'china', '["Applications massives", "Données", "Reconnaissance faciale"]', '["Baidu", "ByteDance", "SenseTime"]'),
('semiconductor', 'usa', '["Conception", "Recherche", "Investissements"]', '["Nvidia", "Qualcomm", "AMD", "ARM"]'),
('semiconductor', 'taiwan', '["Fabrication", "Technologies avancées"]', '["TSMC"]'),
('semiconductor', 'south-korea', '["Fabrication", "Mémoire"]', '["Samsung", "SK Hynix"]'),
('quantum-computing', 'usa', '["Recherche fondamentale", "Entreprises privées"]', '["Google", "IBM", "Microsoft"]'),
('quantum-computing', 'china', '["Investissements publics", "Recherche académique"]', '["Alibaba", "Baidu"]'),
('renewable-energy', 'china', '["Production", "Installation", "Technologies"]', '["Jinko Solar", "Longi", "Goldwind"]'),
('renewable-energy', 'germany', '["Technologies", "Politiques", "Innovation"]', '["Siemens", "Enercon"]'),
('energy-storage', 'china', '["Production de batteries", "Matériaux"]', '["CATL", "BYD"]'),
('energy-storage', 'south-korea', '["Technologies", "Qualité"]', '["LG Chem", "Samsung SDI"]'),
('biopharmaceuticals', 'usa', '["Recherche", "Innovation", "Capital"]', '["Pfizer", "Moderna", "Johnson & Johnson"]'),
('biopharmaceuticals', 'switzerland', '["Qualité", "Innovation", "Stabilité"]', '["Roche", "Novartis"]'),
('genetic-engineering', 'usa', '["Recherche", "Applications agricoles"]', '["Monsanto", "DuPont"]'),
('genetic-engineering', 'china', '["Recherche", "Applications médicales"]', '["BGI", "Sinogene"]'); 