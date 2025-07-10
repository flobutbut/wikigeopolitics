-- Script pour ajouter des organisations diplomatiques et commerciales supplémentaires
-- Date: 2025-01-XX

-- Organisations diplomatiques et politiques
INSERT INTO organization (id, nom, type, description, datecreation, siege) VALUES
-- Organisations diplomatiques régionales
('org_african_union', 'Union Africaine (UA)', 'Organisation régionale', 'Organisation continentale regroupant 55 États membres africains, succédant à l''Organisation de l''unité africaine (OUA)', '2002-07-09', 'Addis-Abeba, Éthiopie'),
('org_asean', 'Association des nations de l''Asie du Sud-Est (ASEAN)', 'Organisation régionale', 'Organisation politique, économique et culturelle regroupant 10 pays d''Asie du Sud-Est', '1967-08-08', 'Jakarta, Indonésie'),
('org_mercosur', 'Mercosur', 'Union douanière', 'Marché commun du Sud, union douanière et zone de libre-échange en Amérique du Sud', '1991-03-26', 'Montevideo, Uruguay'),
('org_afcfta', 'Zone de libre-échange continentale africaine (ZLECAf)', 'Zone de libre-échange', 'Zone de libre-échange continentale africaine visant à créer un marché unique africain', '2019-05-30', 'Kigali, Rwanda'),

-- Organisations commerciales et économiques
('org_wto', 'Organisation mondiale du commerce (OMC)', 'Organisation commerciale', 'Organisation internationale qui s''occupe des règles régissant le commerce entre les nations', '1995-01-01', 'Genève, Suisse'),
('org_oecd', 'Organisation de coopération et de développement économiques (OCDE)', 'Organisation économique', 'Organisation internationale d''études économiques, dont les pays membres ont en commun un système de gouvernement démocratique et une économie de marché', '1961-09-30', 'Paris, France'),
('org_imf', 'Fonds monétaire international (FMI)', 'Institution financière', 'Institution financière internationale qui veille à la stabilité du système monétaire international', '1945-12-27', 'Washington, États-Unis'),
('org_world_bank', 'Banque mondiale', 'Institution financière', 'Institution financière internationale qui accorde des prêts aux pays en développement', '1944-07-22', 'Washington, États-Unis'),

-- Organisations de sécurité et défense
('org_nato', 'Organisation du Traité de l''Atlantique Nord (OTAN)', 'Alliance militaire', 'Alliance militaire intergouvernementale basée sur le Traité de l''Atlantique Nord', '1949-04-04', 'Bruxelles, Belgique'),
('org_csto', 'Organisation du Traité de sécurité collective (OTSC)', 'Alliance militaire', 'Alliance militaire eurasienne regroupant plusieurs pays de l''ex-URSS', '2002-05-15', 'Moscou, Russie'),
('org_gulf_cooperation', 'Conseil de coopération du Golfe (CCG)', 'Organisation régionale', 'Organisation politique et économique des États arabes du Golfe Persique', '1981-05-25', 'Riyad, Arabie saoudite'),

-- Organisations de développement et coopération
('org_commonwealth', 'Commonwealth des Nations', 'Organisation intergouvernementale', 'Association volontaire de 56 États souverains, la plupart étant d''anciens territoires de l''Empire britannique', '1931-12-11', 'Londres, Royaume-Uni'),
('org_francophonie', 'Organisation internationale de la Francophonie (OIF)', 'Organisation culturelle', 'Organisation internationale de pays francophones', '1970-03-20', 'Paris, France'),
('org_commonwealth_independent', 'Communauté des États indépendants (CEI)', 'Organisation régionale', 'Organisation régionale regroupant 9 des 15 anciennes républiques soviétiques', '1991-12-21', 'Minsk, Biélorussie'),

-- Organisations spécialisées
('org_icao', 'Organisation de l''aviation civile internationale (OACI)', 'Organisation spécialisée', 'Agence spécialisée de l''ONU qui établit les normes internationales de l''aviation civile', '1947-04-04', 'Montréal, Canada'),
('org_imo', 'Organisation maritime internationale (OMI)', 'Organisation spécialisée', 'Institution spécialisée de l''ONU chargée de la sécurité maritime et de la prévention de la pollution marine', '1959-03-17', 'Londres, Royaume-Uni'),
('org_who', 'Organisation mondiale de la santé (OMS)', 'Organisation spécialisée', 'Institution spécialisée de l''ONU pour la santé publique internationale', '1948-04-07', 'Genève, Suisse'),

-- Organisations de développement régional
('org_eac', 'Communauté d''Afrique de l''Est (CAE)', 'Organisation régionale', 'Organisation intergouvernementale d''Afrique de l''Est', '2000-07-07', 'Arusha, Tanzanie'),
('org_ecowas', 'Communauté économique des États de l''Afrique de l''Ouest (CEDEAO)', 'Organisation régionale', 'Organisation régionale d''Afrique de l''Ouest', '1975-05-28', 'Abuja, Nigeria'),
('org_sadc', 'Communauté de développement d''Afrique australe (SADC)', 'Organisation régionale', 'Organisation intergouvernementale d''Afrique australe', '1992-08-17', 'Gaborone, Botswana'),

-- Organisations commerciales spécialisées
('org_opec', 'Organisation des pays exportateurs de pétrole (OPEP)', 'Cartel pétrolier', 'Organisation intergouvernementale de pays producteurs de pétrole', '1960-09-14', 'Vienne, Autriche'),
('org_opec_plus', 'OPEP+', 'Alliance pétrolière', 'Alliance entre l''OPEP et d''autres producteurs de pétrole pour coordonner la production', '2016-12-10', 'Vienne, Autriche'),
('org_gas_exporting', 'Forum des pays exportateurs de gaz (FPEG)', 'Organisation gazière', 'Organisation intergouvernementale de pays exportateurs de gaz naturel', '2001-05-23', 'Doha, Qatar'),

-- Organisations de coopération technique
('org_iso', 'Organisation internationale de normalisation (ISO)', 'Organisation de normalisation', 'Organisation internationale de normalisation composée d''organismes nationaux de normalisation', '1947-02-23', 'Genève, Suisse'),
('org_iea', 'Agence internationale de l''énergie (AIE)', 'Organisation énergétique', 'Organisation internationale chargée de coordonner les politiques énergétiques des pays membres', '1974-11-15', 'Paris, France'),
('org_irena', 'Agence internationale pour les énergies renouvelables (IRENA)', 'Organisation énergétique', 'Organisation intergouvernementale pour promouvoir l''adoption et l''utilisation durable des énergies renouvelables', '2009-01-26', 'Abou Dabi, Émirats arabes unis');

-- Affichage des organisations ajoutées
SELECT 'Organisations ajoutées avec succès' as status;
SELECT COUNT(*) as total_organizations FROM organization; 