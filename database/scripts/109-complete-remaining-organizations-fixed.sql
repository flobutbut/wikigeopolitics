-- Script corrigé pour compléter les pays membres des organisations restantes
-- Utilisation des identifiants corrects des organisations

-- 1. APEC (Coopération économique Asie-Pacifique) - 21 membres
-- Vérification des pays existants d'abord
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion) VALUES
('australia', 'apec', 'membre', '1989-01-01'),
('brunei', 'apec', 'membre', '1989-01-01'),
('canada', 'apec', 'membre', '1989-01-01'),
('chile', 'apec', 'membre', '1994-01-01'),
('china', 'apec', 'membre', '1991-01-01'),
('indonesia', 'apec', 'membre', '1989-01-01'),
('japan', 'apec', 'membre', '1989-01-01'),
('malaysia', 'apec', 'membre', '1989-01-01'),
('mexico', 'apec', 'membre', '1993-01-01'),
('new-zealand', 'apec', 'membre', '1989-01-01'),
('papua-new-guinea', 'apec', 'membre', '1993-01-01'),
('peru', 'apec', 'membre', '1998-01-01'),
('philippines', 'apec', 'membre', '1989-01-01'),
('russia', 'apec', 'membre', '1998-01-01'),
('singapore', 'apec', 'membre', '1989-01-01'),
('south-korea', 'apec', 'membre', '1989-01-01'),
('thailand', 'apec', 'membre', '1989-01-01'),
('united-states', 'apec', 'membre', '1989-01-01'),
('vietnam', 'apec', 'membre', '1998-01-01')
ON CONFLICT (countryid, organizationid) DO NOTHING;

-- 2. Commonwealth des Nations - 56 membres
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion) VALUES
('antigua-and-barbuda', 'org_commonwealth', 'membre', '1981-11-01'),
('australia', 'org_commonwealth', 'membre', '1931-12-11'),
('bahamas', 'org_commonwealth', 'membre', '1973-07-10'),
('bangladesh', 'org_commonwealth', 'membre', '1972-03-18'),
('barbados', 'org_commonwealth', 'membre', '1966-11-30'),
('belize', 'org_commonwealth', 'membre', '1981-09-21'),
('botswana', 'org_commonwealth', 'membre', '1966-09-30'),
('brunei', 'org_commonwealth', 'membre', '1984-01-01'),
('cameroon', 'org_commonwealth', 'membre', '1995-11-13'),
('canada', 'org_commonwealth', 'membre', '1931-12-11'),
('cyprus', 'org_commonwealth', 'membre', '1961-03-13'),
('dominica', 'org_commonwealth', 'membre', '1978-11-03'),
('eswatini', 'org_commonwealth', 'membre', '1968-09-06'),
('fiji', 'org_commonwealth', 'membre', '1970-10-10'),
('gambia', 'org_commonwealth', 'membre', '1965-02-18'),
('ghana', 'org_commonwealth', 'membre', '1957-03-06'),
('grenada', 'org_commonwealth', 'membre', '1974-02-07'),
('guyana', 'org_commonwealth', 'membre', '1966-05-26'),
('india', 'org_commonwealth', 'membre', '1947-08-15'),
('jamaica', 'org_commonwealth', 'membre', '1962-08-06'),
('kenya', 'org_commonwealth', 'membre', '1963-12-12'),
('kiribati', 'org_commonwealth', 'membre', '1979-07-12'),
('lesotho', 'org_commonwealth', 'membre', '1966-10-04'),
('malawi', 'org_commonwealth', 'membre', '1964-07-06'),
('malaysia', 'org_commonwealth', 'membre', '1957-08-31'),
('maldives', 'org_commonwealth', 'membre', '1982-07-09'),
('malta', 'org_commonwealth', 'membre', '1964-09-21'),
('mauritius', 'org_commonwealth', 'membre', '1968-03-12'),
('mozambique', 'org_commonwealth', 'membre', '1995-11-13'),
('namibia', 'org_commonwealth', 'membre', '1990-03-21'),
('nauru', 'org_commonwealth', 'membre', '1968-11-01'),
('new-zealand', 'org_commonwealth', 'membre', '1931-12-11'),
('nigeria', 'org_commonwealth', 'membre', '1960-10-01'),
('pakistan', 'org_commonwealth', 'membre', '1947-08-14'),
('papua-new-guinea', 'org_commonwealth', 'membre', '1975-09-16'),
('rwanda', 'org_commonwealth', 'membre', '2009-11-29'),
('saint-kitts-and-nevis', 'org_commonwealth', 'membre', '1983-09-19'),
('saint-lucia', 'org_commonwealth', 'membre', '1979-02-22'),
('saint-vincent-and-the-grenadines', 'org_commonwealth', 'membre', '1979-10-27'),
('samoa', 'org_commonwealth', 'membre', '1970-08-28'),
('seychelles', 'org_commonwealth', 'membre', '1976-06-29'),
('sierra-leone', 'org_commonwealth', 'membre', '1961-04-27'),
('singapore', 'org_commonwealth', 'membre', '1965-10-15'),
('solomon-islands', 'org_commonwealth', 'membre', '1978-07-07'),
('south-africa', 'org_commonwealth', 'membre', '1931-12-11'),
('sri-lanka', 'org_commonwealth', 'membre', '1948-02-04'),
('tanzania', 'org_commonwealth', 'membre', '1961-12-09'),
('tonga', 'org_commonwealth', 'membre', '1970-06-04'),
('trinidad-and-tobago', 'org_commonwealth', 'membre', '1962-08-31'),
('tuvalu', 'org_commonwealth', 'membre', '1978-10-01'),
('uganda', 'org_commonwealth', 'membre', '1962-10-09'),
('united-kingdom', 'org_commonwealth', 'membre', '1931-12-11'),
('vanuatu', 'org_commonwealth', 'membre', '1980-07-30'),
('zambia', 'org_commonwealth', 'membre', '1964-10-24'),
('zimbabwe', 'org_commonwealth', 'membre', '1980-04-18')
ON CONFLICT (countryid, organizationid) DO NOTHING;

