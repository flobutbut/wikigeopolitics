-- Insertion des conflits armés actuels (2024)
-- Données basées sur les conflits réels en cours

-- Guerre en Ukraine (2022-présent)
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Guerre en Ukraine', 
'Conflit armé entre la Russie et l''Ukraine suite à l''invasion russe du 24 février 2022. La Russie a envahi l''Ukraine en violation du droit international, déclenchant la plus grande guerre en Europe depuis 1945.', 
2022, NULL, 'En cours', 
'["russia", "ukraine"]', 
'{"russian_casualties": "Plus de 300 000", "ukrainian_casualties": "Plus de 200 000", "civilian_casualties": "Plus de 10 000", "refugees": "Plus de 8 millions"}', 
'Impact majeur sur la sécurité énergétique européenne, reconfiguration des alliances, crise alimentaire mondiale, renforcement de l''OTAN, sanctions économiques contre la Russie');

-- Conflit Israël-Hamas (2023-présent)
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Conflit Israël-Hamas', 
'Conflit armé entre Israël et le Hamas dans la bande de Gaza, déclenché par l''attaque surprise du Hamas le 7 octobre 2023. Conflit de haute intensité avec bombardements massifs et opérations terrestres.', 
2023, NULL, 'En cours', 
'["israel", "palestine"]', 
'{"israeli_casualties": "Plus de 1 400", "palestinian_casualties": "Plus de 25 000", "civilian_casualties": "Plus de 20 000", "displaced": "Plus de 1,9 million"}', 
'Crise humanitaire majeure, tensions régionales, risque d''extension au Liban et en Syrie, impact sur les relations internationales, question de la solution à deux États');

-- Guerre civile au Soudan (2023-présent)
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Guerre civile au Soudan', 
'Conflit armé entre l''Armée régulière soudanaise (SAF) et les Forces de soutien rapide (RSF) depuis avril 2023. Combat pour le contrôle du pouvoir politique et économique au Soudan.', 
2023, NULL, 'En cours', 
'["sudan"]', 
'{"total_casualties": "Plus de 12 000", "displaced": "Plus de 7 millions", "refugees": "Plus de 1,5 million"}', 
'Crise humanitaire majeure, déstabilisation de la région, impact sur les routes migratoires vers l''Europe, intervention de puissances étrangères (Égypte, Émirats)');

-- Conflit au Sahel (2012-présent)
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Conflit au Sahel', 
'Conflits armés dans la région du Sahel impliquant des groupes djihadistes, des forces gouvernementales et des milices locales. Affecte principalement le Mali, le Burkina Faso et le Niger.', 
2012, NULL, 'En cours', 
'["mali", "burkina-faso", "niger", "chad"]', 
'{"total_casualties": "Plus de 15 000", "displaced": "Plus de 3 millions", "terrorist_attacks": "Plus de 2 000 par an"}', 
'Déstabilisation de l''Afrique de l''Ouest, terrorisme islamiste, intervention française (Barkhane), coups d''État militaires, crise humanitaire');

-- Guerre civile en Éthiopie (2020-présent)
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Guerre civile en Éthiopie', 
'Conflit armé dans la région du Tigré en Éthiopie entre le gouvernement fédéral et le Front de libération du peuple du Tigré (TPLF). Conflit complexe avec implications régionales.', 
2020, NULL, 'En cours', 
'["ethiopia", "eritrea"]', 
'{"total_casualties": "Plus de 600 000", "displaced": "Plus de 2,5 millions", "famine_risk": "Plus de 5 millions"}', 
'Crise humanitaire majeure, déstabilisation de la Corne de l''Afrique, impact sur les relations Éthiopie-Érythrée, questions de génocide');

-- Conflit en République démocratique du Congo (1996-présent)
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Conflit en République démocratique du Congo', 
'Conflits armés dans l''est de la RDC impliquant de nombreux groupes armés, milices locales et forces étrangères. Conflit complexe lié aux ressources naturelles.', 
1996, NULL, 'En cours', 
'["democratic-republic-of-congo", "rwanda", "uganda"]', 
'{"total_casualties": "Plus de 6 millions", "displaced": "Plus de 5 millions", "sexual_violence": "Plus de 200 000 cas"}', 
'Exploitation des ressources naturelles (coltan, or), violences sexuelles massives, crise humanitaire, intervention de l''ONU (MONUSCO)');

-- Guerre civile au Yémen (2014-présent)
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Guerre civile au Yémen', 
'Conflit armé entre le gouvernement yéménite soutenu par l''Arabie saoudite et les rebelles Houthis soutenus par l''Iran. Guerre par procuration dans la région.', 
2014, NULL, 'En cours', 
'["yemen", "saudi-arabia", "iran"]', 
'{"total_casualties": "Plus de 150 000", "humanitarian_crisis": "Plus de 24 millions en besoin d''aide", "cholera_cases": "Plus de 2,5 millions"}', 
'Crise humanitaire majeure, intervention de la coalition saoudienne, tensions Iran-Arabie saoudite, blocus maritime, famine');

-- Conflit en République centrafricaine (2012-présent)
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Conflit en République centrafricaine', 
'Conflit armé entre différents groupes armés en RCA, impliquant des milices locales et des forces étrangères. Conflit complexe avec dimensions ethniques et religieuses.', 
2012, NULL, 'En cours', 
'["central-african-republic", "russia", "france"]', 
'{"total_casualties": "Plus de 5 000", "displaced": "Plus de 600 000", "humanitarian_crisis": "Plus de 3 millions en besoin"}', 
'Crise humanitaire, intervention internationale (MINUSCA), exploitation des ressources, présence de mercenaires russes (Wagner)');

-- Conflit au Myanmar (2021-présent)
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Conflit au Myanmar', 
'Conflit armé au Myanmar suite au coup d''État militaire de février 2021. Opposition armée entre la junte militaire et les forces démocratiques, avec implications ethniques.', 
2021, NULL, 'En cours', 
'["myanmar"]', 
'{"total_casualties": "Plus de 8 000", "displaced": "Plus de 2 millions", "refugees": "Plus de 1 million"}', 
'Crise humanitaire, déstabilisation de l''Asie du Sud-Est, impact sur les relations Chine-Myanmar, questions de génocide (Rohingyas)');

-- Conflit en Somalie (1991-présent)
INSERT INTO armed_conflict (name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) VALUES
('Conflit en Somalie', 
'Conflit armé complexe en Somalie impliquant le gouvernement fédéral, les Shebab (Al-Shabaab) et divers groupes armés. Conflit avec dimensions terroristes.', 
1991, NULL, 'En cours', 
'["somalia", "kenya", "ethiopia"]', 
'{"total_casualties": "Plus de 500 000", "terrorist_attacks": "Plus de 1 000 par an", "piracy_peak": "2008-2012"}', 
'Terrorisme islamiste, piratage maritime (réduit), crise humanitaire, intervention de l''AMISOM, impact sur la sécurité maritime'); 