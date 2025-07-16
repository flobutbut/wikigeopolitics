/**
 * Store dédié à la gestion de la navigation
 */

import { defineStore } from 'pinia'
import { useNavigation, type NavigationState } from '@/composables/useNavigation'
import { getCategoryData } from '@/services/readService'

export interface NavigationStoreState {
  currentView: NavigationState
  searchQuery: string
}

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
    // Navigation vers un sous-menu
    async navigateToSubmenu(id: string) {
      console.log('Navigating to submenu:', id)
      
      // Routes spéciales
      const specialRoutes: Record<string, () => void> = {
        'pays-du-monde-list': () => this.navigateToCountryList(),
        'regimes-politiques': () => this.navigateToPoliticalRegimeList(),
        'regime-des-etats': () => this.navigateToPoliticalRegimeList(),
        'relations-internationales': () => this.navigateToOrganizationsList(),
        'conflits-armes': () => this.navigateToArmedConflictsList()
      }

      if (specialRoutes[id]) {
        specialRoutes[id]()
        return
      }

      // Navigation normale
      try {
        const categoryData = await getCategoryData(id)
        
        if (categoryData) {
          this.updateCurrentView({
            type: categoryData.category?.isSubPage ? 'submenu' : 'submenu',
            id: categoryData.category.id,
            title: categoryData.category.title,
            searchEnabled: categoryData.category.searchEnabled !== false,
            hasReturnButton: categoryData.category.hasReturnButton !== false,
            items: categoryData.items || [],
            organizations: categoryData.organizations || null
          })
        }
      } catch (error) {
        console.error('Erreur lors de la navigation vers le sous-menu:', error)
      }
    },

    // Navigation vers la liste des pays
    navigateToCountryList() {
      const selectionStore = useSelectionStore()
      
      this.updateCurrentView({
        type: 'countryList',
        id: 'country-list',
        title: 'Liste des pays',
        searchEnabled: true,
        hasReturnButton: true,
        items: selectionStore.appData.countryList,
        organizations: null
      })
    },

    // Navigation vers la liste des régimes politiques
    navigateToPoliticalRegimeList() {
      const selectionStore = useSelectionStore()
      
      this.updateCurrentView({
        type: 'politicalRegimeList',
        id: 'political-regime-list',
        title: 'Régimes politiques',
        searchEnabled: true,
        hasReturnButton: true,
        items: selectionStore.appData.politicalRegimeList,
        organizations: null
      })
    },

    // Navigation vers la liste des organisations
    navigateToOrganizationsList() {
      const selectionStore = useSelectionStore()
      
      this.updateCurrentView({
        type: 'organizationList',
        id: 'organization-list',
        title: 'Organisations internationales',
        searchEnabled: true,
        hasReturnButton: true,
        items: Object.values(selectionStore.appData.organizationList).flat(),
        organizations: null
      })
    },

    // Navigation vers la liste des conflits armés
    navigateToArmedConflictsList() {
      const selectionStore = useSelectionStore()
      
      this.updateCurrentView({
        type: 'armedConflictList',
        id: 'armed-conflict-list',
        title: 'Conflits armés',
        searchEnabled: true,
        hasReturnButton: true,
        items: selectionStore.appData.armedConflictList,
        organizations: null
      })
    },

    // Retourner à la vue principale
    returnToMain() {
      this.updateCurrentView({
        type: 'main',
        id: 'main',
        title: '',
        searchEnabled: true,
        hasReturnButton: false,
        items: [],
        organizations: null
      })
      this.clearSearch()
    },

    // Mettre à jour la vue actuelle
    updateCurrentView(view: Partial<NavigationState>) {
      this.currentView = { ...this.currentView, ...view }
      this.clearSearch()
    },

    // Gestion de la recherche
    setSearchQuery(query: string) {
      this.searchQuery = query
    },

    clearSearch() {
      this.searchQuery = ''
    }
  }
})

// Import circulaire résolu en bas du fichier
import { useSelectionStore } from './selectionStore'