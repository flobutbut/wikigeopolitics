/**
 * Store dédié à la gestion des données et du cache
 */

import { defineStore } from 'pinia'
import { useAsyncState } from '@/composables/useAsyncState'
import { 
  getAllCountries, 
  getNavigationData, 
  getAllPoliticalRegimes,
  getCategoryData,
  getCountriesByRegime,
  getOrganizationsByType,
  getCountriesByOrganization
} from '@/services/readService'
import { API } from '@/services/api'

export interface DataStoreState {
  // Cache des données
  dataCache: Record<string, any>
  
  // États de chargement
  isLoading: boolean
  error: string | null
  
  // Données spécifiques
  subPages: Record<string, any>
  detailPages: Record<string, any>
}

export const useDataStore = defineStore('data', {
  state: (): DataStoreState => ({
    dataCache: {},
    isLoading: false,
    error: null,
    subPages: {},
    detailPages: {}
  }),

  getters: {
    // Vérifier si des données sont en cache
    isCached: (state) => (key: string) => key in state.dataCache,
    
    // Obtenir des données du cache
    getCachedData: (state) => (key: string) => state.dataCache[key],
    
    // État de chargement global
    hasError: (state) => !!state.error,
    
    // Vérifier si une sous-page est chargée
    isSubPageLoaded: (state) => (id: string) => id in state.subPages
  },

  actions: {
    // Initialiser les données de base
    async initializeData() {
      const asyncState = useAsyncState()
      
      return await asyncState.execute(async () => {
        this.isLoading = true
        this.error = null
        
        try {
          // Charger les données depuis la base de données
          const [countries, navigationData, politicalRegimes] = await Promise.all([
            getAllCountries(),
            getNavigationData(),
            getAllPoliticalRegimes()
          ])
          
          // Mettre à jour le store de sélection
          const selectionStore = useSelectionStore()
          selectionStore.setCountryList(countries || [])
          selectionStore.setMainNavigation(navigationData?.categories || [])
          selectionStore.setPoliticalRegimeList(politicalRegimes || [])
          
          // Mettre en cache
          this.setCacheData('countries', countries)
          this.setCacheData('navigation', navigationData)
          this.setCacheData('politicalRegimes', politicalRegimes)
          
          return { countries, navigationData, politicalRegimes }
        } catch (error) {
          console.error('Erreur lors de l\'initialisation des données:', error)
          this.error = 'Erreur lors du chargement des données'
          throw error
        } finally {
          this.isLoading = false
        }
      })
    },

    // Charger les données d'une sous-page
    async loadSubPageData(id: string) {
      const cacheKey = `subpage_${id}`
      
      // Vérifier le cache
      if (this.isCached(cacheKey)) {
        return this.getCachedData(cacheKey)
      }

      const asyncState = useAsyncState()
      
      return await asyncState.execute(async () => {
        try {
          const data = await getCategoryData(id)
          
          // Mettre en cache et dans l'état
          this.setCacheData(cacheKey, data)
          this.subPages[id] = data
          
          return data
        } catch (error) {
          console.error(`Erreur lors du chargement de la sous-page ${id}:`, error)
          throw error
        }
      })
    },

    // Charger les pays par régime politique
    async loadCountriesByRegime(regimeId: string) {
      const cacheKey = `countries_by_regime_${regimeId}`
      
      if (this.isCached(cacheKey)) {
        return this.getCachedData(cacheKey)
      }

      const asyncState = useAsyncState()
      
      return await asyncState.execute(async () => {
        try {
          const countries = await getCountriesByRegime(regimeId)
          this.setCacheData(cacheKey, countries)
          return countries
        } catch (error) {
          console.error(`Erreur lors du chargement des pays pour le régime ${regimeId}:`, error)
          throw error
        }
      })
    },

    // Charger les organisations par type
    async loadOrganizationsByType(type: string) {
      const cacheKey = `organizations_by_type_${type}`
      
      if (this.isCached(cacheKey)) {
        return this.getCachedData(cacheKey)
      }

      const asyncState = useAsyncState()
      
      return await asyncState.execute(async () => {
        try {
          const organizations = await getOrganizationsByType(type)
          
          // Mettre à jour le store de sélection
          const selectionStore = useSelectionStore()
          const currentOrgs = { ...selectionStore.appData.organizationList }
          currentOrgs[type] = organizations
          selectionStore.setOrganizationList(currentOrgs)
          
          this.setCacheData(cacheKey, organizations)
          return organizations
        } catch (error) {
          console.error(`Erreur lors du chargement des organisations de type ${type}:`, error)
          throw error
        }
      })
    },

    // Charger les pays par organisation
    async loadCountriesByOrganization(organizationId: string) {
      const cacheKey = `countries_by_organization_${organizationId}`
      
      if (this.isCached(cacheKey)) {
        return this.getCachedData(cacheKey)
      }

      const asyncState = useAsyncState()
      
      return await asyncState.execute(async () => {
        try {
          const countries = await getCountriesByOrganization(organizationId)
          this.setCacheData(cacheKey, countries)
          return countries
        } catch (error) {
          console.error(`Erreur lors du chargement des pays pour l'organisation ${organizationId}:`, error)
          throw error
        }
      })
    },

    // Charger les conflits armés
    async loadArmedConflicts() {
      const cacheKey = 'armed_conflicts'
      
      if (this.isCached(cacheKey)) {
        return this.getCachedData(cacheKey)
      }

      const asyncState = useAsyncState()
      
      return await asyncState.execute(async () => {
        try {
          const conflicts = await API.armedConflicts.getAll()
          
          // Mettre à jour le store de sélection
          const selectionStore = useSelectionStore()
          selectionStore.setArmedConflictList(conflicts)
          
          this.setCacheData(cacheKey, conflicts)
          return conflicts
        } catch (error) {
          console.error('Erreur lors du chargement des conflits armés:', error)
          throw error
        }
      })
    },

    // Gestion du cache
    setCacheData(key: string, data: any) {
      this.dataCache[key] = data
    },

    removeCacheData(key: string) {
      delete this.dataCache[key]
    },

    clearCache() {
      this.dataCache = {}
    },

    // Gestion des erreurs
    setError(error: string) {
      this.error = error
    },

    clearError() {
      this.error = null
    },

    // Gestion du chargement
    setLoading(loading: boolean) {
      this.isLoading = loading
    }
  }
})

// Import circulaire résolu en bas du fichier
import { useSelectionStore } from './selectionStore'