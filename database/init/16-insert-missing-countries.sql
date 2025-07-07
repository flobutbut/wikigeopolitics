-- =====================================================
-- Script pour insérer les pays manquants dans la table country
-- Basé sur l'identification précédente (36 pays)
-- =====================================================

-- Pour chaque pays manquant, on insère avec des valeurs par défaut pour les champs non obligatoires
-- À adapter si certains champs sont NOT NULL sans valeur par défaut

INSERT INTO country (nom, continent)
SELECT 'Burundi', 'Afrique' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Burundi');
INSERT INTO country (nom, continent)
SELECT 'Congo', 'Afrique' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Congo');
INSERT INTO country (nom, continent)
SELECT 'Tunisie', 'Afrique' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Tunisie');
INSERT INTO country (nom, continent)
SELECT 'Antigua-et-Barbuda', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Antigua-et-Barbuda');
INSERT INTO country (nom, continent)
SELECT 'Bahamas', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Bahamas');
INSERT INTO country (nom, continent)
SELECT 'Barbade', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Barbade');
INSERT INTO country (nom, continent)
SELECT 'Belize', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Belize');
INSERT INTO country (nom, continent)
SELECT 'Costa Rica', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Costa Rica');
INSERT INTO country (nom, continent)
SELECT 'Dominique', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Dominique');
INSERT INTO country (nom, continent)
SELECT 'Grenade', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Grenade');
INSERT INTO country (nom, continent)
SELECT 'Guatemala', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Guatemala');
INSERT INTO country (nom, continent)
SELECT 'Haïti', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Haïti');
INSERT INTO country (nom, continent)
SELECT 'Honduras', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Honduras');
INSERT INTO country (nom, continent)
SELECT 'Jamaïque', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Jamaïque');
INSERT INTO country (nom, continent)
SELECT 'Nicaragua', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Nicaragua');
INSERT INTO country (nom, continent)
SELECT 'Panama', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Panama');
INSERT INTO country (nom, continent)
SELECT 'République dominicaine', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'République dominicaine');
INSERT INTO country (nom, continent)
SELECT 'Saint-Kitts-et-Nevis', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Saint-Kitts-et-Nevis');
INSERT INTO country (nom, continent)
SELECT 'Saint-Lucie', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Saint-Lucie');
INSERT INTO country (nom, continent)
SELECT 'Saint-Vincent-et-les-Grenadines', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Saint-Vincent-et-les-Grenadines');
INSERT INTO country (nom, continent)
SELECT 'Salvador', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Salvador');
INSERT INTO country (nom, continent)
SELECT 'Trinité-et-Tobago', 'Amérique du Nord' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Trinité-et-Tobago');
INSERT INTO country (nom, continent)
SELECT 'Bahreïn', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Bahreïn');
INSERT INTO country (nom, continent)
SELECT 'Birmanie', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Birmanie');
INSERT INTO country (nom, continent)
SELECT 'Israël', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Israël');
INSERT INTO country (nom, continent)
SELECT 'Jordanie', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Jordanie');
INSERT INTO country (nom, continent)
SELECT 'Kirghizistan', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Kirghizistan');
INSERT INTO country (nom, continent)
SELECT 'Koweït', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Koweït');
INSERT INTO country (nom, continent)
SELECT 'Liban', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Liban');
INSERT INTO country (nom, continent)
SELECT 'Oman', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Oman');
INSERT INTO country (nom, continent)
SELECT 'Syrie', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Syrie');
INSERT INTO country (nom, continent)
SELECT 'Tadjikistan', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Tadjikistan');
INSERT INTO country (nom, continent)
SELECT 'Turkménistan', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Turkménistan');
INSERT INTO country (nom, continent)
SELECT 'Yémen', 'Asie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Yémen');
INSERT INTO country (nom, continent)
SELECT 'Marshall', 'Océanie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Marshall');
INSERT INTO country (nom, continent)
SELECT 'Salomon', 'Océanie' WHERE NOT EXISTS (SELECT 1 FROM country WHERE nom = 'Salomon'); 