-- Script pour ajouter des relations pays-organisations représentatives
-- Date: 2025-01-XX

-- Relations avec l'ASEAN (utiliser org_asean qui existe)
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion, datesortie) VALUES
-- Membres fondateurs de l'ASEAN
('indonesia', 'org_asean', 'Membre fondateur', '1967-08-08', NULL),
('malaysia', 'org_asean', 'Membre fondateur', '1967-08-08', NULL),
('philippines', 'org_asean', 'Membre fondateur', '1967-08-08', NULL),
('singapore', 'org_asean', 'Membre fondateur', '1967-08-08', NULL),
('thailand', 'org_asean', 'Membre fondateur', '1967-08-08', NULL),

-- Membres plus récents de l'ASEAN
('brunei', 'org_asean', 'Membre', '1984-01-07', NULL),
('vietnam', 'org_asean', 'Membre', '1995-07-28', NULL),
('laos', 'org_asean', 'Membre', '1997-07-23', NULL),
('myanmar', 'org_asean', 'Membre', '1997-07-23', NULL),
('cambodia', 'org_asean', 'Membre', '1999-04-30', NULL);

-- Relations avec l'OMC
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion, datesortie) VALUES
-- Membres de l'OMC
('usa', 'org_wto', 'Membre', '1995-01-01', NULL),
('china', 'org_wto', 'Membre', '2001-12-11', NULL),
('japan', 'org_wto', 'Membre', '1995-01-01', NULL),
('germany', 'org_wto', 'Membre', '1995-01-01', NULL),
('france', 'org_wto', 'Membre', '1995-01-01', NULL),
('india', 'org_wto', 'Membre', '1995-01-01', NULL),
('brazil', 'org_wto', 'Membre', '1995-01-01', NULL),
('russia', 'org_wto', 'Membre', '2012-08-22', NULL),
('south-africa', 'org_wto', 'Membre', '1995-01-01', NULL),
('australia', 'org_wto', 'Membre', '1995-01-01', NULL),
('canada', 'org_wto', 'Membre', '1995-01-01', NULL),
('mexico', 'org_wto', 'Membre', '1995-01-01', NULL),
('south-korea', 'org_wto', 'Membre', '1995-01-01', NULL),
('singapore', 'org_wto', 'Membre', '1995-01-01', NULL);

-- Relations avec l'OCDE
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion, datesortie) VALUES
-- Membres de l'OCDE
('usa', 'org_oecd', 'Membre', '1961-09-30', NULL),
('japan', 'org_oecd', 'Membre', '1964-04-28', NULL),
('germany', 'org_oecd', 'Membre', '1961-09-30', NULL),
('france', 'org_oecd', 'Membre', '1961-09-30', NULL),
('italy', 'org_oecd', 'Membre', '1962-03-29', NULL),
('canada', 'org_oecd', 'Membre', '1961-09-30', NULL),
('australia', 'org_oecd', 'Membre', '1971-06-07', NULL),
('spain', 'org_oecd', 'Membre', '1961-09-30', NULL),
('netherlands', 'org_oecd', 'Membre', '1961-09-30', NULL),
('belgium', 'org_oecd', 'Membre', '1961-09-30', NULL),
('sweden', 'org_oecd', 'Membre', '1961-09-30', NULL),
('switzerland', 'org_oecd', 'Membre', '1961-09-30', NULL),
('austria', 'org_oecd', 'Membre', '1961-09-30', NULL),
('denmark', 'org_oecd', 'Membre', '1961-09-30', NULL),
('norway', 'org_oecd', 'Membre', '1961-09-30', NULL),
('finland', 'org_oecd', 'Membre', '1969-01-28', NULL),
('new-zealand', 'org_oecd', 'Membre', '1973-05-29', NULL),
('ireland', 'org_oecd', 'Membre', '1961-09-30', NULL),
('luxembourg', 'org_oecd', 'Membre', '1961-09-30', NULL),
('iceland', 'org_oecd', 'Membre', '1961-09-30', NULL),
('portugal', 'org_oecd', 'Membre', '1961-09-30', NULL),
('greece', 'org_oecd', 'Membre', '1961-09-30', NULL),
('turkey', 'org_oecd', 'Membre', '1961-09-30', NULL),
('mexico', 'org_oecd', 'Membre', '1994-05-18', NULL),
('czech-republic', 'org_oecd', 'Membre', '1995-12-21', NULL),
('hungary', 'org_oecd', 'Membre', '1996-05-07', NULL),
('poland', 'org_oecd', 'Membre', '1996-11-22', NULL),
('south-korea', 'org_oecd', 'Membre', '1996-12-12', NULL),
('slovakia', 'org_oecd', 'Membre', '2000-12-14', NULL),
('chile', 'org_oecd', 'Membre', '2010-05-07', NULL),
('slovenia', 'org_oecd', 'Membre', '2010-07-21', NULL),
('israel', 'org_oecd', 'Membre', '2010-09-07', NULL),
('estonia', 'org_oecd', 'Membre', '2010-12-09', NULL),
('latvia', 'org_oecd', 'Membre', '2016-07-01', NULL),
('lithuania', 'org_oecd', 'Membre', '2018-07-05', NULL),
('colombia', 'org_oecd', 'Membre', '2020-04-28', NULL),
('costa-rica', 'org_oecd', 'Membre', '2021-05-25', NULL);

