# Guide des Stores - WikiGeopolitics

## 📊 Architecture de gestion d'état

WikiGeopolitics utilise **Pinia** pour la gestion d'état avec une architecture modulaire et typée. Chaque store a une responsabilité spécifique et interagit harmonieusement avec les autres.

## 🏗️ Structure des stores

```
src/stores/
├── asideStore.ts          # Store principal - données et état des panneaux
├── mapStore.ts            # Gestion de la carte et des marqueurs
├── selectionSystem.ts     # Système de sélection unifié
├── uiStore.ts            # Interface utilisateur et notifications
└── index.ts              # Exports centralisés
```

---

## 🎯 asideStore - Store principal

**Responsabilité** : Gestion des données de l'application, navigation dans les panneaux, et état des détails.

### État (State)

```typescript
interface AsideStoreState {
  // Navigation et vues
  currentView: NavigationState
  searchQuery: string
  
  // Données de l'application
  appData: {
    search: { enabled: boolean, placeholder: string }
    mainNavigation: MainNavigationItem[]
    countryList: Country[]
    politicalRegimeList: PoliticalRegime[]
    organizationList: Record<string, Organization[]>
    armedConflictList: ArmedConflict[]
    conflictMarkers: ConflictMarker[]
    combatZones: CombatZone[]
  }
  
  // État des entités
  currentDetailData: CountryDetailData | ConflictDetailData | null
  currentEntityType: EntityType | null
  selectedCountryId: string | null
  selectedOrganizationId: string | null
  selectedPoliticalRegimeId: string | null
  selectedArmedConflictId: string | null
  
  // Cache et performance
  dataCache: Record<string, any>
  isLoading: boolean
  error: string | null
}
```

### Getters

```typescript
// Navigation
isMainView: (state) => state.currentView.type === 'main'
currentTitle: (state) => state.currentView.title || 'Accueil'
canSearch: (state) => state.currentView.searchEnabled

// Données filtrées
filteredCountries: (state) => {
  if (!state.searchQuery) return state.appData.countryList
  return state.appData.countryList.filter(country => 
    country.nom.toLowerCase().includes(state.searchQuery.toLowerCase())
  )
}

filteredConflicts: (state) => {
  // Logique de filtrage des conflits
}

// Sélections
selectedCountry: (state) => {
  return state.appData.countryList.find(c => c.id === state.selectedCountryId)
}

hasAnySelection: (state) => {
  return !!(state.selectedCountryId || state.selectedOrganizationId || 
           state.selectedPoliticalRegimeId || state.selectedArmedConflictId)
}
```

### Actions principales

#### Initialisation des données
```typescript
async initializeData(): Promise<void> {
  try {
    this.isLoading = true
    
    // Chargement parallèle des données principales
    const [
      mainNav,
      countries,
      regimes,
      organizations,
      conflicts
    ] = await Promise.all([
      supabaseService.getNavigationData(),
      supabaseService.getCountries(),
      supabaseService.getPoliticalRegimes(),
      supabaseService.getOrganizationsByType(),
      supabaseService.getArmedConflicts()
    ])
    
    // Mise à jour de l'état
    this.appData.mainNavigation = mainNav
    this.appData.countryList = countries
    this.appData.politicalRegimeList = regimes
    this.appData.organizationList = organizations
    this.appData.armedConflictList = conflicts
    
  } catch (error) {
    this.error = `Erreur d'initialisation: ${error.message}`
  } finally {
    this.isLoading = false
  }
}
```

#### Navigation
```typescript
// Navigation vers les différentes vues
async navigateToCountryList(): Promise<void> {
  this.updateCurrentView({
    type: 'countriesList',
    title: 'Pays du monde',
    searchEnabled: true,
    hasReturnButton: true,
    items: this.appData.countryList
  })
}

