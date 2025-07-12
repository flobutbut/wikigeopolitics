import { defineStore } from 'pinia'
import { getAllCountries, getNavigationData, getCategoryData, getAllPoliticalRegimes, getCountriesByRegime, getOrganizationsByType, getCountriesByOrganization } from '@/services/readService'

// Définir les interfaces pour le typage
interface AppData {
  search: { 
    enabled: boolean; 
    placeholder: string 
  };
  mainNavigation: any[];
  countryList: any[];
  politicalRegimeList: any[];
  organizationList: Record<string, any[]>;
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
  datePrisePoste?: string;
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
    type?: string;
    role?: string;
    dateAdhesion?: string;
    dateSortie?: string;
  }>;
  accords: Array<{
    id: string;
    title: string;
    type?: string;
    role?: string;
    dateAdhesion?: string;
    dateSortie?: string;
  }>;
}

// Définir le store avec Pinia
export const useAsideStore = defineStore('aside', {
  // État (state)
  state: () => ({
    // Vue actuelle
    currentView: {
      type: 'main',
      id: 'main',
      title: '',
      searchEnabled: true,
      hasReturnButton: false,
      items: [],
      organizations: null
    } as CurrentView,
    
    // Données de l'application
    appData: {
      search: {
        enabled: true,
        placeholder: 'Rechercher...'
      },
      mainNavigation: [],
      countryList: [],
      politicalRegimeList: [],
      organizationList: {},
      subPages: {},
      detailPages: {}
    } as AppData,
    
    // Données détaillées du pays sélectionné
    currentDetailData: null as CountryDetailData | null,
    
    // États de sélection
    selectedCountryId: null as string | null,
    selectedOrganizationId: null as string | null,
    selectedPoliticalRegimeId: null as string | null,
    
    // Cache des données
    dataCache: {} as Record<string, any>,
    
    // Requête de recherche
    searchQuery: '',
    
    // État de chargement
    isLoading: false,
    error: null as string | null
  }),

  // Getters (équivalent aux computed)
  getters: {
    // Getters pour les états de sélection
    isCountrySelected: (state) => (countryId: string) => state.selectedCountryId === countryId,
    isOrganizationSelected: (state) => (orgId: string) => state.selectedOrganizationId === orgId,
    isPoliticalRegimeSelected: (state) => (regimeId: string) => state.selectedPoliticalRegimeId === regimeId,
    
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
    },

    filteredPoliticalRegimes: (state) => {
      if (!state.appData.politicalRegimeList) return []
      
      if (!state.searchQuery) return state.appData.politicalRegimeList
      
      const query = state.searchQuery.toLowerCase()
      return state.appData.politicalRegimeList.filter((regime: any) => 
        regime.name.toLowerCase().includes(query) || 
        regime.description?.toLowerCase().includes(query)
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
        const [countries, navigationData, politicalRegimes] = await Promise.all([
          getAllCountries(),
          getNavigationData(),
          getAllPoliticalRegimes()
        ])
        
        // Mettre à jour l'état avec les données récupérées
        this.appData.countryList = countries || []
        this.appData.mainNavigation = navigationData?.categories || []
        this.appData.politicalRegimeList = politicalRegimes || []
        
      } catch (error) {
        console.error('Erreur lors de l\'initialisation des données:', error)
        this.error = 'Erreur lors du chargement des données'
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
            datePrisePoste: countryData.datePrisePoste,
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
            coalitions: countryData.coalitions || [],
            accords: countryData.accords || []
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
            datePrisePoste: '',
            histoire: '',
            indiceSouverainete: undefined,
            indiceDependance: undefined,
            statutStrategique: '',
            dateCreation: '',
            dateDerniereMiseAJour: '',
            sections: [],
            collapsibleSections: [],
            coalitions: [],
            accords: []
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
          datePrisePoste: '',
          histoire: '',
          indiceSouverainete: undefined,
          indiceDependance: undefined,
          statutStrategique: '',
          dateCreation: '',
          dateDerniereMiseAJour: '',
          sections: [],
          collapsibleSections: [],
          coalitions: [],
          accords: []
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
      // Vérifier si c'est la liste des régimes politiques (ancien ID)
      if (id === 'regimes-politiques') {
        this.navigateToPoliticalRegimeList()
        return
      }
      // Vérifier si c'est "Régime des états" - utiliser la liste des régimes politiques
      if (id === 'regime-des-etats') {
        this.navigateToPoliticalRegimeList()
        return
      }
      // Vérifier si c'est "Relations internationales" - utiliser la liste des organisations
      if (id === 'relations-internationales') {
        this.navigateToOrganizationsList()
        return
      }
      // Sauvegarder la vue précédente
      this.currentView.previousView = { ...this.currentView }
      
      // Charger les données de la sous-page si nécessaire
      let response
      if (!this.appData.subPages[id]) {
        response = await this.loadSubPageData(id)
      } else {
        response = this.appData.subPages[id]
      }
      // Appel direct à l'API pour obtenir la structure complète (catégorie ou sous-page)
      try {
        const categoryData = await getCategoryData(id)
        // Cas sous-page : forcer l'affichage du sous-menu
        if (categoryData && categoryData.category && categoryData.category.isSubPage) {
          this.currentView.type = 'submenu'
          this.currentView.id = categoryData.category.id
          this.currentView.title = categoryData.category.title
          this.currentView.searchEnabled = categoryData.category.searchEnabled !== false
          this.currentView.hasReturnButton = categoryData.category.hasReturnButton !== false
          this.currentView.items = categoryData.items || []
          this.currentView.organizations = categoryData.organizations || null
          this.searchQuery = ''
          return
        }
        // Cas normal (catégorie principale)
        if (categoryData) {
          this.currentView.type = 'submenu'
          this.currentView.id = categoryData.category.id
          this.currentView.title = categoryData.category.title
          this.currentView.searchEnabled = categoryData.category.searchEnabled !== false
          this.currentView.hasReturnButton = categoryData.category.hasReturnButton !== false
          this.currentView.items = categoryData.items || []
          this.currentView.organizations = categoryData.organizations || null
          this.searchQuery = ''
        }
      } catch (error) {
        console.error('Erreur lors de la navigation vers le sous-menu:', error)
      }
    },
    
    // Navigation vers la liste des pays
    navigateToCountryList() {
      console.log('Navigating to country list')
      
      // Sauvegarder la vue précédente
      this.currentView.previousView = { ...this.currentView }
      
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

    // Navigation vers la liste des régimes politiques
    navigateToPoliticalRegimeList() {
      console.log('Navigating to political regime list')
      
      // Sauvegarder la vue précédente
      this.currentView.previousView = { ...this.currentView }
      
      this.currentView.type = 'politicalRegimeList'
      this.currentView.id = 'political-regime-list'
      this.currentView.title = 'Régimes politiques'
      this.currentView.searchEnabled = true
      this.currentView.hasReturnButton = true
      this.currentView.items = []
      this.currentView.organizations = null
      
      // Réinitialiser la recherche
      this.searchQuery = ''
    },

    // Navigation vers la liste des organisations
    async navigateToOrganizationsList() {
      console.log('Navigating to organizations list')

      // Sauvegarder la vue précédente
      this.currentView.previousView = { ...this.currentView }

      this.currentView.type = 'organizationsList'
      this.currentView.id = 'organizations-list'
      this.currentView.title = 'Organisations internationales'
      this.currentView.searchEnabled = true
      this.currentView.hasReturnButton = true
      this.currentView.items = []
      this.currentView.organizations = null

      // Réinitialiser la recherche
      this.searchQuery = ''

      try {
        const organizations = await getOrganizationsByType()
        // Stocker les organisations dans appData comme les autres listes
        this.appData.organizationList = organizations || {}
      } catch (error) {
        console.error('Erreur lors du chargement des organisations internationales:', error)
        this.error = 'Erreur lors du chargement des organisations'
      }
    },
    
    // Retour à la vue principale
    async returnToMainView() {
      console.log('Returning to main view')
      this.currentView.type = 'main'
      this.currentView.id = 'main'
      this.currentView.title = ''
      this.currentView.searchEnabled = this.appData.search?.enabled !== false
      this.currentView.hasReturnButton = false
      this.currentView.items = []
      this.currentView.organizations = null
      
      // Effacer toutes les sélections
      this.clearAllSelections()
      
      // Effacer les sélections sur la carte
      const { useMapStore } = await import('@/stores/mapStore')
      const mapStore = useMapStore()
      mapStore.clearSelectedCountries()
      
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
      
      // Mettre à jour l'état de sélection
      this.selectedCountryId = id
      this.selectedOrganizationId = null
      this.selectedPoliticalRegimeId = null
      
      // Charger les données du pays pour le panneau flottant
      await this.loadCountryData(id)
      
      // NE PAS changer la vue actuelle - l'utilisateur reste sur la vue active
      // Les données sont disponibles dans currentDetailData pour le panneau flottant
    },
    
    // Sélection d'une organisation
    async selectOrganization(id: string) {
      console.log('Organization selected:', id)
      
      // Mettre à jour l'état de sélection
      this.selectedOrganizationId = id
      this.selectedCountryId = null
      this.selectedPoliticalRegimeId = null
      
      try {
        // Trouver le nom de l'organisation
        let organizationName = 'Organisation'
        if (this.appData.organizationList) {
          for (const type in this.appData.organizationList) {
            const org = this.appData.organizationList[type].find((o: any) => o.id === id)
            if (org) {
              organizationName = org.title
              break
            }
          }
        }
        
        // Charger les pays membres de cette organisation
        const countries = await getCountriesByOrganization(id)
        
        // Mettre à jour les marqueurs sur la carte
        const { useMapStore } = await import('@/stores/mapStore')
        const mapStore = useMapStore()
        
        // Extraire les IDs des pays membres
        const countryIds = countries.map(country => country.id)
        console.log('Pays membres de l\'organisation:', countryIds)
        
        // Sélectionner ces pays sur la carte
        mapStore.selectMultipleCountries(countryIds)
        
        // NE PAS changer la vue - l'utilisateur reste sur la liste des organisations
        // Les données sont disponibles pour le panneau flottant si nécessaire
        
      } catch (error) {
        console.error('Erreur lors du chargement des pays par organisation:', error)
        this.error = 'Erreur lors du chargement des pays'
      }
    },

    // Sélection d'un régime politique
    async selectPoliticalRegime(id: string) {
      console.log('Political regime selected:', id)
      
      // Mettre à jour l'état de sélection
      this.selectedPoliticalRegimeId = id
      this.selectedCountryId = null
      this.selectedOrganizationId = null
      
      try {
        // Sauvegarder la vue précédente
        this.currentView.previousView = { ...this.currentView }
        
        // Trouver le nom du régime politique
        const regime = this.appData.politicalRegimeList.find(r => r.id === id)
        const regimeName = regime ? regime.name : 'Régime politique'
        
        // Charger les pays associés à ce régime
        const countries = await getCountriesByRegime(id)
        
        // Mettre à jour la vue pour afficher les pays de ce régime
        this.currentView.type = 'countryList'
        this.currentView.id = `regime-${id}-countries`
        this.currentView.title = regimeName
        this.currentView.searchEnabled = true
        this.currentView.hasReturnButton = true
        this.currentView.items = []
        this.currentView.organizations = null
        
        // Mettre à jour la liste des pays filtrés pour ce régime
        this.appData.countryList = countries || []
        
        // Mettre à jour les marqueurs sur la carte
        const { useMapStore } = await import('@/stores/mapStore')
        const mapStore = useMapStore()
        
        // Extraire les IDs des pays membres
        const countryIds = countries.map(country => country.id)
        console.log('Pays avec ce régime politique:', countryIds)
        
        // Sélectionner ces pays sur la carte
        mapStore.selectMultipleCountries(countryIds)
        
        // Réinitialiser la recherche
        this.searchQuery = ''
        
      } catch (error) {
        console.error('Erreur lors du chargement des pays par régime:', error)
        this.error = 'Erreur lors du chargement des pays'
      }
    },
    
    // Actions pour effacer les sélections
    clearCountrySelection() {
      this.selectedCountryId = null
    },
    
    clearOrganizationSelection() {
      this.selectedOrganizationId = null
    },
    
    clearPoliticalRegimeSelection() {
      this.selectedPoliticalRegimeId = null
    },
    
    // Effacer toutes les sélections
    clearAllSelections() {
      this.selectedCountryId = null
      this.selectedOrganizationId = null
      this.selectedPoliticalRegimeId = null
    },
    
    // Gestion de la recherche
    setSearchQuery(query: string) {
      this.searchQuery = query
    },
    
    handleToggleOption(option: { id: string, enabled: boolean }) {
      console.log('Option toggled:', option.id, option.enabled)
      // Logique pour gérer le changement d'état d'une option
    },
    
    // Retour à la vue précédente (navigation hiérarchique)
    async returnToPreviousView() {
      console.log('Returning to previous view, current type:', this.currentView.type)
      
      // Utiliser la vue précédente sauvegardée pour remonter d'un niveau
      if (this.currentView.previousView) {
        console.log('Returning to previous view:', this.currentView.previousView.type)
        
        // Restaurer la vue précédente
        this.currentView = { ...this.currentView.previousView }
        
        // Nettoyer la vue précédente pour éviter les références circulaires
        this.currentView.previousView = undefined
        
        // Effacer les sélections sur la carte si on retourne au menu principal
        if (this.currentView.type === 'main') {
          const { useMapStore } = await import('@/stores/mapStore')
          const mapStore = useMapStore()
          mapStore.clearSelectedCountries()
        }
        
        // Réinitialiser la recherche
        this.searchQuery = ''
      } else {
        // Si pas de vue précédente, retourner au menu principal
        console.log('No previous view, returning to main')
        await this.returnToMainView()
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