import { defineStore } from 'pinia'
import { countryApi } from '@/services/apiService'
import { armedConflictAPI } from '@/services/api/armedConflictAPI'
import { combatZoneAPI } from '@/services/api/combatZoneAPI'

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
    selectedConflicts: [] as string[], // Tableau pour les conflits sélectionnés
    
    // Couches additionnelles
    tradeRoutes: null as any,
    conflictZones: null as any,
    armedConflicts: null as any,
    conflictEpicenterMarkers: [] as Array<{
      id: string
      type: 'conflict-epicenter'
      coordinates: [number, number]
      icon: string
      name: string
      data: any
    }>,
    
    
    // Visibilité des couches
    visibleLayers: {
      countries: true,
      tradeRoutes: false,
      conflictZones: false,
      armedConflicts: false,
      conflictEpicenters: false
    },
    
    // Mode d'affichage des pays
    countryDisplayMode: 'all' as 'all' | 'selected' | 'none',
    
    // Paramètres de zoom
    targetZoom: null as { coordinates: [number, number], zoom: number, name?: string } | null,
    
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
    
    
    // Charger les conflits armés
    async loadArmedConflicts() {
      try {
        this.isLoading = true
        
        console.log('[mapStore] Chargement de toutes les zones de combat...')
        
        // Note: La table combat_zone n'existe pas dans Supabase
        // On crée un GeoJSON vide pour la compatibilité
        console.log('[mapStore] ⚠️ Pas de table combat_zone dans Supabase')
        
        this.armedConflicts = {
          type: 'FeatureCollection',
          features: []
        }
        
        console.log('[mapStore] ✅ Données de conflits armés chargées avec succès')
        
      } catch (error) {
        console.error('[mapStore] Erreur lors du chargement des conflits armés:', error)
        this.armedConflicts = { type: 'FeatureCollection', features: [] }
      } finally {
        this.isLoading = false
      }
    },
    
    // Charger les épicentres de conflits
    async loadConflictEpicenters() {
      console.log('🔥🔥🔥 loadConflictEpicenters() appelée !')
      try {
        this.isLoading = true
        
        console.log('[mapStore] ⚡️ Chargement des épicentres de conflits...')
        const { supabaseService } = await import('@/services/supabaseService')
        const conflicts = await supabaseService.getArmedConflicts()
        
        console.log('[mapStore] 📊 Conflits reçus de l\'API:', conflicts.length)
        
        // Filtrer les conflits avec épicentre (adaptation pour Supabase)
        const conflictsWithEpicenter = conflicts.filter((conflict: any) => 
          conflict.epicenter && conflict.epicenter.coordinates && conflict.epicenter.coordinates.length === 2
        )
        
        console.log('[mapStore] 📍 Conflits avec épicentre trouvés:', conflictsWithEpicenter.length)
        console.log('[mapStore] 📍 Épicentres:', conflictsWithEpicenter.map(c => `${c.nom}: [${c.epicenter.coordinates}]`))
        
        // Créer les marqueurs d'épicentres (adaptation pour Supabase)
        const epicenterMarkers = conflictsWithEpicenter.map((conflict: any) => ({
          id: `conflict-epicenter-${conflict.id}`,
          type: 'conflict-epicenter' as const,
          coordinates: [conflict.epicenter.coordinates[1], conflict.epicenter.coordinates[0]] as [number, number], // [lat, lng] depuis [lng, lat]
          icon: '⚡️',
          name: conflict.nom, // Adaptation pour Supabase
          data: conflict
        }))
        
        console.log('[mapStore] ⚡️ Marqueurs d\'épicentres créés:', epicenterMarkers.length)
        
        // Stocker les marqueurs avec un délai pour laisser le DOM se préparer
        await new Promise(resolve => setTimeout(resolve, 100))
        this.setConflictEpicenterMarkers(epicenterMarkers)
        
        // Activer la couche
        this.visibleLayers.conflictEpicenters = true
        
        console.log('[mapStore] ✅ Épicentres de conflits chargés et affichés')
      } catch (error) {
        console.error('[mapStore] Erreur lors du chargement des épicentres de conflits:', error)
      } finally {
        this.isLoading = false
      }
    },
    
    // Charger les zones de combat pour un conflit spécifique
    async loadConflictZones(conflictId: string | number) {
      try {
        this.isLoading = true
        
        console.log('[mapStore] 🔥 Chargement des zones de combat pour le conflit:', conflictId)
        
        // Récupérer les vraies zones de combat depuis Supabase
        const { supabaseService } = await import('@/services/supabaseService')
        const combatZones = await supabaseService.getCombatZonesByConflict(conflictId.toString())
        
        console.log('[mapStore] 📊 Zones de combat récupérées:', combatZones.length)
        
        // Convertir les zones de combat en features GeoJSON
        const features = combatZones.map(zone => {
          console.log('[mapStore] 📍 Traitement zone:', zone.name, 'location:', zone.location)
          
          // Extraire les coordonnées du format PostGIS
          let coordinates = null
          if (zone.location) {
            if (typeof zone.location === 'string') {
              // Format "POINT(longitude latitude)"
              const match = zone.location.match(/POINT\(([-\d.]+) ([-\d.]+)\)/)
              if (match) {
                coordinates = [parseFloat(match[1]), parseFloat(match[2])]
              }
            } else if (zone.location.coordinates) {
              // Format GeoJSON
              coordinates = zone.location.coordinates
            }
          }
          
          if (!coordinates) {
            console.warn('[mapStore] ⚠️ Coordonnées invalides pour la zone:', zone.name)
            return null
          }
          
          return {
            type: 'Feature',
            properties: {
              id: `combat-zone-${zone.id}`,
              name: zone.name,
              description: zone.description || '',
              status: zone.status || 'active',
              conflict_id: conflictId,
              intensity: zone.intensity || 'medium',
              zone_type: zone.zone_type || 'combat',
              civilian_impact: zone.civilian_impact || 'medium',
              last_activity: zone.last_activity
            },
            geometry: {
              type: 'Point',
              coordinates: coordinates
            }
          }
        }).filter(Boolean) // Supprimer les zones avec des coordonnées invalides
        
        console.log('[mapStore] 🔥 Features créées:', features.length)
        
        this.armedConflicts = {
          type: 'FeatureCollection',
          features: features
        }
        
        console.log('[mapStore] 📊 armedConflicts défini:', this.armedConflicts)
        
        // Activer la couche pour afficher les zones du conflit sélectionné
        this.visibleLayers.armedConflicts = true
        console.log('[mapStore] ✅ Zones de combat chargées et activées pour le conflit:', conflictId)
        console.log('[mapStore] 👁️ visibleLayers.armedConflicts:', this.visibleLayers.armedConflicts)
        console.log('[mapStore] 📊 Features count:', features.length)
      } catch (error) {
        console.error('Erreur lors du chargement des zones de combat pour le conflit:', error)
        this.armedConflicts = { type: 'FeatureCollection', features: [] }
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
    
    // Sélectionner un conflit
    selectConflict(conflictId: string) {
      if (!this.selectedConflicts.includes(conflictId)) {
        this.selectedConflicts.push(conflictId)
      }
    },
    
    // Désélectionner un conflit
    deselectConflict(conflictId: string) {
      this.selectedConflicts = this.selectedConflicts.filter(id => id !== conflictId)
    },
    
    // Effacer toutes les sélections de conflits
    clearSelectedConflicts() {
      this.selectedConflicts = []
    },
    
    // Activer/désactiver une couche
    toggleLayer(layerName: keyof typeof this.visibleLayers) {
      if (this.visibleLayers.hasOwnProperty(layerName)) {
        this.visibleLayers[layerName] = !this.visibleLayers[layerName]
      }
    },
    
    // Zoomer vers des coordonnées spécifiques
    zoomToCoordinates(coordinates: [number, number], zoom: number = 6, name?: string) {
      this.targetZoom = { coordinates, zoom, name }
    },
    
    // Effacer le zoom cible
    clearTargetZoom() {
      this.targetZoom = null
    },
    
    // Définir le mode d'affichage des pays
    setCountryDisplayMode(mode: 'all' | 'selected' | 'none') {
      this.countryDisplayMode = mode
    },
    
    // Définir les pays sélectionnés (remplace la méthode selectMultipleCountries)
    setSelectedCountries(countryIds: string[]) {
      this.selectedCountries = [...countryIds]
    },
    
    // Ajouter un pays à la sélection (utilise la méthode existante toggleCountrySelection)
    addSelectedCountry(countryId: string) {
      if (!this.selectedCountries.includes(countryId)) {
        this.selectedCountries.push(countryId)
      }
    },
    
    // Retirer un pays de la sélection
    removeSelectedCountry(countryId: string) {
      this.selectedCountries = this.selectedCountries.filter(id => id !== countryId)
    },
    
    // Définir les marqueurs d'épicentres de conflits
    setConflictEpicenterMarkers(markers: Array<{
      id: string
      type: 'conflict-epicenter'
      coordinates: [number, number]
      icon: string
      name: string
      data: any
    }>) {
      this.conflictEpicenterMarkers = markers
      console.log('[mapStore] ⚡️ Marqueurs d\'épicentres définis:', markers.length)
    },
    
    // Effacer les marqueurs d'épicentres de conflits
    clearConflictEpicenterMarkers() {
      console.log('🧹 clearConflictEpicenterMarkers() appelé')
      console.log('📍 Marqueurs avant nettoyage:', this.conflictEpicenterMarkers.length)
      this.visibleLayers.conflictEpicenters = false
      this.conflictEpicenterMarkers = []
      console.log('✅ Marqueurs après nettoyage:', this.conflictEpicenterMarkers.length)
    },
    
    // Forcer l'affichage des marqueurs d'épicentres
    forceDisplayConflictEpicenterMarkers() {
      console.log('🔄 Force display des marqueurs d\'épicentres')
      console.log('📍 Nombre de marqueurs:', this.conflictEpicenterMarkers.length)
      console.log('👁️ Couche visible:', this.visibleLayers.conflictEpicenters)
      
      // Forcer la réactivité en modifiant l'état
      this.visibleLayers.conflictEpicenters = false
      setTimeout(() => {
        this.visibleLayers.conflictEpicenters = true
        console.log('🔄 Couche réactivée')
      }, 50)
    },
    
    // Méthode de débogage pour forcer l'affichage
    debugConflictEpicenterMarkers() {
      console.log('🔍 DEBUG - État des marqueurs d\'épicentres:')
      console.log('📍 Marqueurs:', this.conflictEpicenterMarkers)
      console.log('👁️ Couche visible:', this.visibleLayers.conflictEpicenters)
      console.log('📊 Nombre de marqueurs:', this.conflictEpicenterMarkers?.length)
      
      // Forcer la réactivité
      this.visibleLayers.conflictEpicenters = false
      setTimeout(() => {
        this.visibleLayers.conflictEpicenters = true
        console.log('🔄 Couche réactivée manuellement')
      }, 100)
    },
    
    // Méthode pour déclencher manuellement le chargement des marqueurs
    triggerConflictEpicenterMarkersLoad() {
      console.log('🎯 Déclenchement manuel du chargement des marqueurs d\'épicentres')
      
      // Émettre un événement personnalisé pour déclencher le watcher
      const event = new CustomEvent('conflict-epicenter-markers-updated', {
        detail: {
          markers: this.conflictEpicenterMarkers,
          visible: this.visibleLayers.conflictEpicenters
        }
      })
      window.dispatchEvent(event)
    },
    
  }
}) 