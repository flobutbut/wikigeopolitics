import { defineStore } from 'pinia'
import { getAllCountries, getNavigationData, getCategoryData } from '@/services/readService'

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
  previousView?: CurrentView;
}

interface CollapsibleSection {
  id: string;
  title: string;
  expanded: boolean;
  content: string;
  source?: string;
  sourceUrl?: string;
}

interface CountryDetailData {
  id: string;
  title: string;
  drapeau?: string;
  capitale?: string;
  langue?: string;
  monnaie?: string;
  pib?: number;
  population?: number;
  revenuMedian?: number;
  superficieKm2?: number;
  regimePolitique?: string;
  appartenanceGeographique?: string;
  chefEtat?: string;
  histoire?: string;
  indiceSouverainete?: number;
  indiceDependance?: number;
  statutStrategique?: string;
  dateCreation?: string;
  dateDerniereMiseAJour?: string;
  sections: Array<{
    title?: string;
    value?: string;
    keyValues?: Array<{
      key: string;
      value: string;
    }>;
  }>;
  collapsibleSections: CollapsibleSection[];
  coalitions: Array<{
    id: string;
    title: string;
  }>;
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
      drapeau: '',
      capitale: '',
      langue: '',
      monnaie: '',
      pib: undefined,
      population: undefined,
      revenuMedian: undefined,
      superficieKm2: undefined,
      regimePolitique: '',
      appartenanceGeographique: '',
      chefEtat: '',
      histoire: '',
      indiceSouverainete: undefined,
      indiceDependance: undefined,
      statutStrategique: '',
      dateCreation: '',
      dateDerniereMiseAJour: '',
      sections: [],
      collapsibleSections: [] as CollapsibleSection[],
      coalitions: []
    } as CountryDetailData,
    // Ajouter un cache pour les données chargées
    dataCache: {} as Record<string, any>,
    // État de chargement
    isLoading: false,
    error: null as string | null
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
        if (category.toggleOptions && category.toggleOptions.some((opt: any) => 
          opt.title.toLowerCase().includes(query)
        )) return true
        
        // Vérifier les éléments
        if (category.items && category.items.some((item: any) => 
          item.title.toLowerCase().includes(query)
        )) return true
        
        return false
      })
    },
    
    filteredItems: (state) => {
      if (!state.currentView.items) return []
      
      if (!state.searchQuery) return state.currentView.items
      
      const query = state.searchQuery.toLowerCase()
      return state.currentView.items.filter((item: any) => 
        item.title?.toLowerCase().includes(query) || 
        item.name?.toLowerCase().includes(query)
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
      return state.appData.countryList.filter((country: any) => 
        country.title.toLowerCase().includes(query) || 
        country.flag.includes(query)
      )
    }
  },

  // Actions (méthodes)
  actions: {
    // Initialiser les données de base depuis la base de données
    async initializeData() {
      try {
        this.isLoading = true
        this.error = null
        
        // Charger les données depuis la base de données
        const [countries, navigationData] = await Promise.all([
          getAllCountries(),
          getNavigationData()
        ])
        
        // Assembler les données
        this.appData = {
          search: { enabled: true, placeholder: "Rechercher" },
          mainNavigation: navigationData.categories || [],
          countryList: countries || [],
          subPages: {},
          detailPages: {}
        }
        
        console.log('App data loaded from database')
      } catch (error) {
        console.error('Error loading app data from database:', error)
        this.error = 'Impossible de charger les données depuis la base de données'
      } finally {
        this.isLoading = false
      }
    },
    
    // Charger les données d'une sous-page à la demande depuis la base de données
    async loadSubPageData(id: string) {
      // Vérifier si les données sont déjà en cache
      if (this.dataCache[`subpage-${id}`]) {
        this.appData.subPages[id] = this.dataCache[`subpage-${id}`]
        return
      }
      
      try {
        this.isLoading = true
        
        // Charger les données depuis la base de données
        const categoryData = await getCategoryData(id)
        
        if (categoryData) {
          this.appData.subPages[id] = {
            title: categoryData.category.nom,
            items: categoryData.data || []
          }
        } else {
          // Fallback si la catégorie n'existe pas
          this.appData.subPages[id] = { 
            title: id, 
            items: [] 
          }
        }
        
        // Mettre en cache les données
        this.dataCache[`subpage-${id}`] = this.appData.subPages[id]
        
      } catch (error) {
        console.error(`Error loading subpage data for ${id} from database:`, error)
        // Créer une page par défaut en cas d'erreur
        this.appData.subPages[id] = { title: id, items: [] }
      } finally {
        this.isLoading = false
      }
    },
    
    // Charger les données d'un pays à la demande depuis la base de données
    async loadCountryData(id: string) {
      // Vérifier si les données sont déjà en cache
      if (this.dataCache[`country-${id}`]) {
        this.currentDetailData = this.dataCache[`country-${id}`]
        return
      }
      
      try {
        this.isLoading = true
        
        // Charger les données du pays depuis la base de données
        const { getCountryDetails } = await import('@/services/readService')
        const countryData = await getCountryDetails(id)
        
        if (countryData) {
          this.currentDetailData = {
            id: countryData.id,
            title: countryData.title,
            drapeau: countryData.drapeau,
            capitale: countryData.capitale,
            langue: countryData.langue,
            monnaie: countryData.monnaie,
            pib: countryData.pib,
            population: countryData.population,
            revenuMedian: countryData.revenuMedian,
            superficieKm2: countryData.superficieKm2,
            regimePolitique: countryData.regimePolitique,
            appartenanceGeographique: countryData.appartenanceGeographique,
            chefEtat: countryData.chefEtat,
            histoire: countryData.histoire,
            indiceSouverainete: countryData.indiceSouverainete,
            indiceDependance: countryData.indiceDependance,
            statutStrategique: countryData.statutStrategique,
            dateCreation: countryData.dateCreation,
            dateDerniereMiseAJour: countryData.dateDerniereMiseAJour,
            sections: countryData.sections || [],
            collapsibleSections: [
              {
                id: 'histoire',
                title: 'Histoire',
                expanded: false,
                content: countryData.histoire?.content || 'Aucune information disponible'
              },
              {
                id: 'politique',
                title: 'Système politique',
                expanded: false,
                content: countryData.politique?.content || 'Aucune information disponible'
              },
              {
                id: 'economie',
                title: 'Économie',
                expanded: false,
                content: countryData.economie?.content || 'Aucune information disponible'
              },
              {
                id: 'demographie',
                title: 'Société et Démographie',
                expanded: false,
                content: countryData.demographie?.content || 'Aucune information disponible'
              }
            ] as CollapsibleSection[],
            coalitions: countryData.politicalRegime?.organizations || []
          }
        } else {
          // Créer des données par défaut si le pays n'existe pas
          this.currentDetailData = {
            id: id,
            title: id.charAt(0).toUpperCase() + id.slice(1).replace(/-/g, ' '),
            drapeau: '',
            capitale: '',
            langue: '',
            monnaie: '',
            pib: undefined,
            population: undefined,
            revenuMedian: undefined,
            superficieKm2: undefined,
            regimePolitique: '',
            appartenanceGeographique: '',
            chefEtat: '',
            histoire: '',
            indiceSouverainete: undefined,
            indiceDependance: undefined,
            statutStrategique: '',
            dateCreation: '',
            dateDerniereMiseAJour: '',
            sections: [],
            collapsibleSections: [],
            coalitions: []
          }
        }
        
        // Mettre en cache les données
        this.dataCache[`country-${id}`] = this.currentDetailData
        
      } catch (error) {
        console.error(`Error loading country data for ${id} from database:`, error)
        // Créer des données par défaut en cas d'erreur
        this.currentDetailData = {
          id: id,
          title: id.charAt(0).toUpperCase() + id.slice(1).replace(/-/g, ' '),
          drapeau: '',
          capitale: '',
          langue: '',
          monnaie: '',
          pib: undefined,
          population: undefined,
          revenuMedian: undefined,
          superficieKm2: undefined,
          regimePolitique: '',
          appartenanceGeographique: '',
          chefEtat: '',
          histoire: '',
          indiceSouverainete: undefined,
          indiceDependance: undefined,
          statutStrategique: '',
          dateCreation: '',
          dateDerniereMiseAJour: '',
          sections: [],
          collapsibleSections: [],
          coalitions: []
        }
      } finally {
        this.isLoading = false
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
    },

    // Mettre à jour la vue courante
    updateCurrentView(view: Partial<CurrentView>) {
      this.currentView = { ...this.currentView, ...view }
    },

    // Naviguer vers une vue
    navigateToView(view: CurrentView) {
      this.currentView.previousView = { ...this.currentView }
      this.currentView = view
    },

    // Retourner à la vue précédente
    goBack() {
      if (this.currentView.previousView) {
        this.currentView = this.currentView.previousView
      }
    },

    // Mettre à jour la requête de recherche
    updateSearchQuery(query: string) {
      this.searchQuery = query
    },

    // Effacer la recherche
    clearSearch() {
      this.searchQuery = ''
    }
  }
}) 