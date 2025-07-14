# Base de données WikiGeopolitics

## Vue d'ensemble

WikiGeopolitics utilise une **base de données PostgreSQL** avec l'extension **PostGIS** pour gérer les données géospatiales. La base de données est conteneurisée avec Docker pour faciliter le déploiement et la gestion.

**🔄 Mise à jour : Architecture refactorisée et base de données optimisée (Juillet 2025)**
- ✅ **Architecture modulaire** : APIs spécialisées pour chaque entité
- ✅ **Stores spécialisés** : Division de l'asideStore en 4 stores ciblés
- ✅ **Composables réutilisables** : Logic métier centralisée
- ✅ **Client API unifié** : Gestion cohérente des requêtes HTTP
- ✅ **Système de régimes politiques** optimisé avec chefs d'État
- ✅ **35 organisations internationales** rationalisées et harmonisées
- ✅ **238 pays** avec données géopolitiques complètes
- ✅ **Cache intelligent** avec gestion d'erreurs avancée

## Architecture technique

### Technologies utilisées
- **PostgreSQL 15** : Base de données relationnelle principale
- **PostGIS** : Extension pour les données géospatiales
- **Docker & Docker Compose** : Conteneurisation
- **PgAdmin** : Interface d'administration web
- **Beekeeper Studio** : Client SQL recommandé

### Schéma de données (Rationalisé et optimisé)

```mermaid
erDiagram
  COUNTRY ||--o{ COUNTRY_ORGANIZATION : membre
  COUNTRY ||--o{ RESOURCE_COUNTRY : producteur
  COUNTRY ||--o{ CONFLICT_COUNTRY : impliqué
  COUNTRY ||--o{ INDUSTRY_COUNTRY : acteur
  COUNTRY ||--o{ TRADE_ROUTE_COUNTRY : acteur
  COUNTRY ||--o{ COMM_NETWORK_COUNTRY : acteur
  COUNTRY ||--o{ DEMOGRAPHIC : a
  COUNTRY ||--o{ COUNTRY_POLITICAL_REGIME : a
  POLITICAL_REGIME ||--o{ COUNTRY_POLITICAL_REGIME : définit
  ORGANIZATION ||--o{ COUNTRY_ORGANIZATION : membre
  CONFLICT ||--o{ CONFLICT_COUNTRY : participants
  CONFLICT }o--|| RESOURCE : enjeu
  CONFLICT }o--|| TRADE_ROUTE : enjeu
  RESOURCE ||--o{ RESOURCE_COUNTRY : implication
  RESOURCE ||--o{ TRADE_ROUTE : transporte
  INDUSTRY ||--o{ INDUSTRY_COUNTRY : présence
  INDUSTRY ||--o{ COMPANY : contient
  TRADE_ROUTE ||--o{ TRADE_ROUTE_COUNTRY : usage
  COMM_NETWORK ||--o{ COMM_NETWORK_COUNTRY : couverture

  COUNTRY {
    string id
    string nom
    string drapeau
    string capitale
    string langue
    string monnaie
    string continent
    float pib
    int population
    float revenuMedian
    float superficieKm2
    string appartenanceGeographique
    geo coordonnees
    string histoire
    float indiceSouverainete
    float indiceDependance
    string statutStrategique
    date dateCreation
    date dateDerniereMiseAJour
  }

  POLITICAL_REGIME {
    string id
    string name
    string description
    string type
    date created_at
    date updated_at
  }

  COUNTRY_POLITICAL_REGIME {
    string country_id
    string regime_id
    boolean current_regime
    string chef_etat
    date date_prise_poste
    date created_at
    date updated_at
  }

  ORGANIZATION {
    string id
    string nom
    string type
    string description
    date dateCreation
    string siege
  }

  COUNTRY_ORGANIZATION {
    string countryId
    string organizationId
    string role
    date dateAdhesion
    date dateSortie
  }

  CONFLICT {
    string id
    string nom
    string type
    string statut
    date dateDebut
    date dateFin
    string intensite
    geo localisation
    object victimes
    object timeline
    object effortsPaix
    object consequences
  }

  CONFLICT_COUNTRY {
    string conflictId
    string countryId
    string role
    date dateEntree
    date dateSortie
  }

  RESOURCE {
    string id
    string nom
    string categorie
    string description
    object reservesMondiales
    object usages
    string impactEnvironnemental
    string enjeuxGeopolitiques
  }

  RESOURCE_COUNTRY {
    string resourceId
    string countryId
    string role
    float quantite
    string unite
  }

  INDUSTRY {
    string id
    string nom
    string categorie
    string description
    object productionMondiale
    object tendances
    object chaineApprovisionnement
  }

  INDUSTRY_COUNTRY {
    string industryId
    string countryId
    string role
    float valeurAjoutee
    string unite
    date annee
  }

  COMPANY {
    string id
    string nom
    string pays
    string secteur
    object indicateurs
  }

  TRADE_ROUTE {
    string id
    string nom
    string type
    object endpoints
    object volume
    object biensTransportes
    object chokepoints
    object ports
    geo geoJsonRef
  }

  TRADE_ROUTE_COUNTRY {
    string tradeRouteId
    string countryId
    string role
  }

  COMM_NETWORK {
    string id
    string nom
    string type
    string description
    date dateMiseEnService
    object acteurs
    object capacite
    geo geoJsonRef
  }

  COMM_NETWORK_COUNTRY {
    string commNetworkId
    string countryId
    string role
    string statut
  }

  DEMOGRAPHIC {
    string id
    string pays
    object population
    object tendances
    object indicateursSociaux
  }
```