async navigateToArmedConflictsList(): Promise<void> {
  if (!this.appData.armedConflictList.length) {
    await this.loadArmedConflicts()
  }
  
  this.updateCurrentView({
    type: 'armedConflictsList', 
    title: 'Conflits armés',
    searchEnabled: true,
    hasReturnButton: true,
    items: this.appData.armedConflictList.map(conflict => ({
      id: conflict.id,
      title: conflict.nom,
      badge: conflict.type || conflict.intensite || '',
      hasSubmenu: true
    }))
  })
}
```

#### Sélection d'entités
```typescript
async selectCountry(id: string, source?: SelectionSource): Promise<void> {
  try {
    this.isLoading = true
    this.clearNonCountrySelections()
    this.selectedCountryId = id
    
    // Chargement des détails du pays
    const countryData = await supabaseService.getCountryById(id)
    if (countryData) {
      this.currentDetailData = this.mapCountryData(countryData)
      this.currentEntityType = 'country'
    }
    
    // Synchronisation avec la carte
    const mapStore = useMapStore()
    mapStore.selectCountry(id)
    
  } catch (error) {
    this.error = `Erreur lors de la sélection du pays: ${error.message}`
  } finally {
    this.isLoading = false
  }
}

async selectArmedConflict(id: string, source?: SelectionSource): Promise<void> {
  try {
    this.isLoading = true
    this.clearNonConflictSelections()
    this.selectedArmedConflictId = id
    
    // Chargement des détails du conflit
    const conflictData = await supabaseService.getArmedConflictById(id)
    if (conflictData) {
      this.currentDetailData = this.mapConflictData(conflictData)
      this.currentEntityType = 'conflict'
    }
    
    // Chargement des zones de combat
    const mapStore = useMapStore()
    await mapStore.loadConflictZones(id)
    
  } catch (error) {
    this.error = `Erreur lors de la sélection du conflit: ${error.message}`
  } finally {
    this.isLoading = false
  }
}
```

#### Mapping des données
```typescript
private mapCountryData(countryData: any): CountryDetailData {
  return {
    id: countryData.id,
    title: countryData.nom,
    regimePolitique: countryData.regime_politique || 'Non spécifié',
    chefEtat: countryData.chef_etat || 'Non renseigné',
    datePrisePoste: countryData.datePrisePoste || 'Non renseignée',
    pib: countryData.pib,
    population: countryData.population,
    revenuMedian: countryData.revenuMedian,
    superficieKm2: countryData.superficie,
    
    // Données relationnelles
    conflitsArmes: countryData.conflitsArmes || [],
    coalitions: countryData.coalitions || [],
    accords: countryData.accords || []
  }
}
```

---

## 🗺️ mapStore - Gestion cartographique

**Responsabilité** : Gestion de la carte, des marqueurs et des couches géographiques.

### État (State)

```typescript
interface MapStoreState {
  // Instance de carte
  map: L.Map | null
  isMapReady: boolean
  
  // Marqueurs et couches
  countryMarkers: Map<string, L.Marker>
  conflictMarkers: Map<string, L.Marker>
  combatZoneMarkers: Map<string, L.Marker>
  selectedMarkers: Set<string>
  
  // Visibilité des couches
  layersVisibility: {
    countries: boolean
    conflicts: boolean
    combatZones: boolean
    organizations: boolean
  }
  
  // État de sélection
  selectedCountryIds: string[]
  selectedConflictId: string | null
  
  // Configuration
  mapCenter: [number, number]
  mapZoom: number
}
```

### Actions principales

#### Initialisation de la carte
```typescript
async initializeMap(container: HTMLElement): Promise<void> {
  try {
    // Création de l'instance Leaflet
    this.map = L.map(container, {
      center: this.mapCenter,
      zoom: this.mapZoom,
      zoomControl: true,
      attributionControl: true
    })
    
    // Ajout de la couche de base
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors',
      maxZoom: 18
    }).addTo(this.map)
    
    this.isMapReady = true
    
    // Chargement initial des marqueurs
    await this.loadCountryMarkers()
    await this.loadConflictMarkers()
    
  } catch (error) {
    console.error('Erreur initialisation carte:', error)
  }
}
```

#### Gestion des marqueurs de pays
```typescript
async loadCountryMarkers(): Promise<void> {
  if (!this.map) return
  
  const asideStore = useAsideStore()
  const countries = asideStore.appData.countryList
  
  // Création des marqueurs pour chaque pays
  countries.forEach(country => {
    if (country.coordonnees) {
      const marker = this.createCountryMarker(country)
      this.countryMarkers.set(country.id, marker)
      
      if (this.layersVisibility.countries) {
        marker.addTo(this.map!)
      }
    }
  })
}

