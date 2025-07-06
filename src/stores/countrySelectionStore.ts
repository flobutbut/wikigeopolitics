import { defineStore } from 'pinia'
import { getCountriesGeoData, getAllCountries, getCountryDetails } from '@/services/readService'

interface Country {
  id: string
  name: string
  flag: string
  coordinates: [number, number]
}

interface CountryDetails {
  id: string
  title: string
  flag: string
  generalInfo: {
    capitale: string
    langue: string
    monnaie: string
  }
  sections: any[]
  indicateurs: any
  histoire: any
  politique: any
  economie: any
  demographie: any
  frontieres: any
  coordonnees: [number, number]
  tourisme: any
  politicalRegime: any
  agriculturalData: any
  technologyData: any
  demographicData: any
  conflictsData: any
  naturalResources: any
  industrialData: any
  transportData: any
}

export const useCountrySelectionStore = defineStore('countrySelection', {
  state: () => ({
    // Pays actuellement sélectionné
    selectedCountry: null as Country | null,
    
    // Données géographiques des pays
    countriesData: [] as Country[],
    
    // Données détaillées du pays sélectionné
    selectedCountryDetails: null as CountryDetails | null,
    
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
    },

    // Récupérer les détails du pays sélectionné
    currentCountryDetails: (state) => state.selectedCountryDetails
  },

  actions: {
    // Initialiser les données des pays depuis la base de données
    async initializeCountriesData() {
      try {
        this.isLoading = true
        this.error = null
        
        // Charger les données géographiques depuis la base de données
        const geoData = await getCountriesGeoData()
        
        // Transformer les données GeoJSON en format plus simple
        this.countriesData = geoData.features.map(feature => ({
          id: feature.properties.id,
          name: feature.properties.name,
          flag: feature.properties.flag,
          coordinates: feature.geometry.coordinates as [number, number]
        }))
        
        console.log(`Données de ${this.countriesData.length} pays chargées depuis la base de données`)
      } catch (error) {
        console.error('Erreur lors du chargement des données des pays:', error)
        this.error = 'Impossible de charger les données des pays depuis la base de données'
      } finally {
        this.isLoading = false
      }
    },

    // Sélectionner un pays
    async selectCountry(countryId: string) {
      const country = this.getCountryById(countryId)
      if (country) {
        this.selectedCountry = country
        
        // Charger les détails du pays depuis la base de données
        try {
          this.isLoading = true
          const details = await getCountryDetails(countryId)
          this.selectedCountryDetails = details
          console.log(`Pays sélectionné: ${country.name} avec détails chargés`)
        } catch (error) {
          console.error('Erreur lors du chargement des détails du pays:', error)
          this.selectedCountryDetails = null
        } finally {
          this.isLoading = false
        }
        
        return country
      } else {
        console.warn(`Pays non trouvé: ${countryId}`)
        return null
      }
    },

    // Désélectionner le pays actuel
    clearSelection() {
      this.selectedCountry = null
      this.selectedCountryDetails = null
      console.log('Sélection effacée')
    },

    // Sélectionner un pays par ses coordonnées (pour la sélection sur la carte)
    async selectCountryByCoordinates(lat: number, lng: number) {
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
        await this.selectCountry(closestCountry.id)
        return closestCountry
      }
      
      return null
    },

    // Charger les détails d'un pays spécifique
    async loadCountryDetails(countryId: string) {
      try {
        this.isLoading = true
        const details = await getCountryDetails(countryId)
        this.selectedCountryDetails = details
        return details
      } catch (error) {
        console.error('Erreur lors du chargement des détails du pays:', error)
        this.selectedCountryDetails = null
        return null
      } finally {
        this.isLoading = false
      }
    }
  }
}) 