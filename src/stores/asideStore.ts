import { defineStore } from 'pinia'
import { getAllCountries, getNavigationData, getCategoryData, getAllPoliticalRegimes, getCountriesByRegime, getOrganizationsByType, getCountriesByOrganization } from '@/services/readService'
import { supabaseService } from '@/services/supabaseService'
import { armedConflictApi } from '@/services/apiService'
import { armedConflictAPI } from '@/services/api/armedConflictAPI'
import AdaptiveApiService from '@/services/adaptiveApiService'

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
  armedConflictList: any[];
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

// Types pour les données d'entités génériques
type EntityType = 'country' | 'conflict' | 'regime' | 'organization' | 'resource'

interface BaseEntityData {
  id: string;
  title: string;
  type?: string;
  description?: string;
}

interface CountryDetailData extends BaseEntityData {
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
  conflitsArmes: Array<{
    id: string;
    nom: string;
    status: string;
    startDate?: string;
    endDate?: string;
    description?: string;
  }>;
}

interface ConflictDetailData extends BaseEntityData {
  statut?: string;
  intensite?: string;
  dateDebut?: string;
  dateFin?: string;
  localisation?: string;
  zones?: string[];
  victimes?: Record<string, any>;
  paysImpliques?: Array<{
    id: string;
    nom: string;
    flag?: string;
    role?: string;
    dateEntree?: string;
  }>;
  timeline?: Array<{
    id: string;
    date: string;
    titre: string;
    description?: string;
  }>;
}

interface RegimeDetailData extends BaseEntityData {
  classification?: string;
  systemeElectoral?: string;
  characteristics?: string[];
  countries?: Array<{
    id: string;
    nom: string;
    flag?: string;
    chefEtat?: string;
    datePrisePoste?: string;
  }>;
  avantages?: string[];
  inconvenients?: string[];
  evolutionHistorique?: string;
}

interface OrganizationDetailData extends BaseEntityData {
  statut?: string;
  domaineAction?: string;
  dateCreation?: string;
  siege?: string;
  adresse?: string;
  objectifs?: string[];
  paysMembres?: Array<{
    id: string;
    nom: string;
    flag?: string;
    statut?: string;
    dateAdhesion?: string;
    role?: string;
  }>;
  structure?: {
    organigramme?: string;
    secretaireGeneral?: string;
    mandatDebut?: string;
    organesDecision?: string[];
  };
}

interface ResourceDetailData extends BaseEntityData {
  categorie?: string;
  etatReserves?: string;
  rarete?: string;
  localisationPrincipale?: string;
  zonesExtraction?: string[];
  unite?: string;
  reservesMondiales?: {
    total?: number;
    principauxGisements?: Array<{
      id: string;
      localisation: string;
      pays?: { flag?: string };
      quantite?: number;
      pourcentageMondial?: number;
    }>;
  };
}

