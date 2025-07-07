-- =====================================================
-- Script pour insérer les pays manquants dans la table country
-- Respecte le format d'id déjà présent (slug anglais)
-- =====================================================

INSERT INTO country (id, nom, continent)
SELECT 'burundi', 'Burundi', 'Afrique' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'burundi');
INSERT INTO country (id, nom, continent)
SELECT 'tunisia', 'Tunisie', 'Afrique' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'tunisia');
INSERT INTO country (id, nom, continent)
SELECT 'antigua-and-barbuda', 'Antigua-et-Barbuda', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'antigua-and-barbuda');
INSERT INTO country (id, nom, continent)
SELECT 'bahamas', 'Bahamas', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'bahamas');
INSERT INTO country (id, nom, continent)
SELECT 'barbados', 'Barbade', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'barbados');
INSERT INTO country (id, nom, continent)
SELECT 'belize', 'Belize', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'belize');
INSERT INTO country (id, nom, continent)
SELECT 'costa-rica', 'Costa Rica', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'costa-rica');
INSERT INTO country (id, nom, continent)
SELECT 'dominica', 'Dominique', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'dominica');
INSERT INTO country (id, nom, continent)
SELECT 'grenada', 'Grenade', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'grenada');
INSERT INTO country (id, nom, continent)
SELECT 'guatemala', 'Guatemala', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'guatemala');
INSERT INTO country (id, nom, continent)
SELECT 'haiti', 'Haïti', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'haiti');
INSERT INTO country (id, nom, continent)
SELECT 'honduras', 'Honduras', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'honduras');
INSERT INTO country (id, nom, continent)
SELECT 'jamaica', 'Jamaïque', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'jamaica');
INSERT INTO country (id, nom, continent)
SELECT 'nicaragua', 'Nicaragua', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'nicaragua');
INSERT INTO country (id, nom, continent)
SELECT 'panama', 'Panama', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'panama');
INSERT INTO country (id, nom, continent)
SELECT 'dominican-republic', 'République dominicaine', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'dominican-republic');
INSERT INTO country (id, nom, continent)
SELECT 'saint-kitts-and-nevis', 'Saint-Kitts-et-Nevis', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'saint-kitts-and-nevis');
INSERT INTO country (id, nom, continent)
SELECT 'saint-lucia', 'Saint-Lucie', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'saint-lucia');
INSERT INTO country (id, nom, continent)
SELECT 'saint-vincent-and-the-grenadines', 'Saint-Vincent-et-les-Grenadines', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'saint-vincent-and-the-grenadines');
INSERT INTO country (id, nom, continent)
SELECT 'el-salvador', 'Salvador', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'el-salvador');
INSERT INTO country (id, nom, continent)
SELECT 'trinidad-and-tobago', 'Trinité-et-Tobago', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'trinidad-and-tobago');
INSERT INTO country (id, nom, continent)
SELECT 'bahrain', 'Bahreïn', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'bahrain');
INSERT INTO country (id, nom, continent)
SELECT 'myanmar', 'Birmanie', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'myanmar');
INSERT INTO country (id, nom, continent)
SELECT 'israel', 'Israël', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'israel');
INSERT INTO country (id, nom, continent)
SELECT 'jordan', 'Jordanie', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'jordan');
INSERT INTO country (id, nom, continent)
SELECT 'kyrgyzstan', 'Kirghizistan', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'kyrgyzstan');
INSERT INTO country (id, nom, continent)
SELECT 'kuwait', 'Koweït', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'kuwait');
INSERT INTO country (id, nom, continent)
SELECT 'lebanon', 'Liban', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'lebanon');
INSERT INTO country (id, nom, continent)
SELECT 'oman', 'Oman', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'oman');
INSERT INTO country (id, nom, continent)
SELECT 'syria', 'Syrie', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'syria');
INSERT INTO country (id, nom, continent)
SELECT 'tajikistan', 'Tadjikistan', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'tajikistan');
INSERT INTO country (id, nom, continent)
SELECT 'turkmenistan', 'Turkménistan', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'turkmenistan');
INSERT INTO country (id, nom, continent)
SELECT 'yemen', 'Yémen', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'yemen');
INSERT INTO country (id, nom, continent)
SELECT 'marshall-islands', 'Marshall', 'Océanie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'marshall-islands');
INSERT INTO country (id, nom, continent)
SELECT 'solomon-islands', 'Salomon', 'Océanie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE id = 'solomon-islands'); 