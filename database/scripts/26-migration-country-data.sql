-- =====================================================
-- Migration des données : table country
-- Remplissage des nouveaux champs à partir de l'existant ou par défaut
-- =====================================================

-- Exemple : si une colonne jsonb 'histoire' existe, on la convertit en string
UPDATE country SET histoire = histoire::text WHERE histoire IS NOT NULL;

-- Pour les nouveaux champs, on laisse NULL ou 0 si aucune donnée n'est disponible
UPDATE country SET pib = 0 WHERE pib IS NULL;
UPDATE country SET population = 0 WHERE population IS NULL;
UPDATE country SET revenuMedian = 0 WHERE revenuMedian IS NULL;
UPDATE country SET superficieKm2 = 0 WHERE superficieKm2 IS NULL;
UPDATE country SET regimePolitique = politique->>'nom' WHERE regimePolitique IS NULL AND politique IS NOT NULL AND politique ? 'nom';
UPDATE country SET appartenanceGeographique = NULL WHERE appartenanceGeographique IS NULL;
UPDATE country SET indiceSouverainete = 0 WHERE indiceSouverainete IS NULL;
UPDATE country SET indiceDependance = 0 WHERE indiceDependance IS NULL;
UPDATE country SET statutStrategique = NULL WHERE statutStrategique IS NULL;
UPDATE country SET dateCreation = created_at::date WHERE dateCreation IS NULL AND created_at IS NOT NULL;
UPDATE country SET dateDerniereMiseAJour = updated_at::date WHERE dateDerniereMiseAJour IS NULL AND updated_at IS NOT NULL; 