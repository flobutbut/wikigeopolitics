-- Script pour insérer une liste exhaustive de ressources naturelles majeures
-- Date: 2025-01-XX

INSERT INTO resource (id, nom, categorie, description) VALUES
-- MÉTAUX
('iron', 'Fer', 'Métal', 'Métal de base pour la sidérurgie, composant principal de l''acier'),
('copper', 'Cuivre', 'Métal', 'Métal conducteur utilisé dans l''électricité, l''électronique et la construction'),
('aluminium', 'Aluminium', 'Métal', 'Métal léger utilisé dans l''aéronautique, l''automobile et l''emballage'),
('gold', 'Or', 'Métal précieux', 'Métal précieux utilisé pour la joaillerie, la réserve de valeur et l''industrie'),
('silver', 'Argent', 'Métal précieux', 'Métal précieux utilisé en joaillerie, électronique et photographie'),
('platinum', 'Platine', 'Métal précieux', 'Métal précieux utilisé dans les catalyseurs, la joaillerie et l''industrie'),
('nickel', 'Nickel', 'Métal', 'Métal utilisé dans les alliages, batteries et aciers inoxydables'),
('cobalt', 'Cobalt', 'Métal', 'Métal utilisé dans les batteries, alliages et pigments'),
('manganese', 'Manganèse', 'Métal', 'Métal utilisé dans la production d''acier et de batteries'),
('zinc', 'Zinc', 'Métal', 'Métal utilisé pour la galvanisation, alliages et batteries'),
('lead', 'Plomb', 'Métal', 'Métal lourd utilisé dans les batteries, la protection contre les radiations'),
('tin', 'Étain', 'Métal', 'Métal utilisé dans les alliages, soudures et emballages'),
('bauxite', 'Bauxite', 'Minerai', 'Minerai principal pour la production d''aluminium'),
('coal', 'Charbon', 'Énergie', 'Roche combustible fossile, utilisée principalement pour la production d''électricité et la sidérurgie'),

-- AUTRES MINÉRAUX
('phosphate', 'Phosphate', 'Minéral', 'Minéral utilisé principalement pour la fabrication d''engrais'),
('potash', 'Potasse', 'Minéral', 'Minéral utilisé comme engrais potassique'),
('diamonds', 'Diamants', 'Pierre précieuse', 'Pierre précieuse utilisée en joaillerie et pour des usages industriels'),
('graphite', 'Graphite', 'Minéral', 'Minéral utilisé dans les batteries, réfractaires et lubrifiants'),
('salt', 'Sel', 'Minéral', 'Minéral utilisé pour l''alimentation, l''industrie et le traitement de l''eau'),

-- PRODUITS AGRICOLES
('wheat', 'Blé', 'Agricole', 'Céréale de base pour l''alimentation humaine et animale'),
('corn', 'Maïs', 'Agricole', 'Céréale utilisée pour l''alimentation, l''éthanol et l''industrie'),
('rice', 'Riz', 'Agricole', 'Céréale de base pour l''alimentation de plus de la moitié de la population mondiale'),
('soy', 'Soja', 'Agricole', 'Légumineuse utilisée pour l''huile, l''alimentation animale et humaine'),
('cotton', 'Coton', 'Agricole', 'Fibre végétale utilisée dans l''industrie textile'),
('coffee', 'Café', 'Agricole', 'Grain utilisé pour la boisson la plus consommée au monde après l''eau'),
('cocoa', 'Cacao', 'Agricole', 'Grain utilisé pour la fabrication du chocolat'),
('sugar', 'Sucre', 'Agricole', 'Produit issu de la canne à sucre ou de la betterave'),
('tea', 'Thé', 'Agricole', 'Feuille utilisée pour la boisson la plus consommée au monde après l''eau et le café'),
('tobacco', 'Tabac', 'Agricole', 'Plante utilisée pour la fabrication de cigarettes et autres produits'),
('rubber', 'Caoutchouc', 'Agricole', 'Produit naturel ou synthétique utilisé dans l''industrie automobile et divers produits'),
('palm_oil', 'Huile de palme', 'Agricole', 'Huile végétale utilisée dans l''alimentation et l''industrie'),
('olive_oil', 'Huile d''olive', 'Agricole', 'Huile végétale utilisée dans l''alimentation'),
('wine', 'Vin', 'Agricole', 'Boisson alcoolisée issue de la fermentation du raisin'),

-- AUTRES
('wool', 'Laine', 'Agricole', 'Fibre animale utilisée dans le textile'),
('honey', 'Miel', 'Agricole', 'Produit naturel issu des abeilles'),
('flowers', 'Fleurs', 'Agricole', 'Produit horticole pour l''ornement et l''industrie'),
('spices', 'Épices', 'Agricole', 'Produits végétaux utilisés pour l''assaisonnement et la conservation des aliments');

-- Affichage des ressources ajoutées
SELECT 'Ressources ajoutées avec succès' as status;
SELECT COUNT(*) as total_resources FROM resource; 