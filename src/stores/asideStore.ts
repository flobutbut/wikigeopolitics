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
  detailPages: Record<string, any>;
}

interface CurrentView {
  type: string;
  id: string;
  title: string;
  searchEnabled: boolean;
  hasReturnButton: boolean;
  items: any[];
  organizations: any[] | null;
  previousView?: { type: string; id: string };
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
      subPages: {},
      detailPages: {}
    } as AppData,
    currentView: {
      type: 'main',
      id: 'main',
      title: '',
      searchEnabled: true,
      hasReturnButton: false,
      items: [],
      organizations: null,
      previousView: undefined
    } as CurrentView,
    currentDetailData: {
      id: '',
      title: '',
      sections: [],
      collapsibleSections: [],
      coalitions: []
    },
    // Ajouter un cache pour les données chargées
    dataCache: {} as Record<string, any>
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
    // Initialiser les données de base
    async initializeData() {
      try {
        // Charger la structure de l'application
        const appStructure = await import('@data/app/app-structure.json')
        
        // Charger la navigation principale
        const mainNavigation = await import('@data/app/main-navigation.json')
        
        // Charger la liste des pays (version légère)
        const countryList = await import('@data/countries/index.json')
        
        // Assembler les données
        this.appData = {
          search: appStructure.search,
          mainNavigation: mainNavigation.categories,
          countryList: countryList.countries,
          subPages: {},
          detailPages: {}
        }
        
        console.log('App data loaded')
      } catch (error) {
        console.error('Error loading app data:', error)
      }
    },
    
    // Charger les données d'une sous-page à la demande
    async loadSubPageData(id: string) {
      // Vérifier si les données sont déjà en cache
      if (this.dataCache[`subpage-${id}`]) {
        this.appData.subPages[id] = this.dataCache[`subpage-${id}`]
        return
      }
      
      try {
        // Déterminer le fichier à charger en fonction de l'ID
        let dataModule
        
        if (id.startsWith('relations-')) {
          dataModule = await import('@data/categories/politics.json')
          this.appData.subPages[id] = dataModule.subPages[id]
        } else if (id.startsWith('commerce-')) {
          dataModule = await import('@data/categories/economy.json')
          this.appData.subPages[id] = dataModule.subPages[id]
        } else {
          // Essayer de charger directement un fichier correspondant à l'ID
          try {
            dataModule = await import(`@data/categories/${id}.json`)
            this.appData.subPages[id] = dataModule.default
          } catch {
            console.warn(`No specific file found for ${id}, using fallback`)
            // Fallback: charger toutes les catégories
            const allCategories = await import('@data/categories/index.json')
            this.appData.subPages[id] = allCategories.subPages[id] || { title: id, items: [] }
          }
        }
        
        // Mettre en cache les données
        this.dataCache[`subpage-${id}`] = this.appData.subPages[id]
        
      } catch (error) {
        console.error(`Error loading subpage data for ${id}:`, error)
        // Créer une page par défaut en cas d'erreur
        this.appData.subPages[id] = { title: id, items: [] }
      }
    },
    
    // Charger les données d'un pays à la demande
    async loadCountryData(id: string) {
      // Vérifier si les données sont déjà en cache
      if (this.dataCache[`country-${id}`]) {
        this.currentDetailData = this.dataCache[`country-${id}`]
        return
      }
      
      try {
        // Charger les données du pays
        const countryData = await import(`@data/countries/${id}.json`)
        this.currentDetailData = countryData.default
        
        // Mettre en cache les données
        this.dataCache[`country-${id}`] = this.currentDetailData
        
      } catch (error) {
        console.error(`Error loading country data for ${id}:`, error)
        // Créer des données par défaut en cas d'erreur
        this.currentDetailData = {
          id: id,
          title: id.charAt(0).toUpperCase() + id.slice(1).replace(/-/g, ' '),
          sections: [],
          collapsibleSections: [],
          coalitions: []
        }
      }
    },
    
    // Navigation vers un sous-menu (mise à jour)
    async navigateToSubmenu(id: string) {
      console.log('Navigating to submenu:', id)
      
      // Vérifier si c'est la liste des pays
      if (id === 'pays-du-monde-list') {
        this.navigateToCountryList()
        return
      }
      
      // Charger les données de la sous-page si nécessaire
      if (!this.appData.subPages[id]) {
        await this.loadSubPageData(id)
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
    
    // Sélection d'un pays (mise à jour)
    async selectCountry(id: string) {
      console.log('Country selected:', id)
      
      // Charger les données du pays pour le panneau flottant
      await this.loadCountryData(id)
      
      // NE PAS changer la vue actuelle - l'utilisateur reste sur la vue active
      // Les données sont disponibles dans currentDetailData pour le panneau flottant
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
    },
    
    // Retour à la vue précédente
    returnToPreviousView() {
      if (this.currentView.previousView) {
        if (this.currentView.previousView.type === 'main') {
          this.returnToMainView()
        } else if (this.currentView.previousView.type === 'submenu') {
          this.navigateToSubmenu(this.currentView.previousView.id)
        } else if (this.currentView.previousView.type === 'countryList') {
          this.navigateToCountryList()
        }
      } else {
        // Par défaut, retour à la vue principale
        this.returnToMainView()
      }
    }
  }
}) 