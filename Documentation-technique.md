# Documentation Technique - WikiGeopolitics

## 🎯 Vue d'ensemble

**WikiGeopolitics** est une application web de cartographie géopolitique interactive développée avec une architecture moderne entièrement refactorisée.

**🔄 Mise à jour : Architecture 3.1.0 - Refactoring complet + Conflits Armés (Juillet 2025)**

### Révolution Architecturale

L'application a subi une **transformation complète** avec une approche modulaire et maintenable :

#### ✅ **Stores Spécialisés** (Division d'asideStore 870 → 110 lignes/store)
- **`navigationStore`** : Navigation et gestion des vues
- **`selectionStore`** : Sélections et données d'application
- **`dataStore`** : Cache intelligent et chargement asynchrone
- **`uiStore`** : Interface utilisateur et notifications

#### ✅ **APIs Modulaires** (3 services → 5 APIs spécialisées)
- **`countryAPI`** : Gestion complète des pays et géographie
- **`organizationAPI`** : Organisations internationales
- **`politicalRegimeAPI`** : Régimes politiques et classifications
- **`armedConflictAPI`** : Conflits armés avec zones de combat géolocalisées
- **`navigationAPI`** : Structure de navigation dynamique

#### ✅ **Composables Réutilisables**
- **`useAsyncState`** : Gestion d'état asynchrone avec retry et cache
- **`useSelection`** : Logique de sélection unifiée multi-entités
- **`useNavigation`** : Navigation avec historique complet
- **`useSearch`** : Recherche avancée avec debounce et filtres

#### ✅ **Utilitaires Transversaux**
- **`apiClient`** : Client HTTP unifié avec gestion d'erreurs
- **`filterUtils`** : Logique de filtrage centralisée
- **`formatUtils`** : Formatage de données cohérent

## 🏗️ Architecture technique

### Stack technologique

#### Frontend (Refactorisé)
- **Framework** : Vue.js 3 avec Composition API
- **Language** : TypeScript 5.x avec types stricts
- **Build tool** : Vite 5.x optimisé
- **State management** : Pinia avec stores spécialisés
- **Architecture** : Composables réutilisables + APIs modulaires
- **Styling** : CSS personnalisé avec design tokens
- **Cartographie** : Leaflet.js avec OpenStreetMap
- **Package manager** : Yarn

#### Backend (Optimisé)
- **Framework** : Node.js avec Express et TypeScript
- **APIs** : RESTful spécialisées par domaine
- **Base de données** : PostgreSQL 15 avec PostGIS (Migration vers Supabase en cours)
- **Architecture** : Services modulaires alignés avec frontend
- **Cache** : Intelligent avec TTL configurable
- **Validation** : Schémas TypeScript complets
- **Supabase** : Client intégré pour migration cloud

#### Infrastructure
- **Conteneurisation** : Docker & Docker Compose
- **Base de données** : PostgreSQL 15 avec PostGIS
- **Administration** : PgAdmin interface web
- **Versioning** : Git avec branches spécialisées
- **Documentation** : Inline + guides complets

## 🗄️ Architecture des données refactorisée

### Stores Spécialisés (Nouveau)

#### NavigationStore
```typescript
// src/stores/navigationStore.ts
export const useNavigationStore = defineStore('navigation', {
  state: (): NavigationStoreState => ({
    currentView: {
      type: 'main',
      id: 'main',
      title: '',
      searchEnabled: true,
      hasReturnButton: false,
      items: [],
      organizations: null
    },
    searchQuery: ''
  }),

  getters: {
    isMainView: (state) => state.currentView.type === 'main',
    canSearch: (state) => state.currentView.searchEnabled,
    hasItems: (state) => state.currentView.items?.length > 0,
    currentTitle: (state) => state.currentView.title || 'Accueil'
  },

  actions: {
    async navigateToSubmenu(id: string),
    navigateToCountryList(),
    navigateToPoliticalRegimeList(),
    navigateToOrganizationsList(),
    navigateToArmedConflictsList(),
    returnToMain(),
    updateCurrentView(view: Partial<NavigationState>),
    clearAllSelectionsAndLayers()
  }
})
```

