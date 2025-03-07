import { defineStore } from 'pinia'
import menuData from '@data/menu.json'

// Définir les interfaces pour le typage
interface AppData {
  search: { 
    enabled: boolean; 
    placeholder: string 
  };
  mainNavigation: any[];
  countryList: any[];
  subPages: Record<string, any>;
}

interface CurrentView {
  type: string;
  id: string;
  title: string;
  searchEnabled: boolean;
  hasReturnButton: boolean;
  items: any[];
  organizations: any[] | null;
}

// Définir le store avec Pinia
export const useAsideStore = defineStore('aside', {
  // État (state)
  state: () => ({
    searchQuery: '',
    appData: {
      search: { enabled: true, placeholder: "Rechercher" },
      mainNavigation: [],
      countryList: [],
      subPages: {}
    } as AppData,
    currentView: {
      type: 'main',
      id: 'main',
      title: '',
      searchEnabled: true,
      hasReturnButton: false,
      items: [],
      organizations: null
    } as CurrentView
  }),

  // Getters (équivalent aux computed)
  getters: {
    searchPlaceholder: (state) => {
      return state.appData.search?.placeholder || "Rechercher"
    },
    
    filteredNavigation: (state) => {
      if (!state.appData.mainNavigation) return []
      
      if (!state.searchQuery) return state.appData.mainNavigation
      
      const query = state.searchQuery.toLowerCase()
      return state.appData.mainNavigation.filter(category => {
        // Vérifier si le titre de la catégorie correspond
        if (category.title.toLowerCase().includes(query)) return true
        
        // Vérifier les options de toggle
        if (category.toggleOptions && category.toggleOptions.some(opt => 
          opt.title.toLowerCase().includes(query)
        )) return true
        
        // Vérifier les éléments
        if (category.items && category.items.some(item => 
          item.title.toLowerCase().includes(query)
        )) return true
        
        return false
      })
    },
    
    filteredItems: (state) => {
      if (!state.currentView.items) return []
      
      if (!state.searchQuery) return state.currentView.items
      
      const query = state.searchQuery.toLowerCase()
      return state.currentView.items.filter(item => 
        item.title.toLowerCase().includes(query)
      )
    },
    
    filteredOrganizations: (state) => {
      if (!state.currentView.organizations) return []
      
      if (!state.searchQuery) return state.currentView.organizations
      
      const query = state.searchQuery.toLowerCase()
      return state.currentView.organizations.filter(org => 
        org.title.toLowerCase().includes(query)
      )
    },
    
    filteredCountries: (state) => {
      if (!state.appData.countryList) return []
      
      if (!state.searchQuery) return state.appData.countryList
      
      const query = state.searchQuery.toLowerCase()
      return state.appData.countryList.filter(country => 
        country.title.toLowerCase().includes(query) || 
        country.flag.includes(query)
      )
    }
  },

  // Actions (méthodes)
  actions: {
    // Initialiser les données
    initializeData() {
      this.appData = menuData.applicationStructure
      console.log('App data loaded:', this.appData)
    },
    
    // Navigation vers un sous-menu
    navigateToSubmenu(id: string) {
      console.log('Navigating to submenu:', id)
      
      // Vérifier si c'est la liste des pays
      if (id === 'pays-du-monde-list') {
        this.navigateToCountryList()
        return
      }
      
      // Chercher le sous-menu dans les subPages
      const subPage = this.appData.subPages[id]
      if (subPage) {
        this.currentView.type = 'submenu'
        this.currentView.id = id
        this.currentView.title = subPage.title
        this.currentView.searchEnabled = subPage.searchEnabled !== false
        this.currentView.hasReturnButton = subPage.hasReturnButton !== false
        this.currentView.items = subPage.items || []
        this.currentView.organizations = subPage.organizations || null
        
        // Réinitialiser la recherche
        this.searchQuery = ''
      }
    },
    
    // Navigation vers la liste des pays
    navigateToCountryList() {
      console.log('Navigating to country list')
      this.currentView.type = 'countryList'
      this.currentView.id = 'country-list'
      this.currentView.title = 'Pays du monde'
      this.currentView.searchEnabled = true
      this.currentView.hasReturnButton = true
      this.currentView.items = []
      this.currentView.organizations = null
      
      // Réinitialiser la recherche
      this.searchQuery = ''
    },
    
    // Retour à la vue principale
    returnToMainView() {
      console.log('Returning to main view')
      this.currentView.type = 'main'
      this.currentView.id = 'main'
      this.currentView.title = ''
      this.currentView.searchEnabled = this.appData.search?.enabled !== false
      this.currentView.hasReturnButton = false
      this.currentView.items = []
      this.currentView.organizations = null
      
      // Réinitialiser la recherche
      this.searchQuery = ''
    },
    
    // Navigation vers un détail
    navigateToDetail(id: string) {
      console.log('Navigating to detail:', id)
      // Logique pour naviguer vers un détail spécifique
    },
    
    // Sélection d'un pays
    selectCountry(id: string) {
      console.log('Country selected:', id)
      // Logique pour sélectionner un pays
    },
    
    // Sélection d'une organisation
    selectOrganization(id: string) {
      console.log('Organization selected:', id)
      // Logique pour sélectionner une organisation
    },
    
    // Gestion de la recherche
    setSearchQuery(query: string) {
      this.searchQuery = query
    },
    
    handleToggleOption(option: { id: string, enabled: boolean }) {
      console.log('Option toggled:', option.id, option.enabled)
      // Logique pour gérer le changement d'état d'une option
    }
  }
}) 