-- Insertion des données de conflits armés
-- Script: 09-insert-conflicts-data.sql

-- Insertion des conflits armés
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Guerre en Ukraine', 'Conflit armé entre la Russie et l''Ukraine suite à l''invasion russe de 2022.', 2022, NULL, 'En cours', '["russia", "ukraine"]', '{"russian_casualties": "Estimations variables", "ukrainian_casualties": "Estimations variables", "civilian_casualties": "Plus de 10 000"}', 'Impact majeur sur la sécurité énergétique européenne, reconfiguration des alliances, crise alimentaire mondiale'),

('Guerre civile syrienne', 'Conflit complexe impliquant le gouvernement syrien, l''opposition, et divers groupes armés.', 2011, NULL, 'En cours', '["syria", "russia", "iran", "turkey", "usa"]', '{"total_casualties": "Plus de 500 000", "refugees": "Plus de 6 millions"}', 'Crise migratoire majeure, intervention de puissances étrangères, déstabilisation régionale'),

('Conflit israélo-palestinien', 'Conflit de longue date entre Israël et les Palestiniens.', 1948, NULL, 'En cours', '["israel", "palestine"]', '{"israeli_casualties": "Plus de 6 000", "palestinian_casualties": "Plus de 20 000"}', 'Tensions régionales continues, impact sur les relations internationales, question de Jérusalem'),

('Guerre civile yéménite', 'Conflit entre le gouvernement yéménite et les rebelles Houthis.', 2014, NULL, 'En cours', '["yemen", "saudi-arabia", "iran"]', '{"total_casualties": "Plus de 150 000", "humanitarian_crisis": "Plus de 24 millions en besoin d''aide"}', 'Crise humanitaire majeure, intervention de la coalition saoudienne, tensions Iran-Arabie saoudite'),

('Conflit en Éthiopie', 'Conflit dans la région du Tigré en Éthiopie.', 2020, NULL, 'En cours', '["ethiopia", "eritrea"]', '{"casualties": "Estimations variables", "displaced": "Plus de 2 millions"}', 'Crise humanitaire, déstabilisation de la Corne de l''Afrique'),

('Guerre civile libyenne', 'Conflit entre différents groupes armés en Libye.', 2014, NULL, 'En cours', '["libya", "russia", "turkey", "egypt"]', '{"casualties": "Plus de 10 000", "displaced": "Plus de 400 000"}', 'Instabilité en Afrique du Nord, trafic d''armes, migration vers l''Europe'),

('Conflit au Sahel', 'Conflits armés dans la région du Sahel en Afrique.', 2012, NULL, 'En cours', '["mali", "niger", "burkina-faso", "chad"]', '{"casualties": "Plus de 10 000", "displaced": "Plus de 2 millions"}', 'Déstabilisation de l''Afrique de l''Ouest, terrorisme islamiste, intervention française'),

('Guerre civile somalienne', 'Conflit complexe en Somalie impliquant le gouvernement et divers groupes armés.', 1991, NULL, 'En cours', '["somalia", "kenya", "ethiopia"]', '{"casualties": "Plus de 500 000", "pirates": "Problème majeur jusqu''en 2012"}', 'Piratage maritime, terrorisme islamiste, crise humanitaire'),

('Conflit en République centrafricaine', 'Conflit entre groupes armés en RCA.', 2012, NULL, 'En cours', '["central-african-republic", "russia", "france"]', '{"casualties": "Plus de 5 000", "displaced": "Plus de 600 000"}', 'Crise humanitaire, intervention internationale, exploitation des ressources'),

('Guerre civile sud-soudanaise', 'Conflit entre factions politiques au Soudan du Sud.', 2013, NULL, 'En cours', '["south-sudan"]', '{"casualties": "Plus de 400 000", "displaced": "Plus de 4 millions"}', 'Crise humanitaire majeure, impact sur la production pétrolière'),

('Conflit en République démocratique du Congo', 'Conflits armés dans l''est de la RDC.', 1996, NULL, 'En cours', '["democratic-republic-of-congo", "rwanda", "uganda"]', '{"casualties": "Plus de 5 millions", "displaced": "Plus de 5 millions"}', 'Exploitation des ressources naturelles, violences sexuelles, crise humanitaire'),

('Guerre en Afghanistan', 'Conflit impliquant les talibans et les forces internationales.', 2001, 2021, 'Terminé', '["afghanistan", "usa", "uk", "germany", "france"]', '{"afghan_casualties": "Plus de 100 000", "coalition_casualties": "Plus de 3 500"}', 'Retour des talibans au pouvoir, crise humanitaire, questions de sécurité internationale'),

('Guerre en Irak', 'Conflit impliquant les forces internationales et divers groupes armés.', 2003, 2011, 'Terminé', '["iraq", "usa", "uk"]', '{"iraqi_casualties": "Plus de 100 000", "coalition_casualties": "Plus de 4 800"}', 'Déstabilisation de l''Irak, montée de l''État islamique, impact sur la région'),

('Guerre civile sri-lankaise', 'Conflit entre le gouvernement sri-lankais et les Tigres tamouls.', 1983, 2009, 'Terminé', '["sri-lanka"]', '{"casualties": "Plus de 100 000", "displaced": "Plus de 1 million"}', 'Réconciliation nationale, développement économique, questions de droits humains'),

('Guerre des Balkans', 'Conflits dans l''ex-Yougoslavie.', 1991, 2001, 'Terminé', '["serbia", "croatia", "bosnia-herzegovina", "kosovo"]', '{"casualties": "Plus de 140 000", "displaced": "Plus de 4 millions"}', 'Réorganisation territoriale, questions de génocide, intégration européenne'); 