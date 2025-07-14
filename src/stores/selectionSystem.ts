import { defineStore } from 'pinia'
import { useMapStore } from './mapStore'
import { useAsideStore } from './asideStore'

// Types pour le système de sélection unifié
export type EntityType = 'country' | 'conflict' | 'organization' | 'regime' | 'resource'

export interface SelectionState {
  type: 'initial' | 'country' | 'conflict' | 'country_conflict' | 'organization' | 'regime'
  
  // Entités sélectionnées
  selectedCountry: string | null
  selectedConflict: string | null
  selectedOrganization: string | null
  selectedRegime: string | null
  
  // État de l'interface
  floatingPanelOpen: boolean
  floatingPanelType: EntityType | null
  
  // Pays visibles sur la carte selon le contexte
  visibleCountries: string[]
  highlightedCountries: string[]
  
  // Zones de combat visibles
  conflictZonesVisible: boolean
  
  // Historique pour navigation
  history: Array<{
    state: SelectionState
    timestamp: number
  }>
}

/**
 * Store unifié pour TOUTE la logique de sélection
 * Gère tous les états et transitions de manière centralisée
 */
export const useSelectionSystem = defineStore('selectionSystem', {
  state: (): SelectionState => ({
    type: 'initial',
    
    selectedCountry: null,
    selectedConflict: null,
    selectedOrganization: null,
    selectedRegime: null,
    
    floatingPanelOpen: false,
    floatingPanelType: null,
    
    visibleCountries: [],
    highlightedCountries: [],
    
    conflictZonesVisible: false,
    
    history: []
  }),

  getters: {
    // État actuel simplifié
    currentState: (state) => ({
      type: state.type,
      country: state.selectedCountry,
      conflict: state.selectedConflict,
      organization: state.selectedOrganization,
      regime: state.selectedRegime
    }),
    
    // Vérifications d'état
    hasCountrySelected: (state) => state.selectedCountry !== null,
    hasConflictSelected: (state) => state.selectedConflict !== null,
    isInContextualMode: (state) => state.selectedConflict !== null,
    
    // Vérifications de sélection
    isCountrySelected: (state) => (countryId: string) => state.selectedCountry === countryId,
    isConflictSelected: (state) => (conflictId: string) => state.selectedConflict === conflictId,
    
    // État de la carte
    shouldShowCountry: (state) => (countryId: string) => {
      if (state.type === 'initial') return true
      if (state.type === 'conflict') return state.visibleCountries.includes(countryId)
      if (state.type === 'country_conflict') return state.visibleCountries.includes(countryId)
      return true
    },
    
    shouldHighlightCountry: (state) => (countryId: string) => {
      return state.highlightedCountries.includes(countryId)
    }
  },

  actions: {
    /**
     * UC1 - État initial / Reset complet
     */
    async resetToInitial() {
      // Sauvegarder l'état actuel
      this.saveCurrentState()
      
      // Reset de l'état
      this.type = 'initial'
      this.selectedCountry = null
      this.selectedConflict = null
      this.selectedOrganization = null
      this.selectedRegime = null
      
      this.floatingPanelOpen = false
      this.floatingPanelType = null
      
      this.visibleCountries = []
      this.highlightedCountries = []
      this.conflictZonesVisible = false
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * UC2, UC3, UC4 - Sélection d'un pays
     */
    async selectCountry(countryId: string, source: 'map' | 'aside' = 'map') {
      // Si on est en mode conflit et que la sélection vient de l'aside
      // on revient à l'état initial puis on sélectionne le pays
      if (this.selectedConflict && source === 'aside') {
        await this.resetToInitial()
        // Continuer avec la sélection normale
      }
      
      // Si on est en mode conflit et que la sélection vient de la map, c'est contextuel
      if (this.selectedConflict && source === 'map') {
        return this.selectCountryInContext(countryId)
      }
      
      // Sauvegarder l'état actuel
      this.saveCurrentState()
      
      // Nouvelle sélection de pays
      this.type = 'country'
      this.selectedCountry = countryId
      this.selectedConflict = null
      this.selectedOrganization = null
      this.selectedRegime = null
      
      this.floatingPanelOpen = true
      this.floatingPanelType = 'country'
      
      this.visibleCountries = [countryId]
      this.highlightedCountries = [countryId]
      this.conflictZonesVisible = false
      
      // Charger les données du pays
      const asideStore = useAsideStore()
      await asideStore.loadCountryData(countryId)
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * UC8 - Sélection contextuelle d'un pays (conflit actif)
     */
    async selectCountryInContext(countryId: string) {
      console.log(`[SelectionSystem] 🎯 Sélection contextuelle pays ${countryId}`)
      
      if (!this.selectedConflict) {
        console.warn('[SelectionSystem] Sélection contextuelle sans conflit actif')
        return this.selectCountry(countryId)
      }
      
      // Sauvegarder l'état actuel
      this.saveCurrentState()
      
      // Mise à jour contextuelle
      this.type = 'country_conflict'
      this.selectedCountry = countryId
      // Conserver this.selectedConflict
      
      this.floatingPanelOpen = true
      this.floatingPanelType = 'country'
      
      // Les pays visibles et zones de combat restent inchangés
      this.highlightedCountries = [countryId]
      
      // Charger les données du pays
      const asideStore = useAsideStore()
      await asideStore.loadCountryData(countryId)
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * UC6, UC7 - Sélection d'un conflit
     */
    async selectConflict(conflictId: string, source: 'aside' | 'panel' = 'aside') {
      console.log(`[SelectionSystem] ⚔️ Sélection conflit ${conflictId} depuis ${source}`)
      
      // Sauvegarder l'état actuel
      this.saveCurrentState()
      
      // Déterminer le nouvel état
      if (this.selectedCountry && source === 'panel') {
        this.type = 'country_conflict'
      } else {
        this.type = 'conflict'
        this.selectedCountry = null
      }
      
      this.selectedConflict = conflictId
      this.selectedOrganization = null
      this.selectedRegime = null
      
      this.floatingPanelOpen = source === 'panel'
      this.floatingPanelType = source === 'panel' ? 'country' : 'conflict'
      
      this.conflictZonesVisible = true
      
      // Charger les pays du conflit
      const { armedConflictAPI } = await import('@/services/api/armedConflictAPI')
      try {
        const countries = await armedConflictAPI.getCountries(conflictId)
        this.visibleCountries = countries.map((c: any) => c.id)
        
        if (source === 'aside') {
          this.highlightedCountries = this.visibleCountries
        }
      } catch (error) {
        console.error('[SelectionSystem] Erreur chargement pays conflit:', error)
        this.visibleCountries = []
      }
      
      // Charger les données du conflit si nécessaire
      if (source === 'aside') {
        const asideStore = useAsideStore()
        await asideStore.selectArmedConflict(conflictId)
      }
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * UC5 - Fermeture du floating panel
     */
    async closeFloatingPanel() {
      this.floatingPanelOpen = false
      this.floatingPanelType = null
      
      // Logique de fermeture du panel :
      // - Si on a sélectionné un conflit DEPUIS l'aside (menu conflits), on garde le contexte conflit
      // - Si on a sélectionné un conflit DEPUIS la fiche d'un pays, on revient à l'état initial
      // - Dans tous les autres cas, on revient à l'état initial
      
      if (this.type === 'country_conflict' && this.selectedConflict) {
        // Vérifier si le conflit a été sélectionné depuis l'aside (menu conflits)
        const asideStore = useAsideStore()
        const isInConflictMenu = asideStore.currentView?.type === 'armedConflictsList'
        
        if (isInConflictMenu) {
          // Garder le contexte conflit mais désélectionner le pays
          this.type = 'conflict'
          this.selectedCountry = null
          this.highlightedCountries = this.visibleCountries
        } else {
          // Retour à l'état initial car le conflit venait de la fiche d'un pays
          await this.resetToInitial()
          return // resetToInitial() appelle déjà syncWithStores()
        }
      } else {
        // Retour à l'état initial dans tous les autres cas
        await this.resetToInitial()
        return // resetToInitial() appelle déjà syncWithStores()
      }
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * Synchronisation avec mapStore et asideStore
     */
    async syncWithStores() {
      const mapStore = useMapStore()
      
      // Synchroniser l'affichage des pays sur la carte
      if (this.type === 'initial') {
        mapStore.setCountryDisplayMode('all')
        mapStore.clearSelectedCountries()
      } else {
        mapStore.setCountryDisplayMode('selected')
        mapStore.setSelectedCountries(this.visibleCountries)
      }
      
      // Synchroniser les zones de combat
      if (this.conflictZonesVisible && this.selectedConflict) {
        mapStore.visibleLayers.armedConflicts = true
        await mapStore.loadConflictZones(this.selectedConflict)
      } else {
        mapStore.visibleLayers.armedConflicts = false
        mapStore.armedConflicts = null
      }
      
      // Déclencher un refresh des marqueurs
      // Cela sera intercepté par le watcher dans useUnifiedMarkers
    },

    /**
     * Gestion de l'historique
     */
    saveCurrentState() {
      const currentState = JSON.parse(JSON.stringify({
        type: this.type,
        selectedCountry: this.selectedCountry,
        selectedConflict: this.selectedConflict,
        selectedOrganization: this.selectedOrganization,
        selectedRegime: this.selectedRegime,
        floatingPanelOpen: this.floatingPanelOpen,
        floatingPanelType: this.floatingPanelType,
        visibleCountries: this.visibleCountries,
        highlightedCountries: this.highlightedCountries,
        conflictZonesVisible: this.conflictZonesVisible
      }))
      
      this.history.push({
        state: currentState,
        timestamp: Date.now()
      })
      
      // Limiter l'historique
      if (this.history.length > 10) {
        this.history.shift()
      }
    },

    /**
     * UC10 - Navigation retour
     */
    async goBack() {
      if (this.history.length === 0) {
        return this.resetToInitial()
      }
      
      const previousState = this.history.pop()!
      Object.assign(this, previousState.state)
      
      await this.syncWithStores()
    },

    /**
     * Retour à la racine de la navigation (depuis l'aside)
     */
    async returnToRoot() {
      await this.resetToInitial()
    },

    /**
     * Utilitaires pour les composants
     */
    async selectEntity(type: EntityType, id: string, source: string = 'unknown') {
      switch (type) {
        case 'country':
          return this.selectCountry(id, source as 'map' | 'aside')
        case 'conflict':
          return this.selectConflict(id, source as 'aside' | 'panel')
        case 'organization':
          // TODO: Implémenter
          break
        case 'regime':
          // TODO: Implémenter
          break
      }
    }
  }
})