private createCountryMarker(country: Country): L.Marker {
  const marker = L.marker([country.coordonnees.lat, country.coordonnees.lng], {
    icon: this.createCountryIcon(country),
    title: country.nom
  })
  
  // Popup avec informations de base
  marker.bindPopup(`
    <div class="country-popup">
      <h3>${country.nom}</h3>
      <p><strong>Capitale:</strong> ${country.capitale}</p>
      <p><strong>Population:</strong> ${country.population?.toLocaleString()}</p>
    </div>
  `)
  
  // Gestion du clic
  marker.on('click', () => {
    const asideStore = useAsideStore()
    asideStore.selectCountry(country.id, 'map')
  })
  
  return marker
}
```

#### Gestion des conflits et zones de combat
```typescript
async loadConflictMarkers(): Promise<void> {
  if (!this.map) return
  
  const asideStore = useAsideStore()
  const conflicts = asideStore.appData.armedConflictList
  
  conflicts.forEach(conflict => {
    if (conflict.epicenter) {
      const marker = this.createConflictMarker(conflict)
      this.conflictMarkers.set(conflict.id, marker)
      
      if (this.layersVisibility.conflicts) {
        marker.addTo(this.map!)
      }
    }
  })
}

async loadConflictZones(conflictId: string): Promise<void> {
  try {
    const zones = await supabaseService.getCombatZonesByConflict(conflictId)
    
    // Suppression des zones précédentes
    this.clearCombatZones()
    
    // Ajout des nouvelles zones
    zones.forEach(zone => {
      if (zone.coordinates) {
        const marker = this.createCombatZoneMarker(zone)
        this.combatZoneMarkers.set(zone.id, marker)
        
        if (this.layersVisibility.combatZones) {
          marker.addTo(this.map!)
        }
      }
    })
    
  } catch (error) {
    console.error('Erreur chargement zones de combat:', error)
  }
}
```

#### Sélection et mise en évidence
```typescript
selectCountry(countryId: string): void {
  // Mise à jour de la sélection
  this.selectedCountryIds = [countryId]
  
  // Mise en évidence visuelle
  this.updateMarkersSelection()
  
  // Centrage sur le pays
  const marker = this.countryMarkers.get(countryId)
  if (marker && this.map) {
    this.map.setView(marker.getLatLng(), 6)
  }
}

private updateMarkersSelection(): void {
  // Mise à jour des styles des marqueurs pays
  this.countryMarkers.forEach((marker, id) => {
    const isSelected = this.selectedCountryIds.includes(id)
    const icon = isSelected ? this.createSelectedCountryIcon() : this.createCountryIcon()
    marker.setIcon(icon)
  })
  
  // Mise à jour des marqueurs de conflits
  this.conflictMarkers.forEach((marker, id) => {
    const isSelected = id === this.selectedConflictId
    const icon = isSelected ? this.createSelectedConflictIcon() : this.createConflictIcon()
    marker.setIcon(icon)
  })
}
```

#### Contrôle des couches
```typescript
toggleLayer(layerType: keyof LayersVisibility): void {
  this.layersVisibility[layerType] = !this.layersVisibility[layerType]
  
  switch (layerType) {
    case 'countries':
      this.toggleCountryMarkers(this.layersVisibility.countries)
      break
    case 'conflicts':
      this.toggleConflictMarkers(this.layersVisibility.conflicts)
      break
    case 'combatZones':
      this.toggleCombatZoneMarkers(this.layersVisibility.combatZones)
      break
  }
}

