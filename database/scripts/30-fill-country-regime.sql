-- =====================================================
-- Remplissage du champ regimePolitique pour tous les pays
-- (clé étrangère vers political_regime)
-- =====================================================

-- Exemples (à adapter si besoin)
-- France : République parlementaire
UPDATE country SET regimePolitique = (SELECT id FROM political_regime WHERE name = 'République parlementaire') WHERE id = 'france';
-- États-Unis : République présidentielle
UPDATE country SET regimePolitique = (SELECT id FROM political_regime WHERE name = 'République présidentielle') WHERE id = 'usa';
-- Arabie Saoudite : Monarchie absolue
UPDATE country SET regimePolitique = (SELECT id FROM political_regime WHERE name = 'Monarchie absolue') WHERE id = 'saudi-arabia';
-- Royaume-Uni : Monarchie constitutionnelle
UPDATE country SET regimePolitique = (SELECT id FROM political_regime WHERE name = 'Monarchie constitutionnelle') WHERE id = 'uk';
-- Iran : Théocratie
UPDATE country SET regimePolitique = (SELECT id FROM political_regime WHERE name = 'Théocratie') WHERE id = 'iran';
-- Russie : Régime autoritaire
UPDATE country SET regimePolitique = (SELECT id FROM political_regime WHERE name = 'Régime autoritaire') WHERE id = 'russia';
-- Chine : Régime autoritaire
UPDATE country SET regimePolitique = (SELECT id FROM political_regime WHERE name = 'Régime autoritaire') WHERE id = 'china';
-- Suisse : Démocratie directe
UPDATE country SET regimePolitique = (SELECT id FROM political_regime WHERE name = 'Démocratie directe') WHERE id = 'switzerland';
-- Allemagne : République parlementaire
UPDATE country SET regimePolitique = (SELECT id FROM political_regime WHERE name = 'République parlementaire') WHERE id = 'germany';
-- Inde : République parlementaire
UPDATE country SET regimePolitique = (SELECT id FROM political_regime WHERE name = 'République parlementaire') WHERE id = 'india';

-- ...
-- (Le script complet contiendra une ligne par pays, selon la classification internationale la plus courante) 