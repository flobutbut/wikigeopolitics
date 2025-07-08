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
    regimepolitique character varying(50),
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
-- Name: country_natural_resource; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.country_natural_resource (
    id integer NOT NULL,
    country_id character varying(10),
    resource_id character varying(50),
    abundance_level character varying(50),
    locations jsonb,
    production_value numeric(12,2),
    production_unit character varying(20),
    production_year integer
);


ALTER TABLE public.country_natural_resource OWNER TO wikigeo_user;

--
-- Name: country_natural_resource_id_seq; Type: SEQUENCE; Schema: public; Owner: wikigeo_user
--

CREATE SEQUENCE public.country_natural_resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.country_natural_resource_id_seq OWNER TO wikigeo_user;

--
-- Name: country_natural_resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wikigeo_user
--

ALTER SEQUENCE public.country_natural_resource_id_seq OWNED BY public.country_natural_resource.id;


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
    notes text
);


ALTER TABLE public.country_political_regime OWNER TO wikigeo_user;

--
-- Name: country_relation; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.country_relation (
    countryid character varying(50) NOT NULL,
    relationid character varying(50) NOT NULL,
    statut character varying(100),
    dateadhesion date,
    datesortie date
);


ALTER TABLE public.country_relation OWNER TO wikigeo_user;

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
-- Name: natural_resource; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.natural_resource (
    id character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50),
    description text,
    global_reserves_value numeric(12,2),
    global_reserves_unit character varying(20),
    global_reserves_year integer
);


ALTER TABLE public.natural_resource OWNER TO wikigeo_user;

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
-- Name: organization_relation; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.organization_relation (
    organization_id character varying(50) NOT NULL,
    relation_id character varying(50) NOT NULL,
    role character varying(100)
);


ALTER TABLE public.organization_relation OWNER TO wikigeo_user;

