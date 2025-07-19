import { defineStore } from 'pinia'
import { useMapStore } from './mapStore'
import { useAsideStore } from './asideStore'

// Types pour le système de sélection unifié
export type EntityType = 'country' | 'conflict' | 'conflict-epicenter' | 'organization' | 'regime' | 'resource'

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
  
  // Contexte parent pour navigation contextuelle
  parentContext: {
    type: 'regime' | 'organization' | 'conflict' | 'initial'
    id: string | null
  }
  
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
    
    parentContext: {
      type: 'initial',
      id: null
    },
    
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
      console.log('[SelectionSystem] 🔄 Reset to initial state')
      
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
      
      // Reset du contexte parent
      this.parentContext = {
        type: 'initial',
        id: null
      }
      
      // Nettoyer les couches de conflits
      const { useMapStore } = await import('@/stores/mapStore')
      const mapStore = useMapStore()
      mapStore.visibleLayers.armedConflicts = false
      mapStore.armedConflicts = null
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * UC2, UC3, UC4 - Sélection d'un pays
     */
    async selectCountry(countryId: string, source: 'map' | 'aside' = 'map'): Promise<void> {
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
      // Conserver le contexte parent (regime/organization) pour le retour
      
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
    async selectCountryInContext(countryId: string): Promise<void> {
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
    async selectConflict(conflictId: string, source: 'aside' | 'panel' | 'map' = 'aside') {
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
      console.log(`[SelectionSystem] 🎯 selectedConflict mis à jour:`, this.selectedConflict)
      this.selectedOrganization = null
      this.selectedRegime = null
      
      this.floatingPanelOpen = true
      this.floatingPanelType = source === 'panel' ? 'country' : 'conflict'
      
      // Garder les marqueurs d'épicentres visibles lors de la sélection d'un conflit
      const { useMapStore } = await import('@/stores/mapStore')
      const mapStore = useMapStore()
      // On garde les épicentres visibles pour permettre la sélection d'autres conflits
      
      // Charger les pays du conflit
      const { supabaseService } = await import('@/services/supabaseService')
      try {
        const countries = await supabaseService.getCountriesByConflict(conflictId)
        this.visibleCountries = countries.map((c: any) => c.id)
        console.log(`[SelectionSystem] 🏳️ Pays du conflit ${conflictId}:`, this.visibleCountries)
        
        if (source === 'aside') {
          this.highlightedCountries = this.visibleCountries
        }
        
        if (source === 'aside') {
          // Menu conflit armé : marquer visible AVANT pour que les watchers se déclenchent
          this.conflictZonesVisible = true
          console.log(`[SelectionSystem] 🔥 conflictZonesVisible défini à true pour conflit ${conflictId} (menu)`)
          await mapStore.loadConflictZones(conflictId)
          console.log(`[SelectionSystem] 🔥 Zones de combat chargées pour conflit ${conflictId}`)
        } else {
          // Floating panel : charger AVANT de marquer visible pour éviter les watchers prématurés
          await mapStore.loadConflictZones(conflictId)
          console.log(`[SelectionSystem] 🔥 Zones de combat chargées pour conflit ${conflictId}`)
          this.conflictZonesVisible = true
          console.log(`[SelectionSystem] 🔥 conflictZonesVisible défini à true pour conflit ${conflictId} (panel)`)
        }
      } catch (error) {
        console.error('[SelectionSystem] Erreur chargement pays conflit:', error)
        this.visibleCountries = []
      }
      
      // Charger les données du conflit
      const asideStore = useAsideStore()
      if (source === 'aside') {
        await asideStore.loadConflictData(conflictId)
      } else if (source === 'map') {
        // Pour les sélections depuis la map, charger les données du conflit pour le floating panel
        await asideStore.loadConflictData(conflictId)
        
        // Mettre à jour le mode d'affichage des pays
        const { useMapStore } = await import('@/stores/mapStore')
        const mapStore = useMapStore()
        mapStore.setCountryDisplayMode('selected')
      }
      
      // Synchroniser avec les autres stores
      console.log(`[SelectionSystem] 🔄 Appel de syncWithStores pour conflit ${conflictId}`)
      await this.syncWithStores()
    },

    /**
     * Retour au menu conflits armés
     */
    async returnToConflictMenu() {
      console.log('[SelectionSystem] 🔄 Retour au menu conflits armés')
      
      // Sauvegarder l'état actuel
      this.saveCurrentState()
      
      // Réinitialiser toutes les sélections
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
      
      // Nettoyer les couches de conflits
      const { useMapStore } = await import('@/stores/mapStore')
      const mapStore = useMapStore()
      mapStore.visibleLayers.armedConflicts = false
      mapStore.armedConflicts = null
      
      // Reset du contexte parent
      this.parentContext = {
        type: 'initial',
        id: null
      }
      
      // Configurer l'affichage pour le menu conflits
      mapStore.setCountryDisplayMode('none')
      mapStore.clearSelectedCountries()
      
      // Nettoyer complètement les marqueurs de conflits/zones de combat
      mapStore.visibleLayers.armedConflicts = false
      mapStore.armedConflicts = null
      
      // Configurer l'affichage des épicentres
      mapStore.visibleLayers.conflictEpicenters = true
      
      // S'assurer que les marqueurs d'épicentres sont présents et rechargés
      if (mapStore.conflictEpicenterMarkers.length === 0) {
        await mapStore.loadConflictEpicenters()
      } else {
        // Forcer le rafraîchissement en réactivant la couche
        mapStore.visibleLayers.conflictEpicenters = false
        await new Promise(resolve => setTimeout(resolve, 10))
        mapStore.visibleLayers.conflictEpicenters = true
      }
      
      // Synchroniser avec les autres stores pour forcer le rafraîchissement des marqueurs
      await this.syncWithStores()
    },

    /**
     * UC5 - Fermeture du floating panel
     */
    async closeFloatingPanel() {
      this.floatingPanelOpen = false
      this.floatingPanelType = null
      
      // Logique de fermeture du panel avec contexte parent
      if (this.type === 'country_conflict' && this.selectedConflict) {
        // Vérifier si le conflit a été sélectionné depuis l'aside (menu conflits)
        const asideStore = useAsideStore()
        const isInConflictMenu = asideStore.currentView?.type === 'armedConflictsList'
        
        if (isInConflictMenu) {
          // Retour au menu conflits (désélectionner le conflit et le pays)
          console.log('[SelectionSystem] 🔄 closeFloatingPanel: Désélection contextuelle - retour au menu conflits')
          await this.returnToConflictMenu()
          return // returnToConflictMenu() configure déjà mapStore
        } else {
          // Retour à l'état initial car le conflit venait de la fiche d'un pays
          await this.resetToInitial()
          return // resetToInitial() appelle déjà syncWithStores()
        }
      } else if (this.type === 'conflict' && this.selectedConflict) {
        // Vérifier si on est dans le menu conflits
        const asideStore = useAsideStore()
        const isInConflictMenu = asideStore.currentView?.type === 'armedConflictsList'
        
        if (isInConflictMenu) {
          // Retour au menu conflits (désélectionner le conflit)
          await this.returnToConflictMenu()
          return // returnToConflictMenu() appelle déjà syncWithStores()
        } else {
          // Retour à l'état initial dans les autres cas
          await this.resetToInitial()
          return // resetToInitial() appelle déjà syncWithStores()
        }
      } else if (this.type === 'country' && this.parentContext.type !== 'initial') {
        // Retour au contexte parent (regime/organization)
        await this.returnToParentContext()
        return // returnToParentContext() appelle déjà syncWithStores()
      } else {
        // Retour à l'état initial dans tous les autres cas
        await this.resetToInitial()
        return // resetToInitial() appelle déjà syncWithStores()
      }
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * Retour au contexte parent (regime/organization)
     */
    async returnToParentContext() {
      console.log(`[SelectionSystem] 🔄 Retour au contexte parent: ${this.parentContext.type} ${this.parentContext.id}`)
      
      // Sauvegarder l'état actuel
      this.saveCurrentState()
      
      // Désélectionner le pays
      this.selectedCountry = null
      this.floatingPanelOpen = false
      this.floatingPanelType = null
      
      // Retourner au contexte parent
      if (this.parentContext.type === 'regime') {
        this.type = 'regime'
        this.selectedRegime = this.parentContext.id
        this.selectedOrganization = null
        this.selectedConflict = null
        
        // Recharger les pays du régime
        const { supabaseService } = await import('@/services/supabaseService')
        try {
          const countries = await supabaseService.getCountriesByRegime(this.parentContext.id!)
          this.visibleCountries = countries.map((c: any) => c.id)
          this.highlightedCountries = []
        } catch (error) {
          console.error('[SelectionSystem] Erreur rechargement pays régime:', error)
          this.visibleCountries = []
        }
      } else if (this.parentContext.type === 'organization') {
        this.type = 'organization'
        this.selectedOrganization = this.parentContext.id
        this.selectedRegime = null
        this.selectedConflict = null
        
        // Recharger les pays de l'organisation
        const { supabaseService } = await import('@/services/supabaseService')
        try {
          const countries = await supabaseService.getCountriesByOrganization(this.parentContext.id!)
          this.visibleCountries = countries.map((c: any) => c.id)
          this.highlightedCountries = []
        } catch (error) {
          console.error('[SelectionSystem] Erreur rechargement pays organisation:', error)
          this.visibleCountries = []
        }
      } else {
        // Fallback vers l'état initial
        await this.resetToInitial()
        return
      }
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * UC11 - Déselection lors d'un clic sur la carte
     */
    async deselectOnMapClick() {
      console.log('[SelectionSystem] 🗺️ Déselection depuis clic sur la carte')
      
      // Utiliser la même logique que closeFloatingPanel() pour tous les cas
      if (this.type === 'initial') {
        // État initial, rien à faire
        console.log('[SelectionSystem] Aucune sélection active à désélectionner')
        return
      }
      
      // Simuler la fermeture du panel pour tous les cas de sélection
      this.floatingPanelOpen = false
      this.floatingPanelType = null
      
      // Utiliser la logique existante de closeFloatingPanel()
      if (this.type === 'country_conflict' && this.selectedConflict) {
        // Vérifier si le conflit a été sélectionné depuis l'aside (menu conflits)
        const asideStore = useAsideStore()
        const isInConflictMenu = asideStore.currentView?.type === 'armedConflictsList'
        
        if (isInConflictMenu) {
          // Retour au menu conflits (désélectionner le conflit et le pays)
          console.log('[SelectionSystem] 🔄 deselectOnMapClick: Désélection contextuelle - retour au menu conflits')
          await this.returnToConflictMenu()
          return // returnToConflictMenu() configure déjà mapStore
        } else {
          // Retour à l'état initial car le conflit venait de la fiche d'un pays
          await this.resetToInitial()
          return // resetToInitial() appelle déjà syncWithStores()
        }
      } else if (this.type === 'conflict' && this.selectedConflict) {
        // Vérifier si on est dans le menu conflits
        const asideStore = useAsideStore()
        const isInConflictMenu = asideStore.currentView?.type === 'armedConflictsList'
        
        if (isInConflictMenu) {
          // Retour au menu conflits (désélectionner le conflit)
          await this.returnToConflictMenu()
          return // returnToConflictMenu() appelle déjà syncWithStores()
        } else {
          // Retour à l'état initial dans les autres cas
          await this.resetToInitial()
          return // resetToInitial() appelle déjà syncWithStores()
        }
      } else if (this.type === 'country' && this.parentContext.type !== 'initial') {
        // Retour au contexte parent (regime/organization)
        await this.returnToParentContext()
        return // returnToParentContext() appelle déjà syncWithStores()
      } else {
        // Retour à l'état initial dans tous les autres cas
        await this.resetToInitial()
        return // resetToInitial() appelle déjà syncWithStores()
      }
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * UC9 - Sélection d'un régime politique
     */
    async selectRegime(regimeId: string, source: 'aside' | 'panel' = 'aside') {
      console.log(`[SelectionSystem] ⚖️ Sélection régime ${regimeId} depuis ${source}`)
      
      // Sauvegarder l'état actuel
      this.saveCurrentState()
      
      // Nouvelle sélection de régime
      this.type = 'regime'
      this.selectedRegime = regimeId
      this.selectedCountry = null
      this.selectedConflict = null
      this.selectedOrganization = null
      
      this.floatingPanelOpen = true
      this.floatingPanelType = source === 'panel' ? 'country' : 'regime'
      
      this.conflictZonesVisible = false
      
      // Définir le contexte parent
      this.parentContext = {
        type: 'regime',
        id: regimeId
      }
      
      // Charger les pays de ce régime
      const { supabaseService } = await import('@/services/supabaseService')
      try {
        const countries = await supabaseService.getCountriesByRegime(regimeId)
        this.visibleCountries = countries.map((c: any) => c.id)
        
        // Pour les régimes, on ne met pas les pays en évidence par défaut
        // Ils restent en état normal, juste visibles
        this.highlightedCountries = []
      } catch (error) {
        console.error('[SelectionSystem] Erreur chargement pays régime:', error)
        this.visibleCountries = []
      }
      
      // Charger les données du régime si nécessaire
      if (source === 'aside') {
        const asideStore = useAsideStore()
        await asideStore.loadRegimeData(regimeId)
      }
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * UC10 - Sélection d'une organisation
     */
    async selectOrganization(organizationId: string, source: 'aside' | 'panel' = 'aside') {
      console.log(`[SelectionSystem] 🏢 Sélection organisation ${organizationId} depuis ${source}`)
      
      // Sauvegarder l'état actuel
      this.saveCurrentState()
      
      // Nouvelle sélection d'organisation
      this.type = 'organization'
      this.selectedOrganization = organizationId
      this.selectedCountry = null
      this.selectedConflict = null
      this.selectedRegime = null
      
      this.floatingPanelOpen = true
      this.floatingPanelType = source === 'panel' ? 'country' : 'organization'
      
      this.conflictZonesVisible = false
      
      // Définir le contexte parent
      this.parentContext = {
        type: 'organization',
        id: organizationId
      }
      
      // Charger les pays membres de cette organisation
      const { supabaseService } = await import('@/services/supabaseService')
      try {
        const countries = await supabaseService.getCountriesByOrganization(organizationId)
        this.visibleCountries = countries.map((c: any) => c.id)
        
        // Pour les organisations, on ne met pas les pays en évidence par défaut
        // Ils restent en état normal, juste visibles
        this.highlightedCountries = []
      } catch (error) {
        console.error('[SelectionSystem] Erreur chargement pays organisation:', error)
        this.visibleCountries = []
      }
      
      // Charger les données de l'organisation si nécessaire
      if (source === 'aside') {
        const asideStore = useAsideStore()
        await asideStore.loadOrganizationData(organizationId)
      }
      
      // Synchroniser avec les autres stores
      await this.syncWithStores()
    },

    /**
     * Synchronisation avec mapStore et asideStore
     */
    async syncWithStores() {
      const mapStore = useMapStore()
      const asideStore = useAsideStore()
      
      console.log(`[SelectionSystem] 🔄 syncWithStores - type: ${this.type}, conflictZonesVisible: ${this.conflictZonesVisible}, selectedConflict: ${this.selectedConflict}`)
      
      // Synchroniser l'affichage des pays sur la carte
      if (this.type === 'initial') {
        // Vérifier si on est dans le menu conflits
        const isInConflictMenu = asideStore.currentView?.type === 'armedConflictsList'
        
        if (isInConflictMenu) {
          // Dans le menu conflits : masquer les pays
          mapStore.setCountryDisplayMode('none')
          mapStore.clearSelectedCountries()
        } else {
          // Sinon : afficher tous les pays
          mapStore.setCountryDisplayMode('all')
          mapStore.clearSelectedCountries()
        }
      } else {
        console.log(`[SelectionSystem] 🏳️ Synchronisation des pays - visibleCountries: ${this.visibleCountries.length}`, this.visibleCountries)
        mapStore.setCountryDisplayMode('selected')
        mapStore.setSelectedCountries(this.visibleCountries)
        console.log(`[SelectionSystem] 🏳️ Countries synchronisés avec mapStore, countryDisplayMode: ${mapStore.countryDisplayMode}`)
      }
      
      // Synchroniser les zones de combat
      if (this.conflictZonesVisible && this.selectedConflict) {
        console.log(`[SelectionSystem] 🔥 Activation des zones de combat pour conflit ${this.selectedConflict}`)
        mapStore.visibleLayers.armedConflicts = true
        await mapStore.loadConflictZones(this.selectedConflict)
        console.log(`[SelectionSystem] 🔥 Zones de combat chargées, visibleLayers.armedConflicts: ${mapStore.visibleLayers.armedConflicts}`)
      } else {
        console.log(`[SelectionSystem] 🔥 Désactivation des zones de combat - conflictZonesVisible: ${this.conflictZonesVisible}, selectedConflict: ${this.selectedConflict}`)
        mapStore.visibleLayers.armedConflicts = false
        mapStore.armedConflicts = null
      }
      
      // Synchroniser les couches selon le type de sélection
      if (this.type === 'regime' || this.type === 'organization') {
        // Désactiver les zones de combat pour les régimes et organisations
        console.log(`[SelectionSystem] 🔥 Désactivation des zones de combat pour ${this.type}`)
        mapStore.visibleLayers.armedConflicts = false
        mapStore.armedConflicts = null
      }
      
      // Déclencher un refresh des marqueurs
      // Cela sera intercepté par le watcher dans useUnifiedMarkers
      console.log(`[SelectionSystem] ✅ syncWithStores terminé`)
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
          return this.selectConflict(id, source as 'aside' | 'panel' | 'map')
        case 'conflict-epicenter':
          // Pour les épicentres, sélectionner le conflit parent
          return this.selectConflict(id, source as 'aside' | 'panel' | 'map')
        case 'organization':
          return this.selectOrganization(id, source as 'aside' | 'panel')
        case 'regime':
          return this.selectRegime(id, source as 'aside' | 'panel')
        case 'resource':
          // TODO: Implémenter pour les ressources
          console.warn('[SelectionSystem] Sélection de ressource non implémentée')
          break
      }
    }
  }
})