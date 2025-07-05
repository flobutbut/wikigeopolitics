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
    country_id character varying(10),
    product_id character varying(50),
    export_value numeric(10,1),
    export_unit character varying(50),
    export_year integer,
    percentage_of_global numeric(5,2)
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
    country_id character varying(10),
    product_id character varying(50),
    import_value numeric(10,1),
    import_unit character varying(50),
    import_year integer
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
    start_year integer,
    end_year integer,
    status character varying(50),
    involved_countries jsonb,
    casualty_estimates jsonb,
    geopolitical_impact text
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
-- Name: company; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.company (
    id character varying(50) NOT NULL,
    nom character varying(255) NOT NULL,
    pays character varying(50),
    secteur character varying(100),
    indicateurs jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
    date_debut date,
    date_fin date,
    intensite character varying(50),
    localisation public.geometry(Polygon,4326),
    victimes jsonb,
    timeline jsonb,
    efforts_paix jsonb,
    consequences jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.conflict OWNER TO wikigeo_user;

--
-- Name: TABLE conflict; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.conflict IS 'Conflits armés et historiques';


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
    histoire jsonb,
    politique jsonb,
    economie jsonb,
    demographie jsonb,
    frontieres jsonb,
    coordonnees public.geometry(Point,4326),
    tourisme jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
    country_id character varying(10),
    product_id character varying(50),
    production_value numeric(10,1),
    production_unit character varying(50),
    production_year integer,
    percentage_of_global numeric(5,2)
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
-- Name: country_conflict; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.country_conflict (
    country_id character varying(50) NOT NULL,
    conflict_id character varying(50) NOT NULL,
    role character varying(100)
);


ALTER TABLE public.country_conflict OWNER TO wikigeo_user;

--
-- Name: country_industry; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.country_industry (
    country_id character varying(50) NOT NULL,
    industry_id character varying(50) NOT NULL,
    production_volume jsonb,
    importance character varying(100)
);


ALTER TABLE public.country_industry OWNER TO wikigeo_user;

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
    country_id character varying(50) NOT NULL,
    organization_id character varying(50) NOT NULL,
    role character varying(100),
    date_adhesion date,
    statut character varying(100)
);


ALTER TABLE public.country_organization OWNER TO wikigeo_user;

--
-- Name: country_relation; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.country_relation (
    country_id character varying(50) NOT NULL,
    relation_id character varying(50) NOT NULL,
    role character varying(100)
);


ALTER TABLE public.country_relation OWNER TO wikigeo_user;

--
-- Name: country_resource; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.country_resource (
    country_id character varying(50) NOT NULL,
    resource_id character varying(50) NOT NULL,
    production_volume jsonb,
    reserves jsonb
);


ALTER TABLE public.country_resource OWNER TO wikigeo_user;

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
    country_id character varying(10),
    year integer,
    population bigint,
    median_age numeric(4,1),
    fertility_rate numeric(3,2),
    life_expectancy numeric(4,1),
    urbanization_rate numeric(4,1),
    elderly_percentage numeric(4,1),
    gdp_per_capita numeric(12,2),
    hdi_index numeric(3,3),
    literacy_rate numeric(4,1),
    data_source character varying(200)
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
    production_mondiale jsonb,
    tendances jsonb,
    chaine_approvisionnement jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
    date_creation date,
    siege character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
    date_debut date,
    date_fin date,
    statut character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.relation OWNER TO wikigeo_user;

--
-- Name: TABLE relation; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.relation IS 'Relations internationales entre pays (alliances, conflits, accords)';


--
-- Name: resource; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.resource (
    id character varying(50) NOT NULL,
    nom character varying(255) NOT NULL,
    categorie character varying(100),
    description text,
    reserves_mondiales jsonb,
    usages jsonb,
    impact_environnemental text,
    enjeux_geopolitiques text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.resource OWNER TO wikigeo_user;

--
-- Name: TABLE resource; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.resource IS 'Ressources naturelles et leurs enjeux géopolitiques';


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
    subsector_id character varying(50),
    country_id character varying(10),
    strengths jsonb,
    companies jsonb
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
    global_market_value numeric(12,2),
    global_market_unit character varying(20),
    global_market_year integer,
    cagr character varying(20)
);


ALTER TABLE public.technology_sector OWNER TO wikigeo_user;

--
-- Name: technology_subsector; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.technology_subsector (
    id character varying(50) NOT NULL,
    sector_id character varying(50),
    name character varying(100) NOT NULL,
    description text,
    status character varying(50),
    applications jsonb,
    geopolitical_issues jsonb
);


ALTER TABLE public.technology_subsector OWNER TO wikigeo_user;

--
-- Name: tourism_data; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.tourism_data (
    id integer NOT NULL,
    country_id character varying(10),
    annual_visitors bigint,
    visitors_year integer,
    major_attractions jsonb,
    economic_impact numeric(12,2),
    economic_impact_unit character varying(20)
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
    geo_json_ref text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.trade_route OWNER TO wikigeo_user;

--
-- Name: TABLE trade_route; Type: COMMENT; Schema: public; Owner: wikigeo_user
--

COMMENT ON TABLE public.trade_route IS 'Routes commerciales et de transport';


--
-- Name: transport_data; Type: TABLE; Schema: public; Owner: wikigeo_user
--

CREATE TABLE public.transport_data (
    id integer NOT NULL,
    country_id character varying(10),
    transport_type character varying(50),
    volume_value numeric(12,2),
    volume_unit character varying(20),
    volume_year integer,
    routes jsonb,
    infrastructure_data jsonb
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
    cf.date_debut,
    array_agg(DISTINCT c.nom) AS pays_impliques
   FROM ((public.conflict cf
     LEFT JOIN public.country_conflict cc ON (((cf.id)::text = (cc.conflict_id)::text)))
     LEFT JOIN public.country c ON (((cc.country_id)::text = (c.id)::text)))
  GROUP BY cf.id, cf.nom, cf.type, cf.statut, cf.date_debut;


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
     LEFT JOIN public.country_organization co ON (((c.id)::text = (co.country_id)::text)))
     LEFT JOIN public.organization o ON (((co.organization_id)::text = (o.id)::text)))
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
     LEFT JOIN public.country_resource cr ON (((c.id)::text = (cr.country_id)::text)))
     LEFT JOIN public.resource r ON (((cr.resource_id)::text = (r.id)::text)))
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

