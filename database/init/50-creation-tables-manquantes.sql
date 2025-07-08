-- =====================================================
-- Création des tables manquantes selon le schéma cible
-- =====================================================

-- 1. Table COMM_NETWORK (Réseaux de communication)
CREATE TABLE IF NOT EXISTS comm_network (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    type VARCHAR(100),
    description TEXT,
    dateMiseEnService DATE,
    acteurs JSONB,
    capacite JSONB,
    geoJsonRef GEOMETRY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Table COMM_NETWORK_COUNTRY (Relation pays-réseaux)
CREATE TABLE IF NOT EXISTS comm_network_country (
    commNetworkId VARCHAR(50) REFERENCES comm_network(id) ON DELETE CASCADE,
    countryId VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    role VARCHAR(100),
    statut VARCHAR(100),
    PRIMARY KEY (commNetworkId, countryId)
);

-- 3. Table RELATION_COUNTRY (Relation pays-relations internationales)
CREATE TABLE IF NOT EXISTS relation_country (
    relationId VARCHAR(50) REFERENCES relation(id) ON DELETE CASCADE,
    countryId VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    statut VARCHAR(100),
    dateAdhesion DATE,
    dateSortie DATE,
    PRIMARY KEY (relationId, countryId)
);

-- 4. Table TRADE_ROUTE_COUNTRY (Relation pays-routes commerciales)
CREATE TABLE IF NOT EXISTS trade_route_country (
    tradeRouteId VARCHAR(50) REFERENCES trade_route(id) ON DELETE CASCADE,
    countryId VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    role VARCHAR(100),
    PRIMARY KEY (tradeRouteId, countryId)
);

-- Vérifier que les tables ont été créées
SELECT table_name 
FROM information_schema.tables 
WHERE table_name IN ('comm_network', 'comm_network_country', 'relation_country', 'trade_route_country')
ORDER BY table_name; 