type EntityDetailData = CountryDetailData | ConflictDetailData | RegimeDetailData | OrganizationDetailData | ResourceDetailData

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
      armedConflictList: [],
      subPages: {},
      detailPages: {}
    } as AppData,
    
    // Données détaillées de l'entité sélectionnée
    currentDetailData: null as EntityDetailData | null,
    currentEntityType: null as EntityType | null,
    
    // États de sélection
    selectedCountryId: null as string | null,
    selectedOrganizationId: null as string | null,
    selectedPoliticalRegimeId: null as string | null,
    selectedArmedConflictId: null as string | null,
    
    // Pays impliqués dans le conflit actuellement sélectionné
    conflictCountries: [] as Array<{ id: string; nom: string; flag?: string }>,
    
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
    isArmedConflictSelected: (state) => (conflictId: string) => state.selectedArmedConflictId === conflictId,
    
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
      
      // Transformer les données pour avoir title et flag
      const transformedCountries = state.appData.countryList.map((country: any) => ({
        ...country,
        title: country.nom || country.name || country.title || country.id,
        flag: country.drapeau || country.flag,
        continent: country.continent || 'Autres'
      }))
      
      if (!state.searchQuery) return transformedCountries
      
      const query = state.searchQuery.toLowerCase()
      return transformedCountries.filter((country: any) => 
        (country.title && country.title.toLowerCase().includes(query)) || 
        (country.flag && country.flag.includes(query))
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
        
        // Charger les données depuis Supabase
        const [countries, politicalRegimes] = await Promise.all([
          supabaseService.getCountries(),
          supabaseService.getPoliticalRegimes()
        ])
        
        // Mettre à jour l'état avec les données récupérées
        this.appData.countryList = countries || []
        this.appData.politicalRegimeList = politicalRegimes || []
        
        // Debug pour voir si les données sont chargées
        console.log('🔍 Debug initializeData:')
        console.log('   Countries loaded:', this.appData.countryList.length)
        console.log('   Political regimes loaded:', this.appData.politicalRegimeList.length)
        
        // Charger le menu original depuis les données statiques
        const menuData = await import('@/data/app/menu.json')
        this.appData.mainNavigation = menuData.applicationStructure.mainNavigation
        
      } catch (error) {
        console.error('Erreur lors de l\'initialisation des données:', error)
        this.error = 'Erreur lors du chargement des données'
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
      if (id === 'relations-internationales' || id === 'organisations-internationales') {
        this.navigateToOrganizationsList()
        return
      }
      // Vérifier si c'est "Conflits armés" - utiliser la liste des conflits armés
      if (id === 'conflits-armes') {
        this.navigateToArmedConflictsList()
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
      // Définir le type d'entité en premier pour éviter les problèmes de timing
      this.currentEntityType = 'country'
      
      // FORCER RELOAD pour test - supprimer le cache
      delete this.dataCache[`country-${id}`]
      
      // if (this.dataCache[`country-${id}`]) {
      //   this.currentDetailData = this.dataCache[`country-${id}`]
      //   return
      // }
      
      try {
        this.isLoading = true
        
        // Charger les données du pays depuis Supabase
        const { supabaseService } = await import('@/services/supabaseService')
        const countryData = await supabaseService.getCountryById(id)
        
        console.log('[asideStore] 🏳️ Données pays reçues pour', id)
        
        if (countryData) {
          this.currentDetailData = {
            id: countryData.id,
            title: countryData.nom || countryData.title,
            type: 'country',
            drapeau: countryData.drapeau,
            capitale: countryData.capitale,
            langue: countryData.langue || '',
            monnaie: countryData.monnaie || '',
            pib: countryData.pib,
            population: countryData.population,
            revenuMedian: countryData.revenumedian || countryData.revenuMedian, // Utiliser le nom réel
            superficieKm2: countryData.superficie,
            regimePolitique: countryData.regime_politique || countryData.formeEtat,
            formeEtat: countryData.formeEtat || countryData.regime_politique || 'Non spécifié',
            appartenanceGeographique: countryData.continent,
            chefEtat: countryData.chef_etat,
            datePrisePoste: countryData.datePrisePoste || '',
            histoire: countryData.histoire || '',
            indiceSouverainete: countryData.indicesouverainete || countryData.indiceSouverainete,
            indiceDependance: countryData.indicedependance || countryData.indiceDependance,
            statutStrategique: countryData.statutstrategique || countryData.statutStrategique || '',
            dateCreation: countryData.datecreation || countryData.dateCreation || '',
            dateDerniereMiseAJour: countryData.datedernieremiseajour || countryData.dateDerniereMiseAJour || '',
            sections: [],
            collapsibleSections: [
              {
                id: 'histoire',
                title: 'Histoire',
                expanded: false,
                content: countryData.histoire || 'Aucune information disponible'
              },
              {
                id: 'politique',
                title: 'Système politique',
                expanded: false,
                content: `Régime: ${countryData.regime_politique || 'Non spécifié'}\nChef d'État: ${countryData.chef_etat || 'Non spécifié'}`
              },
              {
                id: 'economie',
                title: 'Économie',
                expanded: false,
                content: `PIB: ${countryData.pib ? countryData.pib.toLocaleString() + ' €' : 'Non spécifié'}\nRevenu médian: ${countryData.revenuMedian ? countryData.revenuMedian.toLocaleString() + ' €' : 'Non spécifié'}`
              },
              {
                id: 'demographie',
                title: 'Société et Démographie',
                expanded: false,
                content: `Population: ${countryData.population ? countryData.population.toLocaleString() : 'Non spécifiée'}\nSuperficie: ${countryData.superficie ? countryData.superficie.toLocaleString() + ' km²' : 'Non spécifiée'}`
              }
            ] as CollapsibleSection[],
            coalitions: countryData.coalitions || [],
            accords: countryData.accords || [],
            conflitsArmes: countryData.conflitsArmes || []
          } as CountryDetailData
          this.currentEntityType = 'country'
          
          console.log('[asideStore] 🎯 FINAL currentDetailData.regimePolitique:', this.currentDetailData.regimePolitique)
          console.log('[asideStore] 🎯 FINAL currentDetailData.chefEtat:', this.currentDetailData.chefEtat)
          console.log('[asideStore] 🎯 FINAL currentDetailData.conflitsArmes.length:', this.currentDetailData.conflitsArmes?.length)
          
          // Mettre en cache
          this.dataCache[`country-${id}`] = this.currentDetailData
        } else {
          // Créer des données par défaut si le pays n'existe pas
          this.currentDetailData = {
            id: id,
            title: id.charAt(0).toUpperCase() + id.slice(1).replace(/-/g, ' '),
            type: 'country',
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
            accords: [],
            conflitsArmes: []  // Sera chargé après
          } as CountryDetailData
          this.currentEntityType = 'country'
        }
        
        // Charger les conflits armés du pays
        try {
          console.log('🔥 Chargement des conflits armés pour le pays:', id)
          const conflicts = await supabaseService.getConflictsByCountry(id)
          console.log('🔥 Conflits trouvés:', conflicts.length)
          
          if (this.currentDetailData && 'conflitsArmes' in this.currentDetailData) {
            this.currentDetailData.conflitsArmes = conflicts.map(conflict => ({
              id: conflict.id,
              nom: conflict.nom, // Utiliser 'nom' au lieu de 'name'
              status: conflict.type, // Utiliser 'type' au lieu de 'status'
              startDate: conflict.date_debut,
              endDate: conflict.date_fin,
              description: conflict.description
            }))
          }
        } catch (error) {
          console.error('Erreur lors du chargement des conflits pour le pays:', error)
          if (this.currentDetailData && 'conflitsArmes' in this.currentDetailData) {
            this.currentDetailData.conflitsArmes = []
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
          type: 'country',
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
          accords: [],
          conflitsArmes: []
        } as CountryDetailData
        this.currentEntityType = 'country'
      } finally {
        this.isLoading = false
      }
    },
    
    // Navigation vers la liste des pays
    async navigateToCountryList() {
      console.log('Navigating to country list')
      
      // Nettoyer les zones de combat si on vient du menu conflits
      await this.clearConflictData()
      
      // Sauvegarder la vue précédente
      this.currentView.previousView = { ...this.currentView }
      
      this.currentView.type = 'countryList'
      this.currentView.id = 'country-list'
      this.currentView.title = 'Pays du monde'
      this.currentView.searchEnabled = true
      this.currentView.hasReturnButton = true
      this.currentView.organizations = null
      
      // Réinitialiser la recherche
      this.searchQuery = ''
      
      // Debug pour voir si les données sont présentes
      console.log('🔍 Debug navigateToCountryList:')
      console.log('   appData.countryList.length:', this.appData.countryList.length)
      console.log('   Premier pays:', this.appData.countryList[0])
      
      // Charger les pays et les mettre dans items
      this.currentView.items = this.appData.countryList.map(country => {
        const title = country.nom || country.name || country.title || country.id
        const flag = country.drapeau || country.flag
        
        // Debug pour comprendre le problème
        if (!title) {
          console.warn('⚠️ Pays sans titre:', country)
        }
        
        return {
          id: country.id,
          title: title || 'Pays inconnu',  // Fallback pour éviter undefined
          flag: flag,
          hasSubmenu: true
        }
      }).filter(item => item.title !== 'Pays inconnu') // Filtrer les pays sans nom valide
      
      console.log('   currentView.items.length:', this.currentView.items.length)
      console.log('   Premier item:', this.currentView.items[0])
    },

    // Navigation vers la liste des régimes politiques
    async navigateToPoliticalRegimeList() {
      console.log('Navigating to political regime list')
      
      // Nettoyer les zones de combat si on vient du menu conflits
      await this.clearConflictData()
      
      // Sauvegarder la vue précédente
      this.currentView.previousView = { ...this.currentView }
      
      this.currentView.type = 'politicalRegimeList'
      this.currentView.id = 'political-regime-list'
      this.currentView.title = 'Régimes politiques'
      this.currentView.searchEnabled = true
      this.currentView.hasReturnButton = true
      this.currentView.organizations = null
      
      // Réinitialiser la recherche
      this.searchQuery = ''
      
      // Debug pour voir les données
      console.log('🔍 Debug navigateToPoliticalRegimeList:')
      console.log('   appData.politicalRegimeList.length:', this.appData.politicalRegimeList.length)
      console.log('   Premier régime:', this.appData.politicalRegimeList[0])
      
      // Charger les régimes politiques et les mettre dans items
      this.currentView.items = this.appData.politicalRegimeList.map(regime => ({
        id: regime.id,
        title: regime.nom,
        badge: regime.country_count ? `${regime.country_count} pays` : '',
        hasSubmenu: true
      }))
      
      console.log('   currentView.items.length:', this.currentView.items.length)
      console.log('   Premier item:', this.currentView.items[0])
    },

    // Navigation vers la liste des organisations
    async navigateToOrganizationsList() {
      console.log('Navigating to organizations list - Updated with complete data')

      // Nettoyer les zones de combat si on vient du menu conflits
      await this.clearConflictData()

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
        const organizations = await supabaseService.getOrganizationsByType()
        // Stocker les organisations dans appData comme les autres listes
        this.appData.organizationList = organizations || {}
        console.log('✅ Organisations chargées avec données complètes:', Object.keys(organizations || {}).length, 'types')
        
        // Mettre les organisations dans currentView.organizations pour l'affichage
        this.currentView.organizations = organizations
      } catch (error) {
        console.error('Erreur lors du chargement des organisations internationales:', error)
        this.error = 'Erreur lors du chargement des organisations'
      }
    },

    // Navigation vers la liste des conflits armés
    async navigateToArmedConflictsList() {
      console.log('Navigating to armed conflicts list')

      // Sauvegarder la vue précédente
      this.currentView.previousView = { ...this.currentView }

      this.currentView.type = 'armedConflictsList'
      this.currentView.id = 'armed-conflicts-list'
      this.currentView.title = 'Conflits armés'
      this.currentView.searchEnabled = true
      this.currentView.hasReturnButton = true
      this.currentView.items = []
      this.currentView.organizations = null

      // Réinitialiser la recherche
      this.searchQuery = ''

      try {
        // Charger la liste des conflits avec leurs épicentres
        const conflicts = await supabaseService.getArmedConflicts()
        this.appData.armedConflictList = conflicts || []
        console.log('✅ Conflits armés chargés:', this.appData.armedConflictList.length)
        
        // Mettre les conflits dans currentView.items pour l'affichage
        this.currentView.items = conflicts.map(conflict => ({
          id: conflict.id,
          title: conflict.nom,
          badge: conflict.type || conflict.intensite || '',
          hasSubmenu: true
        }))
        
        // Charger et afficher les marqueurs d'épicentres sur la carte
        const { useMapStore } = await import('@/stores/mapStore')
        const mapStore = useMapStore()
        
        // Masquer les marqueurs de pays pour voir les épicentres
        mapStore.clearSelectedCountries()
        mapStore.setCountryDisplayMode('none')
        
        // Utiliser la nouvelle méthode pour charger les épicentres
        await mapStore.loadConflictEpicenters()
        
        console.log('✅ Navigation vers la liste des conflits armés terminée')
      } catch (error) {
        console.error('❌ Erreur lors de la navigation vers les conflits armés:', error)
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
      
      // Effacer les sélections et zones de conflit sur la carte
      const { useMapStore } = await import('@/stores/mapStore')
      const mapStore = useMapStore()
      mapStore.clearSelectedCountries()
      
      // Remettre l'affichage normal de tous les pays
      mapStore.setCountryDisplayMode('all')
      
      // Désactiver les couches de conflit pour retourner à la vue normale
      mapStore.visibleLayers.armedConflicts = false
      mapStore.visibleLayers.conflictEpicenters = false
      mapStore.armedConflicts = null
      mapStore.clearConflictEpicenterMarkers()
      
      // Réinitialiser la recherche
      this.searchQuery = ''
      
      console.log('🏠 Retour au menu principal : affichage de tous les pays restauré')
    },
    
    // Navigation vers un détail
    navigateToDetail(id: string) {
      console.log('Navigating to detail:', id)
      // Logique pour naviguer vers un détail spécifique
    },
    
    // Sélection d'un pays (méthode centralisée et consolidée)
    async selectCountry(id: string) {
      console.log('🏳️ Sélection centralisée du pays:', id)
      
      // 1. NETTOYER TOUTES les sélections précédentes
      await this.clearAllSelectionsAndLayers()
      
      // 2. Mettre à jour l'état de sélection dans asideStore
      this.selectedCountryId = id
      this.selectedOrganizationId = null
      this.selectedPoliticalRegimeId = null
      this.selectedArmedConflictId = null
      
      // 3. Synchroniser avec mapStore
      const { useMapStore } = await import('@/stores/mapStore')
      const mapStore = useMapStore()
      
      // Effacer toutes les sélections précédentes sur la carte
      mapStore.clearSelectedCountries()
      mapStore.visibleLayers.armedConflicts = false
      mapStore.armedConflicts = null
      
      // Sélectionner le nouveau pays sur la carte
      mapStore.selectSingleCountry(id)
      mapStore.setCountryDisplayMode('selected')
      
      console.log('🗺️ Pays sélectionné sur la carte:', id)
      
      // 4. Charger les données du pays pour le panneau flottant
      await this.loadCountryData(id)
      
      console.log('✅ Sélection de pays terminée:', id)
      
      // NE PAS changer la vue actuelle - l'utilisateur reste sur la vue active
      // Les données sont disponibles dans currentDetailData pour le panneau flottant
    },

    // Sélection d'un pays en préservant le conflit sélectionné
    async selectCountryWithinConflict(countryId: string) {
      console.log('🎯 Sélection pays dans contexte conflit:', countryId)
      
      // Sauvegarder le conflit actuellement sélectionné
      const currentConflictId = this.selectedArmedConflictId
      
      if (!currentConflictId) {
        console.warn('⚠️ Aucun conflit sélectionné, utilisation de la sélection normale')
        return this.selectCountry(countryId)
      }
      
      // Mettre à jour seulement la sélection du pays
      this.selectedCountryId = countryId
      // Garder les autres sélections intactes, notamment le conflit
      // this.selectedArmedConflictId reste inchangé
      
      // Charger les données du pays
      await this.loadCountryData(countryId)
      
      console.log('✅ Sélection pays contextuelle terminée:', countryId, 'conflit préservé:', currentConflictId)
    },

    // Méthode pour nettoyer toutes les sélections et couches
    async clearAllSelectionsAndLayers() {
      console.log('🧹 Nettoyage complet de toutes les sélections et couches')
      
      // Nettoyer les sélections dans asideStore
      this.selectedCountryId = null
      this.selectedOrganizationId = null
      this.selectedPoliticalRegimeId = null
      this.selectedArmedConflictId = null
      this.currentDetailData = null
      
      // Nettoyer les couches sur la carte
      const { useMapStore } = await import('@/stores/mapStore')
      const mapStore = useMapStore()
      
      mapStore.clearSelectedCountries()
      mapStore.visibleLayers.armedConflicts = false
      mapStore.armedConflicts = null
      mapStore.setCountryDisplayMode('all')
      
      console.log('✅ Nettoyage complet terminé')
    },
    
    // Sélection d'une organisation
    async selectOrganization(id: string) {
      console.log('🏢 Organization selected:', id)
      
      // 1. NETTOYER TOUTES les sélections précédentes
      await this.clearAllSelectionsAndLayers()
      
      // 2. Utiliser la nouvelle méthode générique pour charger les données de l'entité
      await this.selectEntity(id, 'organization')
      
      console.log('🏢 After selectEntity - currentDetailData:', this.currentDetailData?.title)
      console.log('🏢 After selectEntity - currentEntityType:', this.currentEntityType)
      
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
        const countries = await supabaseService.getCountriesByOrganization(id)
        
        // Mettre à jour les marqueurs sur la carte
        const { useMapStore } = await import('@/stores/mapStore')
        const mapStore = useMapStore()
        
        // Extraire les IDs des pays membres
        const countryIds = countries.map(country => country.id)
        console.log('Pays membres de l\'organisation:', countryIds)
        
        // Sélectionner ces pays sur la carte
        mapStore.selectMultipleCountries(countryIds)
        
      } catch (error) {
        console.error('Erreur lors du chargement des pays par organisation:', error)
        this.error = 'Erreur lors du chargement des pays'
      }
    },

    // Sélection d'un régime politique
    async selectPoliticalRegime(id: string) {
      console.log('Political regime selected:', id)
      
      // 1. NETTOYER TOUTES les sélections précédentes
      await this.clearAllSelectionsAndLayers()
      
      // 2. Utiliser la nouvelle méthode générique pour charger les données de l'entité
      await this.selectEntity(id, 'regime')
      
      try {
        // Trouver le nom du régime politique
        const regime = this.appData.politicalRegimeList.find(r => r.id === id)
        const regimeName = regime ? regime.name : 'Régime politique'
        
        // Charger les pays associés à ce régime
        const countries = await supabaseService.getCountriesByRegime(id)
        
        // Mettre à jour les marqueurs sur la carte
        const { useMapStore } = await import('@/stores/mapStore')
        const mapStore = useMapStore()
        
        // Extraire les IDs des pays membres
        const countryIds = countries.map(country => country.id)
        console.log('Pays avec ce régime politique:', countryIds)
        
        // Sélectionner ces pays sur la carte
        mapStore.selectMultipleCountries(countryIds)
        
        // NE PAS changer la vue - l'utilisateur reste sur la liste des régimes politiques
        // Les données sont disponibles pour le panneau flottant si nécessaire
        
      } catch (error) {
        console.error('Erreur lors du chargement des pays par régime:', error)
        this.error = 'Erreur lors du chargement des pays'
      }
    },

    // Sélection d'un conflit armé
    async selectArmedConflict(id: string) {
      console.log('🔥 Armed conflict selected in asideStore:', id)
      
      // 1. NETTOYER TOUTES les sélections précédentes
      await this.clearAllSelectionsAndLayers()
      
      // 2. Utiliser la nouvelle méthode générique pour charger les données de l'entité
      await this.selectEntity(id, 'conflict')
      
      try {
        // Trouver le conflit armé avec ses coordonnées
        const conflict = this.appData.armedConflictList.find(c => String(c.id) === String(id))
        const conflictName = conflict ? conflict.name : 'Conflit armé'
        
        // Mettre à jour les marqueurs sur la carte
        const { useMapStore } = await import('@/stores/mapStore')
        const mapStore = useMapStore()
        
        // 1. D'abord activer la couche des conflits armés
        mapStore.visibleLayers.armedConflicts = true
        
        // 2. Charger les zones de combat pour ce conflit spécifiquement (💥)
        await mapStore.loadConflictZones(id)
        
        // 3. Charger les pays impliqués dans ce conflit
        const countries = await supabaseService.getCountriesByConflict(id)
        const countryIds = countries.map(country => country.id)
        console.log('Pays impliqués dans le conflit:', countryIds)
        
        // 4. Afficher SEULEMENT les marqueurs des pays concernés (drapeaux)
        mapStore.clearSelectedCountries()
        mapStore.selectMultipleCountries(countryIds)
        mapStore.setCountryDisplayMode('selected')
        
        // 5. S'assurer que la couche des pays est activée
        mapStore.visibleLayers.countries = true
        
        // 5. Zoomer sur l'épicentre du conflit si disponible
        if (conflict && conflict.epicenter) {
          console.log('Zoom vers l\'épicentre du conflit:', conflict.epicenter)
          mapStore.zoomToCoordinates(conflict.epicenter, 6, conflictName)
        }
        
      } catch (error) {
        console.error('Erreur lors du chargement des pays par conflit:', error)
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
    
    clearArmedConflictSelection() {
      this.selectedArmedConflictId = null
    },
    
    // Effacer toutes les sélections
    clearAllSelections() {
      this.selectedCountryId = null
      this.selectedOrganizationId = null
      this.selectedPoliticalRegimeId = null
      this.selectedArmedConflictId = null
    },

    // Nettoyer les données de conflit et zones de combat
    async clearConflictData() {
      if (this.currentView.type === 'armedConflictsList' || this.currentView.type.includes('Conflict')) {
        console.log('🧹 Nettoyage des données de conflit lors du changement de navigation')
        
        const { useMapStore } = await import('@/stores/mapStore')
        const mapStore = useMapStore()
        
        // Effacer les zones de combat
        mapStore.visibleLayers.armedConflicts = false
        mapStore.armedConflicts = null
        
        // Remettre l'affichage de tous les pays (sortie du mode sélectionné)
        mapStore.clearSelectedCountries()
        mapStore.setCountryDisplayMode('all')
        
        // Effacer la sélection de conflit
        this.clearArmedConflictSelection()
        this.currentDetailData = null
        
        console.log('🏠 Données de conflit nettoyées, affichage de tous les pays restauré')
      }
    },

    // Sélectionner un conflit depuis la fiche détail d'un pays
    async selectConflictFromCountryDetail(conflictId: string) {
      console.log('🔥 Sélection conflit depuis fiche pays:', conflictId)
      
      try {
        // 1. NETTOYER partiellement (garder le pays sélectionné mais effacer les conflits précédents)
        const { useMapStore } = await import('@/stores/mapStore')
        const mapStore = useMapStore()
        
        // Nettoyer seulement les conflits précédents
        mapStore.visibleLayers.armedConflicts = false
        mapStore.armedConflicts = null
        
        // 2. Activer la couche des conflits armés
        mapStore.visibleLayers.armedConflicts = true
        
        // 3. Charger les zones de combat pour ce conflit spécifiquement
        await mapStore.loadConflictZones(conflictId)
        
        // 4. Charger les pays impliqués dans ce conflit
        const countries = await supabaseService.getCountriesByConflict(conflictId)
        const countryIds = countries.map((country: any) => country.id)
        console.log('🏳️ Pays impliqués dans le conflit:', countryIds)
        
        // 5. Afficher SEULEMENT les marqueurs des pays concernés
        mapStore.clearSelectedCountries()
        mapStore.selectMultipleCountries(countryIds)
        mapStore.setCountryDisplayMode('selected')
        
        // 6. S'assurer que la couche des pays est activée
        mapStore.visibleLayers.countries = true
        
        // 7. Marquer ce conflit comme sélectionné
        this.selectedArmedConflictId = conflictId
        
        console.log('✅ Conflit sélectionné depuis fiche pays, zones et pays affichés')
        
      } catch (error) {
        console.error('Erreur lors de la sélection du conflit depuis la fiche pays:', error)
      }
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
        
        // SAUVEGARDER le type de vue actuelle AVANT de la changer
        const currentViewType = this.currentView.type
        
        // Restaurer la vue précédente
        this.currentView = { ...this.currentView.previousView }
        
        // Nettoyer la vue précédente pour éviter les références circulaires
        this.currentView.previousView = undefined
        
        // Effacer les sélections selon le type de vue D'ORIGINE
        const { useMapStore } = await import('@/stores/mapStore')
        const mapStore = useMapStore()
        
        if (this.currentView.type === 'main') {
          // Retour au menu principal : tout effacer et remettre l'affichage normal
          mapStore.clearSelectedCountries()
          mapStore.visibleLayers.armedConflicts = false
          mapStore.armedConflicts = null
          
          // Si on vient du menu conflits, nettoyer aussi les épicentres
          if (currentViewType === 'armedConflictsList' || currentViewType.includes('Conflict')) {
            mapStore.clearConflictEpicenterMarkers()
            console.log('🧹 Nettoyage des épicentres lors du retour au menu principal depuis les conflits')
          }
          
          mapStore.setCountryDisplayMode('all')  // IMPORTANT : remettre l'affichage de tous les pays
          this.currentDetailData = null
          this.clearAllSelections()
          console.log('🚫 Retour au menu principal : tout effacé et affichage de tous les pays restauré')
        } else if (currentViewType === 'armedConflictsList' || currentViewType.includes('Conflict')) {
          // On sort du menu conflits armés : effacer les zones de combat, les épicentres et déselectionner le conflit
          console.log('🚫 Sortie du menu conflits armés détectée')
          mapStore.visibleLayers.armedConflicts = false
          mapStore.armedConflicts = null  // Forcer la suppression des données
          mapStore.clearConflictEpicenterMarkers()  // Nettoyer les marqueurs d'épicentres
          this.currentDetailData = null
          this.clearArmedConflictSelection()
          console.log('🚫 Sortie du menu conflits armés : zones et épicentres effacés, conflit désélectionné')
        } else if (currentViewType === 'countryList' || currentViewType === 'politicalRegimeList' || currentViewType === 'organizationsList') {
          // Sortie d'un autre menu : nettoyer les sélections spécifiques et remettre tous les pays si on retourne au menu principal
          if (this.currentView.type === 'main') {
            mapStore.clearSelectedCountries()
            mapStore.setCountryDisplayMode('all')
            console.log('🏠 Retour au menu principal depuis', currentViewType, ': tous les pays affichés')
          }
          this.currentDetailData = null
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
    },

    // Actions pour charger les données d'autres types d'entités
    async loadConflictData(id: string | number) {
      // Convertir l'ID en string pour l'API
      const conflictId = String(id)
      
      // FORCER le rechargement - ignorer le cache temporairement pour tester
      console.log('[asideStore] 🔄 FORCE RELOAD - Ignoring cache for conflict:', conflictId)
      // if (this.dataCache[`conflict-${conflictId}`]) {
      //   this.currentDetailData = this.dataCache[`conflict-${conflictId}`]
      //   this.currentEntityType = 'conflict'
      //   return
      // }
      
      try {
        this.isLoading = true
        
        // Trouver le nom du conflit dans les données existantes
        let conflictName = typeof id === 'string' 
          ? id.charAt(0).toUpperCase() + id.slice(1).replace(/-/g, ' ')
          : `Conflit #${id}`
        const conflict = this.appData.armedConflictList.find(c => String(c.id) === conflictId)
        if (conflict) {
          conflictName = conflict.nom || conflict.name || conflict.title
        }
        
        // Essayer de charger les données du conflit depuis l'API
        try {
          const conflictData = await supabaseService.getArmedConflictById(conflictId)
          
          console.log('[asideStore] ⚔️ Données conflit reçues:', conflictData)
        console.log('[asideStore] 🔍 intensiteDetaillee:', conflictData?.intensite_detaillee)
        console.log('[asideStore] 🔍 paysImpliques:', conflictData?.paysImpliques)
        console.log('[asideStore] 🔍 victimes:', conflictData?.victimes)
        console.log('[asideStore] 🔍 timeline:', conflictData?.timeline)
          
          if (conflictData) {
            this.currentDetailData = {
              id: conflictData.id,
              title: conflictData.nom || conflictData.title,
              type: 'conflict',
              description: conflictData.description,
              statut: conflictData.statut || conflictData.type,
              intensite: conflictData.intensite,
              intensiteDetaillee: conflictData.intensite_detaillee || {},
              dateDebut: conflictData.date_debut || conflictData.dateDebut,
              dateFin: conflictData.date_fin || conflictData.dateFin,
              anneeDebut: conflictData.annee_debut,
              anneeFin: conflictData.annee_fin,
              impactGeopolitique: conflictData.impact_geopolitique,
              paysImpliques: conflictData.paysImpliques || conflictData.pays_impliques || [],
              localisation: conflictData.localisation,
              zones: conflictData.zones,
              victimes: conflictData.victimes,
              timeline: conflictData.timeline
            } as ConflictDetailData
            this.currentEntityType = 'conflict'
            
            // Charger les pays impliqués séparément
            try {
              const countries = await supabaseService.getCountriesByConflict(conflictId)
              if (this.currentDetailData && 'paysImpliques' in this.currentDetailData) {
                this.currentDetailData.paysImpliques = countries.map((country: any) => ({
                  id: country.id || country.countryId,
                  nom: country.nom || country.name || country.title || country.country_name,
                  flag: country.flag || country.drapeau || country.emoji_flag,
                  role: country.role || country.involvement_type || 'Participant',
                  dateEntree: country.dateEntree || country.involvement_date || country.start_date
                }))
              }
            } catch (countriesError) {
              console.error('Erreur lors du chargement des pays impliqués:', countriesError)
              if (this.currentDetailData && 'paysImpliques' in this.currentDetailData) {
                this.currentDetailData.paysImpliques = []
              }
            }
          } else {
            throw new Error('Conflict data not found')
          }
        } catch (apiError) {
          // Si l'API échoue, créer des données mock
          console.log('API failed, using mock data for conflict:', conflictId)
          this.currentDetailData = {
            id: conflictId,
            title: conflictName,
            type: 'conflict',
            description: `Conflit armé en cours d'analyse`,
            statut: 'actif',
            intensite: 'moyenne',
            dateDebut: '2020-01-01',
            dateFin: undefined,
            localisation: 'À déterminer',
            zones: ['Zone de conflit'],
            victimes: {
              morts: 1000,
              blesses: 5000,
              deplaces: 50000
            },
            paysImpliques: [
              {
                id: '1',
                nom: 'Pays exemple',
                flag: '🏳️',
                role: 'Participant',
                dateEntree: '2020-01-01'
              }
            ],
            timeline: [{
              id: '1',
              date: '2020-01-01',
              titre: 'Début du conflit',
              description: 'Escalade des tensions'
            }]
          } as ConflictDetailData
          this.currentEntityType = 'conflict'
        }
        
        // Mettre en cache les données
        this.dataCache[`conflict-${conflictId}`] = this.currentDetailData
        
        console.log('✅ Conflict data loaded:', this.currentDetailData)
        
      } catch (error) {
        console.error(`Error loading conflict data for ${id}:`, error)
      } finally {
        this.isLoading = false
      }
    },

    async loadRegimeData(id: string) {
      // Vérifier si les données sont déjà en cache
      if (this.dataCache[`regime-${id}`]) {
        this.currentDetailData = this.dataCache[`regime-${id}`]
        this.currentEntityType = 'regime'
        return
      }
      
      try {
        this.isLoading = true
        
        // Charger les données du régime depuis l'API
        // const regimeData = await politicalRegimeApi.getRegimeDetails(id)
        
        // Pour l'instant, créer des données mock
        this.currentDetailData = {
          id: id,
          title: id.charAt(0).toUpperCase() + id.slice(1).replace(/-/g, ' '),
          type: 'regime',
          description: 'Description du régime politique',
          classification: '',
          systemeElectoral: '',
          characteristics: [],
          countries: [],
          avantages: [],
          inconvenients: [],
          evolutionHistorique: ''
        } as RegimeDetailData
        this.currentEntityType = 'regime'
        
        // Mettre en cache les données
        this.dataCache[`regime-${id}`] = this.currentDetailData
        
      } catch (error) {
        console.error(`Error loading regime data for ${id}:`, error)
      } finally {
        this.isLoading = false
      }
    },

    async loadOrganizationData(id: string) {
      // Vérifier si les données sont déjà en cache
      if (this.dataCache[`organization-${id}`]) {
        this.currentDetailData = this.dataCache[`organization-${id}`]
        this.currentEntityType = 'organization'
        return
      }
      
      try {
        this.isLoading = true
        
        // Trouver le nom de l'organisation dans les données existantes
        let organizationName = id.charAt(0).toUpperCase() + id.slice(1).replace(/-/g, ' ')
        let organizationType = ''
        
        if (this.appData.organizationList) {
          for (const type in this.appData.organizationList) {
            const org = this.appData.organizationList[type].find((o: any) => o.id === id)
            if (org) {
              organizationName = org.title
              organizationType = type
              break
            }
          }
        }
        
        // Charger les données de l'organisation depuis Supabase
        const { supabaseService } = await import('@/services/supabaseService')
        const organizationData = await supabaseService.getOrganizationById(id)
        
        console.log('[asideStore] 🌐 Données organisation reçues:', organizationData)
        
        if (organizationData) {
          this.currentDetailData = organizationData
          this.currentEntityType = 'organization'
          
          // Mettre en cache
          this.dataCache[`organization-${id}`] = organizationData
        } else {
          // Fallback avec données basiques si pas trouvé dans Supabase
        this.currentDetailData = {
          id: id,
          title: organizationName,
          type: 'organization',
          description: `Organisation internationale de type ${organizationType}`,
          statut: 'Active',
          domaineAction: organizationType || 'Coopération internationale',
          dateCreation: '',
          siege: '',
          adresse: '',
          objectifs: [
            'Promouvoir la coopération internationale',
            'Faciliter les échanges entre les membres',
            'Développer des standards communs'
          ],
          paysMembres: [],
          structure: {
            organigramme: 'Structure hiérarchique avec secrétariat général',
            secretaireGeneral: 'À déterminer',
            mandatDebut: '',
            organesDecision: ['Assemblée générale', 'Conseil exécutif', 'Secrétariat']
          }
        } as OrganizationDetailData
        this.currentEntityType = 'organization'
        
        // Mettre en cache les données
        this.dataCache[`organization-${id}`] = this.currentDetailData
        
        console.log('✅ Organisation data loaded:', this.currentDetailData)
        }
        
      } catch (error) {
        console.error(`Error loading organization data for ${id}:`, error)
      } finally {
        this.isLoading = false
      }
    },

    async loadResourceData(id: string) {
      // Vérifier si les données sont déjà en cache
      if (this.dataCache[`resource-${id}`]) {
        this.currentDetailData = this.dataCache[`resource-${id}`]
        this.currentEntityType = 'resource'
        return
      }
      
      try {
        this.isLoading = true
        
        // Charger les données de la ressource depuis l'API
        // const resourceData = await resourceApi.getResourceDetails(id)
        
        // Pour l'instant, créer des données mock
        this.currentDetailData = {
          id: id,
          title: id.charAt(0).toUpperCase() + id.slice(1).replace(/-/g, ' '),
          type: 'resource',
          description: 'Description de la ressource',
          categorie: '',
          etatReserves: '',
          rarete: '',
          localisationPrincipale: '',
          zonesExtraction: [],
          unite: '',
          reservesMondiales: {}
        } as ResourceDetailData
        this.currentEntityType = 'resource'
        
        // Mettre en cache les données
        this.dataCache[`resource-${id}`] = this.currentDetailData
        
      } catch (error) {
        console.error(`Error loading resource data for ${id}:`, error)
      } finally {
        this.isLoading = false
      }
    },

    // Action générique pour sélectionner une entité
    async selectEntity(id: string, entityType: EntityType) {
      console.log(`Entity selected: ${id} (${entityType})`)
      
      // Mettre à jour l'état de sélection selon le type
      switch (entityType) {
        case 'country':
          this.selectedCountryId = id
          this.selectedOrganizationId = null
          this.selectedPoliticalRegimeId = null
          this.selectedArmedConflictId = null
          await this.loadCountryData(id)
          break
        case 'conflict':
          this.selectedArmedConflictId = id
          this.selectedCountryId = null
          this.selectedOrganizationId = null
          this.selectedPoliticalRegimeId = null
          await this.loadConflictData(id)
          break
        case 'regime':
          this.selectedPoliticalRegimeId = id
          this.selectedCountryId = null
          this.selectedOrganizationId = null
          this.selectedArmedConflictId = null
          await this.loadRegimeData(id)
          break
        case 'organization':
          this.selectedOrganizationId = id
          this.selectedCountryId = null
          this.selectedPoliticalRegimeId = null
          this.selectedArmedConflictId = null
          await this.loadOrganizationData(id)
          break
        case 'resource':
          // Pas encore de sélection pour les ressources, mais charger les données
          this.clearAllSelections()
          await this.loadResourceData(id)
          break
      }
    },

    // Effacer les données de l'entité actuelle
    clearCurrentEntity() {
      this.currentDetailData = null
      this.currentEntityType = null
      this.clearAllSelections()
    }
  }
}) 