#### SelectionStore
```typescript
// src/stores/selectionStore.ts
export const useSelectionStore = defineStore('selection', {
  state: (): SelectionStoreState => ({
    appData: {
      search: { enabled: true, placeholder: 'Rechercher...' },
      mainNavigation: [],
      countryList: [],
      politicalRegimeList: [],
      organizationList: {},
      armedConflictList: [],
      conflictMarkers: [],
      combatZones: [],
      subPages: {},
      detailPages: {}
    },
    currentDetailData: null,
    selectedCountryId: null,
    selectedOrganizationId: null,
    selectedPoliticalRegimeId: null,
    selectedArmedConflictId: null
  }),

  getters: {
    selectedCountry: (state) => /* logic */,
    hasAnySelection: (state) => /* logic */,
    currentSelectionType: (state) => /* logic */
  },

  actions: {
    selectCountry(id: string),
    selectOrganization(id: string),
    selectPoliticalRegime(id: string),
    selectArmedConflict(id: string),
    clearAllSelections(),
    syncWithMapStore(),
    clearAllSelectionsAndLayers()
  }
})
```

#### DataStore (Cache Intelligent)
```typescript
// src/stores/dataStore.ts
export const useDataStore = defineStore('data', {
  state: (): DataStoreState => ({
    dataCache: {},
    isLoading: false,
    error: null,
    subPages: {},
    detailPages: {}
  }),

  getters: {
    isCached: (state) => (key: string) => key in state.dataCache,
    getCachedData: (state) => (key: string) => state.dataCache[key]
  },

  actions: {
    async initializeData(),
    async loadSubPageData(id: string),
    async loadCountriesByRegime(regimeId: string),
    async loadOrganizationsByType(type: string),
    async loadArmedConflicts(),
    async loadConflictsByCountry(countryId: string),
    async loadCombatZones(conflictId: string),
    setCacheData(key: string, data: any),
    clearCache()
  }
})
```

#### UIStore
```typescript
// src/stores/uiStore.ts
export const useUIStore = defineStore('ui', {
  state: (): UIStoreState => ({
    sidebarCollapsed: false,
    searchVisible: false,
    showModal: false,
    modalContent: null,
    notifications: [],
    isMobile: false,
    screenWidth: window?.innerWidth || 1024,
    expandedSections: {}
  }),

  actions: {
    toggleSidebar(),
    addNotification(notification),
    notifySuccess(title, message),
    notifyError(title, message),
    updateScreenWidth(width),
    initializeResponsive()
  }
})
```

### APIs Spécialisées (Nouveau)

#### Client API Unifié
```typescript
// src/utils/apiClient.ts
export class ApiClient {
  private baseURL: string
  private defaultOptions: RequestInit

  constructor(baseURL: string = 'http://localhost:3000', options: RequestInit = {}) {
    this.baseURL = baseURL.replace(/\/$/, '')
    this.defaultOptions = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      },
      ...options
    }
  }

  async request<T>(endpoint: string, options: RequestInit = {}): Promise<ApiResponse<T>> {
    const url = `${this.baseURL}${endpoint}`
    
    try {
      const response = await fetch(url, {
        ...this.defaultOptions,
        ...options,
        headers: {
          ...this.defaultOptions.headers,
          ...(options.headers || {})
        }
      })

      if (!response.ok) {
        throw new ApiError(`HTTP ${response.status}: ${response.statusText}`, response.status)
      }

      const data = await response.json()
      return {
        data,
        status: response.status,
        statusText: response.statusText
      }
    } catch (error) {
      console.error(`API Error for ${endpoint}:`, error)
      throw error
    }
  }

  async get<T>(endpoint: string, params?: Record<string, any>): Promise<T> {
    const searchParams = params ? `?${new URLSearchParams(params).toString()}` : ''
    const result = await this.request<T>(`${endpoint}${searchParams}`)
    return result.data
  }

  async post<T>(endpoint: string, data?: any): Promise<T> {
    const result = await this.request<T>(endpoint, {
      method: 'POST',
      body: data ? JSON.stringify(data) : undefined
    })
    return result.data
  }
}
```

#### Country API
```typescript
// src/services/api/countryAPI.ts
class CountryAPI {
  private client: ApiClient

  constructor() {
    this.client = new ApiClient()
  }

  async getAll(): Promise<Country[]> {
    console.log('[CountryAPI] Appel getAll...')
    const result = await this.client.get<Country[]>('/api/countries')
    console.log('[CountryAPI] getAll résultat:', result.length, 'pays')
    return result
  }

  async getById(id: string): Promise<Country> {
    return await this.client.get<Country>(`/api/countries/${id}`)
  }

  async getDetails(id: string): Promise<CountryDetail> {
    return await this.client.get<CountryDetail>(`/api/countries/${id}/details`)
  }

  async getByRegime(regimeId: string): Promise<Country[]> {
    return await this.client.get<Country[]>(`/api/political-regimes/${regimeId}/countries`)
  }

  async getConflicts(countryId: string): Promise<ArmedConflict[]> {
    return await this.client.get<ArmedConflict[]>(`/api/countries/${countryId}/conflicts`)
  }

  async getByOrganization(organizationId: string): Promise<Country[]> {
    return await this.client.get<Country[]>(`/api/organizations/${organizationId}/countries`)
  }

  async search(query: string): Promise<Country[]> {
    return await this.client.get<Country[]>(`/api/countries/search?q=${encodeURIComponent(query)}`)
  }
}

export const countryAPI = new CountryAPI()
```

