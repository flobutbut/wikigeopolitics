-- =====================================================
-- Ajout des colonnes manquantes à la table COUNTRY
-- selon le schéma cible
-- =====================================================

-- Ajouter les colonnes manquantes à COUNTRY
ALTER TABLE country ADD COLUMN IF NOT EXISTS pib FLOAT;
ALTER TABLE country ADD COLUMN IF NOT EXISTS population INTEGER;
ALTER TABLE country ADD COLUMN IF NOT EXISTS revenuMedian FLOAT;
ALTER TABLE country ADD COLUMN IF NOT EXISTS superficieKm2 FLOAT;
ALTER TABLE country ADD COLUMN IF NOT EXISTS regimePolitique VARCHAR(100);
ALTER TABLE country ADD COLUMN IF NOT EXISTS appartenanceGeographique VARCHAR(100);
ALTER TABLE country ADD COLUMN IF NOT EXISTS histoire TEXT;
ALTER TABLE country ADD COLUMN IF NOT EXISTS indiceSouverainete FLOAT;
ALTER TABLE country ADD COLUMN IF NOT EXISTS indiceDependance FLOAT;
ALTER TABLE country ADD COLUMN IF NOT EXISTS statutStrategique VARCHAR(100);
ALTER TABLE country ADD COLUMN IF NOT EXISTS dateCreation DATE;
ALTER TABLE country ADD COLUMN IF NOT EXISTS dateDerniereMiseAJour DATE;

-- Vérifier que les colonnes ont été ajoutées
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'country' 
ORDER BY ordinal_position; 