private toggleCountryMarkers(visible: boolean): void {
  this.countryMarkers.forEach(marker => {
    if (visible) {
      marker.addTo(this.map!)
    } else {
      this.map!.removeLayer(marker)
    }
  })
}
```

---

## 🎯 selectionSystem - Système de sélection unifié

**Responsabilité** : Coordination des sélections entre les différents composants et stores.

### Interface principale

```typescript
export interface SelectionSystem {
  // État actuel
  getCurrentSelection(): CurrentSelection | null
  
  // Sélections d'entités
  selectCountry(id: string, source?: SelectionSource): Promise<void>
  selectConflict(id: string, source?: SelectionSource): Promise<void>
  selectOrganization(id: string, source?: SelectionSource): Promise<void>
  selectRegime(id: string, source?: SelectionSource): Promise<void>
  
  // Vérifications d'état
  isCountrySelected(id: string): boolean
  isConflictSelected(id: string): boolean
  isOrganizationSelected(id: string): boolean
  isRegimeSelected(id: string): boolean
  
  // Gestion globale
  clearAllSelections(): void
  clearSelection(type: EntityType): void
}
```

### Implémentation

```typescript
export const useSelectionSystem = () => {
  const asideStore = useAsideStore()
  const mapStore = useMapStore()
  
  const selectCountry = async (id: string, source: SelectionSource = 'unknown') => {
    console.log(`[SelectionSystem] Sélection pays ${id} depuis ${source}`)
    
    // Coordination entre stores
    await asideStore.selectCountry(id, source)
    mapStore.selectCountry(id)
    
    // Événements pour les composants
    emit('country-selected', { id, source })
  }
  
  const selectConflict = async (id: string, source: SelectionSource = 'unknown') => {
    console.log(`[SelectionSystem] Sélection conflit ${id} depuis ${source}`)
    
    await asideStore.selectArmedConflict(id, source)
    await mapStore.loadConflictZones(id)
    mapStore.selectConflict(id)
    
    emit('conflict-selected', { id, source })
  }
  
  return {
    selectCountry,
    selectConflict,
    selectOrganization,
    selectRegime,
    isCountrySelected: (id: string) => asideStore.selectedCountryId === id,
    isConflictSelected: (id: string) => asideStore.selectedArmedConflictId === id,
    clearAllSelections: () => {
      asideStore.clearAllSelections()
      mapStore.clearAllSelections()
    }
  }
}
```

---

## 🎨 uiStore - Interface utilisateur

**Responsabilité** : Gestion de l'état de l'interface, notifications, responsive design.

### État (State)

```typescript
interface UIStoreState {
  // Layout
  sidebarCollapsed: boolean
  panelVisible: boolean
  
  // Responsive
  isMobile: boolean
  screenWidth: number
  
  // Notifications
  notifications: Notification[]
  
  // Modales et overlays
  showModal: boolean
  modalContent: any
  
  // États de chargement globaux
  globalLoading: boolean
  loadingMessage: string
}
```

### Actions principales

```typescript
// Notifications
addNotification(notification: Notification): void {
  this.notifications.push({
    id: Date.now().toString(),
    ...notification,
    timestamp: new Date()
  })
  
  // Auto-suppression après délai
  if (notification.duration !== 0) {
    setTimeout(() => {
      this.removeNotification(notification.id)
    }, notification.duration || 5000)
  }
}

notifySuccess(title: string, message?: string): void {
  this.addNotification({
    type: 'success',
    title,
    message,
    duration: 3000
  })
}

notifyError(title: string, message?: string): void {
  this.addNotification({
    type: 'error',
    title,
    message,
    duration: 0 // Persistante jusqu'à fermeture manuelle
  })
}