--
-- Name: political_regime; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.political_regime (
    id character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    characteristics jsonb,
    examples jsonb
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
-- Name: relation; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.relation (
    id character varying(50) NOT NULL,
    type character varying(100) NOT NULL,
    description text,
    datedebut date,
    datefin date,
    statut character varying(100),
    nom character varying(255)
);


ALTER TABLE public.relation OWNER TO wikigeo_user;

--
-- Name: TABLE relation; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.relation IS 'Relations internationales entre pays (alliances, conflits, accords)';


--
-- Name: relation_country; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.relation_country (
    relationid character varying(50) NOT NULL,
    countryid character varying(50) NOT NULL,
    statut character varying(100),
    dateadhesion date,
    datesortie date
);


ALTER TABLE public.relation_country OWNER TO wikigeo_user;

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
-- Name: country_natural_resource id; Type: DEFAULT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_natural_resource ALTER COLUMN id SET DEFAULT nextval('public.country_natural_resource_id_seq'::regclass);


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

COPY public.country (id, nom, drapeau, capitale, langue, monnaie, continent, sections, indicateurs, politique, economie, demographie, frontieres, coordonnees, pib, population, revenumedian, superficiekm2, indicesouverainete, indicedependance, statutstrategique, datecreation, datedernieremiseajour, histoire, regimepolitique, appartenancegeographique) FROM stdin;
turkey	Turquie	🇹🇷	Ankara	Turc	Livre turque (TRY)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008041400000000000804340	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
eritrea	Érythrée	🇪🇷	Asmara	Tigrinya	Nakfa (ERN)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008043400000000000002E40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
netherlands	Pays-Bas	🇳🇱	Amsterdam	Néerlandais	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000016400000000000004A40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
sri-lanka	Sri Lanka	🇱🇰	Colombo	Cingalais, Tamoul	Roupie srilankaise (LKR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000004054400000000000001C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
poland	Pologne	🇵🇱	Varsovie	Polonais	Zloty (PLN)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000033400000000000004A40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
afghanistan	Afghanistan	🇦🇫	Kaboul	Pachto, Dari	Afghani (AFN)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000004050400000000000804040	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
pakistan	Pakistan	🇵🇰	Islamabad	Ourdou, Anglais	Roupie pakistanaise (PKR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008051400000000000003E40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
bangladesh	Bangladesh	🇧🇩	Dhaka	Bengali	Taka (BDT)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008056400000000000003840	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
bolivia	Bolivie	🇧🇴	La Paz	Espagnol	Boliviano (BOB)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E610000000000000004050C000000000000031C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
ethiopia	Éthiopie	🇪🇹	Addis-Abeba	Amharique	Birr (ETB)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000044400000000000002240	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
nigeria	Nigeria	🇳🇬	Abuja	Anglais	Naira (NGN)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000020400000000000002440	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
botswana	Botswana	🇧🇼	Gaborone	Anglais, Tswana	Pula (BWP)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000000000000000384000000000000036C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
north-korea	Corée du Nord	🇰🇵	Pyongyang	Coréen	Won nord-coréen	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000226C787AA5E05F4088F4DBD7812B4440	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
australia	Australie	🇦🇺	Canberra	Anglais	Dollar australien	Océanie	\N	\N	\N	\N	\N	\N	0101000020E610000026E4839ECDB86040BC0512143F4639C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
usa	États-Unis	🇺🇸	Washington D.C.	Anglais	Dollar américain	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000061545227A0ED57C0B30C71AC8B8B4240	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
burkina-faso	Burkina Faso	🇧🇫	Ouagadougou	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000000C00000000000002840	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
cuba	Cuba	🇨🇺	La Havane	Espagnol	Peso cubain (CUP)	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000054C00000000000803540	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
iraq	Irak	🇮🇶	Bagdad	Arabe	Dinar irakien (IQD)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000046400000000000804040	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
kazakhstan	Kazakhstan	🇰🇿	Nour-Soultan	Kazakh, Russe	Tenge (KZT)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000051400000000000004840	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
tonga	Tonga	🇹🇴	Nuku'alofa	Anglais, Tongan	Pa'anga	Océanie	\N	\N	\N	\N	\N	\N	0101000020E610000027C286A757E665C0E7FBA9F1D22D35C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
tuvalu	Tuvalu	🇹🇻	Funafuti	Tuvaluan, Anglais	Dollar tuvaluan	Océanie	\N	\N	\N	\N	\N	\N	0101000020E61000007D3F355EBA436640E3A59BC420701CC0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
vanuatu	Vanuatu	🇻🇺	Port-Vila	Bichelamar, Anglais, Français	Vatu	Océanie	\N	\N	\N	\N	\N	\N	0101000020E610000009F9A067B3DE644070CE88D2DEC02EC0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
ukraine	Ukraine	🇺🇦	Kiev	Ukrainien	Hryvnia (UAH)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000040400000000000804840	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
uganda	Ouganda	🇺🇬	Kampala	Anglais	Shilling ougandais (UGX)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000004040000000000000F03F	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
uzbekistan	Ouzbékistan	🇺🇿	Tachkent	Ouzbek	Sum (UZS)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000050400000000000804440	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
rwanda	Rwanda	🇷🇼	Kigali	Kinyarwanda, Français, Anglais	Franc rwandais (RWF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003E4000000000000000C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
somalia	Somalie	🇸🇴	Mogadiscio	Somali, Arabe	Shilling somalien (SOS)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008048400000000000002440	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
south-sudan	Soudan du Sud	🇸🇸	Djouba	Anglais	Livre sud-soudanaise (SSP)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003E400000000000001C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
vietnam	Vietnam	🇻🇳	Hanoï	Vietnamien	Dong (VND)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000005B400000000000003040	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
barbados	Barbade	🇧🇧	Bridgetown	Anglais	Dollar barbadien	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000BBB88D06F0CE4DC052B81E85EB312A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
kiribati	Kiribati	🇰🇮	Tarawa	Gilbertese, Anglais	Dollar australien	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000C1A8A44E40B565407E1D38674469F53F	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
denmark	Danemark	🇩🇰	Copenhague	Danois	Couronne danoise (DKK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000034A2B437F8222940AD69DE718AD64B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
ivory-coast	Côte d'Ivoire	🇨🇮	Yamoussoukro	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000007A36AB3E571B15C0ACADD85F764F1B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
spain	Espagne	🇪🇸	Madrid	Espagnol	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000003C4ED1915CFE0DC0857CD0B359354440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
finland	Finlande	🇫🇮	Helsinki	Finnois, Suédois	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000917EFB3AF0384092CB7F48BF154E40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
greece	Grèce	🇬🇷	Athènes	Grec	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000000AD7A3703DBA374004E78C28EDFD4240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
tanzania	Tanzanie	🇹🇿	Dodoma	Swahili, Anglais	Shilling tanzanien (TZS)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000736891ED7CDF4140F4FDD478E9A618C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
sudan	Soudan	🇸🇩	Khartoum	Arabe, Anglais	Livre soudanaise (SDG)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000E4839ECDAA474040E3361AC05B002F40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
angola	Angola	🇦🇴	Luanda	Portugais	Kwanza (AOA)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000645DDC4603782A403E7958A835AD21C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
austria	Autriche	🇦🇹	Vienne	Allemand	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000AB3E575BB15F30407B832F4CA61A4840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
belgium	Belgique	🇧🇪	Bruxelles	Néerlandais, Français, Allemand	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000004703780B24681140F7E461A1D66C4940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
ireland	Irlande	🇮🇪	Dublin	Anglais, Irlandais	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000005F984C158C0A19C00612143FC6AC4A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
italy	Italie	🇮🇹	Rome	Italien	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000003780B2428FE2840166A4DF38EF34440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
kenya	Kenya	🇰🇪	Nairobi	Swahili, Anglais	Shilling kényan (KES)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000008C4AEA0434694240EA95B20C71ACF4BF	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
portugal	Portugal	🇵🇹	Lisbonne	Portugais	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000065AA6054524722C04DF38E53745C4340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
sweden	Suède	🇸🇪	Stockholm	Suédois	Couronne suédoise (SEK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000006F8104C58F11324052499D8026AA4D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
norway	Norvège	🇳🇴	Oslo	Norvégien	Couronne norvégienne (NOK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000371AC05B208125403EE8D9ACFAF44D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
colombia	Colombie	🇨🇴	Bogota	Espagnol	Peso colombien (COP)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000AA8251499D8452C0F2D24D6210D81240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
cyprus	Chypre	🇨🇾	Nicosie	Grec, Turc	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000062A1D634EFB040409D11A5BDC1974140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
czech-republic	République tchèque	🇨🇿	Prague	Tchèque	Couronne tchèque (CZK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000004850FC1873D72C408B6CE7FBA9094940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
brunei	Brunei	🇧🇳	Bandar Seri Begawan	Malais	Dollar de Brunei (BND)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000711B0DE02DBC5C40E4839ECDAA8F1340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
bulgaria	Bulgarie	🇧🇬	Sofia	Bulgare	Lev bulgare (BGN)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000001895D40968523740A835CD3B4E594540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
cambodia	Cambodge	🇰🇭	Phnom Penh	Khmer	Riel (KHR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000B4C876BE9F3A5A4022FDF675E01C2740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
east-timor	Timor oriental	🇹🇱	Dili	Tétoum, Portugais	Dollar américain (USD)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000143FC6DCB5645F405917B7D1001E21C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
ecuador	Équateur	🇪🇨	Quito	Espagnol	Dollar américain (USD)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E61000006744696FF09D53C0E8D9ACFA5C6DCDBF	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
equatorial-guinea	Guinée équatoriale	🇬🇶	Malabo	Espagnol, Français, Portugais	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000E2E995B20C912140143FC6DCB5040E40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
estonia	Estonie	🇪🇪	Tallinn	Estonien	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000FE43FAEDEBC038400E2DB29DEFB74D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
gabon	Gabon	🇬🇦	Libreville	Français	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000073D712F241EF2240C217265305A3DA3F	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
germany	Allemagne	🇩🇪	Berlin	Allemand	Euro	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000BA490C022BE724403E7958A835954940	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
nauru	Nauru	🇳🇷	Yaren	Nauruan, Anglais	Dollar australien	Océanie	\N	\N	\N	\N	\N	\N	0101000020E61000002B8716D9CEDD64405F29CB10C7BAE0BF	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
libya	Libye	🇱🇾	Tripoli	Arabe	Dinar libyen (LYD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000031400000000000003940	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
mali	Mali	🇲🇱	Bamako	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000010C00000000000003140	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
chad	Tchad	🇹🇩	N'Djamena	Français, Arabe	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000033400000000000002E40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
niger	Niger	🇳🇪	Niamey	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000020400000000000003240	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
guinea	Guinée	🇬🇳	Conakry	Français	Franc guinéen (GNF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000005B423EE8D96C2BC06DE7FBA9F1122340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
guyana	Guyana	🇬🇾	Georgetown	Anglais	Dollar de Guyana (GYD)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000CE88D2DEE0134DC0A323B9FC87341B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
iceland	Islande	🇮🇸	Reykjavik	Islandais	Couronne islandaise (ISK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000A835CD3B4EF135C0FE65F7E461095040	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
laos	Laos	🇱🇦	Vientiane	Lao	Kip (LAK)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000A323B9FC87A859400BB5A679C7F93140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
latvia	Lettonie	🇱🇻	Riga	Letton	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000098A1F63EE1A38400B24287E8C794C40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
liberia	Libéria	🇱🇷	Monrovia	Anglais	Dollar libérien (LRD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000F1F44A59869825C0A4DFBE0E9C331940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
lithuania	Lituanie	🇱🇹	Vilnius	Lituanien	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000F2B0506B9A473940D5E76A2BF6574B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
luxembourg	Luxembourg	🇱🇺	Luxembourg	Luxembourgeois, Français, Allemand	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000143FC6DCB5841840E71DA7E848CE4840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
malaysia	Malaisie	🇲🇾	Kuala Lumpur	Malais	Ringgit malaisien (MYR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000D5E76A2BF66B5940E9263108AC1C0940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
slovakia	Slovaquie	🇸🇰	Bratislava	Slovaque	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000007AC7293A921B3140C217265305134840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
romania	Roumanie	🇷🇴	Bucarest	Roumain	Leu roumain (RON)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000000AD7A3703D1A3A4066F7E461A1364640	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
slovenia	Slovénie	🇸🇮	Ljubljana	Slovène	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000034A2B437F8022D403A92CB7F48074740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
malta	Malte	🇲🇹	La Valette	Maltais, Anglais	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000000F0BB5A679072D40EC2FBB270FF34140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
myanmar	Myanmar	🇲🇲	Naypyidaw	Birman	Kyat (MMK)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000F853E3A59B0858406C09F9A067C33340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
mongolia	Mongolie	🇲🇳	Oulan-Bator	Mongol	Tugrik (MNT)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000002EFF21FDF6B95A405396218E75F14740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
nepal	Népal	🇳🇵	Katmandou	Népalais	Roupie népalaise (NPR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000DBF97E6ABC545540F2B0506B9AB73B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
maldives	Maldives	🇲🇻	Malé	Divehi	Rufiyaa (MVR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000008A8EE4F21F4E5240C8073D9B559F0940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
venezuela	Venezuela	🇻🇪	Caracas	Espagnol	Bolivar (VES)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000992A1895D4B950C04BEA043411F62440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
uruguay	Uruguay	🇺🇾	Montevideo	Espagnol	Peso uruguayen (UYU)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000931804560E154CC07A36AB3E577341C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
mexico	Mexique	🇲🇽	Mexico	Espagnol	Peso mexicain (MXN)	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008059C00000000000003740	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
qatar	Qatar	🇶🇦	Doha	Arabe	Riyal qatari (QAR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000006666666666A649400000000000803940	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
paraguay	Paraguay	🇵🇾	Asunción	Espagnol, Guarani	Guarani (PYG)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000454772F90FD14CC088F4DBD7814339C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
suriname	Suriname	🇸🇷	Paramaribo	Néerlandais	Dollar du Suriname (SRD)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E610000060764F1E169A4BC09CC420B072681740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
senegal	Sénégal	🇸🇳	Dakar	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000005227A089B07131C01E166A4DF36E2D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
sierra-leone	Sierra Leone	🇸🇱	Freetown	Anglais	Leone (SLL)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000066F7E461A1762AC0401361C3D3EB2040	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
guinea-bissau	Guinée-Bissau	🇬🇳	Bissau	Portugais	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000B37BF2B0502B2FC0B5A679C729BA2740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
lesotho	Lesotho	🇱🇸	Maseru	Anglais, Sotho	Loti (LSL)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000098DD9387857A3B40386744696F503DC0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
liechtenstein	Liechtenstein	🇱🇮	Vaduz	Allemand	Franc suisse (CHF)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000097900F7A360B234099BB96900F924740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
north-macedonia	Macédoine du Nord	🇲🇰	Skopje	Macédonien	Denar (MKD)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000917EFB3A706E35407FD93D7958004540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
cape-verde	Cap-Vert	🌭	Praia	Portugais	Escudo cap-verdien (CVE)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000A779C7293A8237C05BD3BCE314DD2D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
zimbabwe	Zimbabwe	🇿🇼	Harare	Anglais, Shona, Ndebele	Dollar zimbabwéen (ZWL)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000007F6ABC7493083F40C1A8A44E40D331C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
zambia	Zambie	🇿🇲	Lusaka	Anglais	Kwacha zambien (ZMW)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000D0D556EC2F4B3C406666666666C62EC0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
moldova	Moldavie	🇲🇩	Chișinău	Roumain	Leu moldave (MDL)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000007AC7293A92DB3C40D34D621058814740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
montenegro	Monténégro	🇲🇪	Podgorica	Monténégrin	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000001895D409684233406519E25817374540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
monaco	Monaco	🇲🇨	Monaco	Français	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000009F9A067B3AA1D4012143FC6DCDD4540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
san-marino	Saint-Marin	🇸🇲	Saint-Marin	Italien	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000143FC6DCB5E42840E4141DC9E5F74540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
vatican	Vatican	🇻🇦	Cité du Vatican	Italien, Latin	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000004703780B24E828407AC7293A92F34440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
albania	Albanie	🇦🇱	Tirana	Albanais	Lek (ALL)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000363CBD5296D1334052B81E85EBA94440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
andorra	Andorre	🇦🇩	Andorre-la-Vieille	Catalan	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000045D8F0F44A59F83F7FFB3A70CE404540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
armenia	Arménie	🇦🇲	Erevan	Arménien	Dram (AMD)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000009CC420B072404640D5E76A2BF6174440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
azerbaijan	Azerbaïdjan	🇦🇿	Bakou	Azéri	Manat (AZN)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000492EFF21FDEE48407FD93D7958304440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
benin	Bénin	🇧🇯	Porto-Novo	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000013F241CF66D504409487855AD3FC1940	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
bhutan	Bhoutan	🇧🇹	Thimphou	Dzongkha	Ngultrum (BTN)	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000046B6F3FDD468564029CB10C7BA783B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
cameroon	Cameroun	🇨🇲	Yaoundé	Français, Anglais	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000A9A44E401301274062105839B4C80E40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
china	Chine	🇨🇳	Pékin	Chinois	Yuan	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000DC68006F810C5A404A7B832F4CEE4140	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
japan	Japon	🇯🇵	Tokyo	Japonais	Yen	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000012A5BDC117486140431CEBE2361A4240	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
namibia	Namibie	🇳🇦	Windhoek	Anglais	Dollar namibien (NAD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000000000000000314000000000000036C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
papua-new-guinea	Papouasie-Nouvelle-Guinée	🇵🇬	Port Moresby	Anglais, Tok Pisin	Kina	Océanie	\N	\N	\N	\N	\N	\N	0101000020E61000007F6ABC7493FE6140C3F5285C8F4219C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
argentina	Argentine	🇦🇷	Buenos Aires	Espagnol	Peso argentin (ARS)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000050C000000000000041C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
egypt	Égypte	🇪🇬	Le Caire	Arabe	Livre égyptienne (EGP)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003E400000000000003A40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
russia	Russie	🇷🇺	Moscou	Russe	Rouble	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000BF7D1D3867545A40508D976E12C34E40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
dominica	Dominique	🇩🇲	Roseau	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000EFC9C342ADB14EC05F07CE19519A2E40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
fiji	Fidji	🇫🇯	Suva	Anglais, Fidjien	Dollar fidjien	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000AE47E17A1442664066F7E461A1B631C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
switzerland	Suisse	🇨🇭	Berne	Allemand, Français, Italien	Franc suisse (CHF)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000020400000000000804740	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
peru	Pérou	🇵🇪	Lima	Espagnol	Sol (PEN)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000053C000000000000024C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
morocco	Maroc	🇲🇦	Rabat	Arabe	Dirham marocain (MAD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000014C00000000000004040	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
comoros	Comores	🇰🇲	Moroni	Arabe, Français, Comorien	Franc comorien (KMF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000048BF7D1D389F4540D122DBF97E4A27C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
burundi	Burundi	🇧🇮	Gitega	Kirundi	Franc burundais	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000B1E1E995B2EC3D407E1D386744690BC0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
new-zealand	Nouvelle-Zélande	🇳🇿	Wellington	Anglais, Maori	Dollar néo-zélandais	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000F7E461A1D6D8654088635DDC467344C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
togo	Togo	🇹🇬	Lomé	Français	Franc CFA (XOF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000E3C798BB9690F33FCDCCCCCCCC8C1840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
tunisia	Tunisie	🇹🇳	Tunis	Arabe	Dinar tunisien	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000865AD3BCE35424407FFB3A70CE684240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
indonesia	Indonésie	🇮🇩	Jakarta	Indonésien	Roupie indonésienne (IDR)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000005E4000000000000000C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
taiwan	Taïwan	🇹🇼	Taipei	Mandarin	Dollar taïwanais (TWD)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000405E400000000000803740	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
uae	Émirats arabes unis	🇦🇪	Abu Dhabi	Arabe	Dirham des Émirats (AED)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000004B400000000000003840	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
bosnia-herzegovina	Bosnie-Herzégovine	🇧🇦	Sarajevo	Bosniaque, Croate, Serbe	Mark convertible (BAM)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000032400000000000004640	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
new-caledonia	Nouvelle-Calédonie	🇳🇨	Nouméa	Français	Franc CFP (XPF)	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000B0644000000000008035C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
haiti	Haïti	🇭🇹	Port-au-Prince	Français	Gourde haïtienne	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000AE47E17A141652C0D200DE02098A3240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
thailand	Thaïlande	🇹🇭	Bangkok	Thaï	Baht	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000EC51B81E853F59403D0AD7A370BD2F40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
algeria	Algérie	🇩🇿	Alger	Arabe	Dinar algérien (DZD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000008400000000000003C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
uk	Royaume-Uni	🇬🇧	Londres	Anglais	Livre sterling	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000DA1B7C613255C0BFC5FEB27BF2C04940	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
brazil	Brésil	🇧🇷	Brasília	Portugais	Real	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E6100000917EFB3A70F649C0B81E85EB51782CC0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
iran	Iran	🇮🇷	Téhéran	Persan	Rial	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000F2D24D6210D84A40ADFA5C6DC5364040	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
gambia	Gambie	🇬🇲	Banjul	Anglais	Dalasi (GMD)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000004E621058399430C0A52C431CEBE22A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
central-african-republic	République centrafricaine	🇨🇫	Bangui	Français	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000035400000000000001C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
south-korea	Corée du Sud	🇰🇷	Séoul	Coréen	Won	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000005BD3BCE314F15F4087A757CA32F44140	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
panama	Panama	🇵🇦	Panama	Espagnol	Balboa	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000F775E09C11E153C04850FC1873F72140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
ghana	Ghana	🇬🇭	Accra	Anglais	Cedi (GHS)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000CEAACFD556ECC7BF3D0AD7A3703D1640	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
palau	Palaos	🇵🇼	Ngerulmud	Anglais, Palauan	Dollar américain	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000713D0AD7A3D260408FC2F5285C0F1E40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
samoa	Samoa	🇼🇸	Apia	Samoan, Anglais	Tala	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000AD69DE718A7865C0A4DFBE0E9CB32BC0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
india	Inde	🇮🇳	New Delhi	Hindi	Roupie indienne	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000061545227A0BD53409CA223B9FC973440	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
south-africa	Afrique du Sud	🇿🇦	Pretoria	Afrikaans, Anglais	Rand	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000AEB6627FD9FD3840AC1C5A643B8F3EC0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
canada	Canada	🇨🇦	Ottawa	Anglais, Français	Dollar canadien	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000002E90A0F831965AC0FFB27BF2B0104C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
france	France	🇫🇷	Paris	Français	Euro	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000D93D7958A8B50140E9482EFF211D4740	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
honduras	Honduras	🇭🇳	Tegucigalpa	Espagnol	Lempira hondurien	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000053411363CCD55C069006F8104252C40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
nicaragua	Nicaragua	🇳🇮	Managua	Espagnol	Córdoba oro	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000742497FF909255C0EE7C3F355E3A2840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
chile	Chili	🇨🇱	Santiago	Espagnol	Peso chilien (CLP)	Amérique du Sud	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000C051C00000000000003EC0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
congo	République du Congo	🇨🇬	Brazzaville	Français	Franc CFA (XAF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000002E40000000000000F0BF	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
singapore	Singapour	🇸🇬	Singapour	Anglais, Mandarin, Malais, Tamoul	Dollar de Singapour (SGD)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000003333333333F35940CDCCCCCCCCCCF43F	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
belize	Belize	🇧🇿	Belmopan	Anglais	Dollar bélizien	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000068226C787A3156C0E3361AC05B403140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
el-salvador	Salvador	🇸🇻	San Salvador	Espagnol	Dollar américain	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000002EFF21FDF64D56C0FBCBEEC9C3622B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
saint-kitts-and-nevis	Saint-Kitts-et-Nevis	🇰🇳	Basseterre	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000006B2BF697DD5B4FC005C58F31774D3140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
serbia	Serbie	🇷🇸	Belgrade	Serbe	Dinar serbe (RSD)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000035400000000000004640	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
antigua-and-barbuda	Antigua-et-Barbuda	🇦🇬	Saint John's	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000008FE4F21FD2DF4EC0AA8251499D203140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
saint-lucia	Saint-Lucie	🇱🇨	Castries	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000066666666667E4EC02041F163CCFD2B40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
bahrain	Bahreïn	🇧🇭	Manama	Arabe	Dinar bahreïni	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000007B832F4CA64A4940F0A7C64B37393A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
israel	Israël	🇮🇱	Jérusalem	Hébreu	Nouveau shekel israélien	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000DE9387855A9B41404D840D4FAFC43F40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
kyrgyzstan	Kirghizistan	🇰🇬	Bichkek	Kirghiz	Som kirghize	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000005F29CB10C7A65240728A8EE4F26F4540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
kuwait	Koweït	🇰🇼	Koweït	Arabe	Dinar koweïtien	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000A1D634EF38FD474000917EFB3A603D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
lebanon	Liban	🇱🇧	Beyrouth	Arabe	Livre libanaise	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000000917EFB3AC041401895D40968F24040	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
syria	Syrie	🇸🇾	Damas	Arabe	Livre syrienne	Asie	\N	\N	\N	\N	\N	\N	0101000020E610000008AC1C5A64234240A857CA32C4C14040	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
yemen	Yémen	🇾🇪	Sanaa	Arabe	Rial yéménite	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000C3F5285C8F1A4640E9482EFF21BD2E40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
marshall-islands	Îles Marshall	🇲🇭	Majuro	Marshallese, Anglais	Dollar américain	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000D6C56D34801765402DB29DEFA7861C40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
djibouti	Djibouti	🇩🇯	Djibouti	Français, Arabe	Franc de Djibouti (DJF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000ED0DBE30999245404D158C4AEA242740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
eswatini	Eswatini	🇸🇿	Mbabane	Anglais, Swati	Lilangeni (SZL)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000D734EF3845773F40F6285C8FC2853AC0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
georgia	Géorgie	🇬🇪	Tbilissi	Géorgien	Lari (GEL)	Europe	\N	\N	\N	\N	\N	\N	0101000020E6100000787AA52C436446404FAF946588DB4440	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
micronesia	Micronésie	🇫🇲	Palikir	Anglais	Dollar américain	Océanie	\N	\N	\N	\N	\N	\N	0101000020E6100000C58F31772DC56340FB5C6DC5FEB21B40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
solomon-islands	Îles Salomon	🇸🇧	Honiara	Anglais	Dollar des Îles Salomon	Océanie	\N	\N	\N	\N	\N	\N	0101000020E610000005A3923A01056440ED0DBE30994A23C0	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
turkmenistan	Turkménistan	🇹🇲	Achgabat	Turkmène	Manat turkmène	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000371AC05B20314D4019E25817B7F94240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
oman	Oman	🇴🇲	Mascate	Arabe	Rial omanais	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000007958A835CD4B4D40B003E78C289D3740	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
tajikistan	Tadjikistan	🇹🇯	Douchanbé	Tadjik	Somoni	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000F697DD93873151408CDB68006F494340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
philippines	Philippines	🇵🇭	Manille	Filipino, Anglais	Peso philippin (PHP)	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000805E400000000000002A40	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
saudi-arabia	Arabie Saoudite	🇸🇦	Riyad	Arabe	Riyal	Asie	\N	\N	\N	\N	\N	\N	0101000020E6100000EEEBC039238A4640C286A757CAE23740	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
democratic-republic-of-congo	République démocratique du Congo	🇨🇩	Kinshasa	Français	Franc congolais (CDF)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000039400000000000000000	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
croatia	Croatie	🇭🇷	Zagreb	Croate	Kuna (HRK)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000002E400000000000804640	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
hungary	Hongrie	🇭🇺	Budapest	Hongrois	Forint (HUF)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000034400000000000804740	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
kosovo	Kosovo	🇽🇰	Pristina	Albanais, Serbe	Euro (EUR)	Europe	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003540CDCCCCCCCC4C4540	0	0	0	0	0	0	\N	2025-07-05	2025-07-07	\N	\N	\N
trinidad-and-tobago	Trinité-et-Tobago	🇹🇹	Port d'Espagne	Anglais	Dollar de Trinité-et-Tobago	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E610000042CF66D5E7C24EC0857CD0B359552540	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
costa-rica	Costa Rica	🇨🇷	San José	Espagnol	Colón costaricien	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000006FF085C9540555C0AEB6627FD9DD2340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
guatemala	Guatemala	🇬🇹	Guatemala	Espagnol	Quetzal guatémaltèque	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000005B423EE8D9A056C0F775E09C11452D40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
jamaica	Jamaïque	🇯🇲	Kingston	Anglais	Dollar jamaïcain	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E6100000A69BC420B03253C00DE02D90A0F83140	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
dominican-republic	République dominicaine	🇩🇴	Saint-Domingue	Espagnol	Peso dominicain	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000004182E2C7987B51C0EA95B20C717C3240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
saint-vincent-and-the-grenadines	Saint-Vincent-et-les-Grenadines	🇻🇨	Kingstown	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000000612143FC69C4EC052B81E85EB512A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
bahamas	Bahamas	🇧🇸	Nassau	Anglais	Dollar bahaméen	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000003C4ED1915C4253C032772D211F744340	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
grenada	Grenade	🇬🇩	Saint George's	Anglais	Dollar des Caraïbes orientales	Amérique du Nord	\N	\N	\N	\N	\N	\N	0101000020E61000008FE4F21FD2DF4EC0789CA223B91C2840	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
jordan	Jordanie	🇯🇴	Amman	Arabe	Dinar jordanien	Asie	\N	\N	\N	\N	\N	\N	0101000020E61000006519E25817F74140A4DFBE0E9CF33F40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
madagascar	Madagascar	🇲🇬	Antananarivo	Malgache, Français	Ariary (MGA)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000005BB1BFEC9EC44740A9A44E4013E132C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
malawi	Malawi	🇲🇼	Lilongwe	Anglais, Chichewa	Kwacha malawite (MWK)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000000612143FC6E440405B423EE8D9EC2BC0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
mauritania	Mauritanie	🇲🇷	Nouakchott	Arabe	Ouguiya (MRU)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000ED0DBE3099EA2FC04DF38E5374143240	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
seychelles	Seychelles	🇸🇨	Victoria	Français, Anglais, Créole seychellois	Roupie seychelloise (SCR)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000B5A679C729BA4B407DD0B359F57912C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
mauritius	Maurice	🇲🇺	Port-Louis	Anglais, Français	Roupie mauricienne (MUR)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E6100000F46C567DAEC64C4029ED0DBE302934C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
mozambique	Mozambique	🇲🇿	Maputo	Portugais	Metical (MZN)	Afrique	\N	\N	\N	\N	\N	\N	0101000020E61000009A081B9E5E4940408048BF7D1DF839C0	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
belarus	Biélorussie	🇧🇾	Minsk	Biélorusse, Russe	Rouble biélorusse (BYN)	Europe	\N	\N	\N	\N	\N	\N	0101000020E610000039B4C876BE8F3B402497FF907EF34A40	0	0	0	0	0	0	\N	2025-07-07	2025-07-07	\N	\N	\N
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
-- Data for Name: country_natural_resource; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_natural_resource (id, country_id, resource_id, abundance_level, locations, production_value, production_unit, production_year) FROM stdin;
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
france	otan	Membre fondateur	1949-04-04	\N
usa	otan	Membre fondateur	1949-04-04	\N
germany	otan	Membre	1955-05-09	\N
uk	otan	Membre fondateur	1949-04-04	\N
france	ue	Membre fondateur	1957-03-25	\N
germany	ue	Membre fondateur	1957-03-25	\N
usa	g7	Membre	1975-01-01	\N
japan	g7	Membre	1975-01-01	\N
china	g20	Membre	1999-01-01	\N
india	g20	Membre	1999-01-01	\N
brazil	g20	Membre	1999-01-01	\N
\.


--
-- Data for Name: country_political_regime; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_political_regime (country_id, regime_id, start_year, end_year, current_regime, notes) FROM stdin;
\.


--
-- Data for Name: country_relation; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_relation (countryid, relationid, statut, dateadhesion, datesortie) FROM stdin;
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
-- Data for Name: natural_resource; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.natural_resource (id, name, category, description, global_reserves_value, global_reserves_unit, global_reserves_year) FROM stdin;
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.organization (id, nom, type, description, datecreation, siege) FROM stdin;
onu	Organisation des Nations Unies	Organisation internationale	Organisation internationale pour la paix et la sécurité	1945-10-24	New York, États-Unis
otan	Organisation du Traité de l'Atlantique Nord	Alliance militaire	Alliance militaire occidentale	1949-04-04	Bruxelles, Belgique
ue	Union européenne	Union politique et économique	Union politique et économique européenne	1993-11-01	Bruxelles, Belgique
g7	Groupe des Sept	Forum économique	Forum des sept pays les plus industrialisés	1975-01-01	Rotation annuelle
g20	Groupe des Vingt	Forum économique	Forum des vingt principales économies	1999-01-01	Rotation annuelle
apec	Coopération économique Asie-Pacifique	Forum économique	Forum de coopération économique Asie-Pacifique	1989-01-01	Singapour
mercosur	Mercosur	Union douanière	Marché commun du Sud	1991-03-26	Montevideo, Uruguay
asean	Association des nations de l'Asie du Sud-Est	Organisation régionale	Association des nations de l'Asie du Sud-Est	1967-08-08	Jakarta, Indonésie
\.


--
-- Data for Name: organization_relation; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.organization_relation (organization_id, relation_id, role) FROM stdin;
\.


--
-- Data for Name: political_regime; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.political_regime (id, name, description, characteristics, examples) FROM stdin;
republique-parlementaire	République parlementaire	Système où le chef de l'État est élu mais le pouvoir exécutif appartient au gouvernement responsable devant le parlement.	["Chef d'État élu", "Gouvernement responsable devant le parlement", "Séparation des pouvoirs", "Élections législatives déterminantes"]	["germany", "italy", "india", "south-africa"]
republique-presidentielle	République présidentielle	Système où le président est à la fois chef de l'État et chef du gouvernement.	["Président élu au suffrage universel", "Pouvoirs exécutifs étendus", "Séparation stricte des pouvoirs", "Veto présidentiel"]	["usa", "brazil", "france", "russia"]
monarchie-absolue	Monarchie absolue	Système où le monarque détient tous les pouvoirs sans limitation constitutionnelle.	["Pouvoir absolu du monarque", "Absence de constitution limitative", "Hérédité du pouvoir", "Contrôle total de l'État"]	["saudi-arabia", "brunei", "oman"]
regime-hybride	Régime hybride	Système combinant des éléments démocratiques et autoritaires.	["Élections mais avec restrictions", "Libertés civiles partielles", "Contrôle médiatique", "Opposition limitée"]	["russia", "turkey", "hungary", "poland"]
theocratie	Théocratie	Système où le pouvoir politique est exercé au nom de la religion.	["Autorité religieuse suprême", "Lois basées sur la religion", "Clergé au pouvoir", "Fusion religion-État"]	["iran", "vatican"]
democratie-representative	Démocratie représentative	Système dans lequel les citoyens élisent des représentants qui prennent les décisions en leur nom.	["Élections libres et régulières", "Séparation des pouvoirs", "Protection des libertés civiles", "État de droit"]	["usa", "france", "germany", "uk", "canada"]
monarchie-constitutionnelle	Monarchie constitutionnelle	Système dans lequel un monarque est le chef d'État, mais son pouvoir est limité par une constitution.	["Monarque comme chef d'État", "Pouvoir limité par la constitution", "Parlement élu", "Premier ministre comme chef de gouvernement"]	["uk", "spain", "sweden", "norway", "japan"]
republique-federale	République fédérale	Système où le pouvoir est partagé entre un gouvernement central et des entités fédérées.	["Constitution écrite définissant les pouvoirs", "Autonomie des entités fédérées", "Double niveau de gouvernement", "Mécanismes de résolution des conflits de compétence"]	["usa", "germany", "brazil", "india", "australia"]
regime-autoritaire	Régime autoritaire	Système où le pouvoir politique est concentré et les libertés individuelles limitées.	["Concentration du pouvoir", "Limitations des libertés civiles", "Contrôle des médias", "Restrictions du pluralisme politique"]	["china", "russia", "north-korea", "iran", "saudi-arabia"]
democratie-directe	Démocratie directe	Système où les citoyens participent directement aux décisions politiques.	["Référendums fréquents", "Initiative populaire", "Participation directe", "Transparence des processus"]	["switzerland"]
\.


--
-- Data for Name: political_transition; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.political_transition (id, from_regime_id, to_regime_id, country_id, year, description) FROM stdin;
\.


--
-- Data for Name: relation; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.relation (id, type, description, datedebut, datefin, statut, nom) FROM stdin;
alliance-otan	Alliance militaire	Alliance militaire occidentale	1949-04-04	\N	Actif	\N
alliance-ue	Union politique	Union politique et économique européenne	1993-11-01	\N	Actif	\N
conflit-ukraine	Conflit armé	Conflit en Ukraine	2022-02-24	\N	En cours	\N
accord-paris	Accord climatique	Accord de Paris sur le climat	2015-12-12	\N	Actif	\N
sanctions-russie	Sanctions économiques	Sanctions contre la Russie	2022-02-24	\N	Actif	\N
commerce-chine-usa	Relations commerciales	Relations commerciales Chine-États-Unis	1979-01-01	\N	Actif	\N
\.


--
-- Data for Name: relation_country; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.relation_country (relationid, countryid, statut, dateadhesion, datesortie) FROM stdin;
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
\.


--
-- Data for Name: resource_country; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.resource_country (countryid, resourceid, role, quantite, unite) FROM stdin;
saudi-arabia	petrole	\N	\N	\N
russia	petrole	\N	\N	\N
usa	petrole	\N	\N	\N
china	lithium	\N	\N	\N
australia	lithium	\N	\N	\N
china	terres-rares	\N	\N	\N
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
-- Name: country_natural_resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wikigeo_user
--

SELECT pg_catalog.setval('public.country_natural_resource_id_seq', 1, false);


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
-- Name: country_natural_resource country_natural_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_natural_resource
    ADD CONSTRAINT country_natural_resource_pkey PRIMARY KEY (id);


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
-- Name: country_relation country_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_relation
    ADD CONSTRAINT country_relation_pkey PRIMARY KEY (countryid, relationid);


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
-- Name: natural_resource natural_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.natural_resource
    ADD CONSTRAINT natural_resource_pkey PRIMARY KEY (id);


--
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: organization_relation organization_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.organization_relation
    ADD CONSTRAINT organization_relation_pkey PRIMARY KEY (organization_id, relation_id);


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
-- Name: relation_country relation_country_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.relation_country
    ADD CONSTRAINT relation_country_pkey PRIMARY KEY (relationid, countryid);


--
-- Name: relation relation_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.relation
    ADD CONSTRAINT relation_pkey PRIMARY KEY (id);


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
-- Name: idx_natural_resource_country; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_natural_resource_country ON public.country_natural_resource USING btree (country_id);


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
-- Name: organization update_organization_updated_at; Type: TRIGGER; Schema: public; Owner: wikigeo_user
--

CREATE TRIGGER update_organization_updated_at BEFORE UPDATE ON public.organization FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: relation update_relation_updated_at; Type: TRIGGER; Schema: public; Owner: wikigeo_user
--

CREATE TRIGGER update_relation_updated_at BEFORE UPDATE ON public.relation FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


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
-- Name: country_natural_resource country_natural_resource_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_natural_resource
    ADD CONSTRAINT country_natural_resource_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- Name: country_natural_resource country_natural_resource_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_natural_resource
    ADD CONSTRAINT country_natural_resource_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.natural_resource(id);


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
-- Name: country_relation country_relation_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_relation
    ADD CONSTRAINT country_relation_country_id_fkey FOREIGN KEY (countryid) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: country_relation country_relation_relation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_relation
    ADD CONSTRAINT country_relation_relation_id_fkey FOREIGN KEY (relationid) REFERENCES public.relation(id) ON DELETE CASCADE;


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
-- Name: country fk_country_regime; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT fk_country_regime FOREIGN KEY (regimepolitique) REFERENCES public.political_regime(id);


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
-- Name: organization_relation organization_relation_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.organization_relation
    ADD CONSTRAINT organization_relation_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organization(id) ON DELETE CASCADE;


--
-- Name: organization_relation organization_relation_relation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.organization_relation
    ADD CONSTRAINT organization_relation_relation_id_fkey FOREIGN KEY (relation_id) REFERENCES public.relation(id) ON DELETE CASCADE;


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
-- Name: relation_country relation_country_countryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.relation_country
    ADD CONSTRAINT relation_country_countryid_fkey FOREIGN KEY (countryid) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: relation_country relation_country_relationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.relation_country
    ADD CONSTRAINT relation_country_relationid_fkey FOREIGN KEY (relationid) REFERENCES public.relation(id) ON DELETE CASCADE;


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

