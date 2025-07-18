-- Complétion des membres pour 4 organisations majeures (lot 1)
-- MERCOSUR, OIF, FMI, Banque mondiale

-- MERCOSUR (id: org_mercosur)
INSERT INTO country_organization (countryid, organizationid)
SELECT id, 'org_mercosur' FROM country WHERE id IN ('argentina', 'brazil', 'paraguay', 'uruguay', 'bolivia');

-- OIF (id: org_francophonie)
INSERT INTO country_organization (countryid, organizationid)
SELECT id, 'org_francophonie' FROM country WHERE id IN ('france', 'canada', 'belgium', 'switzerland', 'senegal', 'cote-divoire', 'morocco', 'tunisia', 'vietnam', 'lebanon');

-- FMI (id: org_imf)
INSERT INTO country_organization (countryid, organizationid)
SELECT id, 'org_imf' FROM country WHERE id IN ('france', 'germany', 'usa', 'china', 'brazil', 'india', 'russia', 'south-africa', 'japan', 'canada');

-- Banque mondiale (id: org_world_bank)
INSERT INTO country_organization (countryid, organizationid)
SELECT id, 'org_world_bank' FROM country WHERE id IN ('france', 'germany', 'usa', 'china', 'brazil', 'india', 'russia', 'south-africa', 'japan', 'canada'); 