// Responsive
updateScreenWidth(width: number): void {
  this.screenWidth = width
  this.isMobile = width < 768
  
  // Adaptation automatique du sidebar
  if (this.isMobile && !this.sidebarCollapsed) {
    this.sidebarCollapsed = true
  }
}

// Layout
toggleSidebar(): void {
  this.sidebarCollapsed = !this.sidebarCollapsed
}
```

---

## 🔄 Communication entre stores

### Pattern Observer avec Pinia

```typescript
// Écoute des changements dans asideStore depuis mapStore
export const useMapStore = defineStore('map', {
  // ...
  
  actions: {
    // Synchronisation automatique
    $onAction(({ name, store, args, after }) => {
      if (name === 'selectCountry') {
        after(() => {
          // Mise à jour de la carte après sélection
          this.updateMapSelection()
        })
      }
    })
  }
})
```

### Composables de coordination

```typescript
// Composable pour synchroniser tous les stores
export const useStoreSync = () => {
  const asideStore = useAsideStore()
  const mapStore = useMapStore()
  const uiStore = useUIStore()
  
  // Synchronisation lors des changements de sélection
  watch(() => asideStore.selectedCountryId, (newId, oldId) => {
    if (newId !== oldId) {
      mapStore.selectCountry(newId)
      uiStore.notifySuccess('Pays sélectionné', `${newId} mis en évidence`)
    }
  })
  
  // Synchronisation responsive
  watch(() => uiStore.isMobile, (isMobile) => {
    if (isMobile) {
      asideStore.collapseSidebar()
    }
  })
}
```

---

## 🚀 Optimisations et performance

### Cache intelligent

```typescript
// Cache avec TTL dans asideStore
private cacheData(key: string, data: any, ttl: number = 300000) {
  this.dataCache[key] = {
    data,
    timestamp: Date.now(),
    ttl
  }
}

private getCachedData(key: string): any | null {
  const cached = this.dataCache[key]
  if (cached && (Date.now() - cached.timestamp) < cached.ttl) {
    return cached.data
  }
  return null
}
```

### Chargement différé

```typescript
// Chargement des données selon les besoins
async loadOnDemand(entityType: EntityType, id: string) {
  const cacheKey = `${entityType}-${id}`
  
  // Vérification du cache
  let data = this.getCachedData(cacheKey)
  if (data) return data
  
  // Chargement depuis l'API
  switch (entityType) {
    case 'country':
      data = await supabaseService.getCountryById(id)
      break
    case 'conflict':
      data = await supabaseService.getArmedConflictById(id)
      break
  }
  
  // Mise en cache
  this.cacheData(cacheKey, data)
  return data
}
```

### Debouncing des recherches

```typescript
// Recherche avec debounce dans asideStore
private searchDebounceTimer: number | null = null

setSearchQuery(query: string): void {
  if (this.searchDebounceTimer) {
    clearTimeout(this.searchDebounceTimer)
  }
  
  this.searchDebounceTimer = window.setTimeout(() => {
    this.performSearch(query)
  }, 300)
}
```

---

## 🧪 Tests des stores

### Tests unitaires avec Vitest

```typescript
// tests/stores/asideStore.test.ts
import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAsideStore } from '@/stores/asideStore'

describe('AsideStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })
  
  it('should initialize with default state', () => {
    const store = useAsideStore()
    
    expect(store.isMainView).toBe(true)
    expect(store.selectedCountryId).toBeNull()
    expect(store.hasAnySelection).toBe(false)
  })
  
  it('should select country correctly', async () => {
    const store = useAsideStore()
    
    await store.selectCountry('france')
    
    expect(store.selectedCountryId).toBe('france')
    expect(store.currentEntityType).toBe('country')
    expect(store.hasAnySelection).toBe(true)
  })
})
```

---

L'architecture des stores de WikiGeopolitics offre une **gestion d'état robuste**, **typée** et **performante**. Chaque store a une responsabilité claire et communique efficacement avec les autres pour offrir une expérience utilisateur fluide et cohérente.