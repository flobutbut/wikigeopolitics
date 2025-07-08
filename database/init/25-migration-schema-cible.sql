-- =====================================================
-- Migration schéma cible : création des nouvelles tables et colonnes
-- (aucune suppression, script idempotent)
-- =====================================================

-- 1. Nouvelles tables principales
CREATE TABLE IF NOT EXISTS comm_network (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    type VARCHAR(100),
    description TEXT,
    dateMiseEnService DATE,
    acteurs JSONB,
    capacite JSONB,
    geoJsonRef geometry
);

-- 2. Tables de jointure manquantes
CREATE TABLE IF NOT EXISTS comm_network_country (
    commNetworkId VARCHAR(50) REFERENCES comm_network(id) ON DELETE CASCADE,
    countryId VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    role VARCHAR(100),
    statut VARCHAR(100),
    PRIMARY KEY (commNetworkId, countryId)
);

CREATE TABLE IF NOT EXISTS trade_route_country (
    tradeRouteId VARCHAR(50) REFERENCES trade_route(id) ON DELETE CASCADE,
    countryId VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    role VARCHAR(100),
    PRIMARY KEY (tradeRouteId, countryId)
);

-- 3. Ajout des nouvelles colonnes à country
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='pib') THEN
        ALTER TABLE country ADD COLUMN pib FLOAT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='population') THEN
        ALTER TABLE country ADD COLUMN population INT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='revenuMedian') THEN
        ALTER TABLE country ADD COLUMN revenuMedian FLOAT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='superficieKm2') THEN
        ALTER TABLE country ADD COLUMN superficieKm2 FLOAT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='regimePolitique') THEN
        ALTER TABLE country ADD COLUMN regimePolitique VARCHAR(255);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='appartenanceGeographique') THEN
        ALTER TABLE country ADD COLUMN appartenanceGeographique VARCHAR(255);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='indiceSouverainete') THEN
        ALTER TABLE country ADD COLUMN indiceSouverainete FLOAT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='indiceDependance') THEN
        ALTER TABLE country ADD COLUMN indiceDependance FLOAT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='statutStrategique') THEN
        ALTER TABLE country ADD COLUMN statutStrategique VARCHAR(255);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='dateCreation') THEN
        ALTER TABLE country ADD COLUMN dateCreation DATE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='country' AND column_name='dateDerniereMiseAJour') THEN
        ALTER TABLE country ADD COLUMN dateDerniereMiseAJour DATE;
    END IF;
END$$; 