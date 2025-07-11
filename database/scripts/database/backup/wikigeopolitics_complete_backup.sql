--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8 (Debian 15.8-1.pgdg110+1)
-- Dumped by pg_dump version 15.8 (Debian 15.8-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: generate_country_regime_relations(integer); Type: FUNCTION; Schema: public; Owner: wikigeo_user
--

CREATE FUNCTION public.generate_country_regime_relations(batch_size integer DEFAULT 15) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    country_record RECORD;
    regime_record RECORD;
    regime_count INTEGER;
    current_batch INTEGER := 0;
    total_countries INTEGER;
    processed_countries INTEGER := 0;
BEGIN
    -- Compter le nombre total de pays
    SELECT COUNT(*) INTO total_countries FROM country;
    
    -- Récupérer tous les régimes politiques
    SELECT COUNT(*) INTO regime_count FROM political_regime;
    
    RAISE NOTICE 'Début de la génération des relations pour % pays avec % régimes', total_countries, regime_count;
    
    -- Pour chaque pays, assigner un régime politique aléatoire
    FOR country_record IN SELECT id, nom FROM country ORDER BY nom LOOP
        -- Sélectionner un régime politique aléatoire
        SELECT * INTO regime_record 
        FROM political_regime 
        ORDER BY RANDOM() 
        LIMIT 1;
        
        -- Insérer la relation
        INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
        VALUES (
            country_record.id, 
            regime_record.id, 
            true, 
            EXTRACT(YEAR FROM CURRENT_DATE),
            'Généré automatiquement - ' || country_record.nom || ' -> ' || regime_record.name
        );
        
        processed_countries := processed_countries + 1;
        current_batch := current_batch + 1;
        
        -- Afficher le progrès tous les 15 pays
        IF current_batch >= batch_size THEN
            RAISE NOTICE 'Paquet % terminé: % pays traités sur %', 
                (processed_countries / batch_size), processed_countries, total_countries;
            current_batch := 0;
        END IF;
    END LOOP;
    
    RAISE NOTICE 'Génération terminée: % pays traités', processed_countries;
END;
$$;


ALTER FUNCTION public.generate_country_regime_relations(batch_size integer) OWNER TO wikigeo_user;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: wikigeo_user
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO wikigeo_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: agricultural_export; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.agricultural_export (
    id integer NOT NULL,
    countryid character varying(10),
    productid character varying(50),
    exportvalue numeric(10,1),
    exportunit character varying(50),
    exportyear integer,
    percentageofglobal numeric(5,2),
    description text,
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.agricultural_export OWNER TO wikigeo_user;

--
-- Name: agricultural_export_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.agricultural_export_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agricultural_export_id_seq OWNER TO wikigeo_user;

--
-- Name: agricultural_export_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.agricultural_export_id_seq OWNED BY public.agricultural_export.id;


--
-- Name: agricultural_import; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.agricultural_import (
    id integer NOT NULL,
    countryid character varying(10),
    productid character varying(50),
    importvalue numeric(10,1),
    importunit character varying(50),
    importyear integer,
    description text,
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.agricultural_import OWNER TO wikigeo_user;

--
-- Name: agricultural_import_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.agricultural_import_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agricultural_import_id_seq OWNER TO wikigeo_user;

--
-- Name: agricultural_import_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.agricultural_import_id_seq OWNED BY public.agricultural_import.id;


--
-- Name: agricultural_product; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.agricultural_product (
    id character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50),
    description text,
    global_production_value numeric(10,1),
    global_production_unit character varying(50),
    global_production_year integer
);


ALTER TABLE public.agricultural_product OWNER TO wikigeo_user;

--
-- Name: armed_conflict; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.armed_conflict (
    id integer NOT NULL,
    name character varying(200),
    description text,
    startyear integer,
    endyear integer,
    status character varying(50),
    involvedcountries jsonb,
    casualtyestimates jsonb,
    geopoliticalimpact text,
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.armed_conflict OWNER TO wikigeo_user;

--
-- Name: armed_conflict_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.armed_conflict_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.armed_conflict_id_seq OWNER TO wikigeo_user;

--
-- Name: armed_conflict_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.armed_conflict_id_seq OWNED BY public.armed_conflict.id;


--
-- Name: comm_network; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.comm_network (
    id character varying(50) NOT NULL,
    nom character varying(255) NOT NULL,
    type character varying(100),
    description text,
    datemiseenservice date,
    acteurs jsonb,
    capacite jsonb,
    geojsonref public.geometry
);


ALTER TABLE public.comm_network OWNER TO wikigeo_user;

--
-- Name: comm_network_country; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.comm_network_country (
    commnetworkid character varying(50) NOT NULL,
    countryid character varying(50) NOT NULL,
    role character varying(100),
    statut character varying(100)
);


ALTER TABLE public.comm_network_country OWNER TO wikigeo_user;

--
-- Name: company; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.company (
    id character varying(50) NOT NULL,
    nom character varying(255) NOT NULL,
    pays character varying(50),
    secteur character varying(100),
    indicateurs jsonb
);


ALTER TABLE public.company OWNER TO wikigeo_user;

--
-- Name: TABLE company; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.company IS 'Entreprises majeures par secteur';


--
-- Name: conflict; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.conflict (
    id character varying(50) NOT NULL,
    nom character varying(255) NOT NULL,
    type character varying(100),
    statut character varying(100),
    datedebut date,
    datefin date,
    intensite character varying(50),
    localisation public.geometry(Polygon,4326),
    victimes jsonb,
    timeline jsonb,
    effortspaix jsonb,
    consequences jsonb
);


ALTER TABLE public.conflict OWNER TO wikigeo_user;

--
-- Name: TABLE conflict; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.conflict IS 'Conflits armés et historiques';


--
-- Name: conflict_country; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.conflict_country (
    countryid character varying(50) NOT NULL,
    conflictid character varying(50) NOT NULL,
    role character varying(100),
    dateentree date,
    datesortie date
);


ALTER TABLE public.conflict_country OWNER TO wikigeo_user;

--
-- Name: conflict_resource; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.conflict_resource (
    conflict_id character varying(50) NOT NULL,
    resource_id character varying(50) NOT NULL,
    importance character varying(100)
);


ALTER TABLE public.conflict_resource OWNER TO wikigeo_user;

--
-- Name: conflict_trade_route; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.conflict_trade_route (
    conflict_id character varying(50) NOT NULL,
    trade_route_id character varying(50) NOT NULL,
    impact character varying(100)
);


ALTER TABLE public.conflict_trade_route OWNER TO wikigeo_user;

--
-- Name: country; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.country (
    id character varying(50) NOT NULL,
    nom character varying(255) NOT NULL,
    drapeau character varying(255),
    capitale character varying(255),
    langue character varying(255),
    monnaie character varying(100),
    continent character varying(100),
    sections jsonb,
    indicateurs jsonb,
    politique jsonb,
    economie jsonb,
    demographie jsonb,
    frontieres jsonb,
    coordonnees public.geometry(Point,4326),
    pib double precision,
    population integer,
    revenumedian double precision,
    superficiekm2 double precision,
    indicesouverainete double precision,
    indicedependance double precision,
    statutstrategique character varying(255),
    datecreation date,
    datedernieremiseajour date,
    histoire text,
    appartenancegeographique character varying(100)
);


ALTER TABLE public.country OWNER TO wikigeo_user;

--
-- Name: TABLE country; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.country IS 'Table centrale contenant les informations sur les pays';


--
-- Name: country_agricultural_production; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.country_agricultural_production (
    id integer NOT NULL,
    countryid character varying(10),
    productid character varying(50),
    productionvalue numeric(10,1),
    productionunit character varying(50),
    productionyear integer,
    percentageofglobal numeric(5,2),
    description text,
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.country_agricultural_production OWNER TO wikigeo_user;

--
-- Name: country_agricultural_production_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.country_agricultural_production_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.country_agricultural_production_id_seq OWNER TO wikigeo_user;

--
-- Name: country_agricultural_production_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.country_agricultural_production_id_seq OWNED BY public.country_agricultural_production.id;


--
-- Name: country_organization; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.country_organization (
    countryid character varying(50) NOT NULL,
    organizationid character varying(50) NOT NULL,
    role character varying(100),
    dateadhesion date,
    datesortie date
);


ALTER TABLE public.country_organization OWNER TO wikigeo_user;

--
-- Name: country_political_regime; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.country_political_regime (
    country_id character varying(50) NOT NULL,
    regime_id character varying(50) NOT NULL,
    start_year integer NOT NULL,
    end_year integer,
    current_regime boolean DEFAULT true,
    notes text,
    chef_etat character varying(255),
    date_prise_poste date
);


ALTER TABLE public.country_political_regime OWNER TO wikigeo_user;

--
-- Name: demographic; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.demographic (
    id character varying(50) NOT NULL,
    pays character varying(50),
    population jsonb,
    tendances jsonb,
    indicateurs_sociaux jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.demographic OWNER TO wikigeo_user;

--
-- Name: TABLE demographic; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.demographic IS 'Données démographiques et sociales par pays';


--
-- Name: demographic_data; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.demographic_data (
    id integer NOT NULL,
    countryid character varying(10),
    year integer,
    population bigint,
    medianage numeric(4,1),
    fertilityrate numeric(3,2),
    lifeexpectancy numeric(4,1),
    urbanizationrate numeric(4,1),
    elderlypercentage numeric(4,1),
    gdppercapita numeric(12,2),
    hdiindex numeric(3,3),
    literacyrate numeric(4,1),
    datasource character varying(200),
    description text,
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.demographic_data OWNER TO wikigeo_user;

--
-- Name: demographic_data_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.demographic_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.demographic_data_id_seq OWNER TO wikigeo_user;

--
-- Name: demographic_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.demographic_data_id_seq OWNED BY public.demographic_data.id;


--
-- Name: geographic_detail; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.geographic_detail (
    id integer NOT NULL,
    country_id character varying(10),
    coastline_length numeric(10,2),
    coastline_unit character varying(20),
    terrain_types jsonb,
    climate_types jsonb,
    major_cities jsonb,
    natural_features jsonb
);


ALTER TABLE public.geographic_detail OWNER TO wikigeo_user;

--
-- Name: geographic_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.geographic_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geographic_detail_id_seq OWNER TO wikigeo_user;

--
-- Name: geographic_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.geographic_detail_id_seq OWNED BY public.geographic_detail.id;


--
-- Name: global_demographic_trends; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.global_demographic_trends (
    id integer NOT NULL,
    trend_name character varying(100),
    description text,
    statistics jsonb,
    regional_differences jsonb,
    implications jsonb
);


ALTER TABLE public.global_demographic_trends OWNER TO wikigeo_user;

--
-- Name: global_demographic_trends_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.global_demographic_trends_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.global_demographic_trends_id_seq OWNER TO wikigeo_user;

--
-- Name: global_demographic_trends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.global_demographic_trends_id_seq OWNED BY public.global_demographic_trends.id;


--
-- Name: industry; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.industry (
    id character varying(50) NOT NULL,
    nom character varying(255) NOT NULL,
    categorie character varying(100),
    description text,
    productionmondiale jsonb,
    tendances jsonb,
    chaineapprovisionnement jsonb
);


ALTER TABLE public.industry OWNER TO wikigeo_user;

--
-- Name: TABLE industry; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.industry IS 'Secteurs industriels et économiques';


--
-- Name: industry_company; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.industry_company (
    industry_id character varying(50) NOT NULL,
    company_id character varying(50) NOT NULL,
    role character varying(100)
);


ALTER TABLE public.industry_company OWNER TO wikigeo_user;

--
-- Name: industry_country; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.industry_country (
    countryid character varying(50) NOT NULL,
    industryid character varying(50) NOT NULL,
    role character varying(100),
    valeurajoutee double precision,
    unite character varying(50),
    annee date
);


ALTER TABLE public.industry_country OWNER TO wikigeo_user;

--
-- Name: megacity; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.megacity (
    id integer NOT NULL,
    name character varying(100),
    country_id character varying(10),
    population numeric(8,1),
    unit character varying(20),
    year integer
);


ALTER TABLE public.megacity OWNER TO wikigeo_user;

--
-- Name: megacity_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.megacity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.megacity_id_seq OWNER TO wikigeo_user;

--
-- Name: megacity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.megacity_id_seq OWNED BY public.megacity.id;


--
-- Name: organization; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.organization (
    id character varying(50) NOT NULL,
    nom character varying(255) NOT NULL,
    type character varying(100),
    description text,
    datecreation date,
    siege character varying(255)
);


ALTER TABLE public.organization OWNER TO wikigeo_user;

--
-- Name: TABLE organization; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.organization IS 'Organisations internationales (ONU, OTAN, UE, etc.)';


--
-- Name: political_regime; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.political_regime (
    id character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.political_regime OWNER TO wikigeo_user;

--
-- Name: political_transition; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.political_transition (
    id integer NOT NULL,
    from_regime_id character varying(50),
    to_regime_id character varying(50),
    country_id character varying(10),
    year character varying(10),
    description text
);


ALTER TABLE public.political_transition OWNER TO wikigeo_user;

--
-- Name: political_transition_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.political_transition_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.political_transition_id_seq OWNER TO wikigeo_user;

--
-- Name: political_transition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.political_transition_id_seq OWNED BY public.political_transition.id;


--
-- Name: resource; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.resource (
    id character varying(50) NOT NULL,
    nom character varying(255) NOT NULL,
    categorie character varying(100),
    description text,
    reservesmondiales jsonb,
    usages jsonb,
    impactenvironnemental text,
    enjeuxgeopolitiques text
);


ALTER TABLE public.resource OWNER TO wikigeo_user;

--
-- Name: TABLE resource; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.resource IS 'Ressources naturelles et leurs enjeux géopolitiques';


--
-- Name: resource_country; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.resource_country (
    countryid character varying(50) NOT NULL,
    resourceid character varying(50) NOT NULL,
    role character varying(100),
    quantite double precision,
    unite character varying(50)
);


ALTER TABLE public.resource_country OWNER TO wikigeo_user;

--
-- Name: resource_trade_route; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.resource_trade_route (
    resource_id character varying(50) NOT NULL,
    trade_route_id character varying(50) NOT NULL,
    volume jsonb
);


ALTER TABLE public.resource_trade_route OWNER TO wikigeo_user;

--
-- Name: technology_country_leadership; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.technology_country_leadership (
    id integer NOT NULL,
    subsectorid character varying(50),
    countryid character varying(10),
    strengths jsonb,
    companies jsonb,
    description text,
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.technology_country_leadership OWNER TO wikigeo_user;

--
-- Name: technology_country_leadership_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.technology_country_leadership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.technology_country_leadership_id_seq OWNER TO wikigeo_user;

--
-- Name: technology_country_leadership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.technology_country_leadership_id_seq OWNED BY public.technology_country_leadership.id;


--
-- Name: technology_sector; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.technology_sector (
    id character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    globalmarketvalue numeric(12,2),
    globalmarketunit character varying(20),
    globalmarketyear integer,
    cagr character varying(20),
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.technology_sector OWNER TO wikigeo_user;

--
-- Name: technology_subsector; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.technology_subsector (
    id character varying(50) NOT NULL,
    sectorid character varying(50),
    name character varying(100) NOT NULL,
    description text,
    status character varying(50),
    applications jsonb,
    geopoliticalissues jsonb,
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.technology_subsector OWNER TO wikigeo_user;

--
-- Name: tourism_data; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.tourism_data (
    id integer NOT NULL,
    countryid character varying(10),
    annualvisitors bigint,
    visitorsyear integer,
    majorattractions jsonb,
    economicimpact numeric(12,2),
    economicimpactunit character varying(20),
    description text,
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tourism_data OWNER TO wikigeo_user;

--
-- Name: tourism_data_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.tourism_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tourism_data_id_seq OWNER TO wikigeo_user;

--
-- Name: tourism_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.tourism_data_id_seq OWNED BY public.tourism_data.id;


--
-- Name: trade_route; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.trade_route (
    id character varying(50) NOT NULL,
    nom character varying(255) NOT NULL,
    type character varying(100),
    endpoints jsonb,
    volume jsonb,
    biens_transportes jsonb,
    chokepoints jsonb,
    ports jsonb,
    geojsonref text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.trade_route OWNER TO wikigeo_user;

--
-- Name: TABLE trade_route; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.trade_route IS 'Routes commerciales et de transport';


--
-- Name: trade_route_country; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.trade_route_country (
    traderouteid character varying(50) NOT NULL,
    countryid character varying(50) NOT NULL,
    role character varying(100)
);


ALTER TABLE public.trade_route_country OWNER TO wikigeo_user;

--
-- Name: transport_data; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.transport_data (
    id integer NOT NULL,
    countryid character varying(10),
    transporttype character varying(50),
    volumevalue numeric(12,2),
    volumeunit character varying(20),
    volumeyear integer,
    routes jsonb,
    infrastructuredata jsonb,
    description text,
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.transport_data OWNER TO wikigeo_user;

--
-- Name: transport_data_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.transport_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transport_data_id_seq OWNER TO wikigeo_user;

--
-- Name: transport_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.transport_data_id_seq OWNED BY public.transport_data.id;


--
-- Name: v_conflict_countries; Type: VIEW; Schema: public; Owner: wikigeo_user
--

CREATE VIEW public.v_conflict_countries AS
 SELECT cf.id,
    cf.nom,
    cf.type,
    cf.statut,
    cf.datedebut AS date_debut,
    array_agg(DISTINCT c.nom) AS pays_impliques
   FROM ((public.conflict cf
     LEFT JOIN public.conflict_country cc ON (((cf.id)::text = (cc.conflictid)::text)))
     LEFT JOIN public.country c ON (((cc.countryid)::text = (c.id)::text)))
  GROUP BY cf.id, cf.nom, cf.type, cf.statut, cf.datedebut;


ALTER TABLE public.v_conflict_countries OWNER TO wikigeo_user;

--
-- Name: v_country_organizations; Type: VIEW; Schema: public; Owner: wikigeo_user
--

CREATE VIEW public.v_country_organizations AS
 SELECT c.id,
    c.nom,
    c.capitale,
    c.continent,
    array_agg(DISTINCT o.nom) AS organisations
   FROM ((public.country c
     LEFT JOIN public.country_organization co ON (((c.id)::text = (co.countryid)::text)))
     LEFT JOIN public.organization o ON (((co.organizationid)::text = (o.id)::text)))
  GROUP BY c.id, c.nom, c.capitale, c.continent;


ALTER TABLE public.v_country_organizations OWNER TO wikigeo_user;

--
-- Name: v_country_resources; Type: VIEW; Schema: public; Owner: wikigeo_user
--

CREATE VIEW public.v_country_resources AS
 SELECT c.id,
    c.nom,
    array_agg(DISTINCT r.nom) AS ressources
   FROM ((public.country c
     LEFT JOIN public.resource_country cr ON (((c.id)::text = (cr.countryid)::text)))
     LEFT JOIN public.resource r ON (((cr.resourceid)::text = (r.id)::text)))
  GROUP BY c.id, c.nom;


ALTER TABLE public.v_country_resources OWNER TO wikigeo_user;

--
-- Name: agricultural_export id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_export ALTER COLUMN id SET DEFAULT nextval('public.agricultural_export_id_seq'::regclass);


--
-- Name: agricultural_import id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_import ALTER COLUMN id SET DEFAULT nextval('public.agricultural_import_id_seq'::regclass);


--
-- Name: armed_conflict id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.armed_conflict ALTER COLUMN id SET DEFAULT nextval('public.armed_conflict_id_seq'::regclass);


--
-- Name: country_agricultural_production id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_agricultural_production ALTER COLUMN id SET DEFAULT nextval('public.country_agricultural_production_id_seq'::regclass);


--
-- Name: demographic_data id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.demographic_data ALTER COLUMN id SET DEFAULT nextval('public.demographic_data_id_seq'::regclass);


--
-- Name: geographic_detail id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.geographic_detail ALTER COLUMN id SET DEFAULT nextval('public.geographic_detail_id_seq'::regclass);


--
-- Name: global_demographic_trends id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.global_demographic_trends ALTER COLUMN id SET DEFAULT nextval('public.global_demographic_trends_id_seq'::regclass);


--
-- Name: megacity id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.megacity ALTER COLUMN id SET DEFAULT nextval('public.megacity_id_seq'::regclass);


--
-- Name: political_transition id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.political_transition ALTER COLUMN id SET DEFAULT nextval('public.political_transition_id_seq'::regclass);


--
-- Name: technology_country_leadership id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.technology_country_leadership ALTER COLUMN id SET DEFAULT nextval('public.technology_country_leadership_id_seq'::regclass);


--
-- Name: tourism_data id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.tourism_data ALTER COLUMN id SET DEFAULT nextval('public.tourism_data_id_seq'::regclass);


--
-- Name: transport_data id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.transport_data ALTER COLUMN id SET DEFAULT nextval('public.transport_data_id_seq'::regclass);


--
-- Data for Name: agricultural_export; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.agricultural_export (id, countryid, productid, exportvalue, exportunit, exportyear, percentageofglobal, description, statut, created_at, updated_at) FROM stdin;
12	russia	ble	33.0	millions de tonnes	2021	20.00	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
13	usa	ble	26.1	millions de tonnes	2021	15.80	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
14	canada	ble	23.0	millions de tonnes	2021	13.90	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
15	france	ble	18.0	millions de tonnes	2021	10.90	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
16	ukraine	ble	16.5	millions de tonnes	2021	10.00	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
17	india	riz	21.5	millions de tonnes	2021	40.60	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
18	thailand	riz	6.1	millions de tonnes	2021	11.50	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
19	vietnam	riz	6.3	millions de tonnes	2021	11.90	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
20	usa	mais	69.0	millions de tonnes	2021	35.00	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
21	argentina	mais	39.0	millions de tonnes	2021	19.80	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
22	brazil	mais	20.0	millions de tonnes	2021	10.20	\N	\N	2025-07-08 19:51:07.127592	2025-07-08 19:51:07.137328
\.


--
-- Data for Name: agricultural_import; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.agricultural_import (id, countryid, productid, importvalue, importunit, importyear, description, statut, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: agricultural_product; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.agricultural_product (id, name, category, description, global_production_value, global_production_unit, global_production_year) FROM stdin;
ble	Blé	Céréales	Céréale la plus cultivée au monde, base de l'alimentation de nombreuses populations.	776.0	millions de tonnes	2021
riz	Riz	Céréales	Aliment de base pour plus de la moitié de la population mondiale.	520.0	millions de tonnes	2021
mais	Maïs	Céréales	Céréale la plus produite au monde, utilisée pour l'alimentation humaine, animale et les biocarburants.	1162.0	millions de tonnes	2021
soja	Soja	Légumineuses	Légumineuse riche en protéines, utilisée pour l'alimentation animale et humaine.	372.0	millions de tonnes	2021
coton	Coton	Fibres	Fibre naturelle la plus utilisée dans l'industrie textile mondiale.	25.0	millions de tonnes	2021
cafe	Café	Stimulants	Boisson stimulante la plus consommée au monde après l'eau.	10.5	millions de tonnes	2021
the	Thé	Stimulants	Deuxième boisson la plus consommée au monde.	6.5	millions de tonnes	2021
sucre	Sucre	Édulcorants	Produit sucrant extrait de la canne à sucre et de la betterave.	180.0	millions de tonnes	2021
\.


--
-- Data for Name: armed_conflict; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.armed_conflict (id, name, description, startyear, endyear, status, involvedcountries, casualtyestimates, geopoliticalimpact, statut, created_at, updated_at) FROM stdin;
1	Guerre en Ukraine	Conflit armé entre la Russie et l'Ukraine suite à l'invasion russe du 24 février 2022. La Russie a envahi l'Ukraine en violation du droit international, déclenchant la plus grande guerre en Europe depuis 1945.	2022	\N	En cours	["russia", "ukraine"]	{"refugees": "Plus de 8 millions", "russian_casualties": "Plus de 300 000", "civilian_casualties": "Plus de 10 000", "ukrainian_casualties": "Plus de 200 000"}	Impact majeur sur la sécurité énergétique européenne, reconfiguration des alliances, crise alimentaire mondiale, renforcement de l'OTAN, sanctions économiques contre la Russie	\N	2025-07-08 19:53:51.955902	2025-07-08 19:53:51.963155
2	Conflit Israël-Hamas	Conflit armé entre Israël et le Hamas dans la bande de Gaza, déclenché par l'attaque surprise du Hamas le 7 octobre 2023. Conflit de haute intensité avec bombardements massifs et opérations terrestres.	2023	\N	En cours	["israel", "palestine"]	{"displaced": "Plus de 1,9 million", "israeli_casualties": "Plus de 1 400", "civilian_casualties": "Plus de 20 000", "palestinian_casualties": "Plus de 25 000"}	Crise humanitaire majeure, tensions régionales, risque d'extension au Liban et en Syrie, impact sur les relations internationales, question de la solution à deux États	\N	2025-07-08 19:53:51.955902	2025-07-08 19:53:51.963155
3	Guerre civile au Soudan	Conflit armé entre l'Armée régulière soudanaise (SAF) et les Forces de soutien rapide (RSF) depuis avril 2023. Combat pour le contrôle du pouvoir politique et économique au Soudan.	2023	\N	En cours	["sudan"]	{"refugees": "Plus de 1,5 million", "displaced": "Plus de 7 millions", "total_casualties": "Plus de 12 000"}	Crise humanitaire majeure, déstabilisation de la région, impact sur les routes migratoires vers l'Europe, intervention de puissances étrangères (Égypte, Émirats)	\N	2025-07-08 19:53:51.955902	2025-07-08 19:53:51.963155
4	Conflit au Sahel	Conflits armés dans la région du Sahel impliquant des groupes djihadistes, des forces gouvernementales et des milices locales. Affecte principalement le Mali, le Burkina Faso et le Niger.	2012	\N	En cours	["mali", "burkina-faso", "niger", "chad"]	{"displaced": "Plus de 3 millions", "total_casualties": "Plus de 15 000", "terrorist_attacks": "Plus de 2 000 par an"}	Déstabilisation de l'Afrique de l'Ouest, terrorisme islamiste, intervention française (Barkhane), coups d'État militaires, crise humanitaire	\N	2025-07-08 19:53:51.955902	2025-07-08 19:53:51.963155
5	Guerre civile en Éthiopie	Conflit armé dans la région du Tigré en Éthiopie entre le gouvernement fédéral et le Front de libération du peuple du Tigré (TPLF). Conflit complexe avec implications régionales.	2020	\N	En cours	["ethiopia", "eritrea"]	{"displaced": "Plus de 2,5 millions", "famine_risk": "Plus de 5 millions", "total_casualties": "Plus de 600 000"}	Crise humanitaire majeure, déstabilisation de la Corne de l'Afrique, impact sur les relations Éthiopie-Érythrée, questions de génocide	\N	2025-07-08 19:53:51.955902	2025-07-08 19:53:51.963155
6	Conflit en République démocratique du Congo	Conflits armés dans l'est de la RDC impliquant de nombreux groupes armés, milices locales et forces étrangères. Conflit complexe lié aux ressources naturelles.	1996	\N	En cours	["democratic-republic-of-congo", "rwanda", "uganda"]	{"displaced": "Plus de 5 millions", "sexual_violence": "Plus de 200 000 cas", "total_casualties": "Plus de 6 millions"}	Exploitation des ressources naturelles (coltan, or), violences sexuelles massives, crise humanitaire, intervention de l'ONU (MONUSCO)	\N	2025-07-08 19:53:51.955902	2025-07-08 19:53:51.963155
7	Guerre civile au Yémen	Conflit armé entre le gouvernement yéménite soutenu par l'Arabie saoudite et les rebelles Houthis soutenus par l'Iran. Guerre par procuration dans la région.	2014	\N	En cours	["yemen", "saudi-arabia", "iran"]	{"cholera_cases": "Plus de 2,5 millions", "total_casualties": "Plus de 150 000", "humanitarian_crisis": "Plus de 24 millions en besoin d'aide"}	Crise humanitaire majeure, intervention de la coalition saoudienne, tensions Iran-Arabie saoudite, blocus maritime, famine	\N	2025-07-08 19:53:51.955902	2025-07-08 19:53:51.963155
8	Conflit en République centrafricaine	Conflit armé entre différents groupes armés en RCA, impliquant des milices locales et des forces étrangères. Conflit complexe avec dimensions ethniques et religieuses.	2012	\N	En cours	["central-african-republic", "russia", "france"]	{"displaced": "Plus de 600 000", "total_casualties": "Plus de 5 000", "humanitarian_crisis": "Plus de 3 millions en besoin"}	Crise humanitaire, intervention internationale (MINUSCA), exploitation des ressources, présence de mercenaires russes (Wagner)	\N	2025-07-08 19:53:51.955902	2025-07-08 19:53:51.963155
9	Conflit au Myanmar	Conflit armé au Myanmar suite au coup d'État militaire de février 2021. Opposition armée entre la junte militaire et les forces démocratiques, avec implications ethniques.	2021	\N	En cours	["myanmar"]	{"refugees": "Plus de 1 million", "displaced": "Plus de 2 millions", "total_casualties": "Plus de 8 000"}	Crise humanitaire, déstabilisation de l'Asie du Sud-Est, impact sur les relations Chine-Myanmar, questions de génocide (Rohingyas)	\N	2025-07-08 19:53:51.955902	2025-07-08 19:53:51.963155
10	Conflit en Somalie	Conflit armé complexe en Somalie impliquant le gouvernement fédéral, les Shebab (Al-Shabaab) et divers groupes armés. Conflit avec dimensions terroristes.	1991	\N	En cours	["somalia", "kenya", "ethiopia"]	{"piracy_peak": "2008-2012", "total_casualties": "Plus de 500 000", "terrorist_attacks": "Plus de 1 000 par an"}	Terrorisme islamiste, piratage maritime (réduit), crise humanitaire, intervention de l'AMISOM, impact sur la sécurité maritime	\N	2025-07-08 19:53:51.955902	2025-07-08 19:53:51.963155
\.


--
-- Data for Name: comm_network; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.comm_network (id, nom, type, description, datemiseenservice, acteurs, capacite, geojsonref) FROM stdin;
\.


--
-- Data for Name: comm_network_country; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.comm_network_country (commnetworkid, countryid, role, statut) FROM stdin;
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.company (id, nom, pays, secteur, indicateurs) FROM stdin;
tesla	Tesla	usa	Automobile	{"employes": 127855, "chiffre_affaires": "538.23 milliards USD"}
toyota	Toyota	japan	Automobile	{"employes": 372817, "chiffre_affaires": "279.515 milliards USD"}
volkswagen	Volkswagen	germany	Automobile	{"employes": 662575, "chiffre_affaires": "295.819 milliards USD"}
apple	Apple	usa	Informatique	{"employes": 164000, "chiffre_affaires": "394.328 milliards USD"}
samsung	Samsung	south-korea	Informatique	{"employes": 267937, "chiffre_affaires": "234.2 milliards USD"}
pfizer	Pfizer	usa	Pharmaceutique	{"employes": 83000, "chiffre_affaires": "100.33 milliards USD"}
novartis	Novartis	germany	Pharmaceutique	{"employes": 108000, "chiffre_affaires": "51.6 milliards USD"}
shell	Shell	uk	Énergie	{"employes": 87000, "chiffre_affaires": "386.201 milliards USD"}
\.


--
-- Data for Name: conflict; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.conflict (id, nom, type, statut, datedebut, datefin, intensite, localisation, victimes, timeline, effortspaix, consequences) FROM stdin;
conflit-ukraine-2022	Guerre en Ukraine	Guerre interétatique	En cours	2022-02-24	\N	Élevée	0103000020E61000000100000005000000174850FC18233640B4C876BE9F924940174850FC182336407F6ABC7493304A4090A0F831E61644407F6ABC7493304A4090A0F831E6164440B4C876BE9F924940174850FC18233640B4C876BE9F924940	\N	\N	\N	\N
conflit-syrie	Guerre civile syrienne	Guerre civile	En cours	2011-03-15	\N	Élevée	0103000020E610000001000000050000009FABADD85FCE41408FE4F21FD22740409FABADD85FCE4140AF25E4839EC542400C93A98251314540AF25E4839EC542400C93A982513145408FE4F21FD22740409FABADD85FCE41408FE4F21FD2274040	\N	\N	\N	\N
conflit-yemen	Guerre au Yémen	Guerre civile	En cours	2014-09-19	\N	Moyenne	0103000020E61000000100000005000000857CD0B3594D4540EC51B81E852B2940857CD0B3594D4540ABCFD556ECFF32401FF46C567D5E4B40ABCFD556ECFF32401FF46C567D5E4B40EC51B81E852B2940857CD0B3594D4540EC51B81E852B2940	\N	\N	\N	\N
\.


--
-- Data for Name: conflict_country; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.conflict_country (countryid, conflictid, role, dateentree, datesortie) FROM stdin;
russia	conflit-ukraine-2022	Agresseur	\N	\N
usa	conflit-ukraine-2022	Soutien militaire	\N	\N
france	conflit-ukraine-2022	Soutien militaire	\N	\N
germany	conflit-ukraine-2022	Soutien militaire	\N	\N
uk	conflit-ukraine-2022	Soutien militaire	\N	\N
\.


--
-- Data for Name: conflict_resource; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.conflict_resource (conflict_id, resource_id, importance) FROM stdin;
conflit-ukraine-2022	gaz-naturel	Très importante
conflit-ukraine-2022	petrole	Importante
conflit-syrie	petrole	Importante
conflit-yemen	petrole	Importante
\.


--
-- Data for Name: conflict_trade_route; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.conflict_trade_route (conflict_id, trade_route_id, impact) FROM stdin;
conflit-ukraine-2022	route-suez	Impact limité
conflit-yemen	route-hormuz	Impact majeur
conflit-yemen	route-malacca	Impact mineur
\.


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country (id, nom, drapeau, capitale, langue, monnaie, continent, sections, indicateurs, politique, economie, demographie, frontieres, coordonnees, pib, population, revenumedian, superficiekm2, indicesouverainete, indicedependance, statutstrategique, datecreation, datedernieremiseajour, histoire, appartenancegeographique) FROM stdin;
eritrea	Érythrée	🇪🇷	Asmara	Tigrinya	Nakfa (ERN)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008043400000000000002E40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
netherlands	Pays-Bas	🇳🇱	Amsterdam	Néerlandais	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000016400000000000004A40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
sri-lanka	Sri Lanka	🇱🇰	Colombo	Cingalais, Tamoul	Roupie srilankaise (LKR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000004054400000000000001C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
poland	Pologne	🇵🇱	Varsovie	Polonais	Zloty (PLN)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000033400000000000004A40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
afghanistan	Afghanistan	🇦🇫	Kaboul	Pachto, Dari	Afghani (AFN)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000004050400000000000804040	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
pakistan	Pakistan	🇵🇰	Islamabad	Ourdou, Anglais	Roupie pakistanaise (PKR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008051400000000000003E40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
bangladesh	Bangladesh	🇧🇩	Dhaka	Bengali	Taka (BDT)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008056400000000000003840	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
bolivia	Bolivie	🇧🇴	La Paz	Espagnol	Boliviano (BOB)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E610000000000000004050C000000000000031C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
ethiopia	Éthiopie	🇪🇹	Addis-Abeba	Amharique	Birr (ETB)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000044400000000000002240	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
nigeria	Nigeria	🇳🇬	Abuja	Anglais	Naira (NGN)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000020400000000000002440	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
botswana	Botswana	🇧🇼	Gaborone	Anglais, Tswana	Pula (BWP)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000000000000000384000000000000036C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
burkina-faso	Burkina Faso	🇧🇫	Ouagadougou	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000000C00000000000002840	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
cuba	Cuba	🇨🇺	La Havane	Espagnol	Peso cubain (CUP)	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000054C00000000000803540	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
iraq	Irak	🇮🇶	Bagdad	Arabe	Dinar irakien (IQD)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000046400000000000804040	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
kazakhstan	Kazakhstan	🇰🇿	Nour-Soultan	Kazakh, Russe	Tenge (KZT)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000051400000000000004840	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
tonga	Tonga	🇹🇴	Nuku'alofa	Anglais, Tongan	Pa'anga	Océanie	\N	\N	\N	\N	\N	\N	0101000020E610000027C286A757E665C0E7FBA9F1D22D35C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
tuvalu	Tuvalu	🇹🇻	Funafuti	Tuvaluan, Anglais	Dollar tuvaluan	Océanie	\N	\N	\N	\N	\N	\N	0101000020E61000007D3F355EBA436640E3A59BC420701CC0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
vanuatu	Vanuatu	🇻🇺	Port-Vila	Bichelamar, Anglais, Français	Vatu	Océanie	\N	\N	\N	\N	\N	\N	0101000020E610000009F9A067B3DE644070CE88D2DEC02EC0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
ukraine	Ukraine	🇺🇦	Kiev	Ukrainien	Hryvnia (UAH)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000040400000000000804840	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
uganda	Ouganda	🇺🇬	Kampala	Anglais	Shilling ougandais (UGX)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000004040000000000000F03F	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
uzbekistan	Ouzbékistan	🇺🇿	Tachkent	Ouzbek	Sum (UZS)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000050400000000000804440	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
rwanda	Rwanda	🇷🇼	Kigali	Kinyarwanda, Français, Anglais	Franc rwandais (RWF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003E4000000000000000C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
somalia	Somalie	🇸🇴	Mogadiscio	Somali, Arabe	Shilling somalien (SOS)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008048400000000000002440	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
south-sudan	Soudan du Sud	🇸🇸	Djouba	Anglais	Livre sud-soudanaise (SSP)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003E400000000000001C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
vietnam	Vietnam	🇻🇳	Hanoï	Vietnamien	Dong (VND)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000005B400000000000003040	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
australia	Australie	🇦🇺	Canberra	Anglais	Dollar australien	Océanie	\N	\N	\N	\N	\N	\N	0101000020E610000026E4839ECDB86040BC0512143F4639C0	1675416000000	25690000	65000	7692024	0	0	\N	2025-07-05	2025-07-07	L'Australie, officiellement le Commonwealth d'Australie, a été colonisée par les Britanniques en 1788. Le pays a obtenu son indépendance en 1901 et est devenu une fédération. L'Australie est une monarchie constitutionnelle fédérale, membre du Commonwealth. Le pays est connu pour sa biodiversité unique, ses ressources naturelles abondantes et son économie développée.	\N
barbados	Barbade	🇧🇧	Bridgetown	Anglais	Dollar barbadien	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000BBB88D06F0CE4DC052B81E85EB312A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
kiribati	Kiribati	🇰🇮	Tarawa	Gilbertese, Anglais	Dollar australien	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000C1A8A44E40B565407E1D38674469F53F	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
denmark	Danemark	🇩🇰	Copenhague	Danois	Couronne danoise (DKK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000034A2B437F8222940AD69DE718AD64B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
ivory-coast	Côte d'Ivoire	🇨🇮	Yamoussoukro	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000007A36AB3E571B15C0ACADD85F764F1B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
finland	Finlande	🇫🇮	Helsinki	Finnois, Suédois	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000917EFB3AF0384092CB7F48BF154E40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
greece	Grèce	🇬🇷	Athènes	Grec	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000000AD7A3703DBA374004E78C28EDFD4240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
tanzania	Tanzanie	🇹🇿	Dodoma	Swahili, Anglais	Shilling tanzanien (TZS)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000736891ED7CDF4140F4FDD478E9A618C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
sudan	Soudan	🇸🇩	Khartoum	Arabe, Anglais	Livre soudanaise (SDG)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000E4839ECDAA474040E3361AC05B002F40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
angola	Angola	🇦🇴	Luanda	Portugais	Kwanza (AOA)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000645DDC4603782A403E7958A835AD21C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
austria	Autriche	🇦🇹	Vienne	Allemand	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000AB3E575BB15F30407B832F4CA61A4840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
belgium	Belgique	🇧🇪	Bruxelles	Néerlandais, Français, Allemand	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000004703780B24681140F7E461A1D66C4940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
ireland	Irlande	🇮🇪	Dublin	Anglais, Irlandais	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000005F984C158C0A19C00612143FC6AC4A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
kenya	Kenya	🇰🇪	Nairobi	Swahili, Anglais	Shilling kényan (KES)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000008C4AEA0434694240EA95B20C71ACF4BF	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
portugal	Portugal	🇵🇹	Lisbonne	Portugais	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000065AA6054524722C04DF38E53745C4340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
sweden	Suède	🇸🇪	Stockholm	Suédois	Couronne suédoise (SEK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000006F8104C58F11324052499D8026AA4D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
norway	Norvège	🇳🇴	Oslo	Norvégien	Couronne norvégienne (NOK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000371AC05B208125403EE8D9ACFAF44D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
colombia	Colombie	🇨🇴	Bogota	Espagnol	Peso colombien (COP)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000AA8251499D8452C0F2D24D6210D81240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
cyprus	Chypre	🇨🇾	Nicosie	Grec, Turc	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000062A1D634EFB040409D11A5BDC1974140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
czech-republic	République tchèque	🇨🇿	Prague	Tchèque	Couronne tchèque (CZK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000004850FC1873D72C408B6CE7FBA9094940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
brunei	Brunei	🇧🇳	Bandar Seri Begawan	Malais	Dollar de Brunei (BND)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000711B0DE02DBC5C40E4839ECDAA8F1340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
bulgaria	Bulgarie	🇧🇬	Sofia	Bulgare	Lev bulgare (BGN)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000001895D40968523740A835CD3B4E594540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
cambodia	Cambodge	🇰🇭	Phnom Penh	Khmer	Riel (KHR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000B4C876BE9F3A5A4022FDF675E01C2740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
east-timor	Timor oriental	🇹🇱	Dili	Tétoum, Portugais	Dollar américain (USD)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000143FC6DCB5645F405917B7D1001E21C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
ecuador	Équateur	🇪🇨	Quito	Espagnol	Dollar américain (USD)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E61000006744696FF09D53C0E8D9ACFA5C6DCDBF	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
equatorial-guinea	Guinée équatoriale	🇬🇶	Malabo	Espagnol, Français, Portugais	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000E2E995B20C912140143FC6DCB5040E40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
estonia	Estonie	🇪🇪	Tallinn	Estonien	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000FE43FAEDEBC038400E2DB29DEFB74D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
gabon	Gabon	🇬🇦	Libreville	Français	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000073D712F241EF2240C217265305A3DA3F	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
spain	Espagne	🇪🇸	Madrid	Espagnol	Euro	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000003C4ED1915CFE0DC0857CD0B359354440	1395000000000	47350000	30000	505990	0	0	\N	2025-07-07	2025-07-07	L'Espagne, officiellement le Royaume d'Espagne, a été unifiée sous les Rois Catholiques en 1492. Le pays a connu l'empire colonial espagnol, puis la dictature franquiste de 1939 à 1975. Depuis 1978, l'Espagne est une monarchie constitutionnelle démocratique. Le pays est membre de l'Union européenne et de l'OTAN.	\N
nauru	Nauru	🇳🇷	Yaren	Nauruan, Anglais	Dollar australien	Océanie	\N	\N	\N	\N	\N	\N	0101000020E61000002B8716D9CEDD64405F29CB10C7BAE0BF	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
libya	Libye	🇱🇾	Tripoli	Arabe	Dinar libyen (LYD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000031400000000000003940	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
mali	Mali	🇲🇱	Bamako	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000010C00000000000003140	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
chad	Tchad	🇹🇩	N'Djamena	Français, Arabe	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000033400000000000002E40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
niger	Niger	🇳🇪	Niamey	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000020400000000000003240	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
guinea	Guinée	🇬🇳	Conakry	Français	Franc guinéen (GNF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000005B423EE8D96C2BC06DE7FBA9F1122340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
guyana	Guyana	🇬🇾	Georgetown	Anglais	Dollar de Guyana (GYD)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000CE88D2DEE0134DC0A323B9FC87341B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
laos	Laos	🇱🇦	Vientiane	Lao	Kip (LAK)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000A323B9FC87A859400BB5A679C7F93140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
latvia	Lettonie	🇱🇻	Riga	Letton	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000098A1F63EE1A38400B24287E8C794C40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
liberia	Libéria	🇱🇷	Monrovia	Anglais	Dollar libérien (LRD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000F1F44A59869825C0A4DFBE0E9C331940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
iceland	Islande	🇮🇸	Reykjavik	Islandais	Couronne islandaise (ISK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000A835CD3B4EF135C0FE65F7E461095040	25691000000	372000	67000	103000	0	0	\N	2025-07-07	2025-07-07	L'Islande, officiellement la République d'Islande, a été colonisée par les Vikings norvégiens au IXe siècle. Le pays a obtenu son indépendance du Danemark en 1944. L'Islande est connue pour ses paysages volcaniques, ses sources géothermiques et ses aurores boréales. Le pays a surmonté la crise financière de 2008 et est devenu un modèle de développement durable.	\N
germany	Allemagne	🇩🇪	Berlin	Allemand	Euro	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000BA490C022BE724403E7958A835954940	4072191000000	83290000	52000	357022	0	0	\N	2025-07-05	2025-07-07	L'Allemagne, officiellement la République fédérale d'Allemagne, a été unifiée en 1871 sous l'Empire allemand. Après la défaite de 1945, l'Allemagne a été divisée en RFA et RDA. La chute du mur de Berlin en 1989 a permis la réunification en 1990. L'Allemagne est aujourd'hui la première économie européenne et un leader de l'Union européenne.	\N
lithuania	Lituanie	🇱🇹	Vilnius	Lituanien	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000F2B0506B9A473940D5E76A2BF6574B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
luxembourg	Luxembourg	🇱🇺	Luxembourg	Luxembourgeois, Français, Allemand	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000143FC6DCB5841840E71DA7E848CE4840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
malaysia	Malaisie	🇲🇾	Kuala Lumpur	Malais	Ringgit malaisien (MYR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000D5E76A2BF66B5940E9263108AC1C0940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
slovakia	Slovaquie	🇸🇰	Bratislava	Slovaque	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000007AC7293A921B3140C217265305134840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
romania	Roumanie	🇷🇴	Bucarest	Roumain	Leu roumain (RON)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000000AD7A3703D1A3A4066F7E461A1364640	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
slovenia	Slovénie	🇸🇮	Ljubljana	Slovène	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000034A2B437F8022D403A92CB7F48074740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
malta	Malte	🇲🇹	La Valette	Maltais, Anglais	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000000F0BB5A679072D40EC2FBB270FF34140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
myanmar	Myanmar	🇲🇲	Naypyidaw	Birman	Kyat (MMK)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000F853E3A59B0858406C09F9A067C33340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
mongolia	Mongolie	🇲🇳	Oulan-Bator	Mongol	Tugrik (MNT)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000002EFF21FDF6B95A405396218E75F14740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
nepal	Népal	🇳🇵	Katmandou	Népalais	Roupie népalaise (NPR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000DBF97E6ABC545540F2B0506B9AB73B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
maldives	Maldives	🇲🇻	Malé	Divehi	Rufiyaa (MVR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000008A8EE4F21F4E5240C8073D9B559F0940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
venezuela	Venezuela	🇻🇪	Caracas	Espagnol	Bolivar (VES)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000992A1895D4B950C04BEA043411F62440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
uruguay	Uruguay	🇺🇾	Montevideo	Espagnol	Peso uruguayen (UYU)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000931804560E154CC07A36AB3E577341C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
qatar	Qatar	🇶🇦	Doha	Arabe	Riyal qatari (QAR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000006666666666A649400000000000803940	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
paraguay	Paraguay	🇵🇾	Asunción	Espagnol, Guarani	Guarani (PYG)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000454772F90FD14CC088F4DBD7814339C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
suriname	Suriname	🇸🇷	Paramaribo	Néerlandais	Dollar du Suriname (SRD)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E610000060764F1E169A4BC09CC420B072681740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
senegal	Sénégal	🇸🇳	Dakar	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000005227A089B07131C01E166A4DF36E2D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
sierra-leone	Sierra Leone	🇸🇱	Freetown	Anglais	Leone (SLL)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000066F7E461A1762AC0401361C3D3EB2040	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
guinea-bissau	Guinée-Bissau	🇬🇳	Bissau	Portugais	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000B37BF2B0502B2FC0B5A679C729BA2740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
lesotho	Lesotho	🇱🇸	Maseru	Anglais, Sotho	Loti (LSL)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000098DD9387857A3B40386744696F503DC0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
liechtenstein	Liechtenstein	🇱🇮	Vaduz	Allemand	Franc suisse (CHF)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000097900F7A360B234099BB96900F924740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
north-macedonia	Macédoine du Nord	🇲🇰	Skopje	Macédonien	Denar (MKD)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000917EFB3A706E35407FD93D7958004540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
cape-verde	Cap-Vert	🌭	Praia	Portugais	Escudo cap-verdien (CVE)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000A779C7293A8237C05BD3BCE314DD2D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
zimbabwe	Zimbabwe	🇿🇼	Harare	Anglais, Shona, Ndebele	Dollar zimbabwéen (ZWL)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000007F6ABC7493083F40C1A8A44E40D331C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
zambia	Zambie	🇿🇲	Lusaka	Anglais	Kwacha zambien (ZMW)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000D0D556EC2F4B3C406666666666C62EC0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
moldova	Moldavie	🇲🇩	Chișinău	Roumain	Leu moldave (MDL)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000007AC7293A92DB3C40D34D621058814740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
montenegro	Monténégro	🇲🇪	Podgorica	Monténégrin	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000001895D409684233406519E25817374540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
monaco	Monaco	🇲🇨	Monaco	Français	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000009F9A067B3AA1D4012143FC6DCDD4540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
san-marino	Saint-Marin	🇸🇲	Saint-Marin	Italien	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000143FC6DCB5E42840E4141DC9E5F74540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
vatican	Vatican	🇻🇦	Cité du Vatican	Italien, Latin	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000004703780B24E828407AC7293A92F34440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
albania	Albanie	🇦🇱	Tirana	Albanais	Lek (ALL)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000363CBD5296D1334052B81E85EBA94440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
andorra	Andorre	🇦🇩	Andorre-la-Vieille	Catalan	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000045D8F0F44A59F83F7FFB3A70CE404540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
armenia	Arménie	🇦🇲	Erevan	Arménien	Dram (AMD)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000009CC420B072404640D5E76A2BF6174440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
azerbaijan	Azerbaïdjan	🇦🇿	Bakou	Azéri	Manat (AZN)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000492EFF21FDEE48407FD93D7958304440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
benin	Bénin	🇧🇯	Porto-Novo	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000013F241CF66D504409487855AD3FC1940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
bhutan	Bhoutan	🇧🇹	Thimphou	Dzongkha	Ngultrum (BTN)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000046B6F3FDD468564029CB10C7BA783B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
cameroon	Cameroun	🇨🇲	Yaoundé	Français, Anglais	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000A9A44E401301274062105839B4C80E40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
namibia	Namibie	🇳🇦	Windhoek	Anglais	Dollar namibien (NAD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000000000000000314000000000000036C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
papua-new-guinea	Papouasie-Nouvelle-Guinée	🇵🇬	Port Moresby	Anglais, Tok Pisin	Kina	Océanie	\N	\N	\N	\N	\N	\N	0101000020E61000007F6ABC7493FE6140C3F5285C8F4219C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
usa	États-Unis	🇺🇸	Washington D.C.	Anglais	Dollar américain	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000061545227A0ED57C0B30C71AC8B8B4240	25462700000000	331900000	74000	9833517	0	0	\N	2025-07-05	2025-07-07	Les États-Unis d'Amérique sont nés de la déclaration d'indépendance de 1776. La Constitution de 1787 a établi un système fédéral. Le XIXe siècle a vu l'expansion territoriale vers l'ouest et la guerre civile (1861-1865). Au XXe siècle, les États-Unis sont devenus une superpuissance mondiale, leader de l'économie capitaliste et de l'innovation technologique.	\N
north-korea	Corée du Nord	🇰🇵	Pyongyang	Coréen	Won nord-coréen	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000226C787AA5E05F4088F4DBD7812B4440	18000000000	25780000	1300	120540	0	0	\N	2025-07-05	2025-07-07	La Corée du Nord, officiellement République populaire démocratique de Corée, a été fondée en 1948 après la division de la péninsule coréenne. Dirigée par la dynastie Kim depuis 1948, le pays suit l'idéologie du Juche (autosuffisance). Isolée internationalement, la Corée du Nord a développé un programme nucléaire controversé et maintient un régime totalitaire.	\N
china	Chine	🇨🇳	Pékin	Mandarin	Yuan renminbi	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000DC68006F810C5A404A7B832F4CEE4140	17963170000000	1439000000	12500	9596961	0	0	\N	2025-07-05	2025-07-07	La Chine, officiellement la République populaire de Chine, est l'une des plus anciennes civilisations du monde. L'histoire chinoise remonte à plus de 4000 ans avec les dynasties successives. En 1949, Mao Zedong proclame la République populaire de Chine après la victoire communiste. Depuis les réformes économiques de 1978, la Chine est devenue la deuxième économie mondiale et une puissance majeure sur la scène internationale.	\N
japan	Japon	🇯🇵	Tokyo	Japonais	Yen japonais	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000012A5BDC117486140431CEBE2361A4240	4231141000000	125700000	42000	377975	0	0	\N	2025-07-05	2025-07-07	Le Japon, officiellement l'État du Japon, est une monarchie constitutionnelle avec une histoire millénaire. Après la défaite de 1945, le Japon a adopté une constitution pacifiste et s'est reconstruit pour devenir la troisième économie mondiale. Le pays est connu pour son innovation technologique, sa culture traditionnelle et son système éducatif performant.	\N
argentina	Argentine	🇦🇷	Buenos Aires	Espagnol	Peso argentin (ARS)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000050C000000000000041C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
egypt	Égypte	🇪🇬	Le Caire	Arabe	Livre égyptienne (EGP)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003E400000000000003A40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
russia	Russie	🇷🇺	Moscou	Russe	Rouble russe	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000BF7D1D3867545A40508D976E12C34E40	2240910000000	144100000	12000	17098246	0	0	\N	2025-07-05	2025-07-07	La Russie, officiellement la Fédération de Russie, est le plus grand pays du monde par sa superficie. L'histoire russe remonte à la principauté de Moscou au XIIIe siècle. L'Empire russe s'est étendu jusqu'à devenir l'URSS en 1922. Après la chute de l'URSS en 1991, la Russie est devenue une fédération indépendante. Le pays reste une puissance nucléaire et un acteur majeur de la géopolitique mondiale.	\N
italy	Italie	🇮🇹	Rome	Italien	Euro	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000003780B2428FE2840166A4DF38EF34440	2010430000000	60360000	35000	301340	0	0	\N	2025-07-07	2025-07-07	L'Italie, officiellement la République italienne, est née de l'unification de 1861. Le pays a connu le fascisme de 1922 à 1945, puis est devenu une république démocratique. L'Italie est un membre fondateur de l'Union européenne et de l'OTAN. Le pays est connu pour son patrimoine culturel exceptionnel, son industrie de luxe et son influence dans la mode et le design.	\N
mexico	Mexique	🇲🇽	Mexico	Espagnol	Peso mexicain	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008059C00000000000003740	1417000000000	128900000	9500	1964375	0	0	\N	2025-07-05	2025-07-07	Le Mexique, officiellement les États-Unis mexicains, a été colonisé par l'Espagne au XVIe siècle. Le pays a obtenu son indépendance en 1821. Le Mexique est une république fédérale démocratique. Le pays est la deuxième économie d'Amérique latine et un partenaire commercial majeur des États-Unis.	\N
turkey	Turquie	🇹🇷	Ankara	Turc	Livre turque	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008041400000000000804340	905987000000	84780000	9500	783562	0	0	\N	2025-07-05	2025-07-07	La Turquie, officiellement la République de Turquie, a été fondée en 1923 par Mustafa Kemal Atatürk après la chute de l'Empire ottoman. Le pays a adopté un système laïc et occidental. La Turquie est un pont géographique entre l'Europe et l'Asie. Le pays est membre de l'OTAN et candidat à l'Union européenne.	\N
dominica	Dominique	🇩🇲	Roseau	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000EFC9C342ADB14EC05F07CE19519A2E40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
fiji	Fidji	🇫🇯	Suva	Anglais, Fidjien	Dollar fidjien	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000AE47E17A1442664066F7E461A1B631C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
switzerland	Suisse	🇨🇭	Berne	Allemand, Français, Italien	Franc suisse (CHF)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000020400000000000804740	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
peru	Pérou	🇵🇪	Lima	Espagnol	Sol (PEN)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000053C000000000000024C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
morocco	Maroc	🇲🇦	Rabat	Arabe	Dirham marocain (MAD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000014C00000000000004040	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
comoros	Comores	🇰🇲	Moroni	Arabe, Français, Comorien	Franc comorien (KMF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000048BF7D1D389F4540D122DBF97E4A27C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
burundi	Burundi	🇧🇮	Gitega	Kirundi	Franc burundais	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000B1E1E995B2EC3D407E1D386744690BC0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
new-zealand	Nouvelle-Zélande	🇳🇿	Wellington	Anglais, Maori	Dollar néo-zélandais	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000F7E461A1D6D8654088635DDC467344C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
togo	Togo	🇹🇬	Lomé	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000E3C798BB9690F33FCDCCCCCCCC8C1840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
tunisia	Tunisie	🇹🇳	Tunis	Arabe	Dinar tunisien	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000865AD3BCE35424407FFB3A70CE684240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
indonesia	Indonésie	🇮🇩	Jakarta	Indonésien	Roupie indonésienne (IDR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000005E4000000000000000C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
taiwan	Taïwan	🇹🇼	Taipei	Mandarin	Dollar taïwanais (TWD)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000405E400000000000803740	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
uae	Émirats arabes unis	🇦🇪	Abu Dhabi	Arabe	Dirham des Émirats (AED)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000004B400000000000003840	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
bosnia-herzegovina	Bosnie-Herzégovine	🇧🇦	Sarajevo	Bosniaque, Croate, Serbe	Mark convertible (BAM)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000032400000000000004640	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
new-caledonia	Nouvelle-Calédonie	🇳🇨	Nouméa	Français	Franc CFP (XPF)	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000B0644000000000008035C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
haiti	Haïti	🇭🇹	Port-au-Prince	Français	Gourde haïtienne	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000AE47E17A141652C0D200DE02098A3240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
thailand	Thaïlande	🇹🇭	Bangkok	Thaï	Baht	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000EC51B81E853F59403D0AD7A370BD2F40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
algeria	Algérie	🇩🇿	Alger	Arabe	Dinar algérien (DZD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000008400000000000003C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
gambia	Gambie	🇬🇲	Banjul	Anglais	Dalasi (GMD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000004E621058399430C0A52C431CEBE22A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
central-african-republic	République centrafricaine	🇨🇫	Bangui	Français	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000035400000000000001C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
uk	Royaume-Uni	🇬🇧	Londres	Anglais	Livre sterling	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000DA1B7C613255C0BFC5FEB27BF2C04940	3070667000000	67220000	46000	242495	0	0	\N	2025-07-05	2025-07-07	Le Royaume-Uni de Grande-Bretagne et d'Irlande du Nord est né de l'union de l'Angleterre et de l'Écosse en 1707. Au XIXe siècle, l'Empire britannique est devenu le plus vaste empire de l'histoire. Le pays a joué un rôle crucial dans les deux guerres mondiales. En 1973, il rejoint la CEE, mais quitte l'Union européenne en 2020 (Brexit).	\N
brazil	Brésil	🇧🇷	Brasília	Portugais	Real brésilien	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000917EFB3A70F649C0B81E85EB51782CC0	1920095000000	214300000	8900	8515767	0	0	\N	2025-07-05	2025-07-07	Le Brésil, officiellement la République fédérative du Brésil, a été colonisé par le Portugal au XVIe siècle. Le pays a obtenu son indépendance en 1822 et est devenu une république en 1889. Plus grand pays d'Amérique du Sud, le Brésil est une puissance émergente avec une économie diversifiée et une influence croissante sur la scène internationale.	\N
south-korea	Corée du Sud	🇰🇷	Séoul	Coréen	Won sud-coréen	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000005BD3BCE314F15F4087A757CA32F44140	1674000000000	51740000	35000	100210	0	0	\N	2025-07-05	2025-07-07	La Corée du Sud, officiellement la République de Corée, a été fondée en 1948 après la division de la péninsule coréenne. Le pays a connu une croissance économique spectaculaire depuis les années 1960, devenant l'un des "Tigres asiatiques". La Corée du Sud est une démocratie parlementaire développée, leader dans les technologies et l'innovation.	\N
iran	Iran	🇮🇷	Téhéran	Persan	Rial iranien	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000F2D24D6210D84A40ADFA5C6DC5364040	367970000000	85000000	5500	1648195	0	0	\N	2025-07-05	2025-07-07	L'Iran, officiellement la République islamique d'Iran, a une histoire millénaire remontant à l'Empire perse. En 1979, la Révolution islamique a renversé la monarchie et établi une république islamique. L'Iran est une théocratie où le pouvoir religieux et politique sont fusionnés. Le pays est une puissance régionale majeure au Moyen-Orient.	\N
panama	Panama	🇵🇦	Panama	Espagnol	Balboa	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000F775E09C11E153C04850FC1873F72140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
ghana	Ghana	🇬🇭	Accra	Anglais	Cedi (GHS)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000CEAACFD556ECC7BF3D0AD7A3703D1640	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
palau	Palaos	🇵🇼	Ngerulmud	Anglais, Palauan	Dollar américain	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000713D0AD7A3D260408FC2F5285C0F1E40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
samoa	Samoa	🇼🇸	Apia	Samoan, Anglais	Tala	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000AD69DE718A7865C0A4DFBE0E9CB32BC0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
france	France	🇫🇷	Paris	Français	Euro	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000D93D7958A8B50140E9482EFF211D4740	2782900000000	67390000	42000	551695	0	0	\N	2025-07-05	2025-07-07	La France, officiellement la République française, est un pays d'Europe occidentale. Fondée en 987, elle est devenue une puissance majeure sous les rois capétiens. La Révolution française de 1789 a transformé la monarchie en république. Au XIXe siècle, la France a étendu son empire colonial. Après les deux guerres mondiales, elle est devenue un membre fondateur de l'Union européenne et une puissance nucléaire.	\N
india	Inde	🇮🇳	New Delhi	Hindi	Roupie indienne	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000061545227A0BD53409CA223B9FC973440	3385089000000	1408000000	2200	3287263	0	0	\N	2025-07-05	2025-07-07	L'Inde, officiellement la République de l'Inde, a obtenu son indépendance du Royaume-Uni en 1947. Plus grande démocratie du monde, l'Inde a connu une croissance économique rapide depuis les réformes de 1991. Le pays est marqué par sa diversité culturelle, religieuse et linguistique. L'Inde est devenue une puissance régionale majeure en Asie du Sud.	\N
canada	Canada	🇨🇦	Ottawa	Anglais, Français	Dollar canadien	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000002E90A0F831965AC0FFB27BF2B0104C40	2139840000000	38250000	52000	9984670	0	0	\N	2025-07-05	2025-07-07	Le Canada, officiellement la Confédération canadienne, est né de l'union de colonies britanniques en 1867. Le pays a obtenu son indépendance progressive du Royaume-Uni et est devenu un dominion autonome. Le Canada est une monarchie constitutionnelle fédérale, membre du Commonwealth. Le pays est connu pour sa diversité culturelle, ses vastes territoires naturels et sa qualité de vie élevée.	\N
south-africa	Afrique du Sud	🇿🇦	Pretoria	Anglais, Afrikaans, Zoulou	Rand sud-africain	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000AEB6627FD9FD3840AC1C5A643B8F3EC0	405870000000	59310000	6000	1221037	0	0	\N	2025-07-05	2025-07-07	L'Afrique du Sud, officiellement la République d'Afrique du Sud, a été colonisée par les Européens au XVIIe siècle. Le pays a connu l'apartheid de 1948 à 1994. En 1994, Nelson Mandela est devenu le premier président noir démocratiquement élu. L'Afrique du Sud est la première économie d'Afrique et un leader continental.	\N
honduras	Honduras	🇭🇳	Tegucigalpa	Espagnol	Lempira hondurien	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000053411363CCD55C069006F8104252C40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
nicaragua	Nicaragua	🇳🇮	Managua	Espagnol	Córdoba oro	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000742497FF909255C0EE7C3F355E3A2840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
chile	Chili	🇨🇱	Santiago	Espagnol	Peso chilien (CLP)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000C051C00000000000003EC0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
congo	République du Congo	🇨🇬	Brazzaville	Français	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000002E40000000000000F0BF	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
singapore	Singapour	🇸🇬	Singapour	Anglais, Mandarin, Malais, Tamoul	Dollar de Singapour (SGD)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000003333333333F35940CDCCCCCCCCCCF43F	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
belize	Belize	🇧🇿	Belmopan	Anglais	Dollar bélizien	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000068226C787A3156C0E3361AC05B403140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
el-salvador	Salvador	🇸🇻	San Salvador	Espagnol	Dollar américain	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000002EFF21FDF64D56C0FBCBEEC9C3622B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
saint-kitts-and-nevis	Saint-Kitts-et-Nevis	🇰🇳	Basseterre	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000006B2BF697DD5B4FC005C58F31774D3140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
serbia	Serbie	🇷🇸	Belgrade	Serbe	Dinar serbe (RSD)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000035400000000000004640	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
antigua-and-barbuda	Antigua-et-Barbuda	🇦🇬	Saint John's	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000008FE4F21FD2DF4EC0AA8251499D203140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
saint-lucia	Saint-Lucie	🇱🇨	Castries	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000066666666667E4EC02041F163CCFD2B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
bahrain	Bahreïn	🇧🇭	Manama	Arabe	Dinar bahreïni	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000007B832F4CA64A4940F0A7C64B37393A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
israel	Israël	🇮🇱	Jérusalem	Hébreu	Nouveau shekel israélien	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000DE9387855A9B41404D840D4FAFC43F40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
kyrgyzstan	Kirghizistan	🇰🇬	Bichkek	Kirghiz	Som kirghize	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000005F29CB10C7A65240728A8EE4F26F4540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
kuwait	Koweït	🇰🇼	Koweït	Arabe	Dinar koweïtien	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000A1D634EF38FD474000917EFB3A603D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
lebanon	Liban	🇱🇧	Beyrouth	Arabe	Livre libanaise	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000917EFB3AC041401895D40968F24040	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
syria	Syrie	🇸🇾	Damas	Arabe	Livre syrienne	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000008AC1C5A64234240A857CA32C4C14040	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
yemen	Yémen	🇾🇪	Sanaa	Arabe	Rial yéménite	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000C3F5285C8F1A4640E9482EFF21BD2E40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
marshall-islands	Îles Marshall	🇲🇭	Majuro	Marshallese, Anglais	Dollar américain	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000D6C56D34801765402DB29DEFA7861C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
djibouti	Djibouti	🇩🇯	Djibouti	Français, Arabe	Franc de Djibouti (DJF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000ED0DBE30999245404D158C4AEA242740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
eswatini	Eswatini	🇸🇿	Mbabane	Anglais, Swati	Lilangeni (SZL)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000D734EF3845773F40F6285C8FC2853AC0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
georgia	Géorgie	🇬🇪	Tbilissi	Géorgien	Lari (GEL)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000787AA52C436446404FAF946588DB4440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
micronesia	Micronésie	🇫🇲	Palikir	Anglais	Dollar américain	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000C58F31772DC56340FB5C6DC5FEB21B40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
solomon-islands	Îles Salomon	🇸🇧	Honiara	Anglais	Dollar des Îles Salomon	Océanie	\N	\N	\N	\N	\N	\N	0101000020E610000005A3923A01056440ED0DBE30994A23C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
turkmenistan	Turkménistan	🇹🇲	Achgabat	Turkmène	Manat turkmène	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000371AC05B20314D4019E25817B7F94240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
oman	Oman	🇴🇲	Mascate	Arabe	Rial omanais	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000007958A835CD4B4D40B003E78C289D3740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
tajikistan	Tadjikistan	🇹🇯	Douchanbé	Tadjik	Somoni	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000F697DD93873151408CDB68006F494340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
philippines	Philippines	🇵🇭	Manille	Filipino, Anglais	Peso philippin (PHP)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000805E400000000000002A40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
democratic-republic-of-congo	République démocratique du Congo	🇨🇩	Kinshasa	Français	Franc congolais (CDF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000039400000000000000000	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
croatia	Croatie	🇭🇷	Zagreb	Croate	Kuna (HRK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000002E400000000000804640	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
hungary	Hongrie	🇭🇺	Budapest	Hongrois	Forint (HUF)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000034400000000000804740	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
kosovo	Kosovo	🇽🇰	Pristina	Albanais, Serbe	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003540CDCCCCCCCC4C4540	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N
saudi-arabia	Arabie Saoudite	🇸🇦	Riyad	Arabe	Riyal saoudien	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000EEEBC039238A4640C286A757CAE23740	1010000000000	35950000	25000	2149690	0	0	\N	2025-07-05	2025-07-07	L'Arabie Saoudite, officiellement le Royaume d'Arabie saoudite, a été unifiée en 1932 par Abdelaziz Al Saoud. Le pays est une monarchie absolue gouvernée par la famille Al Saoud. L'Arabie Saoudite est le plus grand exportateur de pétrole au monde et un leader du monde arabe. Le pays est le gardien des lieux saints de l'islam.	\N
trinidad-and-tobago	Trinité-et-Tobago	🇹🇹	Port d'Espagne	Anglais	Dollar de Trinité-et-Tobago	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000042CF66D5E7C24EC0857CD0B359552540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
costa-rica	Costa Rica	🇨🇷	San José	Espagnol	Colón costaricien	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000006FF085C9540555C0AEB6627FD9DD2340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
guatemala	Guatemala	🇬🇹	Guatemala	Espagnol	Quetzal guatémaltèque	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000005B423EE8D9A056C0F775E09C11452D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
jamaica	Jamaïque	🇯🇲	Kingston	Anglais	Dollar jamaïcain	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000A69BC420B03253C00DE02D90A0F83140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
dominican-republic	République dominicaine	🇩🇴	Saint-Domingue	Espagnol	Peso dominicain	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000004182E2C7987B51C0EA95B20C717C3240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
saint-vincent-and-the-grenadines	Saint-Vincent-et-les-Grenadines	🇻🇨	Kingstown	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000000612143FC69C4EC052B81E85EB512A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
bahamas	Bahamas	🇧🇸	Nassau	Anglais	Dollar bahaméen	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000003C4ED1915C4253C032772D211F744340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
grenada	Grenade	🇬🇩	Saint George's	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000008FE4F21FD2DF4EC0789CA223B91C2840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
jordan	Jordanie	🇯🇴	Amman	Arabe	Dinar jordanien	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000006519E25817F74140A4DFBE0E9CF33F40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
madagascar	Madagascar	🇲🇬	Antananarivo	Malgache, Français	Ariary (MGA)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000005BB1BFEC9EC44740A9A44E4013E132C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
malawi	Malawi	🇲🇼	Lilongwe	Anglais, Chichewa	Kwacha malawite (MWK)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000612143FC6E440405B423EE8D9EC2BC0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
mauritania	Mauritanie	🇲🇷	Nouakchott	Arabe	Ouguiya (MRU)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000ED0DBE3099EA2FC04DF38E5374143240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
seychelles	Seychelles	🇸🇨	Victoria	Français, Anglais, Créole seychellois	Roupie seychelloise (SCR)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000B5A679C729BA4B407DD0B359F57912C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
mauritius	Maurice	🇲🇺	Port-Louis	Anglais, Français	Roupie mauricienne (MUR)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000F46C567DAEC64C4029ED0DBE302934C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
mozambique	Mozambique	🇲🇿	Maputo	Portugais	Metical (MZN)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000009A081B9E5E4940408048BF7D1DF839C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
belarus	Biélorussie	🇧🇾	Minsk	Biélorusse, Russe	Rouble biélorusse (BYN)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000039B4C876BE8F3B402497FF907EF34A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N
\.


--
-- Data for Name: country_agricultural_production; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_agricultural_production (id, countryid, productid, productionvalue, productionunit, productionyear, percentageofglobal, description, statut, created_at, updated_at) FROM stdin;
1	china	ble	136.9	millions de tonnes	2021	17.60	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
2	india	ble	109.5	millions de tonnes	2021	14.10	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
3	russia	ble	85.9	millions de tonnes	2021	11.10	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
4	usa	ble	44.8	millions de tonnes	2021	5.80	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
5	france	ble	35.0	millions de tonnes	2021	4.50	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
6	uk	ble	15.6	millions de tonnes	2021	2.00	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
7	germany	ble	22.2	millions de tonnes	2021	2.90	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
8	canada	ble	32.3	millions de tonnes	2021	4.20	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
21	china	ble	136.9	millions de tonnes	2021	17.60	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
22	india	ble	109.5	millions de tonnes	2021	14.10	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
23	russia	ble	85.9	millions de tonnes	2021	11.10	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
24	usa	ble	44.8	millions de tonnes	2021	5.80	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
25	france	ble	35.0	millions de tonnes	2021	4.50	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
26	uk	ble	15.6	millions de tonnes	2021	2.00	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
27	germany	ble	22.2	millions de tonnes	2021	2.90	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
28	canada	ble	32.3	millions de tonnes	2021	4.20	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
29	china	riz	212.8	millions de tonnes	2021	40.90	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
30	india	riz	178.3	millions de tonnes	2021	34.30	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
31	indonesia	riz	54.4	millions de tonnes	2021	10.50	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
32	bangladesh	riz	54.7	millions de tonnes	2021	10.50	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
33	vietnam	riz	43.4	millions de tonnes	2021	8.30	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
34	thailand	riz	21.3	millions de tonnes	2021	4.10	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
35	usa	mais	383.9	millions de tonnes	2021	33.00	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
36	china	mais	272.6	millions de tonnes	2021	23.50	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
37	brazil	mais	87.0	millions de tonnes	2021	7.50	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
38	argentina	mais	51.0	millions de tonnes	2021	4.40	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
39	ukraine	mais	42.1	millions de tonnes	2021	3.60	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
40	india	mais	31.0	millions de tonnes	2021	2.70	\N	\N	2025-07-08 19:50:02.315005	2025-07-08 19:50:02.321317
\.


--
-- Data for Name: country_organization; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_organization (countryid, organizationid, role, dateadhesion, datesortie) FROM stdin;
france	onu	Membre permanent	1945-10-24	\N
usa	onu	Membre permanent	1945-10-24	\N
china	onu	Membre permanent	1971-10-25	\N
russia	onu	Membre permanent	1945-10-24	\N
uk	onu	Membre permanent	1945-10-24	\N
france	ue	Membre fondateur	1957-03-25	\N
germany	ue	Membre fondateur	1957-03-25	\N
usa	g7	Membre	1975-01-01	\N
japan	g7	Membre	1975-01-01	\N
china	g20	Membre	1999-01-01	\N
india	g20	Membre	1999-01-01	\N
brazil	g20	Membre	1999-01-01	\N
usa	org_wto	Membre	1995-01-01	\N
china	org_wto	Membre	2001-12-11	\N
japan	org_wto	Membre	1995-01-01	\N
germany	org_wto	Membre	1995-01-01	\N
france	org_wto	Membre	1995-01-01	\N
india	org_wto	Membre	1995-01-01	\N
brazil	org_wto	Membre	1995-01-01	\N
russia	org_wto	Membre	2012-08-22	\N
south-africa	org_wto	Membre	1995-01-01	\N
australia	org_wto	Membre	1995-01-01	\N
canada	org_wto	Membre	1995-01-01	\N
mexico	org_wto	Membre	1995-01-01	\N
south-korea	org_wto	Membre	1995-01-01	\N
singapore	org_wto	Membre	1995-01-01	\N
usa	org_oecd	Membre	1961-09-30	\N
japan	org_oecd	Membre	1964-04-28	\N
germany	org_oecd	Membre	1961-09-30	\N
france	org_oecd	Membre	1961-09-30	\N
italy	org_oecd	Membre	1962-03-29	\N
canada	org_oecd	Membre	1961-09-30	\N
australia	org_oecd	Membre	1971-06-07	\N
spain	org_oecd	Membre	1961-09-30	\N
netherlands	org_oecd	Membre	1961-09-30	\N
belgium	org_oecd	Membre	1961-09-30	\N
sweden	org_oecd	Membre	1961-09-30	\N
switzerland	org_oecd	Membre	1961-09-30	\N
austria	org_oecd	Membre	1961-09-30	\N
denmark	org_oecd	Membre	1961-09-30	\N
norway	org_oecd	Membre	1961-09-30	\N
finland	org_oecd	Membre	1969-01-28	\N
new-zealand	org_oecd	Membre	1973-05-29	\N
ireland	org_oecd	Membre	1961-09-30	\N
luxembourg	org_oecd	Membre	1961-09-30	\N
iceland	org_oecd	Membre	1961-09-30	\N
portugal	org_oecd	Membre	1961-09-30	\N
greece	org_oecd	Membre	1961-09-30	\N
turkey	org_oecd	Membre	1961-09-30	\N
mexico	org_oecd	Membre	1994-05-18	\N
czech-republic	org_oecd	Membre	1995-12-21	\N
hungary	org_oecd	Membre	1996-05-07	\N
poland	org_oecd	Membre	1996-11-22	\N
south-korea	org_oecd	Membre	1996-12-12	\N
slovakia	org_oecd	Membre	2000-12-14	\N
chile	org_oecd	Membre	2010-05-07	\N
slovenia	org_oecd	Membre	2010-07-21	\N
israel	org_oecd	Membre	2010-09-07	\N
estonia	org_oecd	Membre	2010-12-09	\N
latvia	org_oecd	Membre	2016-07-01	\N
lithuania	org_oecd	Membre	2018-07-05	\N
colombia	org_oecd	Membre	2020-04-28	\N
costa-rica	org_oecd	Membre	2021-05-25	\N
nigeria	org_african_union	Membre	2002-07-09	\N
south-africa	org_african_union	Membre	2002-07-09	\N
egypt	org_african_union	Membre	2002-07-09	\N
ethiopia	org_african_union	Membre	2002-07-09	\N
kenya	org_african_union	Membre	2002-07-09	\N
ghana	org_african_union	Membre	2002-07-09	\N
morocco	org_african_union	Membre	2017-01-30	\N
indonesia	org_asean	Membre fondateur	1967-08-08	\N
malaysia	org_asean	Membre fondateur	1967-08-08	\N
philippines	org_asean	Membre fondateur	1967-08-08	\N
singapore	org_asean	Membre fondateur	1967-08-08	\N
thailand	org_asean	Membre fondateur	1967-08-08	\N
brunei	org_asean	Membre	1984-01-07	\N
vietnam	org_asean	Membre	1995-07-28	\N
laos	org_asean	Membre	1997-07-23	\N
myanmar	org_asean	Membre	1997-07-23	\N
cambodia	org_asean	Membre	1999-04-30	\N
algeria	org_african_union	Membre	2002-07-09	\N
tunisia	org_african_union	Membre	2002-07-09	\N
senegal	org_african_union	Membre	2002-07-09	\N
cameroon	org_african_union	Membre	2002-07-09	\N
angola	org_african_union	Membre	2002-07-09	\N
mozambique	org_african_union	Membre	2002-07-09	\N
zimbabwe	org_african_union	Membre	2002-07-09	\N
saudi-arabia	rel_conseil_cooperation_golfe	membre	2025-07-10	\N
kuwait	rel_conseil_cooperation_golfe	membre	2025-07-10	\N
qatar	rel_conseil_cooperation_golfe	membre	2025-07-10	\N
bahrain	rel_conseil_cooperation_golfe	membre	2025-07-10	\N
oman	rel_conseil_cooperation_golfe	membre	2025-07-10	\N
uae	rel_conseil_cooperation_golfe	membre	2025-07-10	\N
russia	rel_organisation_traite_securite_collective	membre	2025-07-10	\N
belarus	rel_organisation_traite_securite_collective	membre	2025-07-10	\N
kazakhstan	rel_organisation_traite_securite_collective	membre	2025-07-10	\N
kyrgyzstan	rel_organisation_traite_securite_collective	membre	2025-07-10	\N
tajikistan	rel_organisation_traite_securite_collective	membre	2025-07-10	\N
armenia	rel_organisation_traite_securite_collective	membre	2025-07-10	\N
saudi-arabia	org_opec	Membre	1960-09-14	\N
iran	org_opec	Membre	1960-09-14	\N
iraq	org_opec	Membre	1960-09-14	\N
kuwait	org_opec	Membre	1960-09-14	\N
venezuela	org_opec	Membre	1960-09-14	\N
qatar	org_opec	Membre	1961-12-01	\N
libya	org_opec	Membre	1962-06-01	\N
indonesia	org_opec	Membre	1962-11-01	\N
uae	org_opec	Membre	1967-11-01	\N
algeria	org_opec	Membre	1969-07-01	\N
nigeria	org_opec	Membre	1971-07-01	\N
ecuador	org_opec	Membre	1973-01-01	\N
gabon	org_opec	Membre	1975-01-01	\N
angola	org_opec	Membre	2007-01-01	\N
equatorial-guinea	org_opec	Membre	2017-05-25	\N
congo	org_opec	Membre	2018-06-22	\N
usa	org_nato	Membre fondateur	1949-04-04	\N
france	org_nato	Membre fondateur	1949-04-04	\N
germany	org_nato	Membre	1955-05-06	\N
poland	org_nato	Membre	1999-03-12	\N
czech-republic	org_nato	Membre	1999-03-12	\N
hungary	org_nato	Membre	1999-03-12	\N
estonia	org_nato	Membre	2004-03-29	\N
latvia	org_nato	Membre	2004-03-29	\N
lithuania	org_nato	Membre	2004-03-29	\N
\.


--
-- Data for Name: country_political_regime; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_political_regime (country_id, regime_id, start_year, end_year, current_regime, notes, chef_etat, date_prise_poste) FROM stdin;
antigua-and-barbuda	republique-presidentielle	2025	\N	t	Attribution finale	Gaston Browne	2014-06-13
bahamas	republique-presidentielle	2025	\N	t	Attribution finale	Philip Davis	2021-09-17
saudi-arabia	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Mohammed ben Salmane	2017-06-21
japan	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Fumio Kishida	2021-10-04
turkey	republique-presidentielle	2025	\N	t	Attribution finale	Recep Tayyip Erdoğan	2023-06-03
algeria	republique-presidentielle	2025	\N	t	Attribution finale	Abdelmadjid Tebboune	2019-12-19
luxembourg	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Henri	2000-10-07
china	regime-autoritaire	2025	\N	t	Redistribution finale	Xi Jinping	2013-03-14
ukraine	republique-parlementaire	2025	\N	t	Redistribution finale	Volodymyr Zelensky	2019-05-20
belarus	regime-autoritaire	2025	\N	t	Redistribution finale	Alexander Lukashenko	1994-07-20
slovenia	republique-parlementaire	2025	\N	t	Redistribution finale	Nataša Pirc Musar	2022-12-23
egypt	republique-presidentielle	2025	\N	t	Attribution finale	Abdel Fattah al-Sissi	2014-06-08
papua-new-guinea	republique-presidentielle	2025	\N	t	Attribution finale	James Marape	2019-05-30
kenya	republique-presidentielle	2025	\N	t	Attribution finale	William Ruto	2022-09-13
uganda	republique-presidentielle	2025	\N	t	Attribution finale	Yoweri Museveni	1986-01-29
chad	regime-autoritaire	2025	\N	t	Redistribution finale	Idriss Déby	1990-12-02
central-african-republic	regime-autoritaire	2025	\N	t	Redistribution finale	Faustin-Archange Touadéra	2016-03-30
eritrea	regime-autoritaire	2025	\N	t	Redistribution finale	Isaias Afwerki	1993-05-24
zimbabwe	republique-presidentielle	2025	\N	t	Attribution finale	Emmerson Mnangagwa	2017-11-24
tanzania	republique-presidentielle	2025	\N	t	Attribution finale	Samia Suluhu Hassan	2021-03-19
zambia	republique-presidentielle	2025	\N	t	Attribution finale	Hichilema Hakainde	2021-08-24
new-zealand	republique-presidentielle	2025	\N	t	Attribution finale	Christopher Luxon	2023-11-27
fiji	republique-presidentielle	2025	\N	t	Attribution finale	Sitiveni Rabuka	2022-12-24
solomon-islands	republique-presidentielle	2025	\N	t	Attribution finale	Manasseh Sogavare	2019-04-24
kiribati	republique-presidentielle	2025	\N	t	Attribution finale	Taneti Maamau	2016-03-11
samoa	republique-presidentielle	2025	\N	t	Attribution finale	Fiame Naomi Mataafa	2021-05-24
tuvalu	republique-presidentielle	2025	\N	t	Attribution finale	Feleti Teo	2024-02-26
tonga	republique-presidentielle	2025	\N	t	Attribution finale	Tupou VI	2012-03-18
nauru	republique-presidentielle	2025	\N	t	Attribution finale	Nikunau Island Council	1979-07-12
vanuatu	republique-presidentielle	2025	\N	t	Attribution finale	Nikenike Vurobaravu	2022-07-23
brazil	republique-federale	2025	\N	t	Redistribution finale	Luiz Inácio Lula da Silva	2023-01-01
venezuela	regime-autoritaire	2025	\N	t	Redistribution finale	Nicolás Maduro	2013-04-19
lebanon	republique-presidentielle	2025	\N	t	Attribution finale	Najib Mikati	2021-09-10
india	republique-federale	2025	\N	t	Redistribution finale	Narendra Modi	2024-06-09
india	republique-parlementaire	2025	\N	t	Redistribution finale	Narendra Modi	2024-06-09
north-korea	regime-autoritaire	2025	\N	t	Redistribution finale	Kim Jong-un	2011-12-17
iran	regime-autoritaire	2025	\N	t	Redistribution finale	Ebrahim Raisi	2021-08-03
russia	regime-autoritaire	2025	\N	t	Redistribution finale	Vladimir Putin	2024-05-07
south-sudan	regime-autoritaire	2025	\N	t	Redistribution finale	Salva Kiir Mayardit	2011-07-09
sudan	regime-autoritaire	2025	\N	t	Redistribution finale	Omar al-Bashir	1989-06-30
ethiopia	republique-federale	2025	\N	t	Redistribution finale	Abiy Ahmed	2018-04-02
somalia	regime-autoritaire	2025	\N	t	Redistribution finale	Hassan Sheikh Mohamud	2022-05-15
australia	republique-federale	2025	\N	t	Redistribution finale	Anthony Albanese	2022-05-23
libya	regime-autoritaire	2025	\N	t	Redistribution finale	Mohamed al-Menfi	2021-03-15
marshall-islands	republique-federale	2025	\N	t	Redistribution finale	Iroojlaplap Jurelang Zedkaia	2009-10-26
france	republique-parlementaire	2025	\N	t	Redistribution finale	Emmanuel Macron	2022-05-07
germany	republique-federale	2025	\N	t	Redistribution finale	Olaf Scholz	2021-12-08
malaysia	republique-federale	2025	\N	t	Redistribution finale	Anwar Ibrahim	2022-11-24
mauritius	republique-presidentielle	2025	\N	t	Attribution finale	Pravind Jugnauth	2017-01-23
uzbekistan	regime-autoritaire	2025	\N	t	Redistribution finale	Shavkat Mirziyoyev	2016-12-14
turkmenistan	regime-autoritaire	2025	\N	t	Redistribution finale	Serdar Berdimuhamedow	2022-03-19
austria	republique-federale	2025	\N	t	Redistribution finale	Alexander Van der Bellen	2022-07-09
belgium	republique-federale	2025	\N	t	Redistribution finale	Alexander De Croo	2020-10-01
denmark	republique-parlementaire	2025	\N	t	Redistribution finale	Frederik X	2024-01-14
sweden	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Carl XVI Gustaf	1973-09-15
vietnam	regime-autoritaire	2025	\N	t	Redistribution finale	Võ Văn Thưởng	2023-03-02
mexico	republique-federale	2025	\N	t	Redistribution finale	Andrés Manuel López Obrador	2018-12-01
canada	republique-federale	2025	\N	t	Redistribution finale	Justin Trudeau	2015-11-04
argentina	republique-federale	2025	\N	t	Redistribution finale	Javier Milei	2023-12-10
sri-lanka	republique-parlementaire	2025	\N	t	Redistribution finale	Ranil Wickremesinghe	2022-07-20
dominica	republique-presidentielle	2025	\N	t	Attribution finale	Roosevelt Skerrit	2004-01-08
gambia	republique-presidentielle	2025	\N	t	Attribution finale	Adama Barrow	2017-01-19
kazakhstan	regime-autoritaire	2025	\N	t	Redistribution finale	Kassym-Jomart Tokaïev	2019-03-20
mongolia	republique-presidentielle	2025	\N	t	Attribution finale	Ukhnaagiin Khürelsükh	2021-06-25
andorra	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Xavier Espot Zamora	2019-05-16
bahrain	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Hamad ben Issa Al Khalifa	1999-03-06
barbados	republique-presidentielle	2025	\N	t	Attribution finale	Mia Mottley	2018-05-25
belize	republique-presidentielle	2025	\N	t	Attribution finale	Johnny Briceño	2020-11-12
bhutan	republique-presidentielle	2025	\N	t	Attribution finale	Jigme Khesar Namgyel Wangchuck	2006-12-14
bosnia-herzegovina	republique-federale	2025	\N	t	Redistribution finale	Denis Bećirović	2022-11-16
brunei	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Hassanal Bolkiah	1967-10-05
comoros	republique-federale	2025	\N	t	Redistribution finale	Azali Assoumani	2016-05-26
grenada	republique-presidentielle	2025	\N	t	Attribution finale	Dickon Mitchell	2022-06-24
guyana	republique-presidentielle	2025	\N	t	Attribution finale	Irfaan Ali	2020-08-02
haiti	republique-presidentielle	2025	\N	t	Attribution finale	Ariel Henry	2021-07-20
indonesia	republique-presidentielle	2025	\N	t	Attribution finale	Joko Widodo	2014-10-20
iraq	republique-federale	2025	\N	t	Redistribution finale	Mohammed Chia al-Soudani	2022-10-27
jamaica	republique-presidentielle	2025	\N	t	Attribution finale	Andrew Holness	2016-03-03
kyrgyzstan	regime-autoritaire	2025	\N	t	Redistribution finale	Sadyr Japarov	2021-01-28
kosovo	republique-presidentielle	2025	\N	t	Attribution finale	Vjosa Osmani	2021-04-04
laos	regime-autoritaire	2025	\N	t	Redistribution finale	Thongloun Sisoulith	2021-03-22
maldives	republique-presidentielle	2025	\N	t	Attribution finale	Mohamed Muizzu	2023-11-17
myanmar	regime-autoritaire	2025	\N	t	Redistribution finale	Min Aung Hlaing	2021-02-01
new-caledonia	republique-presidentielle	2025	\N	t	Attribution finale	Louis Mapou	2021-07-08
saint-kitts-and-nevis	republique-presidentielle	2025	\N	t	Attribution finale	Terrance Drew	2022-08-06
saint-lucia	republique-presidentielle	2025	\N	t	Attribution finale	Philip J. Pierre	2021-07-28
saint-vincent-and-the-grenadines	republique-presidentielle	2025	\N	t	Attribution finale	Ralph Gonsalves	2001-03-29
syria	regime-autoritaire	2025	\N	t	Redistribution finale	Bachar el-Assad	2000-07-17
tajikistan	regime-autoritaire	2025	\N	t	Redistribution finale	Emomali Rahmon	1994-11-16
east-timor	republique-presidentielle	2025	\N	t	Attribution finale	José Ramos-Horta	2022-05-20
taiwan	republique-presidentielle	2025	\N	t	Attribution finale	Lai Ching-te	2024-05-20
thailand	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Srettha Thavisin	2023-08-22
trinidad-and-tobago	republique-presidentielle	2025	\N	t	Attribution finale	Keith Rowley	2015-09-09
tunisia	republique-presidentielle	2025	\N	t	Attribution finale	Kaïs Saïed	2019-10-23
armenia	republique-presidentielle	2025	\N	t	Redistribution finale	Vahagn Khachaturyan	2022-03-13
armenia	regime-autoritaire	2025	\N	t	Redistribution finale	Vahagn Khachaturyan	2022-03-13
italy	republique-parlementaire	2025	\N	t	Redistribution finale	Giorgia Meloni	2022-10-22
spain	republique-parlementaire	2025	\N	t	Redistribution finale	Pedro Sánchez	2023-11-17
spain	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Pedro Sánchez	2023-11-17
austria	republique-parlementaire	2025	\N	t	Redistribution finale	Alexander Van der Bellen	2022-07-09
netherlands	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Mark Rutte	2010-10-14
belgium	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Alexander De Croo	2020-10-01
denmark	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Frederik X	2024-01-14
sweden	republique-parlementaire	2025	\N	t	Redistribution finale	Carl XVI Gustaf	1973-09-15
norway	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Harald V	1991-01-17
mexico	republique-presidentielle	2025	\N	t	Redistribution finale	Andrés Manuel López Obrador	2018-12-01
argentina	republique-presidentielle	2025	\N	t	Redistribution finale	Javier Milei	2023-12-10
brazil	republique-presidentielle	2025	\N	t	Redistribution finale	Luiz Inácio Lula da Silva	2023-01-01
chile	republique-presidentielle	2025	\N	t	Redistribution finale	Gabriel Boric	2022-03-11
colombia	republique-presidentielle	2025	\N	t	Redistribution finale	Gustavo Petro	2022-08-07
bolivia	republique-presidentielle	2025	\N	t	Redistribution finale	Luis Arce	2020-11-08
congo	republique-presidentielle	2025	\N	t	Redistribution finale	Félix Tshisekedi	2019-01-24
chad	republique-presidentielle	2025	\N	t	Redistribution finale	Idriss Déby	1990-12-02
central-african-republic	republique-presidentielle	2025	\N	t	Redistribution finale	Faustin-Archange Touadéra	2016-03-30
benin	republique-presidentielle	2025	\N	t	Redistribution finale	Patrice Talon	2016-04-06
burkina-faso	republique-presidentielle	2025	\N	t	Redistribution finale	Roch Marc Christian Kaboré	2015-12-29
cape-verde	republique-presidentielle	2025	\N	t	Redistribution finale	Jorge Carlos Fonseca	2011-09-09
angola	republique-presidentielle	2025	\N	t	Redistribution finale	João Lourenço	2017-09-26
botswana	republique-presidentielle	2025	\N	t	Redistribution finale	Mokgweetsi Masisi	2018-04-01
azerbaijan	republique-presidentielle	2025	\N	t	Redistribution finale	Ilham Aliyev	2003-10-31
burundi	republique-presidentielle	2025	\N	t	Redistribution finale	Évariste Ndayishimiye	2020-06-18
cambodia	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Hun Manet	2023-08-22
cameroon	republique-presidentielle	2025	\N	t	Redistribution finale	Paul Biya	1982-11-06
comoros	republique-presidentielle	2025	\N	t	Redistribution finale	Azali Assoumani	2016-05-26
eswatini	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Mswati III	1986-04-25
jordan	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Abdallah II	1999-02-07
kuwait	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Mishal Al-Ahmad Al-Jaber Al-Sabah	2023-12-16
lesotho	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Sam Matekane	2022-10-28
liechtenstein	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Daniel Risch	2021-03-25
malaysia	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Anwar Ibrahim	2022-11-24
morocco	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Mohammed VI	1999-07-23
monaco	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Albert II	2005-04-06
oman	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Haitham ben Tariq	2020-01-11
qatar	monarchie-constitutionnelle	2025	\N	t	Redistribution finale	Tamim ben Hamad Al Thani	2013-06-25
suriname	republique-presidentielle	2025	\N	t	Attribution finale	Chan Santokhi	2020-07-16
usa	republique-presidentielle	2025	\N	t	Redistribution finale	Donald Trump	2025-01-20
germany	republique-parlementaire	2025	\N	t	Redistribution finale	Olaf Scholz	2021-12-08
costa-rica	republique-presidentielle	2025	\N	t	Redistribution finale	Rodrigo Chaves Robles	2022-05-08
poland	republique-parlementaire	2025	\N	t	Redistribution finale	Donald Tusk	2023-12-13
czech-republic	republique-parlementaire	2025	\N	t	Redistribution finale	Petr Pavel	2023-03-09
hungary	republique-parlementaire	2025	\N	t	Redistribution finale	Viktor Orbán	2010-05-29
ghana	republique-presidentielle	2025	\N	t	Redistribution finale	Nana Akufo-Addo	2017-01-07
bulgaria	republique-parlementaire	2025	\N	t	Redistribution finale	Rumen Radev	2021-11-22
croatia	republique-parlementaire	2025	\N	t	Redistribution finale	Zoran Milanović	2020-02-18
slovakia	republique-parlementaire	2025	\N	t	Redistribution finale	Zuzana Čaputová	2019-06-15
lithuania	republique-parlementaire	2025	\N	t	Redistribution finale	Gitanas Nausėda	2024-05-26
latvia	republique-parlementaire	2025	\N	t	Redistribution finale	Edgars Rinkēvičs	2023-07-08
estonia	republique-parlementaire	2025	\N	t	Redistribution finale	Alar Karis	2021-10-11
finland	republique-parlementaire	2025	\N	t	Redistribution finale	Alexander Stubb	2024-03-01
ireland	republique-parlementaire	2025	\N	t	Redistribution finale	Michael D. Higgins	2011-11-11
portugal	republique-parlementaire	2025	\N	t	Redistribution finale	Marcelo Rebelo de Sousa	2016-03-09
greece	republique-parlementaire	2025	\N	t	Redistribution finale	Katerina Sakellaropoulou	2020-03-13
cyprus	republique-parlementaire	2025	\N	t	Redistribution finale	Nikos Christodoulides	2023-02-28
malta	republique-parlementaire	2025	\N	t	Redistribution finale	George Vella	2019-04-04
south-korea	republique-presidentielle	2025	\N	t	Redistribution finale	Yoon Suk-yeol	2022-05-10
rwanda	republique-presidentielle	2025	\N	t	Redistribution finale	Paul Kagame	2000-04-22
ecuador	republique-presidentielle	2025	\N	t	Redistribution finale	Guillermo Lasso	2021-05-24
peru	republique-presidentielle	2025	\N	t	Redistribution finale	Pedro Castillo	2021-07-28
venezuela	republique-presidentielle	2025	\N	t	Redistribution finale	Nicolás Maduro	2013-04-19
paraguay	republique-presidentielle	2025	\N	t	Redistribution finale	Mario Abdo Benítez	2018-08-15
moldova	republique-parlementaire	2025	\N	t	Redistribution finale	Maia Sandu	2020-12-24
romania	republique-parlementaire	2025	\N	t	Redistribution finale	Klaus Iohannis	2014-12-21
sudan	republique-presidentielle	2025	\N	t	Redistribution finale	Omar al-Bashir	1989-06-30
eritrea	republique-presidentielle	2025	\N	t	Redistribution finale	Isaias Afwerki	1993-05-24
somalia	republique-presidentielle	2025	\N	t	Redistribution finale	Hassan Sheikh Mohamud	2022-05-15
djibouti	republique-presidentielle	2025	\N	t	Redistribution finale	Ismail Omar Guelleh	1999-05-08
senegal	republique-presidentielle	2025	\N	t	Redistribution finale	Macky Sall	2012-04-02
togo	republique-presidentielle	2025	\N	t	Redistribution finale	Faure Gnassingbé	2005-05-04
niger	republique-presidentielle	2025	\N	t	Redistribution finale	Mahamadou Issoufou	2011-04-07
mali	republique-presidentielle	2025	\N	t	Redistribution finale	Ibrahim Boubacar Keïta	2013-09-04
guinea-bissau	republique-presidentielle	2025	\N	t	Redistribution finale	José Mário Vaz	2014-06-23
nigeria	republique-presidentielle	2025	\N	t	Redistribution finale	Bola Tinubu	2023-05-29
namibia	republique-presidentielle	2025	\N	t	Redistribution finale	Hage Geingob	2015-03-21
mozambique	republique-presidentielle	2025	\N	t	Redistribution finale	Filipe Nyusi	2015-01-15
dominican-republic	republique-presidentielle	2025	\N	t	Redistribution finale	Luis Abinader	2020-08-16
tajikistan	republique-presidentielle	2025	\N	t	Redistribution finale	Emomali Rahmon	1994-11-16
malaysia	theocratie	2025	\N	t	Redistribution finale	Anwar Ibrahim	2022-11-24
turkmenistan	republique-presidentielle	2025	\N	t	Redistribution finale	Serdar Berdimuhamedow	2022-03-19
usa	republique-federale	2025	\N	t	Redistribution finale	Donald Trump	2025-01-20
vatican	democratie-directe	2025	\N	t	Redistribution finale	François	2013-03-13
burundi	regime-autoritaire	2025	\N	t	Redistribution finale	Évariste Ndayishimiye	2020-06-18
cambodia	regime-autoritaire	2025	\N	t	Redistribution finale	Hun Manet	2023-08-22
uruguay	republique-presidentielle	2025	\N	t	Redistribution finale	Luis Lacalle Pou	2020-03-01
san-marino	democratie-directe	2025	\N	t	Redistribution finale	Alessandro Scarano	2024-04-01
iceland	republique-parlementaire	2025	\N	t	Redistribution finale	Guðni Th. Jóhannesson	2016-08-01
iran	theocratie	2025	\N	t	Redistribution finale	Ebrahim Raisi	2021-08-03
saudi-arabia	theocratie	2025	\N	t	Redistribution finale	Mohammed ben Salmane	2017-06-21
russia	republique-federale	2025	\N	t	Redistribution finale	Vladimir Putin	2024-05-07
south-africa	republique-federale	2025	\N	t	Redistribution finale	Cyril Ramaphosa	2024-06-14
mauritania	republique-presidentielle	2025	\N	t	Redistribution finale	Mohamed Ould Ghazouani	2019-08-01
guinea	republique-presidentielle	2025	\N	t	Redistribution finale	Alpha Condé	2010-12-21
malawi	republique-presidentielle	2025	\N	t	Redistribution finale	Lazarus Chakwera	2020-06-28
nigeria	republique-federale	2025	\N	t	Redistribution finale	Bola Tinubu	2023-05-29
afghanistan	theocratie	2025	\N	t	Redistribution finale	Hibatullah Akhundzada	2021-08-15
micronesia	republique-federale	2025	\N	t	Redistribution finale	Wesley Simina	2023-05-11
palau	republique-federale	2025	\N	t	Redistribution finale	Surangel Whipps Jr.	2021-01-21
albania	republique-parlementaire	2025	\N	t	Redistribution finale	Bajram Begaj	2022-07-24
armenia	republique-parlementaire	2025	\N	t	Redistribution finale	Vahagn Khachaturyan	2022-03-13
azerbaijan	regime-autoritaire	2025	\N	t	Redistribution finale	Ilham Aliyev	2003-10-31
azerbaijan	republique-parlementaire	2025	\N	t	Redistribution finale	Ilham Aliyev	2003-10-31
bangladesh	republique-parlementaire	2025	\N	t	Redistribution finale	Sheikh Hasina	2009-01-06
bosnia-herzegovina	republique-parlementaire	2025	\N	t	Redistribution finale	Denis Bećirović	2022-11-16
brunei	theocratie	2025	\N	t	Redistribution finale	Hassanal Bolkiah	1967-10-05
cambodia	republique-parlementaire	2025	\N	t	Redistribution finale	Hun Manet	2023-08-22
cuba	regime-autoritaire	2025	\N	t	Redistribution finale	Miguel Díaz-Canel	2018-04-19
gabon	republique-presidentielle	2025	\N	t	Redistribution finale	Brice Oligui	2023-08-30
guatemala	republique-presidentielle	2025	\N	t	Redistribution finale	Bernardo Arévalo	2024-01-15
equatorial-guinea	regime-autoritaire	2025	\N	t	Redistribution finale	Teodoro Obiang Nguema Mbasogo	1979-08-03
equatorial-guinea	republique-presidentielle	2025	\N	t	Redistribution finale	Teodoro Obiang Nguema Mbasogo	1979-08-03
georgia	regime-autoritaire	2025	\N	t	Redistribution finale	Salomé Zourabichvili	2018-12-16
honduras	republique-presidentielle	2025	\N	t	Redistribution finale	Xiomara Castro	2022-01-27
kazakhstan	republique-presidentielle	2025	\N	t	Redistribution finale	Kassym-Jomart Tokaïev	2019-03-20
kyrgyzstan	republique-presidentielle	2025	\N	t	Redistribution finale	Sadyr Japarov	2021-01-28
liberia	republique-presidentielle	2025	\N	t	Redistribution finale	Joseph Boakai	2024-01-22
liechtenstein	democratie-directe	2025	\N	t	Redistribution finale	Daniel Risch	2021-03-25
madagascar	republique-presidentielle	2025	\N	t	Redistribution finale	Andry Rajoelina	2019-01-19
nicaragua	republique-presidentielle	2025	\N	t	Redistribution finale	Daniel Ortega	2007-01-10
uzbekistan	republique-presidentielle	2025	\N	t	Redistribution finale	Shavkat Mirziyoyev	2016-12-14
pakistan	republique-federale	2025	\N	t	Redistribution finale	Anwaar-ul-Haq Kakar	2023-08-14
pakistan	republique-presidentielle	2025	\N	t	Redistribution finale	Anwaar-ul-Haq Kakar	2023-08-14
panama	republique-presidentielle	2025	\N	t	Redistribution finale	Laurentino Cortizo	2019-07-01
philippines	republique-presidentielle	2025	\N	t	Redistribution finale	Ferdinand Marcos Jr.	2022-06-30
el-salvador	republique-presidentielle	2025	\N	t	Redistribution finale	Nayib Bukele	2019-06-01
seychelles	republique-presidentielle	2025	\N	t	Redistribution finale	Wavel Ramkalawan	2020-10-26
sierra-leone	republique-presidentielle	2025	\N	t	Redistribution finale	Julius Maada Bio	2018-04-04
singapore	republique-presidentielle	2025	\N	t	Redistribution finale	Tharman Shanmugaratnam	2023-09-14
switzerland	republique-federale	2025	\N	t	Redistribution finale	Alain Berset	2023-01-01
switzerland	democratie-directe	2025	\N	t	Redistribution finale	Alain Berset	2023-01-01
vatican	theocratie	2025	\N	t	Redistribution finale	François	2013-03-13
yemen	theocratie	2025	\N	t	Redistribution finale	Mahdi al-Mashat	2018-04-25
georgia	republique-parlementaire	2025	\N	t	Redistribution finale	Salomé Zourabichvili	2018-12-16
israel	republique-parlementaire	2025	\N	t	Redistribution finale	Isaac Herzog	2021-07-07
laos	republique-parlementaire	2025	\N	t	Redistribution finale	Thongloun Sisoulith	2021-03-22
north-macedonia	republique-parlementaire	2025	\N	t	Redistribution finale	Stevo Pendarovski	2019-05-12
montenegro	republique-parlementaire	2025	\N	t	Redistribution finale	Jakov Milatović	2023-05-20
myanmar	republique-parlementaire	2025	\N	t	Redistribution finale	Min Aung Hlaing	2021-02-01
nepal	republique-parlementaire	2025	\N	t	Redistribution finale	Pushpa Kamal Dahal	2022-12-25
serbia	republique-parlementaire	2025	\N	t	Redistribution finale	Aleksandar Vučić	2017-05-31
\.


--
-- Data for Name: demographic; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.demographic (id, pays, population, tendances, indicateurs_sociaux, created_at, updated_at) FROM stdin;
demo-france	france	{"total": 67390000, "densite": 119, "croissance": 0.3}	{"urbanisation": 80, "vieillissement": "Élevé"}	{"taux_alphab": 99, "esperance_vie": 82.7}	2025-07-05 21:19:53.161222	2025-07-05 21:19:53.161222
demo-usa	usa	{"total": 331900000, "densite": 36, "croissance": 0.6}	{"urbanisation": 83, "vieillissement": "Moyen"}	{"taux_alphab": 99, "esperance_vie": 78.9}	2025-07-05 21:19:53.161222	2025-07-05 21:19:53.161222
demo-china	china	{"total": 1439000000, "densite": 153, "croissance": 0.4}	{"urbanisation": 61, "vieillissement": "Accéléré"}	{"taux_alphab": 96, "esperance_vie": 76.9}	2025-07-05 21:19:53.161222	2025-07-05 21:19:53.161222
demo-india	india	{"total": 1380000000, "densite": 464, "croissance": 1.1}	{"urbanisation": 35, "vieillissement": "Faible"}	{"taux_alphab": 74, "esperance_vie": 69.4}	2025-07-05 21:19:53.161222	2025-07-05 21:19:53.161222
\.


--
-- Data for Name: demographic_data; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.demographic_data (id, countryid, year, population, medianage, fertilityrate, lifeexpectancy, urbanizationrate, elderlypercentage, gdppercapita, hdiindex, literacyrate, datasource, description, statut, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: geographic_detail; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.geographic_detail (id, country_id, coastline_length, coastline_unit, terrain_types, climate_types, major_cities, natural_features) FROM stdin;
\.


--
-- Data for Name: global_demographic_trends; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.global_demographic_trends (id, trend_name, description, statistics, regional_differences, implications) FROM stdin;
\.


--
-- Data for Name: industry; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.industry (id, nom, categorie, description, productionmondiale, tendances, chaineapprovisionnement) FROM stdin;
automobile	Industrie automobile	Transport	Fabrication de véhicules automobiles	\N	\N	\N
aerospatial	Industrie aérospatiale	Transport	Fabrication d'avions et satellites	\N	\N	\N
pharmaceutique	Industrie pharmaceutique	Santé	Fabrication de médicaments	\N	\N	\N
informatique	Industrie informatique	Technologie	Fabrication d'ordinateurs et logiciels	\N	\N	\N
textile	Industrie textile	Consommation	Fabrication de vêtements et tissus	\N	\N	\N
agroalimentaire	Industrie agroalimentaire	Alimentation	Transformation des produits agricoles	\N	\N	\N
chimie	Industrie chimique	Matériaux	Fabrication de produits chimiques	\N	\N	\N
energie	Industrie énergétique	Énergie	Production et distribution d'énergie	\N	\N	\N
\.


--
-- Data for Name: industry_company; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.industry_company (industry_id, company_id, role) FROM stdin;
automobile	tesla	Leader véhicules électriques
automobile	toyota	Leader mondial
automobile	volkswagen	Leader européen
informatique	apple	Leader smartphones
informatique	samsung	Leader électronique
pharmaceutique	pfizer	Leader mondial
pharmaceutique	novartis	Leader européen
energie	shell	Major pétrolière
\.


--
-- Data for Name: industry_country; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.industry_country (countryid, industryid, role, valeurajoutee, unite, annee) FROM stdin;
usa	automobile	\N	\N	\N	\N
china	automobile	\N	\N	\N	\N
japan	automobile	\N	\N	\N	\N
germany	automobile	\N	\N	\N	\N
usa	informatique	\N	\N	\N	\N
china	informatique	\N	\N	\N	\N
usa	pharmaceutique	\N	\N	\N	\N
germany	pharmaceutique	\N	\N	\N	\N
\.


--
-- Data for Name: megacity; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.megacity (id, name, country_id, population, unit, year) FROM stdin;
1	Mexico City	mexico	22.1	millions	2024
2	São Paulo	brazil	22.0	millions	2024
3	New York	usa	20.1	millions	2024
4	Los Angeles	usa	18.7	millions	2024
5	Buenos Aires	argentina	15.6	millions	2024
6	Rio de Janeiro	brazil	13.5	millions	2024
7	Chicago	usa	12.8	millions	2024
8	Dallas-Fort Worth	usa	12.6	millions	2024
9	Houston	usa	12.4	millions	2024
10	Washington DC	usa	12.3	millions	2024
11	Miami	usa	12.1	millions	2024
12	Philadelphia	usa	12.0	millions	2024
13	Atlanta	usa	11.9	millions	2024
14	Phoenix	usa	11.8	millions	2024
15	Boston	usa	11.7	millions	2024
16	San Francisco	usa	11.6	millions	2024
17	Riverside	usa	11.5	millions	2024
18	Detroit	usa	11.4	millions	2024
19	Seattle	usa	11.3	millions	2024
20	Minneapolis	usa	11.2	millions	2024
21	San Diego	usa	11.1	millions	2024
22	Tampa	usa	11.0	millions	2024
58	Moscow	russia	12.6	millions	2024
59	Istanbul	turkey	16.3	millions	2024
60	London	uk	12.4	millions	2024
61	Paris	france	11.1	millions	2024
88	Tokyo	japan	37.4	millions	2024
89	Delhi	india	32.9	millions	2024
90	Shanghai	china	29.2	millions	2024
91	Mumbai	india	22.6	millions	2024
92	Beijing	china	21.8	millions	2024
93	Osaka	japan	19.2	millions	2024
94	Chongqing	china	16.9	millions	2024
96	Kolkata	india	15.7	millions	2024
97	Lagos	nigeria	15.4	millions	2024
98	Tianjin	china	14.6	millions	2024
99	Guangzhou	china	14.5	millions	2024
100	Shenzhen	china	14.2	millions	2024
101	Bangkok	thailand	14.1	millions	2024
102	Chennai	india	13.8	millions	2024
103	Hyderabad	india	13.5	millions	2024
104	Bangalore	india	12.9	millions	2024
105	Ho Chi Minh City	vietnam	12.8	millions	2024
106	Wuhan	china	12.7	millions	2024
107	Hangzhou	china	12.6	millions	2024
108	Chengdu	china	12.5	millions	2024
109	Xian	china	12.4	millions	2024
110	Ahmedabad	india	12.3	millions	2024
111	Hong Kong	china	12.1	millions	2024
112	Dongguan	china	12.0	millions	2024
113	Foshan	china	11.9	millions	2024
114	Nanjing	china	11.8	millions	2024
115	Suzhou	china	11.7	millions	2024
116	Xiamen	china	11.6	millions	2024
117	Zhengzhou	china	11.5	millions	2024
118	Qingdao	china	11.4	millions	2024
119	Kunming	china	11.3	millions	2024
120	Dalian	china	11.2	millions	2024
121	Jinan	china	11.1	millions	2024
122	Harbin	china	11.0	millions	2024
214	Cairo	egypt	21.3	millions	2024
216	Casablanca	morocco	11.9	millions	2024
217	Alexandria	egypt	11.7	millions	2024
218	Algiers	algeria	11.3	millions	2024
219	Kano	nigeria	11.1	millions	2024
220	Ibadan	nigeria	11.0	millions	2024
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.organization (id, nom, type, description, datecreation, siege) FROM stdin;
onu	Organisation des Nations Unies	Organisation internationale	Organisation internationale pour la paix et la sécurité	1945-10-24	New York, États-Unis
ue	Union européenne	Union politique et économique	Union politique et économique européenne	1993-11-01	Bruxelles, Belgique
g7	Groupe des Sept	Forum économique	Forum des sept pays les plus industrialisés	1975-01-01	Rotation annuelle
g20	Groupe des Vingt	Forum économique	Forum des vingt principales économies	1999-01-01	Rotation annuelle
org_african_union	Union Africaine (UA)	Organisation régionale	Organisation continentale regroupant 55 États membres africains, succédant à l'Organisation de l'unité africaine (OUA)	2002-07-09	Addis-Abeba, Éthiopie
org_asean	Association des nations de l'Asie du Sud-Est (ASEAN)	Organisation régionale	Organisation politique, économique et culturelle regroupant 10 pays d'Asie du Sud-Est	1967-08-08	Jakarta, Indonésie
org_wto	Organisation mondiale du commerce (OMC)	Organisation commerciale	Organisation internationale qui s'occupe des règles régissant le commerce entre les nations	1995-01-01	Genève, Suisse
org_oecd	Organisation de coopération et de développement économiques (OCDE)	Organisation économique	Organisation internationale d'études économiques, dont les pays membres ont en commun un système de gouvernement démocratique et une économie de marché	1961-09-30	Paris, France
org_imf	Fonds monétaire international (FMI)	Institution financière	Institution financière internationale qui veille à la stabilité du système monétaire international	1945-12-27	Washington, États-Unis
org_world_bank	Banque mondiale	Institution financière	Institution financière internationale qui accorde des prêts aux pays en développement	1944-07-22	Washington, États-Unis
org_nato	Organisation du Traité de l'Atlantique Nord (OTAN)	Alliance militaire	Alliance militaire intergouvernementale basée sur le Traité de l'Atlantique Nord	1949-04-04	Bruxelles, Belgique
org_csto	Organisation du Traité de sécurité collective (OTSC)	Alliance militaire	Alliance militaire eurasienne regroupant plusieurs pays de l'ex-URSS	2002-05-15	Moscou, Russie
org_commonwealth	Commonwealth des Nations	Organisation intergouvernementale	Association volontaire de 56 États souverains, la plupart étant d'anciens territoires de l'Empire britannique	1931-12-11	Londres, Royaume-Uni
org_francophonie	Organisation internationale de la Francophonie (OIF)	Organisation culturelle	Organisation internationale de pays francophones	1970-03-20	Paris, France
org_commonwealth_independent	Communauté des États indépendants (CEI)	Organisation régionale	Organisation régionale regroupant 9 des 15 anciennes républiques soviétiques	1991-12-21	Minsk, Biélorussie
org_icao	Organisation de l'aviation civile internationale (OACI)	Organisation spécialisée	Agence spécialisée de l'ONU qui établit les normes internationales de l'aviation civile	1947-04-04	Montréal, Canada
org_imo	Organisation maritime internationale (OMI)	Organisation spécialisée	Institution spécialisée de l'ONU chargée de la sécurité maritime et de la prévention de la pollution marine	1959-03-17	Londres, Royaume-Uni
org_who	Organisation mondiale de la santé (OMS)	Organisation spécialisée	Institution spécialisée de l'ONU pour la santé publique internationale	1948-04-07	Genève, Suisse
org_opec	Organisation des pays exportateurs de pétrole (OPEP)	Cartel pétrolier	Organisation intergouvernementale de pays producteurs de pétrole	1960-09-14	Vienne, Autriche
org_gas_exporting	Forum des pays exportateurs de gaz (FPEG)	Organisation gazière	Organisation intergouvernementale de pays exportateurs de gaz naturel	2001-05-23	Doha, Qatar
org_iso	Organisation internationale de normalisation (ISO)	Organisation de normalisation	Organisation internationale de normalisation composée d'organismes nationaux de normalisation	1947-02-23	Genève, Suisse
org_iea	Agence internationale de l'énergie (AIE)	Organisation énergétique	Organisation internationale chargée de coordonner les politiques énergétiques des pays membres	1974-11-15	Paris, France
org_irena	Agence internationale pour les énergies renouvelables (IRENA)	Organisation énergétique	Organisation intergouvernementale pour promouvoir l'adoption et l'utilisation durable des énergies renouvelables	2009-01-26	Abou Dabi, Émirats arabes unis
rel_accord_libre_echange_na	Accord de libre-échange nord-américain	Organisation commerciale	Zone de libre-échange entre Canada, États-Unis et Mexique	2025-07-10	Washington, États-Unis
rel_accord_etats_unis_mexique_canada	Accord États-Unis-Mexique-Canada	Organisation commerciale	Remplace l'ALENA, accord commercial trinational	2025-07-10	Washington, États-Unis
rel_conseil_cooperation_golfe	Conseil de coopération du Golfe	Organisation diplomatique	Organisation des États arabes du Golfe Persique	2025-07-10	Riyad, Arabie saoudite
rel_organisation_etats_americains	Organisation des États américains	Organisation diplomatique	Organisation panaméricaine	2025-07-10	Washington, États-Unis
rel_organisation_traite_securite_collective	Organisation du Traité de sécurité collective	Alliance militaire	Alliance militaire eurasienne	2025-07-10	Moscou, Russie
org_gulf_cooperation	Conseil de coopération du Golfe (CCG)	Organisation diplomatique	Organisation politique et économique des États arabes du Golfe Persique	1981-05-25	Riyad, Arabie saoudite
org_ecowas	Communauté économique des États de l'Afrique de l'Ouest (CEDEAO)	Organisation économique	Organisation régionale d'Afrique de l'Ouest	1975-05-28	Abuja, Nigeria
org_sadc	Communauté de développement d'Afrique australe (SADC)	Organisation économique	Organisation intergouvernementale d'Afrique australe	1992-08-17	Gaborone, Botswana
org_eac	Communauté d'Afrique de l'Est (CAE)	Union politique et économique	Organisation intergouvernementale d'Afrique de l'Est	2000-07-07	Arusha, Tanzanie
apec	Coopération économique Asie-Pacifique	Organisation économique	Forum de coopération économique Asie-Pacifique	1989-01-01	Singapour
org_afcfta	Zone de libre-échange continentale africaine (ZLECAf)	Organisation commerciale	Zone de libre-échange continentale africaine visant à créer un marché unique africain	2019-05-30	Kigali, Rwanda
org_mercosur	Mercosur	Union politique et économique	Marché commun du Sud, union douanière et zone de libre-échange en Amérique du Sud	1991-03-26	Montevideo, Uruguay
\.


--
-- Data for Name: political_regime; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.political_regime (id, name, description) FROM stdin;
republique-parlementaire	République parlementaire	Système où le chef de l'État est élu mais le pouvoir exécutif appartient au gouvernement responsable devant le parlement.
republique-presidentielle	République présidentielle	Système où le président est à la fois chef de l'État et chef du gouvernement.
monarchie-absolue	Monarchie absolue	Système où le monarque détient tous les pouvoirs sans limitation constitutionnelle.
regime-hybride	Régime hybride	Système combinant des éléments démocratiques et autoritaires.
theocratie	Théocratie	Système où le pouvoir politique est exercé au nom de la religion.
democratie-representative	Démocratie représentative	Système dans lequel les citoyens élisent des représentants qui prennent les décisions en leur nom.
monarchie-constitutionnelle	Monarchie constitutionnelle	Système dans lequel un monarque est le chef d'État, mais son pouvoir est limité par une constitution.
republique-federale	République fédérale	Système où le pouvoir est partagé entre un gouvernement central et des entités fédérées.
regime-autoritaire	Régime autoritaire	Système où le pouvoir politique est concentré et les libertés individuelles limitées.
democratie-directe	Démocratie directe	Système où les citoyens participent directement aux décisions politiques.
\.


--
-- Data for Name: political_transition; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.political_transition (id, from_regime_id, to_regime_id, country_id, year, description) FROM stdin;
\.


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.resource (id, nom, categorie, description, reservesmondiales, usages, impactenvironnemental, enjeuxgeopolitiques) FROM stdin;
petrole	Pétrole	Énergie fossile	Ressource énergétique principale	\N	\N	Élevé - émissions CO2	Contrôle des routes maritimes, dépendance énergétique
gaz-naturel	Gaz naturel	Énergie fossile	Ressource énergétique en croissance	\N	\N	Moyen - émissions CO2	Routes d'approvisionnement, diversification énergétique
uranium	Uranium	Énergie nucléaire	Ressource pour énergie nucléaire	\N	\N	Faible - déchets radioactifs	Prolifération nucléaire, sécurité
lithium	Lithium	Métal rare	Ressource pour batteries	\N	\N	Moyen - extraction minière	Transition énergétique, contrôle des chaînes d'approvisionnement
terres-rares	Terres rares	Métaux rares	Ressources pour technologies	\N	\N	Élevé - extraction polluante	Monopole chinois, technologies vertes
eau	Eau douce	Ressource vitale	Ressource essentielle à la vie	\N	\N	Faible - gestion durable	Conflits d'usage, changement climatique
poissons	Ressources halieutiques	Ressource alimentaire	Ressources marines pour alimentation	\N	\N	Moyen - surpêche	Zones économiques exclusives, surpêche
bois	Bois	Ressource renouvelable	Ressource forestière	\N	\N	Faible - gestion durable	Déforestation, puits de carbone
iron	Fer	Métal	Métal de base pour la sidérurgie, composant principal de l'acier	\N	\N	\N	\N
copper	Cuivre	Métal	Métal conducteur utilisé dans l'électricité, l'électronique et la construction	\N	\N	\N	\N
aluminium	Aluminium	Métal	Métal léger utilisé dans l'aéronautique, l'automobile et l'emballage	\N	\N	\N	\N
gold	Or	Métal précieux	Métal précieux utilisé pour la joaillerie, la réserve de valeur et l'industrie	\N	\N	\N	\N
silver	Argent	Métal précieux	Métal précieux utilisé en joaillerie, électronique et photographie	\N	\N	\N	\N
platinum	Platine	Métal précieux	Métal précieux utilisé dans les catalyseurs, la joaillerie et l'industrie	\N	\N	\N	\N
nickel	Nickel	Métal	Métal utilisé dans les alliages, batteries et aciers inoxydables	\N	\N	\N	\N
cobalt	Cobalt	Métal	Métal utilisé dans les batteries, alliages et pigments	\N	\N	\N	\N
manganese	Manganèse	Métal	Métal utilisé dans la production d'acier et de batteries	\N	\N	\N	\N
zinc	Zinc	Métal	Métal utilisé pour la galvanisation, alliages et batteries	\N	\N	\N	\N
lead	Plomb	Métal	Métal lourd utilisé dans les batteries, la protection contre les radiations	\N	\N	\N	\N
tin	Étain	Métal	Métal utilisé dans les alliages, soudures et emballages	\N	\N	\N	\N
bauxite	Bauxite	Minerai	Minerai principal pour la production d'aluminium	\N	\N	\N	\N
coal	Charbon	Énergie	Roche combustible fossile, utilisée principalement pour la production d'électricité et la sidérurgie	\N	\N	\N	\N
phosphate	Phosphate	Minéral	Minéral utilisé principalement pour la fabrication d'engrais	\N	\N	\N	\N
potash	Potasse	Minéral	Minéral utilisé comme engrais potassique	\N	\N	\N	\N
diamonds	Diamants	Pierre précieuse	Pierre précieuse utilisée en joaillerie et pour des usages industriels	\N	\N	\N	\N
graphite	Graphite	Minéral	Minéral utilisé dans les batteries, réfractaires et lubrifiants	\N	\N	\N	\N
salt	Sel	Minéral	Minéral utilisé pour l'alimentation, l'industrie et le traitement de l'eau	\N	\N	\N	\N
wheat	Blé	Agricole	Céréale de base pour l'alimentation humaine et animale	\N	\N	\N	\N
corn	Maïs	Agricole	Céréale utilisée pour l'alimentation, l'éthanol et l'industrie	\N	\N	\N	\N
rice	Riz	Agricole	Céréale de base pour l'alimentation de plus de la moitié de la population mondiale	\N	\N	\N	\N
soy	Soja	Agricole	Légumineuse utilisée pour l'huile, l'alimentation animale et humaine	\N	\N	\N	\N
cotton	Coton	Agricole	Fibre végétale utilisée dans l'industrie textile	\N	\N	\N	\N
coffee	Café	Agricole	Grain utilisé pour la boisson la plus consommée au monde après l'eau	\N	\N	\N	\N
cocoa	Cacao	Agricole	Grain utilisé pour la fabrication du chocolat	\N	\N	\N	\N
sugar	Sucre	Agricole	Produit issu de la canne à sucre ou de la betterave	\N	\N	\N	\N
tea	Thé	Agricole	Feuille utilisée pour la boisson la plus consommée au monde après l'eau et le café	\N	\N	\N	\N
tobacco	Tabac	Agricole	Plante utilisée pour la fabrication de cigarettes et autres produits	\N	\N	\N	\N
rubber	Caoutchouc	Agricole	Produit naturel ou synthétique utilisé dans l'industrie automobile et divers produits	\N	\N	\N	\N
palm_oil	Huile de palme	Agricole	Huile végétale utilisée dans l'alimentation et l'industrie	\N	\N	\N	\N
olive_oil	Huile d'olive	Agricole	Huile végétale utilisée dans l'alimentation	\N	\N	\N	\N
wine	Vin	Agricole	Boisson alcoolisée issue de la fermentation du raisin	\N	\N	\N	\N
wool	Laine	Agricole	Fibre animale utilisée dans le textile	\N	\N	\N	\N
honey	Miel	Agricole	Produit naturel issu des abeilles	\N	\N	\N	\N
flowers	Fleurs	Agricole	Produit horticole pour l'ornement et l'industrie	\N	\N	\N	\N
spices	Épices	Agricole	Produits végétaux utilisés pour l'assaisonnement et la conservation des aliments	\N	\N	\N	\N
\.


--
-- Data for Name: resource_country; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.resource_country (countryid, resourceid, role, quantite, unite) FROM stdin;
saudi-arabia	petrole	Producteur majeur	10100000	barils/jour
russia	petrole	Producteur majeur	9500000	barils/jour
usa	petrole	Producteur majeur	12000000	barils/jour
iran	petrole	Producteur	4000000	barils/jour
iraq	petrole	Producteur	4200000	barils/jour
venezuela	petrole	Producteur	2500000	barils/jour
canada	petrole	Producteur	4500000	barils/jour
china	petrole	Producteur	3800000	barils/jour
brazil	petrole	Producteur	3000000	barils/jour
norway	petrole	Producteur	2000000	barils/jour
usa	gaz-naturel	Producteur majeur	950000000	m3/jour
russia	gaz-naturel	Producteur majeur	700000000	m3/jour
iran	gaz-naturel	Producteur	250000000	m3/jour
qatar	gaz-naturel	Producteur	180000000	m3/jour
china	gaz-naturel	Producteur	150000000	m3/jour
canada	gaz-naturel	Producteur	170000000	m3/jour
norway	gaz-naturel	Producteur	120000000	m3/jour
algeria	gaz-naturel	Producteur	100000000	m3/jour
kazakhstan	uranium	Producteur majeur	19000	tonnes/an
canada	uranium	Producteur	7000	tonnes/an
australia	uranium	Producteur	6000	tonnes/an
namibia	uranium	Producteur	5500	tonnes/an
niger	uranium	Producteur	2000	tonnes/an
russia	uranium	Producteur	3000	tonnes/an
australia	lithium	Producteur majeur	55000	tonnes/an
chile	lithium	Producteur majeur	40000	tonnes/an
china	lithium	Producteur	20000	tonnes/an
argentina	lithium	Producteur	6000	tonnes/an
china	gold	Producteur majeur	370	tonnes/an
australia	gold	Producteur	330	tonnes/an
russia	gold	Producteur	300	tonnes/an
usa	gold	Producteur	200	tonnes/an
canada	gold	Producteur	180	tonnes/an
ghana	gold	Producteur	130	tonnes/an
south-africa	gold	Producteur	100	tonnes/an
chile	copper	Producteur majeur	5700000	tonnes/an
peru	copper	Producteur	2500000	tonnes/an
china	copper	Producteur	1700000	tonnes/an
usa	copper	Producteur	1200000	tonnes/an
congo	copper	Producteur	1300000	tonnes/an
australia	copper	Producteur	900000	tonnes/an
china	wheat	Producteur majeur	135000000	tonnes/an
india	wheat	Producteur	107000000	tonnes/an
russia	wheat	Producteur	85000000	tonnes/an
usa	wheat	Producteur	50000000	tonnes/an
france	wheat	Producteur	35000000	tonnes/an
canada	wheat	Producteur	32000000	tonnes/an
pakistan	wheat	Producteur	25000000	tonnes/an
ukraine	wheat	Producteur	24000000	tonnes/an
australia	wheat	Producteur	22000000	tonnes/an
china	coal	Producteur majeur	4000000000	tonnes/an
india	coal	Producteur	800000000	tonnes/an
usa	coal	Producteur	600000000	tonnes/an
australia	coal	Producteur	500000000	tonnes/an
russia	coal	Producteur	400000000	tonnes/an
south-africa	coal	Producteur	250000000	tonnes/an
germany	coal	Producteur	120000000	tonnes/an
poland	coal	Producteur	100000000	tonnes/an
australia	iron	Producteur majeur	900000000	tonnes/an
brazil	iron	Producteur	400000000	tonnes/an
china	iron	Producteur	350000000	tonnes/an
india	iron	Producteur	200000000	tonnes/an
russia	iron	Producteur	100000000	tonnes/an
south-africa	iron	Producteur	70000000	tonnes/an
ukraine	iron	Producteur	60000000	tonnes/an
canada	iron	Producteur	50000000	tonnes/an
china	aluminium	Producteur majeur	36000000	tonnes/an
russia	aluminium	Producteur	3600000	tonnes/an
canada	aluminium	Producteur	3200000	tonnes/an
india	aluminium	Producteur	3700000	tonnes/an
uae	aluminium	Producteur	2600000	tonnes/an
australia	aluminium	Producteur	1600000	tonnes/an
norway	aluminium	Producteur	1400000	tonnes/an
bahrain	aluminium	Producteur	1500000	tonnes/an
indonesia	nickel	Producteur majeur	1000000	tonnes/an
philippines	nickel	Producteur	420000	tonnes/an
russia	nickel	Producteur	250000	tonnes/an
new-caledonia	nickel	Producteur	200000	tonnes/an
australia	nickel	Producteur	180000	tonnes/an
canada	nickel	Producteur	160000	tonnes/an
china	nickel	Producteur	120000	tonnes/an
brazil	nickel	Producteur	100000	tonnes/an
congo	cobalt	Producteur majeur	95000	tonnes/an
russia	cobalt	Producteur	7600	tonnes/an
australia	cobalt	Producteur	5600	tonnes/an
philippines	cobalt	Producteur	4500	tonnes/an
cuba	cobalt	Producteur	3500	tonnes/an
madagascar	cobalt	Producteur	3300	tonnes/an
papua-new-guinea	cobalt	Producteur	3100	tonnes/an
canada	cobalt	Producteur	3000	tonnes/an
\.


--
-- Data for Name: resource_trade_route; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.resource_trade_route (resource_id, trade_route_id, volume) FROM stdin;
petrole	route-hormuz	{"volume": "21 millions b/j"}
gaz-naturel	route-hormuz	{"volume": "LNG important"}
petrole	route-malacca	{"volume": "15 millions b/j"}
petrole	route-suez	{"volume": "5 millions b/j"}
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: technology_country_leadership; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.technology_country_leadership (id, subsectorid, countryid, strengths, companies, description, statut, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: technology_sector; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.technology_sector (id, name, description, globalmarketvalue, globalmarketunit, globalmarketyear, cagr, statut, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: technology_subsector; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.technology_subsector (id, sectorid, name, description, status, applications, geopoliticalissues, statut, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: tourism_data; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.tourism_data (id, countryid, annualvisitors, visitorsyear, majorattractions, economicimpact, economicimpactunit, description, statut, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: trade_route; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.trade_route (id, nom, type, endpoints, volume, biens_transportes, chokepoints, ports, geojsonref, created_at, updated_at) FROM stdin;
route-suez	Route de Suez	Maritime	{"depart": "Méditerranée", "arrivee": "Océan Indien"}	{"volume": "12% du commerce mondial"}	["Pétrole", "Conteneurs", "Céréales"]	\N	\N	trade-routes.geo.json#Suez	2025-07-05 21:19:53.152645	2025-07-05 21:19:53.152645
route-malacca	Détroit de Malacca	Maritime	{"depart": "Océan Indien", "arrivee": "Pacifique"}	{"volume": "25% du commerce mondial"}	["Pétrole", "Conteneurs", "Matières premières"]	\N	\N	trade-routes.geo.json#Malacca	2025-07-05 21:19:53.152645	2025-07-05 21:19:53.152645
route-hormuz	Détroit d'Ormuz	Maritime	{"depart": "Golfe Persique", "arrivee": "Océan Indien"}	{"volume": "21% du pétrole mondial"}	["Pétrole", "Gaz naturel"]	\N	\N	trade-routes.geo.json#Hormuz	2025-07-05 21:19:53.152645	2025-07-05 21:19:53.152645
route-panama	Canal de Panama	Maritime	{"depart": "Atlantique", "arrivee": "Pacifique"}	{"volume": "5% du commerce mondial"}	["Conteneurs", "Céréales", "Produits manufacturés"]	\N	\N	trade-routes.geo.json#Panama	2025-07-05 21:19:53.152645	2025-07-05 21:19:53.152645
\.


--
-- Data for Name: trade_route_country; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.trade_route_country (traderouteid, countryid, role) FROM stdin;
\.


--
-- Data for Name: transport_data; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.transport_data (id, countryid, transporttype, volumevalue, volumeunit, volumeyear, routes, infrastructuredata, description, statut, created_at, updated_at) FROM stdin;
\.


--
-- Name: agricultural_export_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.agricultural_export_id_seq', 22, true);


--
-- Name: agricultural_import_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.agricultural_import_id_seq', 1, false);


--
-- Name: armed_conflict_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.armed_conflict_id_seq', 10, true);


--
-- Name: country_agricultural_production_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.country_agricultural_production_id_seq', 40, true);


--
-- Name: demographic_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.demographic_data_id_seq', 1, false);


--
-- Name: geographic_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.geographic_detail_id_seq', 1, false);


--
-- Name: global_demographic_trends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.global_demographic_trends_id_seq', 1, false);


--
-- Name: megacity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.megacity_id_seq', 224, true);


--
-- Name: political_transition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.political_transition_id_seq', 1, false);


--
-- Name: technology_country_leadership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.technology_country_leadership_id_seq', 1, false);


--
-- Name: tourism_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.tourism_data_id_seq', 1, false);


--
-- Name: transport_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.transport_data_id_seq', 1, false);


--
-- Name: agricultural_export agricultural_export_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_export
    ADD CONSTRAINT agricultural_export_pkey PRIMARY KEY (id);


--
-- Name: agricultural_import agricultural_import_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_import
    ADD CONSTRAINT agricultural_import_pkey PRIMARY KEY (id);


--
-- Name: agricultural_product agricultural_product_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_product
    ADD CONSTRAINT agricultural_product_pkey PRIMARY KEY (id);


--
-- Name: armed_conflict armed_conflict_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.armed_conflict
    ADD CONSTRAINT armed_conflict_pkey PRIMARY KEY (id);


--
-- Name: comm_network_country comm_network_country_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.comm_network_country
    ADD CONSTRAINT comm_network_country_pkey PRIMARY KEY (commnetworkid, countryid);


--
-- Name: comm_network comm_network_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.comm_network
    ADD CONSTRAINT comm_network_pkey PRIMARY KEY (id);


--
-- Name: company company_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


--
-- Name: conflict conflict_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.conflict
    ADD CONSTRAINT conflict_pkey PRIMARY KEY (id);


--
-- Name: conflict_resource conflict_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.conflict_resource
    ADD CONSTRAINT conflict_resource_pkey PRIMARY KEY (conflict_id, resource_id);


--
-- Name: conflict_trade_route conflict_trade_route_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.conflict_trade_route
    ADD CONSTRAINT conflict_trade_route_pkey PRIMARY KEY (conflict_id, trade_route_id);


--
-- Name: country_agricultural_production country_agricultural_production_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_agricultural_production
    ADD CONSTRAINT country_agricultural_production_pkey PRIMARY KEY (id);


--
-- Name: conflict_country country_conflict_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.conflict_country
    ADD CONSTRAINT country_conflict_pkey PRIMARY KEY (countryid, conflictid);


--
-- Name: industry_country country_industry_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.industry_country
    ADD CONSTRAINT country_industry_pkey PRIMARY KEY (countryid, industryid);


--
-- Name: country_organization country_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_organization
    ADD CONSTRAINT country_organization_pkey PRIMARY KEY (countryid, organizationid);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: country_political_regime country_political_regime_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_political_regime
    ADD CONSTRAINT country_political_regime_pkey PRIMARY KEY (country_id, regime_id, start_year);


--
-- Name: resource_country country_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.resource_country
    ADD CONSTRAINT country_resource_pkey PRIMARY KEY (countryid, resourceid);


--
-- Name: demographic_data demographic_data_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.demographic_data
    ADD CONSTRAINT demographic_data_pkey PRIMARY KEY (id);


--
-- Name: demographic demographic_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.demographic
    ADD CONSTRAINT demographic_pkey PRIMARY KEY (id);


--
-- Name: geographic_detail geographic_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.geographic_detail
    ADD CONSTRAINT geographic_detail_pkey PRIMARY KEY (id);


--
-- Name: global_demographic_trends global_demographic_trends_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.global_demographic_trends
    ADD CONSTRAINT global_demographic_trends_pkey PRIMARY KEY (id);


--
-- Name: industry_company industry_company_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.industry_company
    ADD CONSTRAINT industry_company_pkey PRIMARY KEY (industry_id, company_id);


--
-- Name: industry industry_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.industry
    ADD CONSTRAINT industry_pkey PRIMARY KEY (id);


--
-- Name: megacity megacity_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.megacity
    ADD CONSTRAINT megacity_pkey PRIMARY KEY (id);


--
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: political_regime political_regime_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.political_regime
    ADD CONSTRAINT political_regime_pkey PRIMARY KEY (id);


--
-- Name: political_transition political_transition_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.political_transition
    ADD CONSTRAINT political_transition_pkey PRIMARY KEY (id);


--
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- Name: resource_trade_route resource_trade_route_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.resource_trade_route
    ADD CONSTRAINT resource_trade_route_pkey PRIMARY KEY (resource_id, trade_route_id);


--
-- Name: technology_country_leadership technology_country_leadership_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.technology_country_leadership
    ADD CONSTRAINT technology_country_leadership_pkey PRIMARY KEY (id);


--
-- Name: technology_sector technology_sector_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.technology_sector
    ADD CONSTRAINT technology_sector_pkey PRIMARY KEY (id);


--
-- Name: technology_subsector technology_subsector_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.technology_subsector
    ADD CONSTRAINT technology_subsector_pkey PRIMARY KEY (id);


--
-- Name: tourism_data tourism_data_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.tourism_data
    ADD CONSTRAINT tourism_data_pkey PRIMARY KEY (id);


--
-- Name: trade_route_country trade_route_country_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.trade_route_country
    ADD CONSTRAINT trade_route_country_pkey PRIMARY KEY (traderouteid, countryid);


--
-- Name: trade_route trade_route_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.trade_route
    ADD CONSTRAINT trade_route_pkey PRIMARY KEY (id);


--
-- Name: transport_data transport_data_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.transport_data
    ADD CONSTRAINT transport_data_pkey PRIMARY KEY (id);


--
-- Name: idx_agricultural_production_country_product; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_agricultural_production_country_product ON public.country_agricultural_production USING btree (countryid, productid);


--
-- Name: idx_conflict_countries; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_conflict_countries ON public.armed_conflict USING gin (involvedcountries);


--
-- Name: idx_conflict_location; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_conflict_location ON public.conflict USING gist (localisation);


--
-- Name: idx_country_coordinates; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_country_coordinates ON public.country USING gist (coordonnees);


--
-- Name: idx_demographic_data_country_year; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_demographic_data_country_year ON public.demographic_data USING btree (countryid, year);


--
-- Name: idx_industry_country; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_industry_country ON public.industry_country USING btree (countryid);


--
-- Name: idx_technology_leadership_country; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_technology_leadership_country ON public.technology_country_leadership USING btree (countryid);


--
-- Name: company update_company_updated_at; Type: TRIGGER; Schema: public; Owner: wikigeo_user
--

CREATE TRIGGER update_company_updated_at BEFORE UPDATE ON public.company FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: conflict update_conflict_updated_at; Type: TRIGGER; Schema: public; Owner: wikigeo_user
--

CREATE TRIGGER update_conflict_updated_at BEFORE UPDATE ON public.conflict FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: country update_country_updated_at; Type: TRIGGER; Schema: public; Owner: wikigeo_user
--

CREATE TRIGGER update_country_updated_at BEFORE UPDATE ON public.country FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: demographic update_demographic_updated_at; Type: TRIGGER; Schema: public; Owner: wikigeo_user
--

CREATE TRIGGER update_demographic_updated_at BEFORE UPDATE ON public.demographic FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: industry update_industry_updated_at; Type: TRIGGER; Schema: public; Owner: wikigeo_user
--

CREATE TRIGGER update_industry_updated_at BEFORE UPDATE ON public.industry FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: resource update_resource_updated_at; Type: TRIGGER; Schema: public; Owner: wikigeo_user
--

CREATE TRIGGER update_resource_updated_at BEFORE UPDATE ON public.resource FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: trade_route update_trade_route_updated_at; Type: TRIGGER; Schema: public; Owner: wikigeo_user
--

CREATE TRIGGER update_trade_route_updated_at BEFORE UPDATE ON public.trade_route FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: agricultural_export agricultural_export_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_export
    ADD CONSTRAINT agricultural_export_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id);


--
-- Name: agricultural_export agricultural_export_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_export
    ADD CONSTRAINT agricultural_export_product_id_fkey FOREIGN KEY (productid) REFERENCES public.agricultural_product(id);


--
-- Name: agricultural_import agricultural_import_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_import
    ADD CONSTRAINT agricultural_import_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id);


--
-- Name: agricultural_import agricultural_import_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_import
    ADD CONSTRAINT agricultural_import_product_id_fkey FOREIGN KEY (productid) REFERENCES public.agricultural_product(id);


--
-- Name: comm_network_country comm_network_country_commnetworkid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.comm_network_country
    ADD CONSTRAINT comm_network_country_commnetworkid_fkey FOREIGN KEY (commnetworkid) REFERENCES public.comm_network(id) ON DELETE CASCADE;


--
-- Name: comm_network_country comm_network_country_countryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.comm_network_country
    ADD CONSTRAINT comm_network_country_countryid_fkey FOREIGN KEY (countryid) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: company company_pays_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pays_fkey FOREIGN KEY (pays) REFERENCES public.country(id);


--
-- Name: conflict_resource conflict_resource_conflict_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.conflict_resource
    ADD CONSTRAINT conflict_resource_conflict_id_fkey FOREIGN KEY (conflict_id) REFERENCES public.conflict(id) ON DELETE CASCADE;


--
-- Name: conflict_resource conflict_resource_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.conflict_resource
    ADD CONSTRAINT conflict_resource_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON DELETE CASCADE;


--
-- Name: conflict_trade_route conflict_trade_route_conflict_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.conflict_trade_route
    ADD CONSTRAINT conflict_trade_route_conflict_id_fkey FOREIGN KEY (conflict_id) REFERENCES public.conflict(id) ON DELETE CASCADE;


--
-- Name: conflict_trade_route conflict_trade_route_trade_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.conflict_trade_route
    ADD CONSTRAINT conflict_trade_route_trade_route_id_fkey FOREIGN KEY (trade_route_id) REFERENCES public.trade_route(id) ON DELETE CASCADE;


--
-- Name: country_agricultural_production country_agricultural_production_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_agricultural_production
    ADD CONSTRAINT country_agricultural_production_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id);


--
-- Name: country_agricultural_production country_agricultural_production_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_agricultural_production
    ADD CONSTRAINT country_agricultural_production_product_id_fkey FOREIGN KEY (productid) REFERENCES public.agricultural_product(id);


--
-- Name: conflict_country country_conflict_conflict_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.conflict_country
    ADD CONSTRAINT country_conflict_conflict_id_fkey FOREIGN KEY (conflictid) REFERENCES public.conflict(id) ON DELETE CASCADE;


--
-- Name: conflict_country country_conflict_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.conflict_country
    ADD CONSTRAINT country_conflict_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: industry_country country_industry_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.industry_country
    ADD CONSTRAINT country_industry_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: industry_country country_industry_industry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.industry_country
    ADD CONSTRAINT country_industry_industry_id_fkey FOREIGN KEY (industryid) REFERENCES public.industry(id) ON DELETE CASCADE;


--
-- Name: country_organization country_organization_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_organization
    ADD CONSTRAINT country_organization_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: country_organization country_organization_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_organization
    ADD CONSTRAINT country_organization_organization_id_fkey FOREIGN KEY (organizationid) REFERENCES public.organization(id) ON DELETE CASCADE;


--
-- Name: country_political_regime country_political_regime_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_political_regime
    ADD CONSTRAINT country_political_regime_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: country_political_regime country_political_regime_regime_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_political_regime
    ADD CONSTRAINT country_political_regime_regime_id_fkey FOREIGN KEY (regime_id) REFERENCES public.political_regime(id) ON DELETE CASCADE;


--
-- Name: resource_country country_resource_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.resource_country
    ADD CONSTRAINT country_resource_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: resource_country country_resource_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.resource_country
    ADD CONSTRAINT country_resource_resource_id_fkey FOREIGN KEY (resourceid) REFERENCES public.resource(id) ON DELETE CASCADE;


--
-- Name: demographic_data demographic_data_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.demographic_data
    ADD CONSTRAINT demographic_data_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id);


--
-- Name: demographic demographic_pays_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.demographic
    ADD CONSTRAINT demographic_pays_fkey FOREIGN KEY (pays) REFERENCES public.country(id);


--
-- Name: geographic_detail geographic_detail_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.geographic_detail
    ADD CONSTRAINT geographic_detail_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- Name: industry_company industry_company_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.industry_company
    ADD CONSTRAINT industry_company_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.company(id) ON DELETE CASCADE;


--
-- Name: industry_company industry_company_industry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.industry_company
    ADD CONSTRAINT industry_company_industry_id_fkey FOREIGN KEY (industry_id) REFERENCES public.industry(id) ON DELETE CASCADE;


--
-- Name: megacity megacity_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.megacity
    ADD CONSTRAINT megacity_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- Name: political_transition political_transition_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.political_transition
    ADD CONSTRAINT political_transition_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- Name: political_transition political_transition_from_regime_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.political_transition
    ADD CONSTRAINT political_transition_from_regime_id_fkey FOREIGN KEY (from_regime_id) REFERENCES public.political_regime(id);


--
-- Name: political_transition political_transition_to_regime_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.political_transition
    ADD CONSTRAINT political_transition_to_regime_id_fkey FOREIGN KEY (to_regime_id) REFERENCES public.political_regime(id);


--
-- Name: resource_trade_route resource_trade_route_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.resource_trade_route
    ADD CONSTRAINT resource_trade_route_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON DELETE CASCADE;


--
-- Name: resource_trade_route resource_trade_route_trade_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.resource_trade_route
    ADD CONSTRAINT resource_trade_route_trade_route_id_fkey FOREIGN KEY (trade_route_id) REFERENCES public.trade_route(id) ON DELETE CASCADE;


--
-- Name: technology_country_leadership technology_country_leadership_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.technology_country_leadership
    ADD CONSTRAINT technology_country_leadership_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id);


--
-- Name: technology_country_leadership technology_country_leadership_subsector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.technology_country_leadership
    ADD CONSTRAINT technology_country_leadership_subsector_id_fkey FOREIGN KEY (subsectorid) REFERENCES public.technology_subsector(id);


--
-- Name: technology_subsector technology_subsector_sector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.technology_subsector
    ADD CONSTRAINT technology_subsector_sector_id_fkey FOREIGN KEY (sectorid) REFERENCES public.technology_sector(id);


--
-- Name: tourism_data tourism_data_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.tourism_data
    ADD CONSTRAINT tourism_data_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id);


--
-- Name: trade_route_country trade_route_country_countryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.trade_route_country
    ADD CONSTRAINT trade_route_country_countryid_fkey FOREIGN KEY (countryid) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: trade_route_country trade_route_country_traderouteid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.trade_route_country
    ADD CONSTRAINT trade_route_country_traderouteid_fkey FOREIGN KEY (traderouteid) REFERENCES public.trade_route(id) ON DELETE CASCADE;


--
-- Name: transport_data transport_data_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.transport_data
    ADD CONSTRAINT transport_data_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id);


--
-- PostgreSQL database dump complete
--