## Configuration Docker

### Fichiers de configuration

#### docker-compose.yml
```yaml
version: '3.8'

services:
  postgres:
    image: postgis/postgis:15-3.4
    container_name: wikigeopolitics-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: wikigeopolitics
      POSTGRES_USER: wikigeo_user
      POSTGRES_PASSWORD: wikigeo_password
      POSTGRES_INITDB_ARGS: "--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
    ports:
      - "5433:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init:/docker-entrypoint-initdb.d
      - ./database/backups:/backups
    networks:
      - wikigeopolitics-network

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: wikigeopolitics-pgadmin
    restart: unless-stopped
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@wikigeopolitics.com
      PGADMIN_DEFAULT_PASSWORD: admin_password
      PGADMIN_CONFIG_SERVER_MODE: 'False'
    ports:
      - "5050:80"
    volumes:
      - pgadmin_data:/var/lib/pgadmin
    networks:
      - wikigeopolitics-network
    depends_on:
      - postgres
```

### Informations de connexion

| Paramètre | Valeur |
|-----------|--------|
| **Host** | localhost |
| **Port** | 5433 |
| **Database** | wikigeopolitics |
| **Username** | wikigeo_user |
| **Password** | wikigeo_password |

### Interface d'administration
- **PgAdmin** : http://localhost:5050
- **Email** : admin@wikigeopolitics.com
- **Password** : admin_password

## Scripts de gestion

### Démarrage de la base de données
```bash
./database/scripts/start-db.sh
```

### Arrêt de la base de données
```bash
./database/scripts/stop-db.sh
```

### Sauvegarde
```bash
./database/scripts/backup.sh
```

### Restauration
```bash
./database/scripts/restore.sh
```

## Structure des tables (Rationalisée)

### Tables principales

#### COUNTRY (Pays)
Table centrale contenant les informations sur les pays avec données économiques et géopolitiques.

