-- Extension du schéma pour les données détaillées
-- Script: 03-extend-schema.sql

-- Table pour les régimes politiques
CREATE TABLE IF NOT EXISTS political_regime (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    characteristics JSONB,
    examples JSONB
);

-- Table pour les transitions politiques
CREATE TABLE IF NOT EXISTS political_transition (
    id SERIAL PRIMARY KEY,
    from_regime_id VARCHAR(50) REFERENCES political_regime(id),
    to_regime_id VARCHAR(50) REFERENCES political_regime(id),
    country_id VARCHAR(10) REFERENCES country(id),
    year VARCHAR(10),
    description TEXT
);

-- Table pour les données démographiques
CREATE TABLE IF NOT EXISTS demographic_data (
    id SERIAL PRIMARY KEY,
    country_id VARCHAR(10) REFERENCES country(id),
    year INTEGER,
    population BIGINT,
    median_age DECIMAL(4,1),
    fertility_rate DECIMAL(3,2),
    life_expectancy DECIMAL(4,1),
    urbanization_rate DECIMAL(4,1),
    elderly_percentage DECIMAL(4,1),
    gdp_per_capita DECIMAL(12,2),
    hdi_index DECIMAL(3,3),
    literacy_rate DECIMAL(4,1),
    data_source VARCHAR(200)
);

-- Table pour les tendances démographiques mondiales
CREATE TABLE IF NOT EXISTS global_demographic_trends (
    id SERIAL PRIMARY KEY,
    trend_name VARCHAR(100),
    description TEXT,
    statistics JSONB,
    regional_differences JSONB,
    implications JSONB
);

-- Table pour les mégapoles
CREATE TABLE IF NOT EXISTS megacity (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    country_id VARCHAR(10) REFERENCES country(id),
    population DECIMAL(8,1),
    unit VARCHAR(20),
    year INTEGER
);

-- Table pour les produits agricoles
CREATE TABLE IF NOT EXISTS agricultural_product (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    description TEXT,
    global_production_value DECIMAL(10,1),
    global_production_unit VARCHAR(50),
    global_production_year INTEGER
);

-- Table pour la production agricole par pays
CREATE TABLE IF NOT EXISTS country_agricultural_production (
    id SERIAL PRIMARY KEY,
    country_id VARCHAR(10) REFERENCES country(id),
    product_id VARCHAR(50) REFERENCES agricultural_product(id),
    production_value DECIMAL(10,1),
    production_unit VARCHAR(50),
    production_year INTEGER,
    percentage_of_global DECIMAL(5,2)
);

-- Table pour les exportations agricoles
CREATE TABLE IF NOT EXISTS agricultural_export (
    id SERIAL PRIMARY KEY,
    country_id VARCHAR(10) REFERENCES country(id),
    product_id VARCHAR(50) REFERENCES agricultural_product(id),
    export_value DECIMAL(10,1),
    export_unit VARCHAR(50),
    export_year INTEGER,
    percentage_of_global DECIMAL(5,2)
);

-- Table pour les importations agricoles
CREATE TABLE IF NOT EXISTS agricultural_import (
    id SERIAL PRIMARY KEY,
    country_id VARCHAR(10) REFERENCES country(id),
    product_id VARCHAR(50) REFERENCES agricultural_product(id),
    import_value DECIMAL(10,1),
    import_unit VARCHAR(50),
    import_year INTEGER
);

-- Table pour les secteurs technologiques
CREATE TABLE IF NOT EXISTS technology_sector (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    global_market_value DECIMAL(12,2),
    global_market_unit VARCHAR(20),
    global_market_year INTEGER,
    cagr VARCHAR(20)
);