#### Organization API
```typescript
// src/services/api/organizationAPI.ts
class OrganizationAPI {
  private client: ApiClient

  async getAll(): Promise<Organization[]> {
    return await this.client.get<Organization[]>('/api/organizations')
  }

  async getByType(type?: string): Promise<Record<string, Organization[]> | Organization[]> {
    if (type) {
      return await this.client.get<Organization[]>(`/api/organizations?type=${type}`)
    }
    return await this.client.get<Record<string, Organization[]>>('/api/organizations/by-type')
  }

  async getCountries(organizationId: string): Promise<any[]> {
    return await this.client.get<any[]>(`/api/organizations/${organizationId}/countries`)
  }

  async search(query: string): Promise<Organization[]> {
    return await this.client.get<Organization[]>(`/api/organizations/search?q=${encodeURIComponent(query)}`)
  }
}

export const organizationAPI = new OrganizationAPI()
```

#### Armed Conflict API (🆕 v3.1.0)
```typescript
// src/services/api/armedConflictAPI.ts
class ArmedConflictAPI {
  private client: ApiClient

  async getAll(): Promise<ArmedConflict[]> {
    console.log('[ArmedConflictAPI] Récupération de tous les conflits')
    return await this.client.get<ArmedConflict[]>('/api/armed-conflicts')
  }

  async getById(id: string): Promise<ArmedConflict> {
    return await this.client.get<ArmedConflict>(`/api/armed-conflicts/${id}`)
  }

  async getByCountry(countryId: string): Promise<ArmedConflict[]> {
    console.log('[ArmedConflictAPI] Conflits pour pays:', countryId)
    try {
      // Appel API principal
      return await this.client.get<ArmedConflict[]>(`/api/countries/${countryId}/conflicts`)
    } catch (error) {
      console.warn('[ArmedConflictAPI] Fallback vers filtrage côté client')
      // Fallback : filtrage côté client
      const allConflicts = await this.getAll()
      return allConflicts.filter((conflict: any) => 
        conflict.involvedcountries && conflict.involvedcountries.includes(countryId)
      )
    }
  }

  async getCombatZones(conflictId: string): Promise<CombatZone[]> {
    console.log('[ArmedConflictAPI] Zones de combat pour conflit:', conflictId)
    return await this.client.get<CombatZone[]>(`/api/armed-conflicts/${conflictId}/combat-zones`)
  }

  async search(query: string): Promise<ArmedConflict[]> {
    return await this.client.get<ArmedConflict[]>(`/api/armed-conflicts/search?q=${encodeURIComponent(query)}`)
  }
}

export const armedConflictAPI = new ArmedConflictAPI()
```

### Composables Réutilisables (Nouveau)

#### useAsyncState
```typescript
// src/composables/useAsyncState.ts
export function useAsyncState<T>(
  asyncFn?: () => Promise<T>,
  options: UseAsyncStateOptions = {}
): AsyncState<T> & AsyncActions<T> {
  const {
    immediate = false,
    retryAttempts = 0,
    retryDelay = 1000,
    onSuccess,
    onError
  } = options

  const data = ref<T | null>(null)
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  async function execute(fn: () => Promise<T>): Promise<T | null> {
    let attempts = 0
    
    while (attempts <= retryAttempts) {
      try {
        isLoading.value = true
        error.value = null
        
        const result = await fn()
        
        data.value = result
        onSuccess?.(result)
        
        return result
      } catch (err) {
        attempts++
        
        if (attempts > retryAttempts) {
          const errorMessage = err instanceof Error ? err.message : 'Unknown error'
          error.value = errorMessage
          onError?.(errorMessage)
          return null
        }
        
        if (retryDelay > 0) {
          await new Promise(resolve => setTimeout(resolve, retryDelay))
        }
      } finally {
        if (attempts > retryAttempts) {
          isLoading.value = false
        }
      }
    }
    
    return null
  }

  function reset(): void {
    data.value = null
    isLoading.value = false
    error.value = null
  }

  if (immediate && asyncFn) {
    execute(asyncFn)
  }

  return {
    data: readonly(data),
    isLoading: readonly(isLoading),
    error: readonly(error),
    execute,
    reset,
    setData: (newData: T) => { data.value = newData },
    setError: (errorMessage: string) => { error.value = errorMessage }
  }
}
```

