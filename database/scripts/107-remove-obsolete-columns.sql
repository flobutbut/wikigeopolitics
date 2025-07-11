-- Script pour supprimer les colonnes obsolètes de la table country
-- Ces colonnes sont maintenant gérées via la table country_political_regime

-- Vérifier d'abord les colonnes existantes
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'country' 
AND column_name IN ('regimepolitique', 'chefetat')
ORDER BY column_name;

-- Supprimer la colonne regimepolitique
ALTER TABLE country DROP COLUMN IF EXISTS regimepolitique;

-- Supprimer la colonne chefetat
ALTER TABLE country DROP COLUMN IF EXISTS chefetat;

-- Vérifier que les colonnes ont été supprimées
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'country' 
ORDER BY ordinal_position;

-- Vérifier que les données sont toujours accessibles via la table de relation
SELECT 
    c.nom as pays,
    pr.name as regime_politique,
    cpr.chef_etat,
    cpr.date_prise_poste
FROM country c
LEFT JOIN country_political_regime cpr ON c.id = cpr.country_id AND cpr.current_regime = true
LEFT JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE c.nom IN ('France', 'États-Unis', 'Allemagne', 'Japon', 'Chine')
ORDER BY c.nom; 