-- Table pour les sous-secteurs technologiques
CREATE TABLE IF NOT EXISTS technology_subsector (
    id VARCHAR(50) PRIMARY KEY,
    sector_id VARCHAR(50) REFERENCES technology_sector(id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(50),
    applications JSONB,
    geopolitical_issues JSONB
);

-- Table pour les pays leaders en technologie
CREATE TABLE IF NOT EXISTS technology_country_leadership (
    id SERIAL PRIMARY KEY,
    subsector_id VARCHAR(50) REFERENCES technology_subsector(id),
    country_id VARCHAR(10) REFERENCES country(id),
    strengths JSONB,
    companies JSONB
);

-- Table pour les ressources naturelles
CREATE TABLE IF NOT EXISTS natural_resource (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    description TEXT,
    global_reserves_value DECIMAL(12,2),
    global_reserves_unit VARCHAR(20),
    global_reserves_year INTEGER
);

-- Table pour les ressources par pays
CREATE TABLE IF NOT EXISTS country_natural_resource (
    id SERIAL PRIMARY KEY,
    country_id VARCHAR(10) REFERENCES country(id),
    resource_id VARCHAR(50) REFERENCES natural_resource(id),
    abundance_level VARCHAR(50),
    locations JSONB,
    production_value DECIMAL(12,2),
    production_unit VARCHAR(20),
    production_year INTEGER
);

-- Table pour les industries
CREATE TABLE IF NOT EXISTS industry (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sector VARCHAR(50),
    description TEXT,
    global_market_value DECIMAL(12,2),
    global_market_unit VARCHAR(20),
    global_market_year INTEGER
);

-- Table pour les industries par pays
CREATE TABLE IF NOT EXISTS country_industry (
    id SERIAL PRIMARY KEY,
    country_id VARCHAR(10) REFERENCES country(id),
    industry_id VARCHAR(50) REFERENCES industry(id),
    significance TEXT,
    companies JSONB,
    production_value DECIMAL(12,2),
    production_unit VARCHAR(20),
    production_year INTEGER
);

-- Table pour les données de transport et marchandises
CREATE TABLE IF NOT EXISTS transport_data (
    id SERIAL PRIMARY KEY,
    country_id VARCHAR(10) REFERENCES country(id),
    transport_type VARCHAR(50),
    volume_value DECIMAL(12,2),
    volume_unit VARCHAR(20),
    volume_year INTEGER,
    routes JSONB,
    infrastructure_data JSONB
);

-- Table pour les conflits armés
CREATE TABLE IF NOT EXISTS armed_conflict (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200),
    description TEXT,
    start_year INTEGER,
    end_year INTEGER,
    status VARCHAR(50),
    involved_countries JSONB,
    casualty_estimates JSONB,
    geopolitical_impact TEXT
);

-- Table pour les relations internationales détaillées
CREATE TABLE IF NOT EXISTS international_relation_detail (
    id SERIAL PRIMARY KEY,
    relation_id INTEGER REFERENCES international_relation(id),
    relation_type VARCHAR(50),
    intensity_level VARCHAR(20),
    economic_volume DECIMAL(12,2),
    economic_unit VARCHAR(20),
    political_impact TEXT,
    military_cooperation BOOLEAN,
    cultural_exchanges JSONB
);

-- Table pour les données géographiques détaillées
CREATE TABLE IF NOT EXISTS geographic_detail (
    id SERIAL PRIMARY KEY,
    country_id VARCHAR(10) REFERENCES country(id),
    coastline_length DECIMAL(10,2),
    coastline_unit VARCHAR(20),
    terrain_types JSONB,
    climate_types JSONB,
    major_cities JSONB,
    natural_features JSONB
);

-- Table pour les données touristiques
CREATE TABLE IF NOT EXISTS tourism_data (
    id SERIAL PRIMARY KEY,
    country_id VARCHAR(10) REFERENCES country(id),
    annual_visitors BIGINT,
    visitors_year INTEGER,
    major_attractions JSONB,
    economic_impact DECIMAL(12,2),
    economic_impact_unit VARCHAR(20)
);

-- Index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_demographic_data_country_year ON demographic_data(country_id, year);
CREATE INDEX IF NOT EXISTS idx_agricultural_production_country_product ON country_agricultural_production(country_id, product_id);
CREATE INDEX IF NOT EXISTS idx_technology_leadership_country ON technology_country_leadership(country_id);
CREATE INDEX IF NOT EXISTS idx_natural_resource_country ON country_natural_resource(country_id);
CREATE INDEX IF NOT EXISTS idx_industry_country ON country_industry(country_id);
CREATE INDEX IF NOT EXISTS idx_conflict_countries ON armed_conflict USING GIN(involved_countries); 