#### useSelection
```typescript
// src/composables/useSelection.ts
export function useSelection(): SelectionState & SelectionData & SelectionActions {
  const selectedCountries = ref<string[]>([])
  const selectedOrganization = ref<string | null>(null)
  const selectedPoliticalRegime = ref<string | null>(null)
  const selectedArmedConflict = ref<string | null>(null)

  const currentSelection = computed<SelectionType | null>(() => {
    if (selectedCountries.value.length > 0) return 'country'
    if (selectedOrganization.value) return 'organization'
    if (selectedPoliticalRegime.value) return 'politicalRegime'
    if (selectedArmedConflict.value) return 'armedConflict'
    return null
  })

  const hasSelection = computed(() => {
    return selectedCountries.value.length > 0 ||
           selectedOrganization.value !== null ||
           selectedPoliticalRegime.value !== null ||
           selectedArmedConflict.value !== null
  })

  function selectCountry(id: string): void {
    clearNonCountrySelections()
    selectedCountries.value = [id]
    updateMapSelection()
  }

  function clearAllSelections(): void {
    selectedCountries.value = []
    selectedOrganization.value = null
    selectedPoliticalRegime.value = null
    selectedArmedConflict.value = null
    updateMapSelection()
  }

  function updateMapSelection(): void {
    const mapStore = useMapStore()
    mapStore.selectMultipleCountries(selectedCountries.value)
  }

  return {
    selectedCountries: readonly(selectedCountries),
    selectedOrganization: readonly(selectedOrganization),
    selectedPoliticalRegime: readonly(selectedPoliticalRegime),
    selectedArmedConflict: readonly(selectedArmedConflict),
    currentSelection,
    hasSelection,
    selectedCount: computed(() => /* logic */),
    selectCountry,
    selectMultipleCountries,
    toggleCountrySelection,
    selectOrganization,
    selectPoliticalRegime,
    selectArmedConflict,
    clearSelection,
    clearAllSelections,
    isSelected
  }
}
```

#### useSearch
```typescript
// src/composables/useSearch.ts
export function useSearch<T extends Filterable>(
  items: () => T[],
  fields: (keyof T)[] = ['title', 'name']
): SearchState & SearchActions & { results: FilteredData<T> } {
  const query = ref('')
  const isActive = computed(() => query.value.trim().length > 0)

  const results = computed<FilteredData<T>>(() => {
    const original = items()
    const filtered = createSearchFilter(original, query.value, fields)
    
    return {
      original,
      filtered,
      count: filtered.length,
      hasResults: filtered.length > 0
    }
  })

  function setQuery(newQuery: string): void {
    query.value = newQuery
  }

  function clearQuery(): void {
    query.value = ''
  }

  return {
    query: readonly(query),
    isActive,
    results,
    setQuery,
    clearQuery,
    toggle: () => { if (isActive.value) clearQuery() }
  }
}

// Version avec debounce
export function useDebouncedSearch<T extends Filterable>(
  items: () => T[],
  fields: (keyof T)[] = ['title', 'name'],
  delay: number = 300
): SearchState & SearchActions & { results: FilteredData<T> } {
  const immediateQuery = ref('')
  const debouncedQuery = ref('')
  
  let timeoutId: number | null = null

  watch(immediateQuery, (newQuery) => {
    if (timeoutId) {
      clearTimeout(timeoutId)
    }
    
    timeoutId = window.setTimeout(() => {
      debouncedQuery.value = newQuery
    }, delay)
  })

  const isActive = computed(() => debouncedQuery.value.trim().length > 0)

  const results = computed<FilteredData<T>>(() => {
    const original = items()
    const filtered = createSearchFilter(original, debouncedQuery.value, fields)
    
    return {
      original,
      filtered,
      count: filtered.length,
      hasResults: filtered.length > 0
    }
  })

  return {
    query: readonly(immediateQuery),
    isActive,
    results,
    setQuery: (newQuery: string) => { immediateQuery.value = newQuery },
    clearQuery: () => {
      immediateQuery.value = ''
      debouncedQuery.value = ''
      if (timeoutId) {
        clearTimeout(timeoutId)
        timeoutId = null
      }
    },
    toggle: () => { /* logic */ }
  }
}
```

