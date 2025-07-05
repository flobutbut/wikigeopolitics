import { defineStore } from 'pinia'
import countriesGeoData from '@/data/countries-geo.json'

interface Country {
  id: string
  name: string
  flag: string
  coordinates: [number, number]
}

export const useCountrySelectionStore = defineStore('countrySelection', {
  state: () => ({
    // Pays actuellement sélectionné
    selectedCountry: null as Country | null,
    
    // Données géographiques des pays
    countriesData: [] as Country[],
    
    // État de chargement
    isLoading: false,
    error: null as string | null
  }),

  getters: {
    // Récupérer le pays sélectionné
    currentSelectedCountry: (state) => state.selectedCountry,
    
    // Vérifier si un pays est sélectionné
    hasSelectedCountry: (state) => state.selectedCountry !== null,
    
    // Récupérer tous les pays
    allCountries: (state) => state.countriesData,
    
    // Récupérer un pays par son ID
    getCountryById: (state) => (id: string) => {
      return state.countriesData.find(country => country.id === id)
    }
  },

  actions: {
    // Initialiser les données des pays
    initializeCountriesData() {
      try {
        this.isLoading = true
        this.error = null
        
        // Transformer les données GeoJSON en format plus simple
        this.countriesData = countriesGeoData.features.map(feature => ({
          id: feature.properties.id,
          name: feature.properties.name,
          flag: feature.properties.flag,
          coordinates: feature.geometry.coordinates as [number, number]
        }))
        
        console.log(`Données de ${this.countriesData.length} pays chargées`)
      } catch (error) {
        console.error('Erreur lors du chargement des données des pays:', error)
        this.error = 'Impossible de charger les données des pays'
      } finally {
        this.isLoading = false
      }
    },

    // Sélectionner un pays
    selectCountry(countryId: string) {
      const country = this.getCountryById(countryId)
      if (country) {
        this.selectedCountry = country
        console.log(`Pays sélectionné: ${country.name}`)
        return country
      } else {
        console.warn(`Pays non trouvé: ${countryId}`)
        return null
      }
    },

    // Désélectionner le pays actuel
    clearSelection() {
      this.selectedCountry = null
      console.log('Sélection effacée')
    },

    // Sélectionner un pays par ses coordonnées (pour la sélection sur la carte)
    selectCountryByCoordinates(lat: number, lng: number) {
      // Trouver le pays le plus proche des coordonnées données
      let closestCountry: Country | null = null
      let minDistance = Infinity

      for (const country of this.countriesData) {
        const distance = Math.sqrt(
          Math.pow(country.coordinates[0] - lng, 2) + 
          Math.pow(country.coordinates[1] - lat, 2)
        )
        
        // Seuil de distance pour considérer qu'un pays est sélectionné
        if (distance < minDistance && distance < 10) {
          minDistance = distance
          closestCountry = country
        }
      }

      if (closestCountry) {
        this.selectCountry(closestCountry.id)
        return closestCountry
      }
      
      return null
    }
  }
}) 