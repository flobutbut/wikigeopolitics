/**
 * Store dédié à la gestion des sélections
 */

import { defineStore } from 'pinia'
import { useSelection, type SelectionType } from '@/composables/useSelection'
import { useMapStore } from './mapStore'

export interface CountryDetailData {
  id: string
  title: string
  drapeau?: string
  capitale?: string
  langue?: string
  monnaie?: string
  pib?: number
  population?: number
  revenuMedian?: number
  superficieKm2?: number
  regimePolitique?: string
  organisations?: string[]
  collapsibleSections?: CollapsibleSection[]
}

export interface CollapsibleSection {
  id: string
  title: string
  expanded: boolean
  content: string
  source?: string
  sourceUrl?: string
}

export interface AppData {
  search: { 
    enabled: boolean
    placeholder: string 
  }
  mainNavigation: any[]
  countryList: any[]
  politicalRegimeList: any[]
  organizationList: Record<string, any[]>
  armedConflictList: any[]
  subPages: Record<string, any>
  detailPages: Record<string, any>
}

export interface SelectionStoreState {
  // Données de l'application
  appData: AppData
  
  // Données détaillées du pays sélectionné
  currentDetailData: CountryDetailData | null
  
  // États des sélections
  selectedCountryId: string | null
  selectedOrganizationId: string | null
  selectedPoliticalRegimeId: string | null
  selectedArmedConflictId: string | null
}

export const useSelectionStore = defineStore('selection', {
  state: (): SelectionStoreState => ({
    appData: {
      search: {
        enabled: true,
        placeholder: 'Rechercher...'
      },
      mainNavigation: [],
      countryList: [],
      politicalRegimeList: [],
      organizationList: {},
      armedConflictList: [],
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
    // Getters pour les données
    countries: (state) => state.appData.countryList,
    organizations: (state) => state.appData.organizationList,
    politicalRegimes: (state) => state.appData.politicalRegimeList,
    armedConflicts: (state) => state.appData.armedConflictList,
    mainNavigation: (state) => state.appData.mainNavigation,
    
    // Getters pour les sélections
    selectedCountry: (state) => {
      if (!state.selectedCountryId) return null
      return state.appData.countryList.find(c => c.id === state.selectedCountryId) || null
    },
    
    selectedOrganization: (state) => {
      if (!state.selectedOrganizationId) return null
      const allOrgs = Object.values(state.appData.organizationList).flat()
      return allOrgs.find(o => o.id === state.selectedOrganizationId) || null
    },
    
    selectedPoliticalRegime: (state) => {
      if (!state.selectedPoliticalRegimeId) return null
      return state.appData.politicalRegimeList.find(r => r.id === state.selectedPoliticalRegimeId) || null
    },
    
    selectedArmedConflict: (state) => {
      if (!state.selectedArmedConflictId) return null
      return state.appData.armedConflictList.find(c => c.id === state.selectedArmedConflictId) || null
    },
    
    // État de sélection
    hasAnySelection: (state) => {
      return !!(state.selectedCountryId || 
               state.selectedOrganizationId || 
               state.selectedPoliticalRegimeId || 
               state.selectedArmedConflictId)
    },
    
    currentSelectionType: (state): SelectionType | null => {
      if (state.selectedCountryId) return 'country'
      if (state.selectedOrganizationId) return 'organization'
      if (state.selectedPoliticalRegimeId) return 'politicalRegime'
      if (state.selectedArmedConflictId) return 'armedConflict'
      return null
    }
  },

  actions: {
    // Gestion des données de l'application
    setAppData(data: Partial<AppData>) {
      this.appData = { ...this.appData, ...data }
    },

    setCountryList(countries: any[]) {
      this.appData.countryList = countries
    },

    setPoliticalRegimeList(regimes: any[]) {
      this.appData.politicalRegimeList = regimes
    },

    setOrganizationList(organizations: Record<string, any[]>) {
      this.appData.organizationList = organizations
    },

    setArmedConflictList(conflicts: any[]) {
      this.appData.armedConflictList = conflicts
    },

    setMainNavigation(navigation: any[]) {
      this.appData.mainNavigation = navigation
    },

    // Gestion des sélections de pays
    selectCountry(id: string) {
      this.clearNonCountrySelections()
      this.selectedCountryId = id
      this.syncWithMapStore()
    },

    selectMultipleCountries(ids: string[]) {
      this.clearNonCountrySelections()
      // Pour la compatibilité, on prend le premier pays
      this.selectedCountryId = ids[0] || null
      this.syncWithMapStore()
    },

    // Gestion des autres sélections
    selectOrganization(id: string) {
      this.clearAllSelections()
      this.selectedOrganizationId = id
    },

    selectPoliticalRegime(id: string) {
      this.clearAllSelections()
      this.selectedPoliticalRegimeId = id
    },

    selectArmedConflict(id: string) {
      this.clearAllSelections()
      this.selectedArmedConflictId = id
    },

    // Nettoyage des sélections
    clearSelection(type?: SelectionType) {
      if (!type) {
        this.clearAllSelections()
        return
      }

      switch (type) {
        case 'country':
          this.selectedCountryId = null
          break
        case 'organization':
          this.selectedOrganizationId = null
          break
        case 'politicalRegime':
          this.selectedPoliticalRegimeId = null
          break
        case 'armedConflict':
          this.selectedArmedConflictId = null
          break
      }
      
      this.syncWithMapStore()
    },

    clearAllSelections() {
      this.selectedCountryId = null
      this.selectedOrganizationId = null
      this.selectedPoliticalRegimeId = null
      this.selectedArmedConflictId = null
      this.syncWithMapStore()
    },

    clearNonCountrySelections() {
      this.selectedOrganizationId = null
      this.selectedPoliticalRegimeId = null
      this.selectedArmedConflictId = null
    },

    // Vérification de sélection
    isSelected(type: SelectionType, id: string): boolean {
      switch (type) {
        case 'country':
          return this.selectedCountryId === id
        case 'organization':
          return this.selectedOrganizationId === id
        case 'politicalRegime':
          return this.selectedPoliticalRegimeId === id
        case 'armedConflict':
          return this.selectedArmedConflictId === id
        default:
          return false
      }
    },

    // Gestion des détails du pays
    setCurrentDetailData(data: CountryDetailData | null) {
      this.currentDetailData = data
    },

    // Synchronisation avec le store de la carte
    syncWithMapStore() {
      const mapStore = useMapStore()
      if (this.selectedCountryId) {
        mapStore.selectMultipleCountries([this.selectedCountryId])
      } else {
        mapStore.selectMultipleCountries([])
      }
    }
  }
})