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
  
  // Système de debounce pour éviter les rafraîchissements excessifs
  let refreshTimer: number | null = null
  const REFRESH_DEBOUNCE_MS = 50
  
  // Cache des rôles des pays dans les conflits pour éviter les appels API répétés
  const countryRolesCache = ref<Map<string, string>>(new Map())
  
  /**
   * Précharger les rôles des pays dans un conflit
   */
  const preloadCountryRoles = async (conflictId: string, countryIds: string[]) => {
    try {
      const { supabaseService } = await import('@/services/supabaseService')
      
      // Charger les rôles en parallèle pour tous les pays
      const rolePromises = countryIds.map(async (countryId) => {
        const cacheKey = `${conflictId}-${countryId}`
        
        if (!countryRolesCache.value.has(cacheKey)) {
          try {
            const role = await supabaseService.getCountryRoleInConflict(countryId, conflictId)
            countryRolesCache.value.set(cacheKey, role || 'participant')
            return { countryId, role: role || 'participant' }
          } catch (error) {
            console.error(`Erreur récupération rôle ${countryId}:`, error)
            countryRolesCache.value.set(cacheKey, 'participant')
            return { countryId, role: 'participant' }
          }
        }
        
        return { countryId, role: countryRolesCache.value.get(cacheKey)! }
      })
      
      await Promise.all(rolePromises)
      
      // Déclencher un rafraîchissement des marqueurs pour appliquer les nouveaux rôles
      refreshAllMarkersImmediate()
      
    } catch (error) {
      console.error('[UnifiedMarkers] Erreur préchargement rôles:', error)
    }
  }
  
  /**
   * Nettoyer le cache des rôles pour un conflit spécifique
   */
  const clearConflictRolesCache = (conflictId?: string) => {
    if (conflictId) {
      // Nettoyer seulement les rôles de ce conflit
      const keysToDelete = Array.from(countryRolesCache.value.keys())
        .filter(key => key.startsWith(`${conflictId}-`))
      
      keysToDelete.forEach(key => countryRolesCache.value.delete(key))
    } else {
      // Nettoyer tout le cache
      countryRolesCache.value.clear()
    }
  }
  
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
    const { type, flag, icon, id, name } = markerData
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
    
    // Créer les attributs data pour le tooltip CSS
    let dataAttrs = ''
    if (markerData.type === 'conflict' && markerData.data?.description) {
      dataAttrs = `data-tooltip="${markerData.name}" data-description="${markerData.data.description}"`
    } else if (markerData.type === 'country') {
      // Vérifier si ce pays a un rôle dans le conflit sélectionné
      const selectionSystem = useSelectionSystem()
      if (selectionSystem.selectedConflict && selectionSystem.visibleCountries.includes(markerData.id)) {
        // Utiliser le cache pour récupérer le rôle (synchrone)
        const cacheKey = `${selectionSystem.selectedConflict}-${markerData.id}`
        const cachedRole = countryRolesCache.value.get(cacheKey)
        
        if (cachedRole && cachedRole !== 'participant') {
          dataAttrs = `data-tooltip="${markerData.name}" data-role="${cachedRole}"`
        }
      }
    }
    
    return L.divIcon({
      className: className,
      html: `<div class="marker-content" ${dataAttrs}>${iconContent}</div>`,
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
      
      // Pas de tooltip Leaflet - utilisation de CSS pur via data attributes
      
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
    
    // Nettoyer aussi le cache des rôles
    clearConflictRolesCache()
  }
  
  /**
   * Rafraîchir tous les marqueurs (avec debounce)
   */
  const refreshAllMarkers = () => {
    if (refreshTimer !== null) {
      clearTimeout(refreshTimer)
    }
    
    refreshTimer = window.setTimeout(() => {
      markers.value.forEach((unifiedMarker) => {
        updateMarkerAppearance(unifiedMarker)
      })
      refreshTimer = null
    }, REFRESH_DEBOUNCE_MS)
  }
  
  /**
   * Rafraîchir immédiatement tous les marqueurs (sans debounce)
   */
  const refreshAllMarkersImmediate = () => {
    if (refreshTimer !== null) {
      clearTimeout(refreshTimer)
      refreshTimer = null
    }
    
    markers.value.forEach((unifiedMarker) => {
      updateMarkerAppearance(unifiedMarker)
    })
  }
  
  /**
   * Synchroniser les marqueurs d'épicentres depuis mapStore
   */
  const syncConflictEpicenters = () => {
    if (!mapStore.visibleLayers.conflictEpicenters) {
      // Ne plus supprimer - laisser updateMarkerAppearance gérer la visibilité
      return
    }
    
    // Ajouter/mettre à jour les marqueurs d'épicentres
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
    if (!mapStore.visibleLayers.armedConflicts || !mapStore.armedConflicts?.features) {
      // Ne plus supprimer - laisser updateMarkerAppearance gérer la visibilité
      return
    }
    
    // Ajouter/mettre à jour les marqueurs de zones de combat
    
    mapStore.armedConflicts.features.forEach((feature) => {
      if (feature.geometry?.type === 'Point' && feature.geometry.coordinates) {
        const coords = feature.geometry.coordinates
        const markerData: MarkerData = {
          id: feature.properties.id,
          type: 'conflict',
          coordinates: [coords[1], coords[0]], // [lat, lng]
          icon: '💥',
          name: feature.properties.name,
          data: feature.properties
        }
        
        createOrUpdateMarker(markerData)
      }
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
  
  // Watcher centralisé pour la synchronisation des marqueurs (optimisé avec debounce)
  watch(() => ({
    // États de sélection qui affectent l'apparence des marqueurs
    selectionState: selectionSystem.currentState,
    countryDisplayMode: mapStore.countryDisplayMode,
    currentViewType: asideStore.currentView?.type,
    currentDetailData: asideStore.currentDetailData,
    currentEntityType: asideStore.currentEntityType
  }), () => {
    if (isInitialized.value) {
      refreshAllMarkers()
    }
  }, { deep: true })
  
  // Watcher séparé pour les épicentres (synchronisation immédiate nécessaire)
  watch(() => ({
    epicenterMarkers: mapStore.conflictEpicenterMarkers,
    epicenterVisible: mapStore.visibleLayers.conflictEpicenters,
    selectionType: selectionSystem.type
  }), () => {
    syncConflictEpicenters()
  }, { deep: true })
  
  // Watcher séparé pour les zones de combat (synchronisation immédiate nécessaire)
  watch(() => ({
    armedConflicts: mapStore.armedConflicts,
    conflictsVisible: mapStore.visibleLayers.armedConflicts
  }), () => {
    syncConflictZones()
  }, { deep: true })
  
  // Nettoyage lors de la destruction (seulement si on est dans un contexte de composant)
  const instance = getCurrentInstance()
  if (instance) {
    onUnmounted(() => {
      // Nettoyer le timer de debounce
      if (refreshTimer !== null) {
        clearTimeout(refreshTimer)
        refreshTimer = null
      }
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
    refreshAllMarkersImmediate,
    initializeMarkers,
    syncConflictEpicenters,
    
    // Gestion des rôles
    preloadCountryRoles,
    clearConflictRolesCache,
    
    // Utilitaires
    validateCoordinates,
    handleMarkerClick
  }
}