-- Relations avec l'OPEP
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion, datesortie) VALUES
-- Membres de l'OPEP
('saudi-arabia', 'org_opec', 'Membre', '1960-09-14', NULL),
('iran', 'org_opec', 'Membre', '1960-09-14', NULL),
('iraq', 'org_opec', 'Membre', '1960-09-14', NULL),
('kuwait', 'org_opec', 'Membre', '1960-09-14', NULL),
('venezuela', 'org_opec', 'Membre', '1960-09-14', NULL),
('qatar', 'org_opec', 'Membre', '1961-12-01', NULL),
('libya', 'org_opec', 'Membre', '1962-06-01', NULL),
('indonesia', 'org_opec', 'Membre', '1962-11-01', NULL),
('uae', 'org_opec', 'Membre', '1967-11-01', NULL),
('algeria', 'org_opec', 'Membre', '1969-07-01', NULL),
('nigeria', 'org_opec', 'Membre', '1971-07-01', NULL),
('ecuador', 'org_opec', 'Membre', '1973-01-01', NULL),
('gabon', 'org_opec', 'Membre', '1975-01-01', NULL),
('angola', 'org_opec', 'Membre', '2007-01-01', NULL),
('equatorial-guinea', 'org_opec', 'Membre', '2017-05-25', NULL),
('congo', 'org_opec', 'Membre', '2018-06-22', NULL);

-- Relations avec l'Union Africaine
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion, datesortie) VALUES
-- Membres de l'Union Africaine
('nigeria', 'org_african_union', 'Membre', '2002-07-09', NULL),
('south-africa', 'org_african_union', 'Membre', '2002-07-09', NULL),
('egypt', 'org_african_union', 'Membre', '2002-07-09', NULL),
('ethiopia', 'org_african_union', 'Membre', '2002-07-09', NULL),
('kenya', 'org_african_union', 'Membre', '2002-07-09', NULL),
('ghana', 'org_african_union', 'Membre', '2002-07-09', NULL),
('morocco', 'org_african_union', 'Membre', '2017-01-30', NULL),
('algeria', 'org_african_union', 'Membre', '2002-07-09', NULL),
('tunisia', 'org_african_union', 'Membre', '2002-07-09', NULL),
('senegal', 'org_african_union', 'Membre', '2002-07-09', NULL),
('cameroon', 'org_african_union', 'Membre', '2002-07-09', NULL),
('angola', 'org_african_union', 'Membre', '2002-07-09', NULL),
('mozambique', 'org_african_union', 'Membre', '2002-07-09', NULL),
('zimbabwe', 'org_african_union', 'Membre', '2002-07-09', NULL);