## 🗺️ Interface cartographique

### Configuration Leaflet (Optimisée)
```typescript
// Configuration moderne avec gestion d'erreurs
const mapConfig = {
  center: [20, 0] as L.LatLngTuple,
  zoom: 2,
  minZoom: 1,
  maxZoom: 18,
  layers: [
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors',
      maxZoom: 18,
      subdomains: ['a', 'b', 'c']
    })
  ],
  zoomControl: true,
  attributionControl: true
}

// Intégration avec les nouveaux stores
const setupMapIntegration = () => {
  const selectionStore = useSelectionStore()
  const uiStore = useUIStore()
  
  map.on('click', (e: L.LeafletMouseEvent) => {
    const nearestCountry = findNearestCountry(e.latlng, selectionStore.countries)
    if (nearestCountry) {
      selectionStore.selectCountry(nearestCountry.id)
      uiStore.notifySuccess('Pays sélectionné', `${nearestCountry.nom} sélectionné`)
    }
  })
}
```

### Gestion des marqueurs (Refactorisée)
```typescript
// Utilisation des utilitaires de formatage
const createCountryMarker = (country: Country) => {
  const formattedTitle = formatCountryWithFlag(country)
  const formattedPopulation = formatPopulation(country.population)
  
  const marker = L.marker([country.coordonnees.lat, country.coordonnees.lng], {
    icon: createCustomIcon(country.drapeau),
    title: formattedTitle
  })
  
  marker.bindPopup(`
    <div class="country-popup">
      <h3>${formattedTitle}</h3>
      <p><strong>Capitale:</strong> ${country.capitale}</p>
      <p><strong>Population:</strong> ${formattedPopulation}</p>
    </div>
  `)
  
  marker.on('click', () => {
    const selectionStore = useSelectionStore()
    selectionStore.selectCountry(country.id)
  })
  
  return marker
}
```

## 📱 Interface utilisateur refactorisée

### Structure des composants (Optimisée)
```
src/components/
├── aside/
│   ├── aside.vue              # Conteneur principal avec nouveaux stores
│   ├── AsideMainView.vue      # Vue principale refactorisée
│   ├── AsideNavigationView.vue # Navigation avec composables
│   └── AsideDetailView.vue    # Détails avec formatUtils
├── common/
│   ├── Button.vue             # Boutons réutilisables
│   ├── Search.vue             # Recherche avec useSearch
│   ├── Notification.vue       # Notifications du uiStore
│   └── LoadingSpinner.vue     # Loading avec useAsyncState
├── map/
│   ├── Map.vue                # Carte avec selectionStore
│   └── MapControls.vue        # Contrôles avec uiStore
└── panels/
    ├── UniversalFloatingPanel.vue # Panel universel pour toutes les entités
    ├── GenericFloatingPanel.vue # Panel générique réutilisable
    ├── FloatingDetailPanel.vue # Panel legacy (pays uniquement)
    ├── FloatingDetailView.vue  # Vue détaillée pour pays
    └── details/
        ├── ConflictDetailView.vue     # Vue pour conflits armés
        ├── RegimeDetailView.vue       # Vue pour régimes politiques
        ├── OrganizationDetailView.vue # Vue pour organisations
        └── ResourceDetailView.vue     # Vue pour ressources
```

### Gestion d'état unifiée (Nouveau)
```typescript
// Composant utilisant les nouveaux stores
<script setup lang="ts">
import { useNavigationStore, useSelectionStore, useDataStore, useUIStore } from '@/stores'
import { useAsyncState, useSearch } from '@/composables'
import { formatPopulation, formatCurrency } from '@/utils/formatUtils'

const navigationStore = useNavigationStore()
const selectionStore = useSelectionStore()
const dataStore = useDataStore()
const uiStore = useUIStore()

// État asynchrone avec retry
const { data: countries, isLoading, error } = useAsyncState(
  () => dataStore.loadCountriesByRegime('democracy'),
  {
    retryAttempts: 3,
    retryDelay: 1000,
    onError: (error) => uiStore.notifyError('Erreur de chargement', error)
  }
)

// Recherche avec debounce
const { query, results, setQuery } = useSearch(
  () => selectionStore.countries,
  ['nom', 'capitale']
)

// Sélection unifiée
const selectCountry = (country: Country) => {
  selectionStore.selectCountry(country.id)
  navigationStore.updateCurrentView({
    type: 'countryDetail',
    title: country.nom
  })
}
</script>
```

