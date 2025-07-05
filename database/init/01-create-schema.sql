-- =====================================================
-- Script d'initialisation de la base de données WikiGeopolitics
-- Création du schéma et des tables principales
-- =====================================================

-- Extension pour les données géospatiales
CREATE EXTENSION IF NOT EXISTS postgis;

-- Extension pour les UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLE COUNTRY (Pays) - Table centrale
-- =====================================================
CREATE TABLE IF NOT EXISTS country (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    drapeau VARCHAR(255),
    capitale VARCHAR(255),
    langue VARCHAR(255),
    monnaie VARCHAR(100),
    continent VARCHAR(100),
    sections JSONB,
    indicateurs JSONB,
    histoire JSONB,
    politique JSONB,
    economie JSONB,
    demographie JSONB,
    frontieres JSONB,
    coordonnees GEOMETRY(POINT, 4326),
    tourisme JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index géospatial pour les coordonnées
CREATE INDEX IF NOT EXISTS idx_country_coordinates ON country USING GIST (coordonnees);

-- =====================================================
-- TABLE ORGANIZATION (Organisations internationales)
-- =====================================================
CREATE TABLE IF NOT EXISTS organization (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    type VARCHAR(100),
    description TEXT,
    date_creation DATE,
    siege VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE RELATION (Relations internationales)
-- =====================================================
CREATE TABLE IF NOT EXISTS relation (
    id VARCHAR(50) PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    description TEXT,
    date_debut DATE,
    date_fin DATE,
    statut VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE CONFLICT (Conflits armés)
-- =====================================================
CREATE TABLE IF NOT EXISTS conflict (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    type VARCHAR(100),
    statut VARCHAR(100),
    date_debut DATE,
    date_fin DATE,
    intensite VARCHAR(50),
    localisation GEOMETRY(POLYGON, 4326),
    victimes JSONB,
    timeline JSONB,
    efforts_paix JSONB,
    consequences JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index géospatial pour la localisation
CREATE INDEX IF NOT EXISTS idx_conflict_location ON conflict USING GIST (localisation);

-- =====================================================
-- TABLE RESOURCE (Ressources naturelles)
-- =====================================================
CREATE TABLE IF NOT EXISTS resource (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    categorie VARCHAR(100),
    description TEXT,
    reserves_mondiales JSONB,
    usages JSONB,
    impact_environnemental TEXT,
    enjeux_geopolitiques TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE INDUSTRY (Secteurs industriels)
-- =====================================================
CREATE TABLE IF NOT EXISTS industry (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    categorie VARCHAR(100),
    description TEXT,
    production_mondiale JSONB,
    tendances JSONB,
    chaine_approvisionnement JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE COMPANY (Entreprises)
-- =====================================================
CREATE TABLE IF NOT EXISTS company (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    pays VARCHAR(50) REFERENCES country(id),
    secteur VARCHAR(100),
    indicateurs JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE DEMOGRAPHIC (Démographie)
-- =====================================================
CREATE TABLE IF NOT EXISTS demographic (
    id VARCHAR(50) PRIMARY KEY,
    pays VARCHAR(50) REFERENCES country(id),
    population JSONB,
    tendances JSONB,
    indicateurs_sociaux JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE TRADE_ROUTE (Routes commerciales)
-- =====================================================
CREATE TABLE IF NOT EXISTS trade_route (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    type VARCHAR(100),
    endpoints JSONB,
    volume JSONB,
    biens_transportes JSONB,
    chokepoints JSONB,
    ports JSONB,
    geo_json_ref TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLES DE RELATION (Junction tables)
-- =====================================================

-- Relation Country-Organization (membres d'organisations)
CREATE TABLE IF NOT EXISTS country_organization (
    country_id VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    organization_id VARCHAR(50) REFERENCES organization(id) ON DELETE CASCADE,
    role VARCHAR(100),
    date_adhesion DATE,
    statut VARCHAR(100),
    PRIMARY KEY (country_id, organization_id)
);

-- Relation Country-Relation (pays impliqués dans des relations)
CREATE TABLE IF NOT EXISTS country_relation (
    country_id VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    relation_id VARCHAR(50) REFERENCES relation(id) ON DELETE CASCADE,
    role VARCHAR(100),
    PRIMARY KEY (country_id, relation_id)
);

-- Relation Country-Conflict (pays impliqués dans des conflits)
CREATE TABLE IF NOT EXISTS country_conflict (
    country_id VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    conflict_id VARCHAR(50) REFERENCES conflict(id) ON DELETE CASCADE,
    role VARCHAR(100),
    PRIMARY KEY (country_id, conflict_id)
);

-- Relation Country-Resource (pays producteurs de ressources)
CREATE TABLE IF NOT EXISTS country_resource (
    country_id VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    resource_id VARCHAR(50) REFERENCES resource(id) ON DELETE CASCADE,
    production_volume JSONB,
    reserves JSONB,
    PRIMARY KEY (country_id, resource_id)
);

-- Relation Country-Industry (pays producteurs industriels)
CREATE TABLE IF NOT EXISTS country_industry (
    country_id VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    industry_id VARCHAR(50) REFERENCES industry(id) ON DELETE CASCADE,
    production_volume JSONB,
    importance VARCHAR(100),
    PRIMARY KEY (country_id, industry_id)
);

-- Relation Conflict-Resource (ressources en jeu dans les conflits)
CREATE TABLE IF NOT EXISTS conflict_resource (
    conflict_id VARCHAR(50) REFERENCES conflict(id) ON DELETE CASCADE,
    resource_id VARCHAR(50) REFERENCES resource(id) ON DELETE CASCADE,
    importance VARCHAR(100),
    PRIMARY KEY (conflict_id, resource_id)
);

-- Relation Conflict-Trade_Route (routes commerciales en jeu)
CREATE TABLE IF NOT EXISTS conflict_trade_route (
    conflict_id VARCHAR(50) REFERENCES conflict(id) ON DELETE CASCADE,
    trade_route_id VARCHAR(50) REFERENCES trade_route(id) ON DELETE CASCADE,
    impact VARCHAR(100),
    PRIMARY KEY (conflict_id, trade_route_id)
);

-- Relation Resource-Trade_Route (ressources transportées)
CREATE TABLE IF NOT EXISTS resource_trade_route (
    resource_id VARCHAR(50) REFERENCES resource(id) ON DELETE CASCADE,
    trade_route_id VARCHAR(50) REFERENCES trade_route(id) ON DELETE CASCADE,
    volume JSONB,
    PRIMARY KEY (resource_id, trade_route_id)
);

-- Relation Industry-Company (entreprises par secteur)
CREATE TABLE IF NOT EXISTS industry_company (
    industry_id VARCHAR(50) REFERENCES industry(id) ON DELETE CASCADE,
    company_id VARCHAR(50) REFERENCES company(id) ON DELETE CASCADE,
    role VARCHAR(100),
    PRIMARY KEY (industry_id, company_id)
);

-- Relation Organization-Relation (organisations concernées par des relations)
CREATE TABLE IF NOT EXISTS organization_relation (
    organization_id VARCHAR(50) REFERENCES organization(id) ON DELETE CASCADE,
    relation_id VARCHAR(50) REFERENCES relation(id) ON DELETE CASCADE,
    role VARCHAR(100),
    PRIMARY KEY (organization_id, relation_id)
);

-- =====================================================
-- TRIGGERS pour updated_at
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Application des triggers sur toutes les tables principales
CREATE TRIGGER update_country_updated_at BEFORE UPDATE ON country FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_organization_updated_at BEFORE UPDATE ON organization FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_relation_updated_at BEFORE UPDATE ON relation FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_conflict_updated_at BEFORE UPDATE ON conflict FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_resource_updated_at BEFORE UPDATE ON resource FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_industry_updated_at BEFORE UPDATE ON industry FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_company_updated_at BEFORE UPDATE ON company FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_demographic_updated_at BEFORE UPDATE ON demographic FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_trade_route_updated_at BEFORE UPDATE ON trade_route FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- COMMENTAIRES sur les tables
-- =====================================================
COMMENT ON TABLE country IS 'Table centrale contenant les informations sur les pays';
COMMENT ON TABLE organization IS 'Organisations internationales (ONU, OTAN, UE, etc.)';
COMMENT ON TABLE relation IS 'Relations internationales entre pays (alliances, conflits, accords)';
COMMENT ON TABLE conflict IS 'Conflits armés et historiques';
COMMENT ON TABLE resource IS 'Ressources naturelles et leurs enjeux géopolitiques';
COMMENT ON TABLE industry IS 'Secteurs industriels et économiques';
COMMENT ON TABLE company IS 'Entreprises majeures par secteur';
COMMENT ON TABLE demographic IS 'Données démographiques et sociales par pays';
COMMENT ON TABLE trade_route IS 'Routes commerciales et de transport';

-- =====================================================
-- VUES UTILES pour l'application
-- =====================================================

-- Vue des pays avec leurs organisations
CREATE OR REPLACE VIEW v_country_organizations AS
SELECT 
    c.id,
    c.nom,
    c.capitale,
    c.continent,
    array_agg(DISTINCT o.nom) as organisations
FROM country c
LEFT JOIN country_organization co ON c.id = co.country_id
LEFT JOIN organization o ON co.organization_id = o.id
GROUP BY c.id, c.nom, c.capitale, c.continent;

-- Vue des conflits avec les pays impliqués
CREATE OR REPLACE VIEW v_conflict_countries AS
SELECT 
    cf.id,
    cf.nom,
    cf.type,
    cf.statut,
    cf.date_debut,
    array_agg(DISTINCT c.nom) as pays_impliques
FROM conflict cf
LEFT JOIN country_conflict cc ON cf.id = cc.conflict_id
LEFT JOIN country c ON cc.country_id = c.id
GROUP BY cf.id, cf.nom, cf.type, cf.statut, cf.date_debut;

-- Vue des ressources par pays
CREATE OR REPLACE VIEW v_country_resources AS
SELECT 
    c.id,
    c.nom,
    array_agg(DISTINCT r.nom) as ressources
FROM country c
LEFT JOIN country_resource cr ON c.id = cr.country_id
LEFT JOIN resource r ON cr.resource_id = r.id
GROUP BY c.id, c.nom; 