-- Relations avec le Commonwealth
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion, datesortie) VALUES
-- Membres du Commonwealth
('canada', 'org_commonwealth', 'Membre', '1931-12-11', NULL),
('australia', 'org_commonwealth', 'Membre', '1931-12-11', NULL),
('new-zealand', 'org_commonwealth', 'Membre', '1931-12-11', NULL),
('india', 'org_commonwealth', 'Membre', '1947-08-15', NULL),
('pakistan', 'org_commonwealth', 'Membre', '1947-08-14', NULL),
('sri-lanka', 'org_commonwealth', 'Membre', '1948-02-04', NULL),
('ghana', 'org_commonwealth', 'Membre', '1957-03-06', NULL),
('malaysia', 'org_commonwealth', 'Membre', '1957-08-31', NULL),
('nigeria', 'org_commonwealth', 'Membre', '1960-10-01', NULL),
('cyprus', 'org_commonwealth', 'Membre', '1961-03-13', NULL),
('sierra-leone', 'org_commonwealth', 'Membre', '1961-04-27', NULL),
('tanzania', 'org_commonwealth', 'Membre', '1961-12-09', NULL),
('jamaica', 'org_commonwealth', 'Membre', '1962-08-06', NULL),
('trinidad-and-tobago', 'org_commonwealth', 'Membre', '1962-08-31', NULL),
('uganda', 'org_commonwealth', 'Membre', '1962-10-09', NULL),
('kenya', 'org_commonwealth', 'Membre', '1963-12-12', NULL),
('malawi', 'org_commonwealth', 'Membre', '1964-07-06', NULL),
('malta', 'org_commonwealth', 'Membre', '1964-09-21', NULL),
('zambia', 'org_commonwealth', 'Membre', '1964-10-24', NULL),
('gambia', 'org_commonwealth', 'Membre', '1965-02-18', NULL),
('singapore', 'org_commonwealth', 'Membre', '1965-10-15', NULL),
('guyana', 'org_commonwealth', 'Membre', '1966-05-26', NULL),
('botswana', 'org_commonwealth', 'Membre', '1966-09-30', NULL),
('lesotho', 'org_commonwealth', 'Membre', '1966-10-04', NULL),
('barbados', 'org_commonwealth', 'Membre', '1966-11-30', NULL),
('mauritius', 'org_commonwealth', 'Membre', '1968-03-12', NULL),
('nauru', 'org_commonwealth', 'Membre', '1968-11-01', NULL),
('swaziland', 'org_commonwealth', 'Membre', '1968-09-06', NULL),
('tonga', 'org_commonwealth', 'Membre', '1970-06-04', NULL),
('samoa', 'org_commonwealth', 'Membre', '1970-08-28', NULL),
('bangladesh', 'org_commonwealth', 'Membre', '1972-03-18', NULL),
('bahamas', 'org_commonwealth', 'Membre', '1973-07-10', NULL),
('grenada', 'org_commonwealth', 'Membre', '1974-02-07', NULL),
('papua-new-guinea', 'org_commonwealth', 'Membre', '1975-09-16', NULL),
('seychelles', 'org_commonwealth', 'Membre', '1976-06-29', NULL),
('solomon-islands', 'org_commonwealth', 'Membre', '1978-07-07', NULL),
('tuvalu', 'org_commonwealth', 'Membre', '1978-10-01', NULL),
('dominica', 'org_commonwealth', 'Membre', '1978-11-03', NULL),
('kiribati', 'org_commonwealth', 'Membre', '1979-07-12', NULL),
('saint-lucia', 'org_commonwealth', 'Membre', '1979-02-22', NULL),
('saint-vincent-and-the-grenadines', 'org_commonwealth', 'Membre', '1979-10-27', NULL),
('vanuatu', 'org_commonwealth', 'Membre', '1980-07-30', NULL),
('belize', 'org_commonwealth', 'Membre', '1981-09-21', NULL),
('antigua-and-barbuda', 'org_commonwealth', 'Membre', '1981-11-01', NULL),
('saint-kitts-and-nevis', 'org_commonwealth', 'Membre', '1983-09-19', NULL),
('brunei', 'org_commonwealth', 'Membre', '1984-01-01', NULL),
('namibia', 'org_commonwealth', 'Membre', '1990-03-21', NULL),
('cameroon', 'org_commonwealth', 'Membre', '1995-11-13', NULL),
('mozambique', 'org_commonwealth', 'Membre', '1995-11-13', NULL),
('rwanda', 'org_commonwealth', 'Membre', '2009-11-29', NULL);