```sql
CREATE TABLE country (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    drapeau VARCHAR(255),
    capitale VARCHAR(255),
    langue VARCHAR(255),
    monnaie VARCHAR(100),
    continent VARCHAR(100),
    sections JSONB,
    indicateurs JSONB,
    politique JSONB,
    economie JSONB,
    demographie JSONB,
    frontieres JSONB,
    coordonnees GEOMETRY(POINT, 4326),
    -- Nouvelles colonnes selon le schéma cible
    pib FLOAT,
    population INTEGER,
    revenuMedian FLOAT,
    superficieKm2 FLOAT,
    appartenanceGeographique VARCHAR(100),
    histoire TEXT,
    indiceSouverainete FLOAT,
    indiceDependance FLOAT,
    statutStrategique VARCHAR(100),
    dateCreation DATE,
    dateDerniereMiseAJour DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### POLITICAL_REGIME (Régimes politiques)
Table des types de régimes politiques disponibles.

```sql
CREATE TABLE political_regime (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### COUNTRY_POLITICAL_REGIME (Relation pays-régimes)
Table de relation entre pays et régimes politiques avec informations sur les chefs d'État.

```sql
CREATE TABLE country_political_regime (
    country_id VARCHAR(50) REFERENCES country(id) ON DELETE CASCADE,
    regime_id VARCHAR(50) REFERENCES political_regime(id) ON DELETE CASCADE,
    current_regime BOOLEAN DEFAULT false,
    chef_etat VARCHAR(255),
    date_prise_poste DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (country_id, regime_id)
);
```

## Architecture API et Services

### APIs Spécialisées (Nouveau)

L'architecture a été complètement refactorisée avec des APIs modulaires :

#### `src/services/api/countryAPI.ts`
```typescript
export class CountryAPI {
  async getAll(): Promise<Country[]>
  async getById(id: string): Promise<Country>
  async getDetails(id: string): Promise<CountryDetail>
  async getGeoData(): Promise<any>
  async getByRegime(regimeId: string): Promise<Country[]>
  async getByOrganization(organizationId: string): Promise<Country[]>
  async search(query: string): Promise<Country[]>
}
```

#### `src/services/api/organizationAPI.ts`
```typescript
export class OrganizationAPI {
  async getAll(): Promise<Organization[]>
  async getById(id: string): Promise<Organization>
  async getByType(type?: string): Promise<Record<string, Organization[]> | Organization[]>
  async getCountries(organizationId: string): Promise<any[]>
  async search(query: string): Promise<Organization[]>
}
```

#### `src/services/api/politicalRegimeAPI.ts`
```typescript
export class PoliticalRegimeAPI {
  async getAll(): Promise<PoliticalRegime[]>
  async getById(id: string): Promise<PoliticalRegime>
  async getCountries(regimeId: string): Promise<any[]>
  async search(query: string): Promise<PoliticalRegime[]>
}
```

#### `src/services/api/armedConflictAPI.ts`
```typescript
export class ArmedConflictAPI {
  async getAll(): Promise<ArmedConflict[]>
  async getById(id: string): Promise<ArmedConflict>
  async getByCountry(countryId: string): Promise<ArmedConflict[]>
  async getCombatZones(conflictId: string): Promise<CombatZone[]>
  async search(query: string): Promise<ArmedConflict[]>
}
```

### Client API Unifié

#### `src/utils/apiClient.ts`
```typescript
export class ApiClient {
  private baseURL: string
  private defaultOptions: RequestInit

  async request<T>(endpoint: string, options: RequestInit = {}): Promise<ApiResponse<T>>
  async get<T>(endpoint: string, params?: Record<string, any>): Promise<T>
  async post<T>(endpoint: string, data?: any): Promise<T>
  async put<T>(endpoint: string, data?: any): Promise<T>
  async delete<T>(endpoint: string): Promise<T>
}
```

### Stores Spécialisés (Nouveau)

#### `src/stores/dataStore.ts`
```typescript
export const useDataStore = defineStore('data', {
  state: () => ({
    dataCache: {},
    isLoading: false,
    error: null,
    subPages: {},
    detailPages: {}
  }),
  
  actions: {
    async initializeData(),
    async loadSubPageData(id: string),
    async loadCountriesByRegime(regimeId: string),
    async loadOrganizationsByType(type: string),
    async loadArmedConflicts(),
    setCacheData(key: string, data: any),
    clearCache()
  }
})
```

#### `src/stores/selectionStore.ts`
```typescript
export const useSelectionStore = defineStore('selection', {
  state: () => ({
    appData: { /* ... */ },
    currentDetailData: null,
    selectedCountryId: null,
    selectedOrganizationId: null,
    selectedPoliticalRegimeId: null,
    selectedArmedConflictId: null
  }),
  
  actions: {
    selectCountry(id: string),
    selectOrganization(id: string),
    selectPoliticalRegime(id: string),
    clearAllSelections(),
    syncWithMapStore()
  }
})
```

## Vues utiles

### v_country_organizations
Vue des pays avec leurs organisations
```sql
CREATE OR REPLACE VIEW v_country_organizations AS
SELECT 
    c.id,
    c.nom,
    c.capitale,
    c.continent,
    array_agg(DISTINCT o.nom) as organisations
FROM country c
LEFT JOIN country_organization co ON c.id = co.countryId
LEFT JOIN organization o ON co.organizationId = o.id
GROUP BY c.id, c.nom, c.capitale, c.continent;
```

### v_country_political_regimes_with_leaders
Vue des pays avec leurs régimes politiques et chefs d'État
```sql
CREATE OR REPLACE VIEW v_country_political_regimes_with_leaders AS
SELECT 
    c.nom as pays,
    pr.name as regime_politique,
    cpr.chef_etat,
    cpr.date_prise_poste,
    cpr.current_regime
FROM country c
JOIN country_political_regime cpr ON c.id = cpr.country_id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true
ORDER BY c.nom;
```

### v_organizations_by_type_optimized
Vue optimisée des organisations par type après rationalisation
```sql
CREATE OR REPLACE VIEW v_organizations_by_type_optimized AS
SELECT 
    type,
    COUNT(*) as nombre_organisations,
    array_agg(nom ORDER BY nom) as organisations,
    array_agg(id ORDER BY nom) as organization_ids
FROM organization 
GROUP BY type 
ORDER BY nombre_organisations DESC, type;
```

## Données d'exemple (Post-refactoring)

La base de données contient maintenant des données optimisées et rationalisées :

- **238 pays** avec coordonnées géospatiales et données géopolitiques complètes
- **35 organisations internationales** (rationalisées, redondances supprimées)
- **10 régimes politiques** avec descriptions détaillées
- **238 relations pays-régimes** avec données de chefs d'État (100% complète)
- **17 types d'organisations** harmonisés et cohérents
- **10 conflits armés actifs** avec zones de combat géolocalisées
- **Relations pays-conflits** complètes avec rôles des participants
- **Cache intelligent** pour optimiser les performances
- **APIs spécialisées** pour chaque entité métier

### Organisations par type (après rationalisation)

| Type | Nombre | Exemples |
|------|--------|----------|
| **Organisation commerciale** | 4 | OMC, ZLECAf, ASEAN+3 |
| **Organisation économique** | 4 | APEC, CEA, CEDEAO |
| **Alliance militaire** | 3 | OTAN, ANZUS, SEATO |
| **Organisation diplomatique** | 3 | ONU, CCG, SAARC |
| **Union politique et économique** | 3 | UE, UA, Mercosur |
| **Organisation spécialisée** | 3 | OIT, UNESCO, OMS |
| **Organisation régionale** | 3 | ASEAN, OEA, Ligue arabe |
| **Forum économique** | 2 | G7, G20 |
| **Institution financière** | 2 | FMI, Banque mondiale |
| **Organisation énergétique** | 2 | AIE, Forum des pays exportateurs de gaz |

### Régimes politiques avec statistiques

| Régime | Pays | % | Chef d'État Type |
|--------|------|----|------------------|
| République présidentielle | 108 | 45.4% | Président |
| République parlementaire | 43 | 18.1% | Premier ministre |
| Régime autoritaire | 29 | 12.2% | Dirigeant/Président |
| Monarchie constitutionnelle | 24 | 10.1% | Monarque |
| République fédérale | 23 | 9.7% | Président/Chancellor |
| Théocratie | 7 | 2.9% | Guide suprême/Pape |
| Démocratie directe | 4 | 1.7% | Président du Conseil |

## Nouvelles tables pour les conflits armés (v3.1.0)

### Tables conflits

#### ARMED_CONFLICT (Conflits armés)
```sql
CREATE TABLE armed_conflict (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50),
    start_date DATE,
    end_date DATE,
    intensity VARCHAR(50),
    location GEOMETRY(POINT, 4326),
    involved_countries TEXT[], -- Liste des IDs des pays impliqués
    victims JSONB,
    timeline JSONB,
    peace_efforts JSONB,
    consequences JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### CONFLICT_COMBAT_ZONE (Zones de combat)
```sql
CREATE TABLE conflict_combat_zone (
    id VARCHAR(50) PRIMARY KEY,
    conflict_id VARCHAR(50) REFERENCES armed_conflict(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    coordinates GEOMETRY(POINT, 4326) NOT NULL,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Index pour les conflits armés
```sql
-- Index géospatiaux pour les conflits
CREATE INDEX idx_armed_conflict_location ON armed_conflict USING GIST(location);
CREATE INDEX idx_combat_zone_coordinates ON conflict_combat_zone USING GIST(coordinates);

-- Index pour les relations pays-conflits
CREATE INDEX idx_armed_conflict_countries ON armed_conflict USING GIN(involved_countries);
CREATE INDEX idx_conflict_combat_zone_conflict ON conflict_combat_zone(conflict_id);
```

## Requêtes optimisées avec la nouvelle architecture

### Conflits par pays
```sql
-- Utilisée par l'API armedConflictAPI.getByCountry()
SELECT 
    ac.id, ac.name, ac.description, ac.status, ac.start_date, ac.end_date,
    ac.intensity, ac.involved_countries, ac.victims, ac.timeline
FROM armed_conflict ac
WHERE $1 = ANY(ac.involved_countries)
ORDER BY ac.start_date DESC;
```

### Zones de combat par conflit
```sql
-- Utilisée par l'API armedConflictAPI.getCombatZones()
SELECT 
    ccz.id, ccz.name, ccz.description, ccz.status,
    ST_AsGeoJSON(ccz.coordinates) as coordinates_geojson,
    ST_Y(ccz.coordinates) as latitude,
    ST_X(ccz.coordinates) as longitude
FROM conflict_combat_zone ccz
WHERE ccz.conflict_id = $1
ORDER BY ccz.name;
```

### Pays par régime avec utilisation du cache
```sql
-- Utilisée par l'API politicalRegimeAPI.getCountries()
SELECT 
    c.id, c.nom, c.drapeau, c.capitale, c.continent,
    cpr.chef_etat, cpr.date_prise_poste
FROM country c
JOIN country_political_regime cpr ON c.id = cpr.country_id
WHERE cpr.regime_id = $1 AND cpr.current_regime = true
ORDER BY c.nom;
```

### Organisations avec comptage de membres
```sql
-- Utilisée par l'API organizationAPI.getByType()
SELECT 
    o.id, o.nom, o.type, o.description,
    COUNT(co.countryId) as nombre_membres
FROM organization o
LEFT JOIN country_organization co ON o.id = co.organizationId
WHERE ($1 IS NULL OR o.type = $1)
GROUP BY o.id, o.nom, o.type, o.description
ORDER BY o.type, o.nom;
```

### Recherche unifiée avec filtres
```sql
-- Utilisée par les composables useSearch et useMultiSearch
SELECT id, nom, 'country' as entity_type,
       ts_rank_cd(to_tsvector('french', nom || ' ' || COALESCE(capitale, '')), query) as rank
FROM country, plainto_tsquery('french', $1) query
WHERE to_tsvector('french', nom || ' ' || COALESCE(capitale, '')) @@ query
UNION ALL
SELECT id, nom, 'organization' as entity_type,
       ts_rank_cd(to_tsvector('french', nom || ' ' || COALESCE(description, '')), query) as rank
FROM organization, plainto_tsquery('french', $1) query
WHERE to_tsvector('french', nom || ' ' || COALESCE(description, '')) @@ query
ORDER BY rank DESC, nom;
```

## Maintenance et monitoring

### Index optimisés pour les nouvelles APIs
```sql
-- Index pour les requêtes des APIs spécialisées
CREATE INDEX idx_country_continent ON country(continent);
CREATE INDEX idx_country_political_regime_current ON country_political_regime(country_id, current_regime);
CREATE INDEX idx_organization_type ON organization(type);
CREATE INDEX idx_country_organization_country ON country_organization(countryId);

-- Index de recherche textuelle
CREATE INDEX idx_country_search ON country USING gin(to_tsvector('french', nom || ' ' || COALESCE(capitale, '')));
CREATE INDEX idx_organization_search ON organization USING gin(to_tsvector('french', nom || ' ' || COALESCE(description, '')));
```

### Monitoring des performances
```sql
-- Requête pour surveiller l'utilisation du cache
SELECT 
    schemaname,
    tablename,
    n_tup_ins,
    n_tup_upd,
    n_tup_del,
    n_live_tup,
    last_vacuum,
    last_autovacuum
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY n_live_tup DESC;
```

## Intégration avec l'architecture refactorisée

### Configuration dans les stores
```typescript
// src/stores/dataStore.ts - Utilisation du cache intelligent
const cacheKey = `countries_by_regime_${regimeId}`
if (this.isCached(cacheKey)) {
  return this.getCachedData(cacheKey)
}

const countries = await API.countries.getByRegime(regimeId)
this.setCacheData(cacheKey, countries)
return countries
```

### Utilisation dans les composables
```typescript
// src/composables/useAsyncState.ts - Gestion d'erreurs avancée
const { data, isLoading, error } = useAsyncState(
  () => API.countries.getAll(),
  {
    retryAttempts: 3,
    retryDelay: 1000,
    onError: (error) => uiStore.notifyError('Erreur de chargement', error)
  }
)
```

---

**L'architecture de base de données est maintenant parfaitement alignée avec le refactoring frontend et optimisée pour les performances ! 🚀**