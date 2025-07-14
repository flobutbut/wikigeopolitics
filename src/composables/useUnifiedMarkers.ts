import { ref, watch, onUnmounted } from 'vue'
import L from 'leaflet'
import { useSelectionSystem, type EntityType } from '@/stores/selectionSystem'

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
      ? selectionSystem.shouldShowCountry(id)
      : type === 'conflict' 
      ? selectionSystem.conflictZonesVisible
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
      await selectionSystem.selectEntity(markerData.type, markerData.id, 'map')
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
  
  // Nettoyage lors de la destruction
  onUnmounted(() => {
    clearAllMarkers()
  })
  
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
    
    // Utilitaires
    validateCoordinates,
    handleMarkerClick
  }
}