-- Relations avec l'OTAN (utiliser org_nato qui existe)
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion, datesortie) VALUES
-- Membres fondateurs de l'OTAN
('usa', 'org_nato', 'Membre fondateur', '1949-04-04', NULL),
('france', 'org_nato', 'Membre fondateur', '1949-04-04', NULL),
('germany', 'org_nato', 'Membre', '1955-05-06', NULL),

-- Membres plus récents de l'OTAN
('poland', 'org_nato', 'Membre', '1999-03-12', NULL),
('czech-republic', 'org_nato', 'Membre', '1999-03-12', NULL),
('hungary', 'org_nato', 'Membre', '1999-03-12', NULL),
('estonia', 'org_nato', 'Membre', '2004-03-29', NULL),
('latvia', 'org_nato', 'Membre', '2004-03-29', NULL),
('lithuania', 'org_nato', 'Membre', '2004-03-29', NULL);

-- Relations avec la Banque mondiale
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion, datesortie) VALUES
-- Membres de la Banque mondiale
('usa', 'org_world_bank', 'Membre', '1944-07-22', NULL),
('japan', 'org_world_bank', 'Membre', '1952-08-13', NULL),
('germany', 'org_world_bank', 'Membre', '1952-08-14', NULL),
('france', 'org_world_bank', 'Membre', '1945-12-27', NULL),
('united-kingdom', 'org_world_bank', 'Membre', '1945-12-27', NULL),
('china', 'org_world_bank', 'Membre', '1980-05-15', NULL),
('india', 'org_world_bank', 'Membre', '1945-12-27', NULL),
('brazil', 'org_world_bank', 'Membre', '1946-01-14', NULL),
('russia', 'org_world_bank', 'Membre', '1992-06-16', NULL),
('south-africa', 'org_world_bank', 'Membre', '1945-12-27', NULL),
('australia', 'org_world_bank', 'Membre', '1947-08-05', NULL),
('canada', 'org_world_bank', 'Membre', '1945-12-27', NULL),
('mexico', 'org_world_bank', 'Membre', '1945-12-27', NULL),
('south-korea', 'org_world_bank', 'Membre', '1955-08-26', NULL),
('singapore', 'org_world_bank', 'Membre', '1966-08-03', NULL);

-- Relations avec le FMI
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion, datesortie) VALUES
-- Membres du FMI
('usa', 'org_imf', 'Membre', '1945-12-27', NULL),
('japan', 'org_imf', 'Membre', '1952-08-13', NULL),
('germany', 'org_imf', 'Membre', '1952-08-14', NULL),
('france', 'org_imf', 'Membre', '1945-12-27', NULL),
('united-kingdom', 'org_imf', 'Membre', '1945-12-27', NULL),
('china', 'org_imf', 'Membre', '1980-05-15', NULL),
('india', 'org_imf', 'Membre', '1945-12-27', NULL),
('brazil', 'org_imf', 'Membre', '1946-01-14', NULL),
('russia', 'org_imf', 'Membre', '1992-06-16', NULL),
('south-africa', 'org_imf', 'Membre', '1945-12-27', NULL),
('australia', 'org_imf', 'Membre', '1947-08-05', NULL),
('canada', 'org_imf', 'Membre', '1945-12-27', NULL),
('mexico', 'org_imf', 'Membre', '1945-12-27', NULL),
('south-korea', 'org_imf', 'Membre', '1955-08-26', NULL),
('singapore', 'org_imf', 'Membre', '1966-08-03', NULL);

-- Affichage des relations ajoutées
SELECT 'Relations pays-organisations ajoutées avec succès' as status;
SELECT COUNT(*) as total_relations FROM country_organization; 