## 🔧 Services et API refactorisés

### Service unifié (Nouveau)
```typescript
// src/services/readService.ts - Utilise les nouvelles APIs
import { API } from './api'
import type { Country } from '@/types/country'

// === PAYS ===
export async function getAllCountries(): Promise<Country[]> {
  return await API.countries.getAll()
}

export async function getCountryById(id: string): Promise<Country | null> {
  try {
    return await API.countries.getById(id)
  } catch (error) {
    console.error(`Erreur lors de la récupération du pays ${id}:`, error)
    return null
  }
}

export async function getCountriesByRegime(regimeId: string) {
  return await API.countries.getByRegime(regimeId)
}

// === NAVIGATION ===
export async function getNavigationData() {
  return await API.navigation.getNavigationData()
}

// === ORGANISATIONS ===
export async function getOrganizationsByType(type?: string) {
  return await API.organizations.getByType(type)
}

// === RÉGIMES POLITIQUES ===
export async function getAllPoliticalRegimes() {
  return await API.politicalRegimes.getAll()
}
```

### Configuration database optimisée
```typescript
// Configuration avec les nouveaux stores
const dbConfig = {
  host: 'localhost',
  port: 5433,
  database: 'wikigeopolitics',
  user: 'wikigeo_user',
  password: 'wikigeo_password'
}

// Pool de connexions optimisé
const pool = new Pool({
  ...dbConfig,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000
})

// Requêtes optimisées pour les nouvelles APIs
export const getCountriesWithCache = async (cacheKey: string): Promise<Country[]> => {
  const dataStore = useDataStore()
  
  if (dataStore.isCached(cacheKey)) {
    return dataStore.getCachedData(cacheKey)
  }
  
  const query = `
    SELECT 
      c.id, c.nom, c.drapeau, c.capitale, c.continent,
      c.pib, c.population, c.revenuMedian,
      ST_AsGeoJSON(c.coordonnees) as coordonnees,
      pr.name as regime_politique,
      cpr.chef_etat, cpr.date_prise_poste
    FROM country c
    LEFT JOIN country_political_regime cpr ON c.id = cpr.country_id AND cpr.current_regime = true
    LEFT JOIN political_regime pr ON cpr.regime_id = pr.id
    ORDER BY c.nom
  `
  
  const result = await pool.query(query)
  const countries = result.rows.map(row => ({
    ...row,
    coordonnees: JSON.parse(row.coordonnees)
  }))
  
  dataStore.setCacheData(cacheKey, countries)
  return countries
}
```

## 📊 Types TypeScript (Refactorisés)

### Types principaux avec architecture modulaire
```typescript
// Types pour les stores spécialisés
export interface NavigationState {
  type: string
  id: string
  title: string
  searchEnabled: boolean
  hasReturnButton: boolean
  items: any[]
  organizations: any[] | null
  data?: any
}

export interface SelectionState {
  selectedCountries: string[]
  selectedOrganization: string | null
  selectedPoliticalRegime: string | null
  selectedArmedConflict: string | null
}

export interface UIState {
  sidebarCollapsed: boolean
  searchVisible: boolean
  notifications: Notification[]
  isMobile: boolean
  expandedSections: Record<string, boolean>
}

// Types pour les APIs
export interface ApiResponse<T = any> {
  data: T
  status: number
  statusText: string
}

export interface ApiError {
  message: string
  status?: number
  details?: any
}

// Types pour les composables
export interface AsyncState<T> {
  data: Readonly<Ref<T | null>>
  isLoading: Readonly<Ref<boolean>>
  error: Readonly<Ref<string | null>>
}

export interface SearchState {
  query: string
  isActive: boolean
}

export interface FilteredData<T> {
  original: T[]
  filtered: T[]
  count: number
  hasResults: boolean
}

// Types métier optimisés
export interface Country {
  id: string
  nom: string
  drapeau?: string
  capitale?: string
  langue?: string
  monnaie?: string
  continent?: string
  pib?: number
  population?: number
  revenuMedian?: number
  superficieKm2?: number
  appartenanceGeographique?: string
  coordonnees: GeoJSON.Point
  regimePolitique?: string
  chefEtat?: string
  datePrisePoste?: Date
}

export interface Organization {
  id: string
  title: string
  type: string
  description?: string
  countries?: string[]
  founded?: number
  headquarters?: string
}
```

