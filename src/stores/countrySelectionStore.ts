import { defineStore } from 'pinia'
import countryService from '@/services/countryService'

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
  [key: string]: any
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
        
        // Charger les données depuis l'API
        const countries = await countryService.getCountries()
        
        // Transformer les données au format attendu
        this.countriesData = countries.map(country => ({
          id: country.id,
          name: country.title,
          flag: country.flag,
          coordinates: country.coordonnees as [number, number]
        }))
        
        console.log(`✅ Données de ${this.countriesData.length} pays chargées depuis l'API`)
        console.log('Premier pays transformé:', this.countriesData[0])
      } catch (error) {
        console.error('Erreur lors du chargement des données des pays:', error)
        this.error = 'Impossible de charger les données des pays depuis l\'API'
      } finally {
        this.isLoading = false
      }
    },

    // Sélectionner un pays
    async selectCountry(countryId: string) {
      const country = this.getCountryById(countryId)
      if (country) {
        this.selectedCountry = country
        
        // Charger les détails du pays depuis l'API
        try {
          this.isLoading = true
          const details = await countryService.getCountryDetail(countryId)
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
        const details = await countryService.getCountryDetail(countryId)
        this.selectedCountryDetails = details
        return details
      } catch (type) {
        console.error('Erreur lors du chargement des détails du pays:', type)
        this.selectedCountryDetails = null
        return null
      } finally {
        this.isLoading = false
      }
    }
  }
}) 