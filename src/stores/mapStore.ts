import { defineStore } from 'pinia'
import { countryApi } from '@/services/apiService'

interface Country {
  id: string
  title: string
  flag: string
  continent?: string
  coordonnees?: [number, number]
}

export const useMapStore = defineStore('map', {
  state: () => ({
    // Données de base
    countriesData: [] as Country[],
    countriesGeoJson: null as any,
    
    // Sélections
    selectedCountries: [] as string[], // Tableau pour permettre la sélection multiple
    
    // Couches additionnelles
    tradeRoutes: null as any,
    conflictZones: null as any,
    
    // Visibilité des couches
    visibleLayers: {
      countries: true,
      tradeRoutes: false,
      conflictZones: false
    },
    
    // Configuration de la carte
    mapConfig: {
      tileProvider: 'osm', // 'osm', 'carto', 'stamen', etc.
      initialView: [20, 0],
      initialZoom: 2
    },
    
    // État de chargement
    isLoading: false,
    error: null as string | null
  }),
  
  getters: {
    // Récupérer les pays sélectionnés avec leurs données complètes
    selectedCountriesData: (state) => {
      if (!state.countriesData) return []
      
      return state.selectedCountries.map(countryId => {
        return state.countriesData.find(country => country.id === countryId)
      }).filter(Boolean)
    }
  },
  
  actions: {
    // Charger les données de base des pays depuis l'API
    async loadCountriesData() {
      try {
        console.log('[mapStore] Début du chargement des données des pays...')
        this.isLoading = true
        this.error = null
        
        // Charger les données des pays depuis l'API
        const countries = await countryApi.getAllCountries()
        console.log('[mapStore] Données reçues de l\'API:', countries.length, 'pays')
        console.log('[mapStore] Premier pays:', countries[0])
        
        console.log('[mapStore] Assignation des données:', countries.length, 'pays')
        this.countriesData = countries
        console.log('[mapStore] Données assignées, this.countriesData:', this.countriesData.length, 'pays')
        
        // Créer le GeoJSON pour les marqueurs
        this.countriesGeoJson = {
          type: 'FeatureCollection',
          features: countries
            .filter(country => country.coordonnees)
            .map(country => ({
              type: 'Feature',
              properties: {
                id: country.id,
                name: country.title,
                flag: country.flag
              },
              geometry: {
                type: 'Point',
                coordinates: country.coordonnees
              }
            }))
        }
        
        console.log('[mapStore] Données des pays chargées:', this.countriesData.length, 'pays')
        console.log('[mapStore] GeoJSON créé avec', this.countriesGeoJson.features.length, 'features')
      } catch (error) {
        console.error('[mapStore] Erreur lors du chargement des données des pays:', error)
        this.error = 'Impossible de charger les données de la carte'
      } finally {
        this.isLoading = false
      }
    },
    
    // Charger les routes commerciales
    async loadTradeRoutes() {
      try {
        this.isLoading = true
        
        const response = await fetch('/data/geo/trade-routes.geo.json')
        this.tradeRoutes = await response.json()
        
        // Activer automatiquement la couche
        this.visibleLayers.tradeRoutes = true
      } catch (error) {
        console.error('Erreur lors du chargement des routes commerciales:', error)
      } finally {
        this.isLoading = false
      }
    },
    
    // Charger les zones de conflit
    async loadConflictZones() {
      try {
        this.isLoading = true
        
        const response = await fetch('/data/geo/conflict-zones.geo.json')
        this.conflictZones = await response.json()
        
        // Activer automatiquement la couche
        this.visibleLayers.conflictZones = true
      } catch (error) {
        console.error('Erreur lors du chargement des zones de conflit:', error)
      } finally {
        this.isLoading = false
      }
    },
    
    // Sélectionner un pays (ajoute ou supprime)
    toggleCountrySelection(countryId: string) {
      const index = this.selectedCountries.indexOf(countryId)
      
      if (index === -1) {
        // Ajouter à la sélection
        this.selectedCountries.push(countryId)
      } else {
        // Retirer de la sélection
        this.selectedCountries.splice(index, 1)
      }
    },
    
    // Sélectionner un seul pays (efface les autres sélections)
    selectSingleCountry(countryId: string) {
      this.selectedCountries = [countryId]
    },
    
    // Sélectionner plusieurs pays à la fois
    selectMultipleCountries(countryIds: string[]) {
      this.selectedCountries = [...countryIds]
    },
    
    // Effacer toutes les sélections
    clearSelectedCountries() {
      this.selectedCountries = []
    },
    
    // Activer/désactiver une couche
    toggleLayer(layerName: keyof typeof this.visibleLayers) {
      if (this.visibleLayers.hasOwnProperty(layerName)) {
        this.visibleLayers[layerName] = !this.visibleLayers[layerName]
      }
    }
  }
}) 