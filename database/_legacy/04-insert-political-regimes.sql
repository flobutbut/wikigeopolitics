-- Insertion des régimes politiques
-- Script: 04-insert-political-regimes.sql

-- Insertion des régimes politiques
INSERT INTO political_regime (id, name, description, characteristics, examples) VALUES
('democratie-representative', 'Démocratie représentative', 
'Système dans lequel les citoyens élisent des représentants qui prennent les décisions en leur nom.',
'["Élections libres et régulières", "Séparation des pouvoirs", "Protection des libertés civiles", "État de droit"]',
'["usa", "france", "germany", "uk", "canada"]'),

('monarchie-constitutionnelle', 'Monarchie constitutionnelle',
'Système dans lequel un monarque est le chef d''État, mais son pouvoir est limité par une constitution.',
'["Monarque comme chef d''État", "Pouvoir limité par la constitution", "Parlement élu", "Premier ministre comme chef de gouvernement"]',
'["uk", "spain", "sweden", "norway", "japan"]'),

('republique-federale', 'République fédérale',
'Système où le pouvoir est partagé entre un gouvernement central et des entités fédérées.',
'["Constitution écrite définissant les pouvoirs", "Autonomie des entités fédérées", "Double niveau de gouvernement", "Mécanismes de résolution des conflits de compétence"]',
'["usa", "germany", "brazil", "india", "australia"]'),

('regime-autoritaire', 'Régime autoritaire',
'Système où le pouvoir politique est concentré et les libertés individuelles limitées.',
'["Concentration du pouvoir", "Limitations des libertés civiles", "Contrôle des médias", "Restrictions du pluralisme politique"]',
'["china", "russia", "north-korea", "iran", "saudi-arabia"]'),

('democratie-directe', 'Démocratie directe',
'Système où les citoyens participent directement aux décisions politiques.',
'["Référendums fréquents", "Initiative populaire", "Participation directe", "Transparence des processus"]',
'["switzerland"]'),

('republique-parlementaire', 'République parlementaire',
'Système où le chef de l''État est élu mais le pouvoir exécutif appartient au gouvernement responsable devant le parlement.',
'["Chef d''État élu", "Gouvernement responsable devant le parlement", "Séparation des pouvoirs", "Élections législatives déterminantes"]',
'["germany", "italy", "india", "south-africa"]'),

('republique-presidentielle', 'République présidentielle',
'Système où le président est à la fois chef de l''État et chef du gouvernement.',
'["Président élu au suffrage universel", "Pouvoirs exécutifs étendus", "Séparation stricte des pouvoirs", "Veto présidentiel"]',
'["usa", "brazil", "france", "russia"]'),

('monarchie-absolue', 'Monarchie absolue',
'Système où le monarque détient tous les pouvoirs sans limitation constitutionnelle.',
'["Pouvoir absolu du monarque", "Absence de constitution limitative", "Hérédité du pouvoir", "Contrôle total de l''État"]',
'["saudi-arabia", "brunei", "oman"]'),

('regime-hybride', 'Régime hybride',
'Système combinant des éléments démocratiques et autoritaires.',
'["Élections mais avec restrictions", "Libertés civiles partielles", "Contrôle médiatique", "Opposition limitée"]',
'["russia", "turkey", "hungary", "poland"]'),

('theocratie', 'Théocratie',
'Système où le pouvoir politique est exercé au nom de la religion.',
'["Autorité religieuse suprême", "Lois basées sur la religion", "Clergé au pouvoir", "Fusion religion-État"]',
'["iran", "vatican"]');

-- Insertion des transitions politiques (exemples)
INSERT INTO political_transition (from_regime_id, to_regime_id, country_id, year, description) VALUES
('regime-autoritaire', 'democratie-representative', 'germany', '1990', 'Réunification allemande et transition vers la démocratie'),
('regime-autoritaire', 'democratie-representative', 'south-africa', '1994', 'Fin de l''apartheid et transition démocratique'),
('monarchie-absolue', 'monarchie-constitutionnelle', 'uk', '1688', 'Glorious Revolution et établissement de la monarchie constitutionnelle'),
('regime-autoritaire', 'republique-presidentielle', 'russia', '1991', 'Effondrement de l''URSS et transition vers la république présidentielle'); 