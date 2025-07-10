-- Script pour ajouter des relations pays-ressources naturelles représentatives
-- Date: 2025-01-XX

-- Pétrole
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('petrole', 'saudi-arabia', 'Producteur majeur', 10100000, 'barils/jour'),
('petrole', 'russia', 'Producteur majeur', 9500000, 'barils/jour'),
('petrole', 'usa', 'Producteur majeur', 12000000, 'barils/jour'),
('petrole', 'iran', 'Producteur', 4000000, 'barils/jour'),
('petrole', 'iraq', 'Producteur', 4200000, 'barils/jour'),
('petrole', 'venezuela', 'Producteur', 2500000, 'barils/jour'),
('petrole', 'canada', 'Producteur', 4500000, 'barils/jour'),
('petrole', 'china', 'Producteur', 3800000, 'barils/jour'),
('petrole', 'brazil', 'Producteur', 3000000, 'barils/jour'),
('petrole', 'norway', 'Producteur', 2000000, 'barils/jour');

-- Gaz naturel
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('gaz-naturel', 'usa', 'Producteur majeur', 950000000, 'm3/jour'),
('gaz-naturel', 'russia', 'Producteur majeur', 700000000, 'm3/jour'),
('gaz-naturel', 'iran', 'Producteur', 250000000, 'm3/jour'),
('gaz-naturel', 'qatar', 'Producteur', 180000000, 'm3/jour'),
('gaz-naturel', 'china', 'Producteur', 150000000, 'm3/jour'),
('gaz-naturel', 'canada', 'Producteur', 170000000, 'm3/jour'),
('gaz-naturel', 'norway', 'Producteur', 120000000, 'm3/jour'),
('gaz-naturel', 'algeria', 'Producteur', 100000000, 'm3/jour');

-- Uranium
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('uranium', 'kazakhstan', 'Producteur majeur', 19000, 'tonnes/an'),
('uranium', 'canada', 'Producteur', 7000, 'tonnes/an'),
('uranium', 'australia', 'Producteur', 6000, 'tonnes/an'),
('uranium', 'namibia', 'Producteur', 5500, 'tonnes/an'),
('uranium', 'niger', 'Producteur', 2000, 'tonnes/an'),
('uranium', 'russia', 'Producteur', 3000, 'tonnes/an');

-- Lithium
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('lithium', 'australia', 'Producteur majeur', 55000, 'tonnes/an'),
('lithium', 'chile', 'Producteur majeur', 40000, 'tonnes/an'),
('lithium', 'china', 'Producteur', 20000, 'tonnes/an'),
('lithium', 'argentina', 'Producteur', 6000, 'tonnes/an');

-- Or
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('gold', 'china', 'Producteur majeur', 370, 'tonnes/an'),
('gold', 'australia', 'Producteur', 330, 'tonnes/an'),
('gold', 'russia', 'Producteur', 300, 'tonnes/an'),
('gold', 'usa', 'Producteur', 200, 'tonnes/an'),
('gold', 'canada', 'Producteur', 180, 'tonnes/an'),
('gold', 'ghana', 'Producteur', 130, 'tonnes/an'),
('gold', 'south-africa', 'Producteur', 100, 'tonnes/an');

-- Cuivre
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('copper', 'chile', 'Producteur majeur', 5700000, 'tonnes/an'),
('copper', 'peru', 'Producteur', 2500000, 'tonnes/an'),
('copper', 'china', 'Producteur', 1700000, 'tonnes/an'),
('copper', 'usa', 'Producteur', 1200000, 'tonnes/an'),
('copper', 'congo', 'Producteur', 1300000, 'tonnes/an'),
('copper', 'australia', 'Producteur', 900000, 'tonnes/an');

-- Blé
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('wheat', 'china', 'Producteur majeur', 135000000, 'tonnes/an'),
('wheat', 'india', 'Producteur', 107000000, 'tonnes/an'),
('wheat', 'russia', 'Producteur', 85000000, 'tonnes/an'),
('wheat', 'usa', 'Producteur', 50000000, 'tonnes/an'),
('wheat', 'france', 'Producteur', 35000000, 'tonnes/an'),
('wheat', 'canada', 'Producteur', 32000000, 'tonnes/an'),
('wheat', 'pakistan', 'Producteur', 25000000, 'tonnes/an'),
('wheat', 'ukraine', 'Producteur', 24000000, 'tonnes/an'),
('wheat', 'australia', 'Producteur', 22000000, 'tonnes/an');

