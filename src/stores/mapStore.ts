import { defineStore } from 'pinia'
import axios from 'axios'

export const useMapStore = defineStore('map', {
  state: () => ({
    // Données de base
    countriesGeoJson: null,
    
    // Sélections
    selectedCountries: [], // Tableau pour permettre la sélection multiple
    
    // Couches additionnelles
    tradeRoutes: null,
    conflictZones: null,
    
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
    error: null
  }),
  
  getters: {
    // Récupérer les pays sélectionnés avec leurs données complètes
    selectedCountriesData: (state) => {
      if (!state.countriesGeoJson) return []
      
      return state.selectedCountries.map(countryCode => {
        const feature = state.countriesGeoJson.features.find(f => 
          (f.properties.iso_a2 || f.properties.ISO_A2) === countryCode
        )
        return feature
      }).filter(Boolean)
    }
  },
  
  actions: {
    // Charger les données de base des pays
    async loadCountriesData() {
      try {
        this.isLoading = true
        this.error = null
        
        // Charger le fichier GeoJSON des frontières des pays
        const response = await axios.get('/data/countries.geo.json')
        
        if (response.data && response.data.type === 'FeatureCollection') {
          this.countriesGeoJson = response.data
        } else {
          throw new Error('Format de données GeoJSON invalide')
        }
      } catch (error) {
        console.error('Erreur lors du chargement des données GeoJSON:', error)
        this.error = 'Impossible de charger les données de la carte'
      } finally {
        this.isLoading = false
      }
    },
    
    // Charger les routes commerciales
    async loadTradeRoutes() {
      try {
        this.isLoading = true
        
        const response = await axios.get('/data/trade-routes.geo.json')
        this.tradeRoutes = response.data
        
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
        
        const response = await axios.get('/data/conflict-zones.geo.json')
        this.conflictZones = response.data
        
        // Activer automatiquement la couche
        this.visibleLayers.conflictZones = true
      } catch (error) {
        console.error('Erreur lors du chargement des zones de conflit:', error)
      } finally {
        this.isLoading = false
      }
    },
    
    // Sélectionner un pays (ajoute ou supprime)
    toggleCountrySelection(countryCode) {
      const index = this.selectedCountries.indexOf(countryCode)
      
      if (index === -1) {
        // Ajouter à la sélection
        this.selectedCountries.push(countryCode)
      } else {
        // Retirer de la sélection
        this.selectedCountries.splice(index, 1)
      }
    },
    
    // Sélectionner un seul pays (efface les autres sélections)
    selectSingleCountry(countryCode) {
      this.selectedCountries = [countryCode]
    },
    
    // Sélectionner plusieurs pays à la fois
    selectMultipleCountries(countryCodes) {
      this.selectedCountries = [...countryCodes]
    },
    
    // Effacer toutes les sélections
    clearSelectedCountries() {
      this.selectedCountries = []
    },
    
    // Activer/désactiver une couche
    toggleLayer(layerName) {
      if (this.visibleLayers.hasOwnProperty(layerName)) {
        this.visibleLayers[layerName] = !this.visibleLayers[layerName]
      }
    }
  }
}) 