## 🚀 Déploiement et configuration

### Variables d'environnement (Mises à jour)
```bash
# .env - Configuration pour l'architecture refactorisée
VITE_API_URL=http://localhost:3000
VITE_MAP_TILE_URL=https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png

# Base de données
POSTGRES_HOST=localhost
POSTGRES_PORT=5433
POSTGRES_DB=wikigeopolitics
POSTGRES_USER=wikigeo_user
POSTGRES_PASSWORD=wikigeo_password

# Cache et performance
VITE_CACHE_TTL=300000
VITE_RETRY_ATTEMPTS=3
VITE_DEBOUNCE_DELAY=300

# UI et notifications
VITE_NOTIFICATION_DURATION=5000
VITE_MOBILE_BREAKPOINT=768
```

### Scripts de développement (Optimisés)
```json
{
  "scripts": {
    "dev": "vite --host",
    "build": "vue-tsc && vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext .vue,.js,.jsx,.cjs,.mjs,.ts,.tsx,.cts,.mts --fix",
    "type-check": "vue-tsc --noEmit",
    "test": "vitest",
    "test:coverage": "vitest --coverage",
    "db:start": "./database/scripts/start-db.sh",
    "db:stop": "./database/scripts/stop-db.sh",
    "db:backup": "./database/scripts/backup.sh",
    "docs:serve": "vitepress serve docs"
  }
}
```

### Configuration Vite (Optimisée)
```typescript
// vite.config.ts - Configuration pour l'architecture modulaire
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
      '@/components': resolve(__dirname, 'src/components'),
      '@/composables': resolve(__dirname, 'src/composables'),
      '@/stores': resolve(__dirname, 'src/stores'),
      '@/services': resolve(__dirname, 'src/services'),
      '@/utils': resolve(__dirname, 'src/utils')
    }
  },
  server: {
    port: 5173,
    host: true,
    strictPort: true
  },
  build: {
    outDir: 'dist',
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          'vendor': ['vue', 'pinia'],
          'map': ['leaflet'],
          'utils': ['@/utils/apiClient', '@/utils/filterUtils', '@/utils/formatUtils']
        }
      }
    }
  },
  optimizeDeps: {
    include: ['vue', 'pinia', 'leaflet']
  }
})
```

## 🔍 Optimisations et performance

### Cache intelligent (Nouveau)
```typescript
// src/composables/useAsyncStateWithCache.ts
export function useAsyncStateWithCache<T>(
  key: string,
  asyncFn: () => Promise<T>,
  options: UseAsyncStateOptions & { ttl?: number } = {}
): AsyncState<T> & AsyncActions<T> & { refresh: () => Promise<T | null> } {
  const { ttl = 5 * 60 * 1000, ...asyncOptions } = options
  
  const state = useAsyncState<T>(undefined, asyncOptions)
  
  // Vérifier le cache session
  const cachedData = sessionStorage.getItem(`async_cache_${key}`)
  if (cachedData) {
    try {
      const { data: cached, timestamp } = JSON.parse(cachedData)
      if (Date.now() - timestamp < ttl) {
        state.setData(cached)
      }
    } catch {
      // Ignorer les erreurs de parsing du cache
    }
  }

  async function executeWithCache(): Promise<T | null> {
    const result = await state.execute(asyncFn)
    
    if (result) {
      sessionStorage.setItem(`async_cache_${key}`, JSON.stringify({
        data: result,
        timestamp: Date.now()
      }))
    }
    
    return result
  }

  if (!state.data.value) {
    executeWithCache()
  }

  return {
    ...state,
    refresh: executeWithCache
  }
}
```

### Virtual scrolling préparé
```typescript
// src/composables/useVirtualList.ts
export function useVirtualList<T>(
  items: Ref<T[]>,
  itemHeight: number = 50,
  containerHeight: number = 400
) {
  const scrollTop = ref(0)
  const containerRef = ref<HTMLElement>()

  const visibleItems = computed(() => {
    const start = Math.floor(scrollTop.value / itemHeight)
    const end = Math.min(
      start + Math.ceil(containerHeight / itemHeight) + 1,
      items.value.length
    )
    
    return items.value.slice(start, end).map((item, index) => ({
      item,
      index: start + index,
      top: (start + index) * itemHeight
    }))
  })

  const totalHeight = computed(() => items.value.length * itemHeight)

  const onScroll = (e: Event) => {
    scrollTop.value = (e.target as HTMLElement).scrollTop
  }

  return {
    containerRef,
    visibleItems,
    totalHeight,
    onScroll
  }
}
```