-- 3. ALENA (Accord de libre-échange nord-américain) - 3 membres
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion) VALUES
('canada', 'rel_accord_libre_echange_na', 'membre', '1994-01-01'),
('mexico', 'rel_accord_libre_echange_na', 'membre', '1994-01-01'),
('united-states', 'rel_accord_libre_echange_na', 'membre', '1994-01-01')
ON CONFLICT (countryid, organizationid) DO NOTHING;

-- 4. AEUMC (Accord États-Unis-Mexique-Canada) - 3 membres
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion) VALUES
('canada', 'rel_accord_etats_unis_mexique_canada', 'membre', '2020-07-01'),
('mexico', 'rel_accord_etats_unis_mexique_canada', 'membre', '2020-07-01'),
('united-states', 'rel_accord_etats_unis_mexique_canada', 'membre', '2020-07-01')
ON CONFLICT (countryid, organizationid) DO NOTHING;

-- 5. OEA (Organisation des États américains) - 35 membres
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion) VALUES
('antigua-and-barbuda', 'rel_organisation_etats_americains', 'membre', '1981-01-01'),
('argentina', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('bahamas', 'rel_organisation_etats_americains', 'membre', '1982-07-10'),
('barbados', 'rel_organisation_etats_americains', 'membre', '1967-11-30'),
('belize', 'rel_organisation_etats_americains', 'membre', '1991-01-08'),
('bolivia', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('brazil', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('canada', 'rel_organisation_etats_americains', 'membre', '1990-01-08'),
('chile', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('colombia', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('costa-rica', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('cuba', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('dominica', 'rel_organisation_etats_americains', 'membre', '1979-01-08'),
('dominican-republic', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('ecuador', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('el-salvador', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('grenada', 'rel_organisation_etats_americains', 'membre', '1975-01-08'),
('guatemala', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('guyana', 'rel_organisation_etats_americains', 'membre', '1991-01-08'),
('haiti', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('honduras', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('jamaica', 'rel_organisation_etats_americains', 'membre', '1969-08-18'),
('mexico', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('nicaragua', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('panama', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('paraguay', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('peru', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('saint-kitts-and-nevis', 'rel_organisation_etats_americains', 'membre', '1987-01-08'),
('saint-lucia', 'rel_organisation_etats_americains', 'membre', '1979-01-08'),
('saint-vincent-and-the-grenadines', 'rel_organisation_etats_americains', 'membre', '1981-01-08'),
('suriname', 'rel_organisation_etats_americains', 'membre', '1977-07-25'),
('trinidad-and-tobago', 'rel_organisation_etats_americains', 'membre', '1967-02-23'),
('united-states', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('uruguay', 'rel_organisation_etats_americains', 'membre', '1948-04-30'),
('venezuela', 'rel_organisation_etats_americains', 'membre', '1948-04-30')
ON CONFLICT (countryid, organizationid) DO NOTHING;

-- 6. CAE (Communauté d'Afrique de l'Est) - 6 membres
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion) VALUES
('burundi', 'org_eac', 'membre', '2007-07-01'),
('kenya', 'org_eac', 'membre', '2000-07-07'),
('rwanda', 'org_eac', 'membre', '2007-07-01'),
('south-sudan', 'org_eac', 'membre', '2016-09-05'),
('tanzania', 'org_eac', 'membre', '2000-07-07'),
('uganda', 'org_eac', 'membre', '2000-07-07')
ON CONFLICT (countryid, organizationid) DO NOTHING;

-- 7. ZLECAf (Zone de libre-échange continentale africaine) - 54 membres
INSERT INTO country_organization (countryid, organizationid, role, dateadhesion) VALUES
('algeria', 'org_afcfta', 'membre', '2021-01-01'),
('angola', 'org_afcfta', 'membre', '2021-01-01'),
('benin', 'org_afcfta', 'membre', '2021-01-01'),
('botswana', 'org_afcfta', 'membre', '2021-01-01'),
('burkina-faso', 'org_afcfta', 'membre', '2021-01-01'),
('burundi', 'org_afcfta', 'membre', '2021-01-01'),
('cameroon', 'org_afcfta', 'membre', '2021-01-01'),
('cape-verde', 'org_afcfta', 'membre', '2021-01-01'),
('central-african-republic', 'org_afcfta', 'membre', '2021-01-01'),
('chad', 'org_afcfta', 'membre', '2021-01-01'),
('comoros', 'org_afcfta', 'membre', '2021-01-01'),
('congo', 'org_afcfta', 'membre', '2021-01-01'),
('cote-divoire', 'org_afcfta', 'membre', '2021-01-01'),
('democratic-republic-of-congo', 'org_afcfta', 'membre', '2021-01-01'),
('djibouti', 'org_afcfta', 'membre', '2021-01-01'),
('egypt', 'org_afcfta', 'membre', '2021-01-01'),
('equatorial-guinea', 'org_afcfta', 'membre', '2021-01-01'),
('eritrea', 'org_afcfta', 'membre', '2021-01-01'),
('eswatini', 'org_afcfta', 'membre', '2021-01-01'),
('ethiopia', 'org_afcfta', 'membre', '2021-01-01'),
('gabon', 'org_afcfta', 'membre', '2021-01-01'),
('gambia', 'org_afcfta', 'membre', '2021-01-01'),
('ghana', 'org_afcfta', 'membre', '2021-01-01'),
('guinea', 'org_afcfta', 'membre', '2021-01-01'),
('guinea-bissau', 'org_afcfta', 'membre', '2021-01-01'),
('kenya', 'org_afcfta', 'membre', '2021-01-01'),
('lesotho', 'org_afcfta', 'membre', '2021-01-01'),
('liberia', 'org_afcfta', 'membre', '2021-01-01'),
('libya', 'org_afcfta', 'membre', '2021-01-01'),
('madagascar', 'org_afcfta', 'membre', '2021-01-01'),
('malawi', 'org_afcfta', 'membre', '2021-01-01'),
('mali', 'org_afcfta', 'membre', '2021-01-01'),
('mauritania', 'org_afcfta', 'membre', '2021-01-01'),
('mauritius', 'org_afcfta', 'membre', '2021-01-01'),
('morocco', 'org_afcfta', 'membre', '2021-01-01'),
('mozambique', 'org_afcfta', 'membre', '2021-01-01'),
('namibia', 'org_afcfta', 'membre', '2021-01-01'),
('niger', 'org_afcfta', 'membre', '2021-01-01'),
('nigeria', 'org_afcfta', 'membre', '2021-01-01'),
('rwanda', 'org_afcfta', 'membre', '2021-01-01'),
('sao-tome-and-principe', 'org_afcfta', 'membre', '2021-01-01'),
('senegal', 'org_afcfta', 'membre', '2021-01-01'),
('seychelles', 'org_afcfta', 'membre', '2021-01-01'),
('sierra-leone', 'org_afcfta', 'membre', '2021-01-01'),
('somalia', 'org_afcfta', 'membre', '2021-01-01'),
('south-africa', 'org_afcfta', 'membre', '2021-01-01'),
('south-sudan', 'org_afcfta', 'membre', '2021-01-01'),
('sudan', 'org_afcfta', 'membre', '2021-01-01'),
('tanzania', 'org_afcfta', 'membre', '2021-01-01'),
('togo', 'org_afcfta', 'membre', '2021-01-01'),
('tunisia', 'org_afcfta', 'membre', '2021-01-01'),
('uganda', 'org_afcfta', 'membre', '2021-01-01'),
('zambia', 'org_afcfta', 'membre', '2021-01-01'),
('zimbabwe', 'org_afcfta', 'membre', '2021-01-01')
ON CONFLICT (countryid, organizationid) DO NOTHING;

-- Vérification finale
SELECT o.id, o.nom, o.acronyme, COUNT(co.countryid) as member_count 
FROM organization o 
LEFT JOIN country_organization co ON o.id = co.organizationid 
GROUP BY o.id, o.nom, o.acronyme 
ORDER BY member_count ASC, o.nom; 