COPY public.agricultural_export (id, country_id, product_id, export_value, export_unit, export_year, percentage_of_global) FROM stdin;
12	russia	ble	33.0	millions de tonnes	2021	20.00
13	usa	ble	26.1	millions de tonnes	2021	15.80
14	canada	ble	23.0	millions de tonnes	2021	13.90
15	france	ble	18.0	millions de tonnes	2021	10.90
16	ukraine	ble	16.5	millions de tonnes	2021	10.00
17	india	riz	21.5	millions de tonnes	2021	40.60
18	thailand	riz	6.1	millions de tonnes	2021	11.50
19	vietnam	riz	6.3	millions de tonnes	2021	11.90
20	usa	mais	69.0	millions de tonnes	2021	35.00
21	argentina	mais	39.0	millions de tonnes	2021	19.80
22	brazil	mais	20.0	millions de tonnes	2021	10.20
\.


--
-- Data for Name: agricultural_import; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.agricultural_import (id, country_id, product_id, import_value, import_unit, import_year) FROM stdin;
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

COPY public.armed_conflict (id, name, description, start_year, end_year, status, involved_countries, casualty_estimates, geopolitical_impact) FROM stdin;
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.company (id, nom, pays, secteur, indicateurs, created_at, updated_at) FROM stdin;
tesla	Tesla	usa	Automobile	{"employes": 127855, "chiffre_affaires": "538.23 milliards USD"}	2025-07-05 21:19:53.138746	2025-07-05 21:19:53.138746
toyota	Toyota	japan	Automobile	{"employes": 372817, "chiffre_affaires": "279.515 milliards USD"}	2025-07-05 21:19:53.138746	2025-07-05 21:19:53.138746
volkswagen	Volkswagen	germany	Automobile	{"employes": 662575, "chiffre_affaires": "295.819 milliards USD"}	2025-07-05 21:19:53.138746	2025-07-05 21:19:53.138746
apple	Apple	usa	Informatique	{"employes": 164000, "chiffre_affaires": "394.328 milliards USD"}	2025-07-05 21:19:53.138746	2025-07-05 21:19:53.138746
samsung	Samsung	south-korea	Informatique	{"employes": 267937, "chiffre_affaires": "234.2 milliards USD"}	2025-07-05 21:19:53.138746	2025-07-05 21:19:53.138746
pfizer	Pfizer	usa	Pharmaceutique	{"employes": 83000, "chiffre_affaires": "100.33 milliards USD"}	2025-07-05 21:19:53.138746	2025-07-05 21:19:53.138746
novartis	Novartis	germany	Pharmaceutique	{"employes": 108000, "chiffre_affaires": "51.6 milliards USD"}	2025-07-05 21:19:53.138746	2025-07-05 21:19:53.138746
shell	Shell	uk	Énergie	{"employes": 87000, "chiffre_affaires": "386.201 milliards USD"}	2025-07-05 21:19:53.138746	2025-07-05 21:19:53.138746
\.


--
-- Data for Name: conflict; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.conflict (id, nom, type, statut, date_debut, date_fin, intensite, localisation, victimes, timeline, efforts_paix, consequences, created_at, updated_at) FROM stdin;
conflit-ukraine-2022	Guerre en Ukraine	Guerre interétatique	En cours	2022-02-24	\N	Élevée	0103000020E61000000100000005000000174850FC18233640B4C876BE9F924940174850FC182336407F6ABC7493304A4090A0F831E61644407F6ABC7493304A4090A0F831E6164440B4C876BE9F924940174850FC18233640B4C876BE9F924940	\N	\N	\N	\N	2025-07-05 21:19:53.134361	2025-07-05 21:19:53.134361
conflit-syrie	Guerre civile syrienne	Guerre civile	En cours	2011-03-15	\N	Élevée	0103000020E610000001000000050000009FABADD85FCE41408FE4F21FD22740409FABADD85FCE4140AF25E4839EC542400C93A98251314540AF25E4839EC542400C93A982513145408FE4F21FD22740409FABADD85FCE41408FE4F21FD2274040	\N	\N	\N	\N	2025-07-05 21:19:53.134361	2025-07-05 21:19:53.134361
conflit-yemen	Guerre au Yémen	Guerre civile	En cours	2014-09-19	\N	Moyenne	0103000020E61000000100000005000000857CD0B3594D4540EC51B81E852B2940857CD0B3594D4540ABCFD556ECFF32401FF46C567D5E4B40ABCFD556ECFF32401FF46C567D5E4B40EC51B81E852B2940857CD0B3594D4540EC51B81E852B2940	\N	\N	\N	\N	2025-07-05 21:19:53.134361	2025-07-05 21:19:53.134361
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