## 🧪 Tests et qualité

### Configuration des tests (Mise à jour)
```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./src/test/setup.ts']
  },
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  }
})
```

### Tests des composables
```typescript
// tests/composables/useAsyncState.test.ts
import { describe, it, expect, vi } from 'vitest'
import { useAsyncState } from '@/composables/useAsyncState'

describe('useAsyncState', () => {
  it('should handle async operations', async () => {
    const mockFn = vi.fn().mockResolvedValue('test data')
    
    const { data, isLoading, error, execute } = useAsyncState()
    
    expect(data.value).toBeNull()
    expect(isLoading.value).toBe(false)
    expect(error.value).toBeNull()
    
    const result = await execute(mockFn)
    
    expect(result).toBe('test data')
    expect(data.value).toBe('test data')
    expect(isLoading.value).toBe(false)
    expect(mockFn).toHaveBeenCalledOnce()
  })

  it('should retry on failure', async () => {
    const mockFn = vi.fn()
      .mockRejectedValueOnce(new Error('First failure'))
      .mockRejectedValueOnce(new Error('Second failure'))
      .mockResolvedValue('success')
    
    const { execute } = useAsyncState(undefined, {
      retryAttempts: 2,
      retryDelay: 10
    })
    
    const result = await execute(mockFn)
    
    expect(result).toBe('success')
    expect(mockFn).toHaveBeenCalledTimes(3)
  })
})
```

### Tests des stores
```typescript
// tests/stores/selectionStore.test.ts
import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useSelectionStore } from '@/stores/selectionStore'

describe('SelectionStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('should select country', () => {
    const store = useSelectionStore()
    
    store.selectCountry('france')
    
    expect(store.selectedCountryId).toBe('france')
    expect(store.currentSelectionType).toBe('country')
    expect(store.hasAnySelection).toBe(true)
  })

  it('should clear selections when selecting different type', () => {
    const store = useSelectionStore()
    
    store.selectCountry('france')
    store.selectOrganization('eu')
    
    expect(store.selectedCountryId).toBeNull()
    expect(store.selectedOrganizationId).toBe('eu')
    expect(store.currentSelectionType).toBe('organization')
  })
})
```

## 📚 Documentation API

### Endpoints principaux refactorisés
```typescript
// Endpoints alignés avec les nouvelles APIs

// Countries API
GET    /api/countries                    # Tous les pays
GET    /api/countries/:id               # Pays spécifique
GET    /api/countries/:id/details       # Détails complets
GET    /api/countries/search?q=:query   # Recherche de pays
GET    /api/countries-geo               # Données géospatiales

// Political Regimes API
GET    /api/political-regimes           # Tous les régimes
GET    /api/political-regimes/:id       # Régime spécifique
GET    /api/political-regimes/:id/countries # Pays par régime

// Organizations API
GET    /api/organizations               # Toutes les organisations
GET    /api/organizations/by-type       # Groupées par type
GET    /api/organizations/:id           # Organisation spécifique
GET    /api/organizations/:id/countries # Pays membres

// Armed Conflicts API
GET    /api/armed-conflicts             # Tous les conflits
GET    /api/armed-conflicts/:id         # Conflit spécifique
GET    /api/armed-conflicts?status=:status # Par statut

// Navigation API
GET    /api/navigation                  # Structure de navigation
GET    /api/categories/:id              # Données de catégorie
```

## 🚀 Prochaines étapes techniques

### Priorité 1 : Migration et adoption
1. **Migration composants** : Adoption progressive des nouveaux stores
2. **Tests complets** : Couverture des composables et APIs
3. **Performance monitoring** : Métriques et optimisations
4. **Documentation** : Guides utilisateur et développeur

### Priorité 2 : Fonctionnalités avancées
1. **PWA** : Service workers et cache avancé
2. **WebSockets** : Mises à jour temps réel
3. **Virtual scrolling** : Optimisation des grandes listes
4. **Bundle optimization** : Code splitting avancé

### Priorité 3 : Évolutions futures
1. **Mobile native** : Application React Native
2. **IA intégrée** : Recommandations et analyse
3. **API publique** : Ouverture des données
4. **Communauté** : Contributions collaboratives

---

**Dernière mise à jour** : Juillet 2025 - Architecture 3.0.0  
**Statut** : ✅ **Refactoring complet terminé**  
**L'architecture est maintenant moderne, maintenable et prête pour l'avenir ! 🚀**