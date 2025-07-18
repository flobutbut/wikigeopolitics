import { ref, watch, onUnmounted, getCurrentInstance } from 'vue'
import L from 'leaflet'
import { useSelectionSystem, type EntityType } from '@/stores/selectionSystem'
import { useMapStore } from '@/stores/mapStore'
import { useAsideStore } from '@/stores/asideStore'

export interface MarkerData {
  id: string
  type: EntityType
  coordinates: [number, number]
  flag?: string
  icon?: string
  name?: string
  data: any
}

export interface UnifiedMarker {
  id: string
  leafletMarker: L.Marker
  data: MarkerData
  isVisible: boolean
  isHighlighted: boolean
  isSelected: boolean
}

/**
 * Système unifié de gestion des marqueurs
 * Gère TOUS les marqueurs (pays + conflits) de manière centralisée et sécurisée
 */
export function useUnifiedMarkers(map: L.Map | null) {
  const selectionSystem = useSelectionSystem()
  const mapStore = useMapStore()
  const asideStore = useAsideStore()
  
  // État interne
  const markers = ref<Map<string, UnifiedMarker>>(new Map())
  const isInitialized = ref(false)
  
  /**
   * Validation sécurisée des coordonnées
   */
  const validateCoordinates = (coords: [number, number], markerId: string): boolean => {
    const [lat, lng] = coords
    
    if (!Array.isArray(coords) || coords.length !== 2) {
      console.warn(`[UnifiedMarkers] Coordonnées invalides pour ${markerId}: pas un tableau [lat, lng]`, coords)
      return false
    }
    
    if (typeof lat !== 'number' || typeof lng !== 'number') {
      console.warn(`[UnifiedMarkers] Coordonnées invalides pour ${markerId}: pas des nombres`, coords)
      return false
    }
    
    if (isNaN(lat) || isNaN(lng)) {
      console.warn(`[UnifiedMarkers] Coordonnées invalides pour ${markerId}: NaN détecté`, coords)
      return false
    }
    
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
      console.warn(`[UnifiedMarkers] Coordonnées hors limites pour ${markerId}:`, coords)
      return false
    }
    
    return true
  }
  
  /**
   * Création d'icône selon le type et l'état
   */
  const createMarkerIcon = (markerData: MarkerData, states: { isSelected: boolean, isHighlighted: boolean, isVisible: boolean }) => {
    const { type, flag, icon, id } = markerData
    const { isSelected, isHighlighted, isVisible } = states
    
    // Classes CSS
    let className = `${type}-marker`
    if (isSelected) className += ' selected'
    if (isHighlighted) className += ' highlighted'
    if (!isVisible) className += ' dimmed'
    
    // Contenu de l'icône
    let iconContent = ''
    if (type === 'country' && flag) {
      iconContent = flag
    } else if (type === 'conflict') {
      iconContent = icon || '💥'
    } else {
      iconContent = getDefaultIconForType(type)
    }
    
    // Taille selon l'état
    const baseSize = type === 'conflict' ? 40 : 30
    const size = isSelected ? baseSize + 5 : baseSize
    const anchor = [size / 2, size / 2]
    
    return L.divIcon({
      className: className,
      html: `<div class="marker-content">${iconContent}</div>`,
      iconSize: [size, size],
      iconAnchor: anchor
    })
  }
  
  /**
   * Icônes par défaut selon le type
   */
  const getDefaultIconForType = (type: EntityType): string => {
    switch (type) {
      case 'country': return '🏳️'
      case 'conflict': return '💥'
      case 'conflict-epicenter': return '⚡️'
      case 'organization': return '🏢'
      case 'regime': return '⚖️'
      case 'resource': return '💎'
      default: return '📍'
    }
  }
  
  /**
   * Créer ou mettre à jour un marqueur
   */
  const createOrUpdateMarker = (markerData: MarkerData): L.Marker | null => {
    if (!map) {
      console.warn('[UnifiedMarkers] Carte non disponible')
      return null
    }
    
    const { id, coordinates } = markerData
    
    // Validation des coordonnées
    if (!validateCoordinates(coordinates, id)) {
      return null
    }
    
    try {
      // Vérifier si le marqueur existe déjà
      const existingMarker = markers.value.get(id)
      
      if (existingMarker) {
        // Mettre à jour le marqueur existant
        updateMarkerAppearance(existingMarker)
        return existingMarker.leafletMarker
      }
      
      // Créer un nouveau marqueur
      const [lat, lng] = coordinates
      
      // Calculer les états du marqueur
      const states = calculateMarkerStates(markerData)
      
      // Créer le marqueur Leaflet
      const leafletMarker = L.marker([lat, lng], {
        icon: createMarkerIcon(markerData, states),
        zIndexOffset: getZIndexForType(markerData.type)
      })
      
      // Ajouter à la carte seulement si visible
      if (states.isVisible && map) {
        leafletMarker.addTo(map)
      }
      
      // Événement de clic
      leafletMarker.on('click', () => handleMarkerClick(markerData))
      
      // Stocker le marqueur
      const unifiedMarker: UnifiedMarker = {
        id,
        leafletMarker,
        data: markerData,
        isVisible: states.isVisible,
        isHighlighted: states.isHighlighted,
        isSelected: states.isSelected
      }
      
      markers.value.set(id, unifiedMarker)
      return leafletMarker
      
    } catch (error) {
      console.error('[UnifiedMarkers] Erreur création marqueur:', id, error)
      return null
    }
  }
  
  /**
   * Calculer les états d'un marqueur selon le contexte de sélection
   */
  const calculateMarkerStates = (markerData: MarkerData) => {
    const { id, type } = markerData
    
    // État de sélection : seulement si le pays est explicitement sélectionné
    const isSelected = type === 'country' 
      ? selectionSystem.isCountrySelected(id) 
      : type === 'conflict' 
      ? selectionSystem.isConflictSelected(id)
      : false
    
    // État de mise en évidence : seulement si le pays est dans la liste des pays mis en évidence
    const isHighlighted = type === 'country' 
      ? selectionSystem.shouldHighlightCountry(id)
      : false
    
    // État de visibilité : selon le contexte (régime, organisation, conflit, etc.)
    const isVisible = type === 'country' 
      ? (mapStore.countryDisplayMode === 'none' ? false : 
         mapStore.countryDisplayMode === 'all' ? true : 
         selectionSystem.shouldShowCountry(id))
      : type === 'conflict' 
      ? selectionSystem.conflictZonesVisible
      : type === 'conflict-epicenter'
      ? mapStore.visibleLayers.conflictEpicenters
      : true
    
    return { isSelected, isHighlighted, isVisible }
  }
  
  /**
   * Mettre à jour l'apparence d'un marqueur existant
   */
  const updateMarkerAppearance = (unifiedMarker: UnifiedMarker) => {
    if (!map) return
    
    const newStates = calculateMarkerStates(unifiedMarker.data)
    const newIcon = createMarkerIcon(unifiedMarker.data, newStates)
    
    // Mettre à jour l'icône
    unifiedMarker.leafletMarker.setIcon(newIcon)
    
    // Gérer la visibilité
    if (newStates.isVisible && !unifiedMarker.isVisible) {
      // Rendre visible
      if (!map.hasLayer(unifiedMarker.leafletMarker)) {
        unifiedMarker.leafletMarker.addTo(map)
      }
    } else if (!newStates.isVisible && unifiedMarker.isVisible) {
      // Cacher
      if (map.hasLayer(unifiedMarker.leafletMarker)) {
        map.removeLayer(unifiedMarker.leafletMarker)
      }
    }
    
    // Mettre à jour les états
    unifiedMarker.isVisible = newStates.isVisible
    unifiedMarker.isHighlighted = newStates.isHighlighted
    unifiedMarker.isSelected = newStates.isSelected
  }
  
  /**
   * Gestion des clics sur marqueurs
   */
  const handleMarkerClick = async (markerData: MarkerData) => {
    try {
      if (markerData.type === 'conflict' && markerData.data && markerData.data.conflict_id) {
        // Pour les zones de combat, utiliser l'ID du conflit parent
        await selectionSystem.selectEntity('conflict', String(markerData.data.conflict_id), 'map')
      } else if (markerData.type === 'conflict-epicenter' && markerData.data && markerData.data.id) {
        // Pour les épicentres de conflits, utiliser l'ID du conflit parent
        await selectionSystem.selectEntity('conflict-epicenter', String(markerData.data.id), 'map')
      } else {
        await selectionSystem.selectEntity(markerData.type, markerData.id, 'map')
      }
    } catch (error) {
      console.error('[UnifiedMarkers] Erreur lors de la sélection:', error)
    }
  }
  
  /**
   * Z-index selon le type
   */
  const getZIndexForType = (type: EntityType): number => {
    switch (type) {
      case 'conflict': return 1500
      case 'conflict-epicenter': return 1600
      case 'country': return 1000
      case 'organization': return 800
      case 'regime': return 700
      case 'resource': return 600
      default: return 500
    }
  }
  
  /**
   * Supprimer un marqueur
   */
  const removeMarker = (markerId: string) => {
    const unifiedMarker = markers.value.get(markerId)
    if (!unifiedMarker) return
    
    try {
      if (map && map.hasLayer(unifiedMarker.leafletMarker)) {
        map.removeLayer(unifiedMarker.leafletMarker)
      }
    } catch (error) {
      console.warn('[UnifiedMarkers] Erreur suppression marqueur:', markerId, error)
    } finally {
      markers.value.delete(markerId)
    }
  }
  
  /**
   * Nettoyer tous les marqueurs
   */
  const clearAllMarkers = () => {
    markers.value.forEach((unifiedMarker, markerId) => {
      try {
        if (map && map.hasLayer(unifiedMarker.leafletMarker)) {
          map.removeLayer(unifiedMarker.leafletMarker)
        }
      } catch (error) {
        console.warn('[UnifiedMarkers] Erreur nettoyage marqueur:', markerId, error)
      }
    })
    
    markers.value.clear()
  }
  
  /**
   * Rafraîchir tous les marqueurs
   */
  const refreshAllMarkers = () => {
    markers.value.forEach((unifiedMarker) => {
      updateMarkerAppearance(unifiedMarker)
    })
  }
  
  /**
   * Synchroniser les marqueurs d'épicentres depuis mapStore
   */
  const syncConflictEpicenters = () => {
    console.log('[UnifiedMarkers] 🔄 Synchronisation des épicentres')
    console.log('[UnifiedMarkers] visibleLayers.conflictEpicenters:', mapStore.visibleLayers.conflictEpicenters)
    console.log('[UnifiedMarkers] conflictEpicenterMarkers count:', mapStore.conflictEpicenterMarkers.length)
    
    if (!mapStore.visibleLayers.conflictEpicenters) {
      // Supprimer tous les marqueurs d'épicentres existants
      const epicenterMarkers = Array.from(markers.value.keys()).filter(id => id.startsWith('conflict-epicenter-'))
      console.log('[UnifiedMarkers] Suppression de', epicenterMarkers.length, 'marqueurs d\'épicentres')
      epicenterMarkers.forEach(id => removeMarker(id))
      return
    }
    
    // Ajouter/mettre à jour les marqueurs d'épicentres
    console.log('[UnifiedMarkers] Ajout/mise à jour des marqueurs d\'épicentres')
    mapStore.conflictEpicenterMarkers.forEach(epicenterData => {
      const markerData: MarkerData = {
        id: epicenterData.id,
        type: epicenterData.type,
        coordinates: epicenterData.coordinates,
        icon: epicenterData.icon,
        name: epicenterData.name,
        data: epicenterData.data
      }
      createOrUpdateMarker(markerData)
    })
  }

  /**
   * Synchroniser les zones de combat depuis mapStore
   */
  const syncConflictZones = () => {
    console.log('[UnifiedMarkers] 🔄 Synchronisation des zones de combat')
    console.log('[UnifiedMarkers] visibleLayers.armedConflicts:', mapStore.visibleLayers.armedConflicts)
    console.log('[UnifiedMarkers] armedConflicts:', mapStore.armedConflicts)
    console.log('[UnifiedMarkers] armedConflicts features count:', mapStore.armedConflicts?.features?.length || 0)
    
    if (!mapStore.visibleLayers.armedConflicts || !mapStore.armedConflicts?.features) {
      // Supprimer tous les marqueurs de zones de combat existants
      const combatZoneMarkers = Array.from(markers.value.keys()).filter(id => id.startsWith('combat-zone-'))
      console.log('[UnifiedMarkers] Suppression de', combatZoneMarkers.length, 'marqueurs de zones de combat')
      combatZoneMarkers.forEach(id => removeMarker(id))
      return
    }
    
    // Ajouter/mettre à jour les marqueurs de zones de combat
    console.log('[UnifiedMarkers] Ajout/mise à jour des marqueurs de zones de combat')
    console.log('[UnifiedMarkers] Features à traiter:', mapStore.armedConflicts.features)
    
    mapStore.armedConflicts.features.forEach((feature, index) => {
      console.log(`[UnifiedMarkers] Traitement feature ${index}:`, feature)
      
      if (feature.geometry?.type === 'Point' && feature.geometry.coordinates) {
        const coords = feature.geometry.coordinates
        console.log(`[UnifiedMarkers] Coordonnées trouvées:`, coords)
        
        const markerData: MarkerData = {
          id: feature.properties.id,
          type: 'conflict',
          coordinates: [coords[1], coords[0]], // [lat, lng]
          icon: '💥',
          name: feature.properties.name,
          data: feature.properties
        }
        
        console.log(`[UnifiedMarkers] Création marqueur zone de combat:`, markerData)
        const marker = createOrUpdateMarker(markerData)
        
        if (marker) {
          console.log(`[UnifiedMarkers] ✅ Marqueur zone de combat créé avec succès: ${markerData.id}`)
        } else {
          console.log(`[UnifiedMarkers] ❌ Échec création marqueur zone de combat: ${markerData.id}`)
        }
      } else {
        console.log(`[UnifiedMarkers] ⚠️ Feature invalide:`, feature)
      }
    })
    
    console.log('[UnifiedMarkers] 📊 Total marqueurs après sync:', markers.value.size)
  }
  
  /**
   * Initialiser les marqueurs selon les données fournies
   */
  const initializeMarkers = (countriesData: any[], conflictsData?: any[]) => {
    // Nettoyer les marqueurs existants
    clearAllMarkers()
    
    // Créer les marqueurs de pays
    countriesData.forEach((country) => {
      const coords = country.coordinates || country.coordonnees
      if (coords && Array.isArray(coords)) {
        const markerData: MarkerData = {
          id: country.id,
          type: 'country',
          coordinates: [coords[1], coords[0]], // [lat, lng]
          flag: country.flag,
          name: country.title || country.name,
          data: country
        }
        createOrUpdateMarker(markerData)
      }
    })
    
    // Créer les marqueurs de conflits si fournis
    if (conflictsData) {
      conflictsData.forEach((conflict, index) => {
        if (conflict.geometry?.coordinates) {
          const coords = conflict.geometry.coordinates
          const markerData: MarkerData = {
            id: `conflict-${conflict.properties?.id || index}`,
            type: 'conflict',
            coordinates: [coords[1], coords[0]], // [lat, lng]
            icon: '💥',
            name: conflict.properties?.name,
            data: conflict.properties
          }
          createOrUpdateMarker(markerData)
        }
      })
    }
    
    isInitialized.value = true
  }
  
  // Surveiller les changements d'état pour rafraîchir les marqueurs
  watch(() => selectionSystem.currentState, () => {
    if (isInitialized.value) {
      refreshAllMarkers()
    }
  }, { deep: true })
  
  // Surveiller les changements d'épicentres de conflits
  watch(() => mapStore.conflictEpicenterMarkers, () => {
    syncConflictEpicenters()
  }, { deep: true })
  
  // Surveiller la visibilité des épicentres
  watch(() => mapStore.visibleLayers.conflictEpicenters, () => {
    syncConflictEpicenters()
  })

  // Surveiller les changements des zones de combat
  watch(() => mapStore.armedConflicts, () => {
    syncConflictZones()
  }, { deep: true })
  
  // Surveiller la visibilité des zones de combat
  watch(() => mapStore.visibleLayers.armedConflicts, () => {
    syncConflictZones()
  })
  
  // Surveiller le mode d'affichage des pays
  watch(() => mapStore.countryDisplayMode, () => {
    if (isInitialized.value) {
      refreshAllMarkers()
    }
  })
  
  // Surveiller les changements de vue de l'aside
  watch(() => asideStore.currentView?.type, () => {
    if (isInitialized.value) {
      refreshAllMarkers()
    }
  })
  
  // Surveiller les changements de type de sélection pour les épicentres
  watch(() => selectionSystem.type, () => {
    if (isInitialized.value) {
      syncConflictEpicenters()
    }
  })
  
  // Nettoyage lors de la destruction (seulement si on est dans un contexte de composant)
  const instance = getCurrentInstance()
  if (instance) {
    onUnmounted(() => {
      clearAllMarkers()
    })
  }
  
  return {
    // État
    markers,
    isInitialized,
    
    // Méthodes principales
    createOrUpdateMarker,
    removeMarker,
    clearAllMarkers,
    refreshAllMarkers,
    initializeMarkers,
    syncConflictEpicenters,
    
    // Utilitaires
    validateCoordinates,
    handleMarkerClick
  }
}