COPY public.country (id, nom, drapeau, capitale, langue, monnaie, continent, sections, indicateurs, histoire, politique, economie, demographie, frontieres, coordonnees, tourisme, created_at, updated_at) FROM stdin;
france	France	\N	Paris	Français	Euro	Europe	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000D93D7958A8B50140E9482EFF211D4740	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
usa	États-Unis	\N	Washington D.C.	Anglais	Dollar américain	Amérique du Nord	\N	\N	\N	\N	\N	\N	\N	0101000020E610000061545227A0ED57C0B30C71AC8B8B4240	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
china	Chine	\N	Pékin	Chinois	Yuan	Asie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000DC68006F810C5A404A7B832F4CEE4140	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
russia	Russie	\N	Moscou	Russe	Rouble	Europe	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000BF7D1D3867545A40508D976E12C34E40	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
germany	Allemagne	\N	Berlin	Allemand	Euro	Europe	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000BA490C022BE724403E7958A835954940	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
uk	Royaume-Uni	\N	Londres	Anglais	Livre sterling	Europe	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000DA1B7C613255C0BFC5FEB27BF2C04940	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
japan	Japon	\N	Tokyo	Japonais	Yen	Asie	\N	\N	\N	\N	\N	\N	\N	0101000020E610000012A5BDC117486140431CEBE2361A4240	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
india	Inde	\N	New Delhi	Hindi	Roupie indienne	Asie	\N	\N	\N	\N	\N	\N	\N	0101000020E610000061545227A0BD53409CA223B9FC973440	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
brazil	Brésil	\N	Brasília	Portugais	Real	Amérique du Sud	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000917EFB3A70F649C0B81E85EB51782CC0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
australia	Australie	\N	Canberra	Anglais	Dollar australien	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E610000026E4839ECDB86040BC0512143F4639C0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
canada	Canada	\N	Ottawa	Anglais, Français	Dollar canadien	Amérique du Nord	\N	\N	\N	\N	\N	\N	\N	0101000020E61000002E90A0F831965AC0FFB27BF2B0104C40	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
south-africa	Afrique du Sud	\N	Pretoria	Afrikaans, Anglais	Rand	Afrique	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000AEB6627FD9FD3840AC1C5A643B8F3EC0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
iran	Iran	\N	Téhéran	Persan	Rial	Asie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000F2D24D6210D84A40ADFA5C6DC5364040	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
saudi-arabia	Arabie Saoudite	\N	Riyad	Arabe	Riyal	Asie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000EEEBC039238A4640C286A757CAE23740	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
south-korea	Corée du Sud	\N	Séoul	Coréen	Won	Asie	\N	\N	\N	\N	\N	\N	\N	0101000020E61000005BD3BCE314F15F4087A757CA32F44140	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
north-korea	Corée du Nord	\N	Pyongyang	Coréen	Won nord-coréen	Asie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000226C787AA5E05F4088F4DBD7812B4440	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
thailand	Thaïlande	\N	Bangkok	Thaï	Baht	Asie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000EC51B81E853F59403D0AD7A370BD2F40	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
fiji	Fidji	\N	Suva	Anglais, Fidjien	Dollar fidjien	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000AE47E17A1442664066F7E461A1B631C0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
new-zealand	Nouvelle-Zélande	\N	Wellington	Anglais, Maori	Dollar néo-zélandais	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000F7E461A1D6D8654088635DDC467344C0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
vanuatu	Vanuatu	\N	Port-Vila	Bichelamar, Anglais, Français	Vatu	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E610000009F9A067B3DE644070CE88D2DEC02EC0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
samoa	Samoa	\N	Apia	Samoan, Anglais	Tala	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000AD69DE718A7865C0A4DFBE0E9CB32BC0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
tonga	Tonga	\N	Nuku'alofa	Anglais, Tongan	Pa'anga	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E610000027C286A757E665C0E7FBA9F1D22D35C0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
tuvalu	Tuvalu	\N	Funafuti	Tuvaluan, Anglais	Dollar tuvaluan	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E61000007D3F355EBA436640E3A59BC420701CC0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
kiribati	Kiribati	\N	Tarawa	Gilbertese, Anglais	Dollar australien	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000C1A8A44E40B565407E1D38674469F53F	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
marshall-islands	Îles Marshall	\N	Majuro	Marshallese, Anglais	Dollar américain	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000D6C56D34801765402DB29DEFA7861C40	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
micronesia	Micronésie	\N	Palikir	Anglais	Dollar américain	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000C58F31772DC56340FB5C6DC5FEB21B40	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
nauru	Nauru	\N	Yaren	Nauruan, Anglais	Dollar australien	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E61000002B8716D9CEDD64405F29CB10C7BAE0BF	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
palau	Palaos	\N	Ngerulmud	Anglais, Palauan	Dollar américain	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000713D0AD7A3D260408FC2F5285C0F1E40	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
papua-new-guinea	Papouasie-Nouvelle-Guinée	\N	Port Moresby	Anglais, Tok Pisin	Kina	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E61000007F6ABC7493FE6140C3F5285C8F4219C0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
solomon-islands	Îles Salomon	\N	Honiara	Anglais	Dollar des Îles Salomon	Océanie	\N	\N	\N	\N	\N	\N	\N	0101000020E610000005A3923A01056440ED0DBE30994A23C0	\N	2025-07-05 21:19:53.087586	2025-07-05 21:19:53.087586
indonesia	Indonésie	\N	Jakarta	Indonésien	Roupie indonésienne (IDR)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000005E4000000000000000C0	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
bangladesh	Bangladesh	\N	Dhaka	Bengali	Taka (BDT)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008056400000000000003840	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
vietnam	Vietnam	\N	Hanoï	Vietnamien	Dong (VND)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000005B400000000000003040	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
egypt	Égypte	\N	Le Caire	Arabe	Livre égyptienne (EGP)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003E400000000000003A40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
algeria	Algérie	\N	Alger	Arabe	Dinar algérien (DZD)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000008400000000000003C40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
morocco	Maroc	\N	Rabat	Arabe	Dirham marocain (MAD)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000014C00000000000004040	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
mexico	Mexique	\N	Mexico	Espagnol	Peso mexicain (MXN)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008059C00000000000003740	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
argentina	Argentine	\N	Buenos Aires	Espagnol	Peso argentin (ARS)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000050C000000000000041C0	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
ukraine	Ukraine	\N	Kiev	Ukrainien	Hryvnia (UAH)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000040400000000000804840	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
taiwan	Taïwan	\N	Taipei	Mandarin	Dollar taïwanais (TWD)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000405E400000000000803740	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
switzerland	Suisse	\N	Berne	Allemand, Français, Italien	Franc suisse (CHF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000020400000000000804740	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
singapore	Singapour	\N	Singapour	Anglais, Mandarin, Malais, Tamoul	Dollar de Singapour (SGD)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000003333333333F35940CDCCCCCCCCCCF43F	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
netherlands	Pays-Bas	\N	Amsterdam	Néerlandais	Euro (EUR)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000016400000000000004A40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
uae	Émirats arabes unis	\N	Abu Dhabi	Arabe	Dirham des Émirats (AED)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000004B400000000000003840	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
pakistan	Pakistan	\N	Islamabad	Ourdou, Anglais	Roupie pakistanaise (PKR)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008051400000000000003E40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
nigeria	Nigeria	\N	Abuja	Anglais	Naira (NGN)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000020400000000000002440	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
qatar	Qatar	\N	Doha	Arabe	Riyal qatari (QAR)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000006666666666A649400000000000803940	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
kazakhstan	Kazakhstan	\N	Nour-Soultan	Kazakh, Russe	Tenge (KZT)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000051400000000000004840	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
namibia	Namibie	\N	Windhoek	Anglais	Dollar namibien (NAD)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000000000000000314000000000000036C0	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
uzbekistan	Ouzbékistan	\N	Tachkent	Ouzbek	Sum (UZS)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000050400000000000804440	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
chile	Chili	\N	Santiago	Espagnol	Peso chilien (CLP)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000C051C00000000000003EC0	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
bolivia	Bolivie	\N	La Paz	Espagnol	Boliviano (BOB)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000004050C000000000000031C0	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
peru	Pérou	\N	Lima	Espagnol	Sol (PEN)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000053C000000000000024C0	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
botswana	Botswana	\N	Gaborone	Anglais, Tswana	Pula (BWP)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E6100000000000000000384000000000000036C0	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
drc	République démocratique du Congo	\N	Kinshasa	Français	Franc congolais (CDF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000039400000000000000000	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
congo	République du Congo	\N	Brazzaville	Français	Franc CFA (XAF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000002E40000000000000F0BF	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
philippines	Philippines	\N	Manille	Filipino, Anglais	Peso philippin (PHP)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000805E400000000000002A40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
new-caledonia	Nouvelle-Calédonie	\N	Nouméa	Français	Franc CFP (XPF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000B0644000000000008035C0	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
cuba	Cuba	\N	La Havane	Espagnol	Peso cubain (CUP)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000054C00000000000803540	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
turkey	Turquie	\N	Ankara	Turc	Livre turque (TRY)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008041400000000000804340	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
iraq	Irak	\N	Bagdad	Arabe	Dinar irakien (IQD)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000046400000000000804040	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
ethiopia	Éthiopie	\N	Addis-Abeba	Amharique	Birr (ETB)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000044400000000000002240	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
eritrea	Érythrée	\N	Asmara	Tigrinya	Nakfa (ERN)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008043400000000000002E40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
libya	Libye	\N	Tripoli	Arabe	Dinar libyen (LYD)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000031400000000000003940	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
mali	Mali	\N	Bamako	Français	Franc CFA (XOF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000010C00000000000003140	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
niger	Niger	\N	Niamey	Français	Franc CFA (XOF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000020400000000000003240	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
burkina-faso	Burkina Faso	\N	Ouagadougou	Français	Franc CFA (XOF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000000C00000000000002840	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
chad	Tchad	\N	N'Djamena	Français, Arabe	Franc CFA (XAF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000033400000000000002E40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
somalia	Somalie	\N	Mogadiscio	Somali, Arabe	Shilling somalien (SOS)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000008048400000000000002440	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
central-african-republic	République centrafricaine	\N	Bangui	Français	Franc CFA (XAF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000035400000000000001C40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
south-sudan	Soudan du Sud	\N	Djouba	Anglais	Livre sud-soudanaise (SSP)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003E400000000000001C40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
democratic-republic-of-congo	République démocratique du Congo	\N	Kinshasa	Français	Franc congolais (CDF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000039400000000000000000	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
rwanda	Rwanda	\N	Kigali	Kinyarwanda, Français, Anglais	Franc rwandais (RWF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003E4000000000000000C0	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
uganda	Ouganda	\N	Kampala	Anglais	Shilling ougandais (UGX)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000004040000000000000F03F	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
sri-lanka	Sri Lanka	\N	Colombo	Cingalais, Tamoul	Roupie srilankaise (LKR)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000004054400000000000001C40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
serbia	Serbie	\N	Belgrade	Serbe	Dinar serbe (RSD)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000035400000000000004640	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
croatia	Croatie	\N	Zagreb	Croate	Kuna (HRK)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000002E400000000000804640	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
bosnia-herzegovina	Bosnie-Herzégovine	\N	Sarajevo	Bosniaque, Croate, Serbe	Mark convertible (BAM)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000032400000000000004640	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
kosovo	Kosovo	\N	Pristina	Albanais, Serbe	Euro (EUR)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E61000000000000000003540CDCCCCCCCC4C4540	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
afghanistan	Afghanistan	\N	Kaboul	Pachto, Dari	Afghani (AFN)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000004050400000000000804040	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
poland	Pologne	\N	Varsovie	Polonais	Zloty (PLN)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000033400000000000004A40	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
hungary	Hongrie	\N	Budapest	Hongrois	Forint (HUF)	\N	\N	\N	\N	\N	\N	\N	\N	0101000020E610000000000000000034400000000000804740	\N	2025-07-05 21:42:56.989894	2025-07-05 21:42:56.989894
\.


--
-- Data for Name: country_agricultural_production; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_agricultural_production (id, country_id, product_id, production_value, production_unit, production_year, percentage_of_global) FROM stdin;
1	china	ble	136.9	millions de tonnes	2021	17.60
2	india	ble	109.5	millions de tonnes	2021	14.10
3	russia	ble	85.9	millions de tonnes	2021	11.10
4	usa	ble	44.8	millions de tonnes	2021	5.80
5	france	ble	35.0	millions de tonnes	2021	4.50
6	uk	ble	15.6	millions de tonnes	2021	2.00
7	germany	ble	22.2	millions de tonnes	2021	2.90
8	canada	ble	32.3	millions de tonnes	2021	4.20
21	china	ble	136.9	millions de tonnes	2021	17.60
22	india	ble	109.5	millions de tonnes	2021	14.10
23	russia	ble	85.9	millions de tonnes	2021	11.10
24	usa	ble	44.8	millions de tonnes	2021	5.80
25	france	ble	35.0	millions de tonnes	2021	4.50
26	uk	ble	15.6	millions de tonnes	2021	2.00
27	germany	ble	22.2	millions de tonnes	2021	2.90
28	canada	ble	32.3	millions de tonnes	2021	4.20
29	china	riz	212.8	millions de tonnes	2021	40.90
30	india	riz	178.3	millions de tonnes	2021	34.30
31	indonesia	riz	54.4	millions de tonnes	2021	10.50
32	bangladesh	riz	54.7	millions de tonnes	2021	10.50
33	vietnam	riz	43.4	millions de tonnes	2021	8.30
34	thailand	riz	21.3	millions de tonnes	2021	4.10
35	usa	mais	383.9	millions de tonnes	2021	33.00
36	china	mais	272.6	millions de tonnes	2021	23.50
37	brazil	mais	87.0	millions de tonnes	2021	7.50
38	argentina	mais	51.0	millions de tonnes	2021	4.40
39	ukraine	mais	42.1	millions de tonnes	2021	3.60
40	india	mais	31.0	millions de tonnes	2021	2.70
\.


--
-- Data for Name: country_conflict; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_conflict (country_id, conflict_id, role) FROM stdin;
russia	conflit-ukraine-2022	Agresseur
usa	conflit-ukraine-2022	Soutien militaire
france	conflit-ukraine-2022	Soutien militaire
germany	conflit-ukraine-2022	Soutien militaire
uk	conflit-ukraine-2022	Soutien militaire
\.


--
-- Data for Name: country_industry; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_industry (country_id, industry_id, production_volume, importance) FROM stdin;
usa	automobile	{"rang": 2, "volume": "8.8 millions véhicules"}	Très importante
china	automobile	{"rang": 1, "volume": "26.1 millions véhicules"}	Très importante
japan	automobile	{"rang": 3, "volume": "7.8 millions véhicules"}	Très importante
germany	automobile	{"rang": 4, "volume": "3.7 millions véhicules"}	Très importante
usa	informatique	{"rang": 1, "volume": "Leader mondial"}	Très importante
china	informatique	{"rang": 2, "volume": "Second producteur"}	Très importante
usa	pharmaceutique	{"rang": 1, "volume": "Leader mondial"}	Très importante
germany	pharmaceutique	{"rang": 2, "volume": "Second producteur"}	Très importante
\.


--
-- Data for Name: country_natural_resource; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_natural_resource (id, country_id, resource_id, abundance_level, locations, production_value, production_unit, production_year) FROM stdin;
\.


--
-- Data for Name: country_organization; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_organization (country_id, organization_id, role, date_adhesion, statut) FROM stdin;
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
-- Data for Name: country_relation; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_relation (country_id, relation_id, role) FROM stdin;
\.


--
-- Data for Name: country_resource; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.country_resource (country_id, resource_id, production_volume, reserves) FROM stdin;
saudi-arabia	petrole	{"rang": 2, "volume": "10.8 millions b/j"}	{"rang": 2, "reserves": "267 milliards barils"}
russia	petrole	{"rang": 3, "volume": "10.1 millions b/j"}	{"rang": 8, "reserves": "80 milliards barils"}
usa	petrole	{"rang": 1, "volume": "11.6 millions b/j"}	{"rang": 9, "reserves": "69 milliards barils"}
china	lithium	{"rang": 3, "volume": "14 000 tonnes"}	{"rang": 4, "reserves": "1.5 millions tonnes"}
australia	lithium	{"rang": 1, "volume": "55 000 tonnes"}	{"rang": 1, "reserves": "6.2 millions tonnes"}
china	terres-rares	{"rang": 1, "volume": "168 000 tonnes"}	{"rang": 1, "reserves": "44 millions tonnes"}
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

COPY public.demographic_data (id, country_id, year, population, median_age, fertility_rate, life_expectancy, urbanization_rate, elderly_percentage, gdp_per_capita, hdi_index, literacy_rate, data_source) FROM stdin;
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

COPY public.industry (id, nom, categorie, description, production_mondiale, tendances, chaine_approvisionnement, created_at, updated_at) FROM stdin;
automobile	Industrie automobile	Transport	Fabrication de véhicules automobiles	\N	\N	\N	2025-07-05 21:19:53.138289	2025-07-05 21:19:53.138289
aerospatial	Industrie aérospatiale	Transport	Fabrication d'avions et satellites	\N	\N	\N	2025-07-05 21:19:53.138289	2025-07-05 21:19:53.138289
pharmaceutique	Industrie pharmaceutique	Santé	Fabrication de médicaments	\N	\N	\N	2025-07-05 21:19:53.138289	2025-07-05 21:19:53.138289
informatique	Industrie informatique	Technologie	Fabrication d'ordinateurs et logiciels	\N	\N	\N	2025-07-05 21:19:53.138289	2025-07-05 21:19:53.138289
textile	Industrie textile	Consommation	Fabrication de vêtements et tissus	\N	\N	\N	2025-07-05 21:19:53.138289	2025-07-05 21:19:53.138289
agroalimentaire	Industrie agroalimentaire	Alimentation	Transformation des produits agricoles	\N	\N	\N	2025-07-05 21:19:53.138289	2025-07-05 21:19:53.138289
chimie	Industrie chimique	Matériaux	Fabrication de produits chimiques	\N	\N	\N	2025-07-05 21:19:53.138289	2025-07-05 21:19:53.138289
energie	Industrie énergétique	Énergie	Production et distribution d'énergie	\N	\N	\N	2025-07-05 21:19:53.138289	2025-07-05 21:19:53.138289
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
-- Data for Name: megacity; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.megacity (id, name, country_id, population, unit, year) FROM stdin;
\.


--
-- Data for Name: natural_resource; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.natural_resource (id, name, category, description, global_reserves_value, global_reserves_unit, global_reserves_year) FROM stdin;
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.organization (id, nom, type, description, date_creation, siege, created_at, updated_at) FROM stdin;
onu	Organisation des Nations Unies	Organisation internationale	Organisation internationale pour la paix et la sécurité	1945-10-24	New York, États-Unis	2025-07-05 21:19:53.132393	2025-07-05 21:19:53.132393
otan	Organisation du Traité de l'Atlantique Nord	Alliance militaire	Alliance militaire occidentale	1949-04-04	Bruxelles, Belgique	2025-07-05 21:19:53.132393	2025-07-05 21:19:53.132393
ue	Union européenne	Union politique et économique	Union politique et économique européenne	1993-11-01	Bruxelles, Belgique	2025-07-05 21:19:53.132393	2025-07-05 21:19:53.132393
g7	Groupe des Sept	Forum économique	Forum des sept pays les plus industrialisés	1975-01-01	Rotation annuelle	2025-07-05 21:19:53.132393	2025-07-05 21:19:53.132393
g20	Groupe des Vingt	Forum économique	Forum des vingt principales économies	1999-01-01	Rotation annuelle	2025-07-05 21:19:53.132393	2025-07-05 21:19:53.132393
apec	Coopération économique Asie-Pacifique	Forum économique	Forum de coopération économique Asie-Pacifique	1989-01-01	Singapour	2025-07-05 21:19:53.132393	2025-07-05 21:19:53.132393
mercosur	Mercosur	Union douanière	Marché commun du Sud	1991-03-26	Montevideo, Uruguay	2025-07-05 21:19:53.132393	2025-07-05 21:19:53.132393
asean	Association des nations de l'Asie du Sud-Est	Organisation régionale	Association des nations de l'Asie du Sud-Est	1967-08-08	Jakarta, Indonésie	2025-07-05 21:19:53.132393	2025-07-05 21:19:53.132393
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
democratie-representative	Démocratie représentative	Système dans lequel les citoyens élisent des représentants qui prennent les décisions en leur nom.	["Élections libres et régulières", "Séparation des pouvoirs", "Protection des libertés civiles", "État de droit"]	["usa", "france", "germany", "uk", "canada"]
monarchie-constitutionnelle	Monarchie constitutionnelle	Système dans lequel un monarque est le chef d'État, mais son pouvoir est limité par une constitution.	["Monarque comme chef d'État", "Pouvoir limité par la constitution", "Parlement élu", "Premier ministre comme chef de gouvernement"]	["uk", "spain", "sweden", "norway", "japan"]
republique-federale	République fédérale	Système où le pouvoir est partagé entre un gouvernement central et des entités fédérées.	["Constitution écrite définissant les pouvoirs", "Autonomie des entités fédérées", "Double niveau de gouvernement", "Mécanismes de résolution des conflits de compétence"]	["usa", "germany", "brazil", "india", "australia"]
regime-autoritaire	Régime autoritaire	Système où le pouvoir politique est concentré et les libertés individuelles limitées.	["Concentration du pouvoir", "Limitations des libertés civiles", "Contrôle des médias", "Restrictions du pluralisme politique"]	["china", "russia", "north-korea", "iran", "saudi-arabia"]
democratie-directe	Démocratie directe	Système où les citoyens participent directement aux décisions politiques.	["Référendums fréquents", "Initiative populaire", "Participation directe", "Transparence des processus"]	["switzerland"]
republique-parlementaire	République parlementaire	Système où le chef de l'État est élu mais le pouvoir exécutif appartient au gouvernement responsable devant le parlement.	["Chef d'État élu", "Gouvernement responsable devant le parlement", "Séparation des pouvoirs", "Élections législatives déterminantes"]	["germany", "italy", "india", "south-africa"]
republique-presidentielle	République présidentielle	Système où le président est à la fois chef de l'État et chef du gouvernement.	["Président élu au suffrage universel", "Pouvoirs exécutifs étendus", "Séparation stricte des pouvoirs", "Veto présidentiel"]	["usa", "brazil", "france", "russia"]
monarchie-absolue	Monarchie absolue	Système où le monarque détient tous les pouvoirs sans limitation constitutionnelle.	["Pouvoir absolu du monarque", "Absence de constitution limitative", "Hérédité du pouvoir", "Contrôle total de l'État"]	["saudi-arabia", "brunei", "oman"]
regime-hybride	Régime hybride	Système combinant des éléments démocratiques et autoritaires.	["Élections mais avec restrictions", "Libertés civiles partielles", "Contrôle médiatique", "Opposition limitée"]	["russia", "turkey", "hungary", "poland"]
theocratie	Théocratie	Système où le pouvoir politique est exercé au nom de la religion.	["Autorité religieuse suprême", "Lois basées sur la religion", "Clergé au pouvoir", "Fusion religion-État"]	["iran", "vatican"]
\.


--
-- Data for Name: political_transition; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.political_transition (id, from_regime_id, to_regime_id, country_id, year, description) FROM stdin;
\.


--
-- Data for Name: relation; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.relation (id, type, description, date_debut, date_fin, statut, created_at, updated_at) FROM stdin;
alliance-otan	Alliance militaire	Alliance militaire occidentale	1949-04-04	\N	Actif	2025-07-05 21:19:53.133918	2025-07-05 21:19:53.133918
alliance-ue	Union politique	Union politique et économique européenne	1993-11-01	\N	Actif	2025-07-05 21:19:53.133918	2025-07-05 21:19:53.133918
conflit-ukraine	Conflit armé	Conflit en Ukraine	2022-02-24	\N	En cours	2025-07-05 21:19:53.133918	2025-07-05 21:19:53.133918
accord-paris	Accord climatique	Accord de Paris sur le climat	2015-12-12	\N	Actif	2025-07-05 21:19:53.133918	2025-07-05 21:19:53.133918
sanctions-russie	Sanctions économiques	Sanctions contre la Russie	2022-02-24	\N	Actif	2025-07-05 21:19:53.133918	2025-07-05 21:19:53.133918
commerce-chine-usa	Relations commerciales	Relations commerciales Chine-États-Unis	1979-01-01	\N	Actif	2025-07-05 21:19:53.133918	2025-07-05 21:19:53.133918
\.


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.resource (id, nom, categorie, description, reserves_mondiales, usages, impact_environnemental, enjeux_geopolitiques, created_at, updated_at) FROM stdin;
petrole	Pétrole	Énergie fossile	Ressource énergétique principale	\N	\N	Élevé - émissions CO2	Contrôle des routes maritimes, dépendance énergétique	2025-07-05 21:19:53.137844	2025-07-05 21:19:53.137844
gaz-naturel	Gaz naturel	Énergie fossile	Ressource énergétique en croissance	\N	\N	Moyen - émissions CO2	Routes d'approvisionnement, diversification énergétique	2025-07-05 21:19:53.137844	2025-07-05 21:19:53.137844
uranium	Uranium	Énergie nucléaire	Ressource pour énergie nucléaire	\N	\N	Faible - déchets radioactifs	Prolifération nucléaire, sécurité	2025-07-05 21:19:53.137844	2025-07-05 21:19:53.137844
lithium	Lithium	Métal rare	Ressource pour batteries	\N	\N	Moyen - extraction minière	Transition énergétique, contrôle des chaînes d'approvisionnement	2025-07-05 21:19:53.137844	2025-07-05 21:19:53.137844
terres-rares	Terres rares	Métaux rares	Ressources pour technologies	\N	\N	Élevé - extraction polluante	Monopole chinois, technologies vertes	2025-07-05 21:19:53.137844	2025-07-05 21:19:53.137844
eau	Eau douce	Ressource vitale	Ressource essentielle à la vie	\N	\N	Faible - gestion durable	Conflits d'usage, changement climatique	2025-07-05 21:19:53.137844	2025-07-05 21:19:53.137844
poissons	Ressources halieutiques	Ressource alimentaire	Ressources marines pour alimentation	\N	\N	Moyen - surpêche	Zones économiques exclusives, surpêche	2025-07-05 21:19:53.137844	2025-07-05 21:19:53.137844
bois	Bois	Ressource renouvelable	Ressource forestière	\N	\N	Faible - gestion durable	Déforestation, puits de carbone	2025-07-05 21:19:53.137844	2025-07-05 21:19:53.137844
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

COPY public.technology_country_leadership (id, subsector_id, country_id, strengths, companies) FROM stdin;
\.


--
-- Data for Name: technology_sector; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.technology_sector (id, name, description, global_market_value, global_market_unit, global_market_year, cagr) FROM stdin;
\.


--
-- Data for Name: technology_subsector; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.technology_subsector (id, sector_id, name, description, status, applications, geopolitical_issues) FROM stdin;
\.


--
-- Data for Name: tourism_data; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.tourism_data (id, country_id, annual_visitors, visitors_year, major_attractions, economic_impact, economic_impact_unit) FROM stdin;
\.


--
-- Data for Name: trade_route; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.trade_route (id, nom, type, endpoints, volume, biens_transportes, chokepoints, ports, geo_json_ref, created_at, updated_at) FROM stdin;
route-suez	Route de Suez	Maritime	{"depart": "Méditerranée", "arrivee": "Océan Indien"}	{"volume": "12% du commerce mondial"}	["Pétrole", "Conteneurs", "Céréales"]	\N	\N	trade-routes.geo.json#Suez	2025-07-05 21:19:53.152645	2025-07-05 21:19:53.152645
route-malacca	Détroit de Malacca	Maritime	{"depart": "Océan Indien", "arrivee": "Pacifique"}	{"volume": "25% du commerce mondial"}	["Pétrole", "Conteneurs", "Matières premières"]	\N	\N	trade-routes.geo.json#Malacca	2025-07-05 21:19:53.152645	2025-07-05 21:19:53.152645
route-hormuz	Détroit d'Ormuz	Maritime	{"depart": "Golfe Persique", "arrivee": "Océan Indien"}	{"volume": "21% du pétrole mondial"}	["Pétrole", "Gaz naturel"]	\N	\N	trade-routes.geo.json#Hormuz	2025-07-05 21:19:53.152645	2025-07-05 21:19:53.152645
route-panama	Canal de Panama	Maritime	{"depart": "Atlantique", "arrivee": "Pacifique"}	{"volume": "5% du commerce mondial"}	["Conteneurs", "Céréales", "Produits manufacturés"]	\N	\N	trade-routes.geo.json#Panama	2025-07-05 21:19:53.152645	2025-07-05 21:19:53.152645
\.


--
-- Data for Name: transport_data; Type: TABLE DATA; Schema: public; Owner: wikigeo_user
--

COPY public.transport_data (id, country_id, transport_type, volume_value, volume_unit, volume_year, routes, infrastructure_data) FROM stdin;
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

SELECT pg_catalog.setval('public.armed_conflict_id_seq', 1, false);


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

SELECT pg_catalog.setval('public.megacity_id_seq', 1, false);


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
-- Name: country_conflict country_conflict_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_conflict
    ADD CONSTRAINT country_conflict_pkey PRIMARY KEY (country_id, conflict_id);


--
-- Name: country_industry country_industry_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_industry
    ADD CONSTRAINT country_industry_pkey PRIMARY KEY (country_id, industry_id);


--
-- Name: country_natural_resource country_natural_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_natural_resource
    ADD CONSTRAINT country_natural_resource_pkey PRIMARY KEY (id);


--
-- Name: country_organization country_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_organization
    ADD CONSTRAINT country_organization_pkey PRIMARY KEY (country_id, organization_id);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: country_relation country_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_relation
    ADD CONSTRAINT country_relation_pkey PRIMARY KEY (country_id, relation_id);


--
-- Name: country_resource country_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_resource
    ADD CONSTRAINT country_resource_pkey PRIMARY KEY (country_id, resource_id);


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

CREATE INDEX idx_agricultural_production_country_product ON public.country_agricultural_production USING btree (country_id, product_id);


--
-- Name: idx_conflict_countries; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_conflict_countries ON public.armed_conflict USING gin (involved_countries);


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

CREATE INDEX idx_demographic_data_country_year ON public.demographic_data USING btree (country_id, year);


--
-- Name: idx_industry_country; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_industry_country ON public.country_industry USING btree (country_id);


--
-- Name: idx_natural_resource_country; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_natural_resource_country ON public.country_natural_resource USING btree (country_id);


--
-- Name: idx_technology_leadership_country; Type: INDEX; Schema: public; Owner: wikigeo_user
--

CREATE INDEX idx_technology_leadership_country ON public.technology_country_leadership USING btree (country_id);


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
    ADD CONSTRAINT agricultural_export_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- Name: agricultural_export agricultural_export_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_export
    ADD CONSTRAINT agricultural_export_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.agricultural_product(id);


--
-- Name: agricultural_import agricultural_import_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_import
    ADD CONSTRAINT agricultural_import_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- Name: agricultural_import agricultural_import_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.agricultural_import
    ADD CONSTRAINT agricultural_import_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.agricultural_product(id);


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
    ADD CONSTRAINT country_agricultural_production_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- Name: country_agricultural_production country_agricultural_production_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_agricultural_production
    ADD CONSTRAINT country_agricultural_production_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.agricultural_product(id);


--
-- Name: country_conflict country_conflict_conflict_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_conflict
    ADD CONSTRAINT country_conflict_conflict_id_fkey FOREIGN KEY (conflict_id) REFERENCES public.conflict(id) ON DELETE CASCADE;


--
-- Name: country_conflict country_conflict_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_conflict
    ADD CONSTRAINT country_conflict_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: country_industry country_industry_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_industry
    ADD CONSTRAINT country_industry_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: country_industry country_industry_industry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_industry
    ADD CONSTRAINT country_industry_industry_id_fkey FOREIGN KEY (industry_id) REFERENCES public.industry(id) ON DELETE CASCADE;


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
    ADD CONSTRAINT country_organization_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: country_organization country_organization_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_organization
    ADD CONSTRAINT country_organization_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organization(id) ON DELETE CASCADE;


--
-- Name: country_relation country_relation_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_relation
    ADD CONSTRAINT country_relation_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: country_relation country_relation_relation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_relation
    ADD CONSTRAINT country_relation_relation_id_fkey FOREIGN KEY (relation_id) REFERENCES public.relation(id) ON DELETE CASCADE;


--
-- Name: country_resource country_resource_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_resource
    ADD CONSTRAINT country_resource_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id) ON DELETE CASCADE;


--
-- Name: country_resource country_resource_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.country_resource
    ADD CONSTRAINT country_resource_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON DELETE CASCADE;


--
-- Name: demographic_data demographic_data_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.demographic_data
    ADD CONSTRAINT demographic_data_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


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
    ADD CONSTRAINT technology_country_leadership_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- Name: technology_country_leadership technology_country_leadership_subsector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.technology_country_leadership
    ADD CONSTRAINT technology_country_leadership_subsector_id_fkey FOREIGN KEY (subsector_id) REFERENCES public.technology_subsector(id);


--
-- Name: technology_subsector technology_subsector_sector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.technology_subsector
    ADD CONSTRAINT technology_subsector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES public.technology_sector(id);


--
-- Name: tourism_data tourism_data_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.tourism_data
    ADD CONSTRAINT tourism_data_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- Name: transport_data transport_data_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wikigeo_user
--

ALTER TABLE ONLY public.transport_data
    ADD CONSTRAINT transport_data_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- PostgreSQL database dump complete
--