-- Charbon
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('coal', 'china', 'Producteur majeur', 4000000000, 'tonnes/an'),
('coal', 'india', 'Producteur', 800000000, 'tonnes/an'),
('coal', 'usa', 'Producteur', 600000000, 'tonnes/an'),
('coal', 'australia', 'Producteur', 500000000, 'tonnes/an'),
('coal', 'russia', 'Producteur', 400000000, 'tonnes/an'),
('coal', 'south-africa', 'Producteur', 250000000, 'tonnes/an'),
('coal', 'germany', 'Producteur', 120000000, 'tonnes/an'),
('coal', 'poland', 'Producteur', 100000000, 'tonnes/an');

-- Fer
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('iron', 'australia', 'Producteur majeur', 900000000, 'tonnes/an'),
('iron', 'brazil', 'Producteur', 400000000, 'tonnes/an'),
('iron', 'china', 'Producteur', 350000000, 'tonnes/an'),
('iron', 'india', 'Producteur', 200000000, 'tonnes/an'),
('iron', 'russia', 'Producteur', 100000000, 'tonnes/an'),
('iron', 'south-africa', 'Producteur', 70000000, 'tonnes/an'),
('iron', 'ukraine', 'Producteur', 60000000, 'tonnes/an'),
('iron', 'canada', 'Producteur', 50000000, 'tonnes/an');

-- Aluminium
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('aluminium', 'china', 'Producteur majeur', 36000000, 'tonnes/an'),
('aluminium', 'russia', 'Producteur', 3600000, 'tonnes/an'),
('aluminium', 'canada', 'Producteur', 3200000, 'tonnes/an'),
('aluminium', 'india', 'Producteur', 3700000, 'tonnes/an'),
('aluminium', 'uae', 'Producteur', 2600000, 'tonnes/an'),
('aluminium', 'australia', 'Producteur', 1600000, 'tonnes/an'),
('aluminium', 'norway', 'Producteur', 1400000, 'tonnes/an'),
('aluminium', 'bahrain', 'Producteur', 1500000, 'tonnes/an');

-- Nickel
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('nickel', 'indonesia', 'Producteur majeur', 1000000, 'tonnes/an'),
('nickel', 'philippines', 'Producteur', 420000, 'tonnes/an'),
('nickel', 'russia', 'Producteur', 250000, 'tonnes/an'),
('nickel', 'new-caledonia', 'Producteur', 200000, 'tonnes/an'),
('nickel', 'australia', 'Producteur', 180000, 'tonnes/an'),
('nickel', 'canada', 'Producteur', 160000, 'tonnes/an'),
('nickel', 'china', 'Producteur', 120000, 'tonnes/an'),
('nickel', 'brazil', 'Producteur', 100000, 'tonnes/an');

-- Cobalt
INSERT INTO resource_country (resourceid, countryid, role, quantite, unite) VALUES
('cobalt', 'congo', 'Producteur majeur', 95000, 'tonnes/an'),
('cobalt', 'russia', 'Producteur', 7600, 'tonnes/an'),
('cobalt', 'australia', 'Producteur', 5600, 'tonnes/an'),
('cobalt', 'philippines', 'Producteur', 4500, 'tonnes/an'),
('cobalt', 'cuba', 'Producteur', 3500, 'tonnes/an'),
('cobalt', 'madagascar', 'Producteur', 3300, 'tonnes/an'),
('cobalt', 'papua-new-guinea', 'Producteur', 3100, 'tonnes/an'),
('cobalt', 'canada', 'Producteur', 3000, 'tonnes/an');

-- Affichage des relations ajoutées
SELECT 'Relations pays-ressources ajoutées avec succès' as status;
SELECT COUNT(*) as total_relations FROM resource_country; 