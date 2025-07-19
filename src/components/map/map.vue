<template>
  <div id="map" ref="mapContainer" class="map-container"></div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, onUnmounted, watch, nextTick } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import { useMapStore } from '@/stores/mapStore'
import { useSelectionSystem } from '@/stores/selectionSystem'
import { useUnifiedMarkers } from '@/composables/useUnifiedMarkers'

export default defineComponent({
  name: 'MapComponent',
  
  props: {
    initialView: {
      type: Array as unknown as () => [number, number],
      default: () => [20, 0] as [number, number]
    },
    initialZoom: {
      type: Number,
      default: 2
    },
    countriesData: {
      type: Array,
      default: () => []
    }
  },

  setup(props, { emit }) {
    const mapContainer = ref<HTMLElement | null>(null)
    const map = ref<L.Map | null>(null)
    
    // Stores
    const mapStore = useMapStore()
    const selectionSystem = useSelectionSystem()
    
    // Système unifié de marqueurs
    const unifiedMarkers = ref<ReturnType<typeof useUnifiedMarkers> | null>(null)
    
    // Initialisation de la carte
    const initializeMap = () => {
      if (!mapContainer.value) return
      
      // Créer la carte Leaflet
      map.value = L.map(mapContainer.value, {
        center: props.initialView,
        zoom: props.initialZoom,
        zoomControl: true,
        attributionControl: true
      })
      
      // Ajouter la couche de base
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        maxZoom: 19
      }).addTo(map.value)
      
      // Initialiser le système de marqueurs
      unifiedMarkers.value = useUnifiedMarkers(map.value)
      
    }
    
    // Charger les données de pays
    const loadCountryMarkers = async () => {
      if (!unifiedMarkers.value || !props.countriesData?.length) {
        console.log('[Map] 📊 Pas de données pays à charger')
        return
      }
      
      // Utiliser la méthode initializeMarkers du système unifié
      unifiedMarkers.value.initializeMarkers(props.countriesData)
    }
    
    // Charger les zones de combat
    const loadConflictMarkers = () => {
      if (!unifiedMarkers.value || !mapStore.armedConflicts?.features?.length) {
        return
      }
      
      // Créer/mettre à jour les marqueurs de conflits SANS supprimer les existants
      mapStore.armedConflicts.features.forEach((feature: any, index: number) => {
        const coords = feature.geometry?.coordinates
        const props = feature.properties
        
        if (coords && props && coords.length >= 2) {
          const markerData = {
            id: `conflict-${props.id || index}`,
            type: 'conflict' as const,
            coordinates: [coords[1], coords[0]] as [number, number],
            icon: '💥',
            name: props.name,
            data: props
          }
          
          const marker = unifiedMarkers.value!.createOrUpdateMarker(markerData)
          // Temporairement pas de tooltip pour éviter les conflits de zoom
          // Nous utiliserons l'attribut title du marqueur comme alternative
        }
      })
      
    }
    
    // Gérer les clics sur la carte (pas sur les marqueurs)
    const handleMapClick = async (event: L.LeafletMouseEvent) => {
      console.log('🗺️ Clic sur la carte:', event.latlng)
      
      // Vérifier si on a cliqué sur un marqueur (éviter la déselection)
      const target = event.originalEvent?.target as HTMLElement
      if (target && (target.closest('.country-marker') || target.closest('.conflict-marker'))) {
        console.log('🗺️ Clic sur un marqueur, pas de déselection')
        return
      }
      
      // Déselectionner selon le contexte actuel
      try {
        await selectionSystem.deselectOnMapClick()
      } catch (error) {
        console.error('Erreur lors de la déselection:', error)
      }
    }
    
    // Lifecycle
    onMounted(async () => {
      await nextTick()
      initializeMap()
      
      if (map.value) {
        map.value.on('click', handleMapClick)
      }
      
      // Charger les données initiales
      await loadCountryMarkers()
    })
    
    onUnmounted(() => {
      if (unifiedMarkers.value) {
        unifiedMarkers.value.clearAllMarkers()
      }
      
      if (map.value) {
        map.value.off('click', handleMapClick)
        map.value.remove()
      }
    })
    
    // Watchers
    
    // Surveiller les changements de données pays
    watch(() => props.countriesData, async (newData) => {
      await nextTick()
      if (newData && newData.length > 0) {
        await loadCountryMarkers()
      }
    }, { immediate: false, deep: true })
    
    // Surveiller les conflits armés
    watch(() => [
      mapStore.armedConflicts?.features?.length, 
      mapStore.visibleLayers.armedConflicts,
      selectionSystem.conflictZonesVisible
    ], 
      async ([featuresCount, isVisible, conflictZonesVisible]) => {
        await nextTick()
        
        if (featuresCount > 0 && (isVisible || conflictZonesVisible)) {
          loadConflictMarkers()
        }
      }, { immediate: false }
    )
    
    // Watcher spécifique pour les changements de conflictZonesVisible
    // pour forcer le chargement même si les données arrivent en retard
    watch(() => selectionSystem.conflictZonesVisible, async (isVisible) => {
      if (isVisible && selectionSystem.selectedConflict) {
        await nextTick()
        // Attendre un peu que les données se chargent si elles ne sont pas encore là
        setTimeout(() => {
          if (mapStore.armedConflicts?.features?.length > 0) {
            loadConflictMarkers()
          }
        }, 100)
      }
    })
    
    // Surveiller les épicentres de conflits
    watch(() => [
      mapStore.conflictEpicenterMarkers?.length,
      mapStore.visibleLayers.conflictEpicenters
    ], 
      async ([markersCount, isVisible]) => {
        await nextTick()
        
        // Le système unifié synchronise automatiquement les marqueurs d'épicentres
        // via les watchers dans useUnifiedMarkers
        if (unifiedMarkers.value) {
          unifiedMarkers.value.syncConflictEpicenters()
        }
      }, { immediate: false }
    )
    
    // Surveiller les demandes de zoom
    watch(() => mapStore.targetZoom, (targetZoom) => {
      if (targetZoom && map.value) {
        const [lng, lat] = targetZoom.coordinates
        map.value.setView([lat, lng], targetZoom.zoom)
        mapStore.clearTargetZoom()
      }
    })
    
    // API publique pour interactions externes
    const zoomToCountry = (countryId: string) => {
      if (!map.value) return
      
      const country = props.countriesData.find((c: any) => c.id === countryId)
      if (country && country.coordonnees) {
        const [lng, lat] = country.coordonnees
        map.value.setView([lat, lng], 6)
      }
    }
    
    const addMarker = (position: L.LatLngExpression, popupContent?: string) => {
      if (!map.value) return null
      
      const marker = L.marker(position).addTo(map.value)
      if (popupContent) {
        marker.bindPopup(popupContent)
      }
      return marker
    }
    
    return {
      mapContainer,
      zoomToCountry,
      addMarker
    }
  }
})
</script>

<style scoped>
.map-container {
  height: 100%;
  width: 100%;
  background-color: #A5CCDA;
}

/* Styles pour les marqueurs de pays */
:deep(.country-marker) {
  background: none;
  border: none;
  z-index: 1000 !important;
}

:deep(.marker-content) {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 30px;
  background: white;
  border: 2px solid #333;
  border-radius: 50%;
  font-size: 16px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  transition: all 0.3s ease;
  cursor: pointer;
}

:deep(.marker-content:hover) {
  transform: scale(1.1);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}

/* Styles pour les marqueurs sélectionnés */
:deep(.country-marker.selected .marker-content) {
  background: white;
  border-color: #2196F3;
  border-width: 3px;
  box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.4);
  transform: scale(1.1);
  z-index: 2000 !important;
}

/* Styles pour les marqueurs mis en évidence */
:deep(.country-marker.highlighted .marker-content) {
  border-color: #FF9800;
  box-shadow: 0 0 0 1px rgba(255, 152, 0, 0.3);
}

/* Styles pour les marqueurs diminués */
:deep(.country-marker.dimmed .marker-content) {
  opacity: 0.3;
  filter: grayscale(50%);
}

/* Styles pour les marqueurs dans le contexte d'un conflit */
:deep(.country-marker.context-mode .marker-content) {
  border-color: #4CAF50;
  box-shadow: 0 0 0 1px rgba(76, 175, 80, 0.3);
}

/* Styles pour les marqueurs de conflits */
:deep(.conflict-marker) {
  background: none;
  border: none;
  z-index: 1500 !important;
}

:deep(.conflict-marker .marker-content) {
  width: 30px;
  height: 30px;
  font-size: 20px;
  background: rgba(255, 68, 68, 0.9);
  border: 2px solid #d32f2f;
  border-radius: 50%;
  box-shadow: 0 2px 8px rgba(255, 68, 68, 0.4);
}

:deep(.conflict-marker.selected .marker-content) {
  background: rgba(255, 68, 68, 1);
  border-width: 3px;
  box-shadow: 0 0 0 3px rgba(255, 68, 68, 0.3);
  transform: scale(1.1);
}

/* Styles pour les marqueurs d'épicentres de conflits */
:deep(.conflict-epicenter-marker) {
  background: none;
  border: none;
  z-index: 1600 !important;
}

:deep(.conflict-epicenter-marker .marker-content) {
  width: 30px;
  height: 30px;
  font-size: 20px;
  background: rgba(255, 193, 7, 0.9);
  border: 2px solid #ff8f00;
  border-radius: 50%;
  box-shadow: 0 2px 8px rgba(255, 193, 7, 0.4);
}

:deep(.conflict-epicenter-marker.selected .marker-content) {
  background: rgba(255, 193, 7, 1);
  border-width: 3px;
  box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.3);
  transform: scale(1.1);
}

/* Assurez-vous que le conteneur parent a une hauteur définie */
:deep(.leaflet-container) {
  height: 100%;
  width: 100%;
}

/* Styles pour les tooltips des zones de combat */
:deep(.combat-zone-tooltip) {
  background: white !important;
  border: 1px solid #ccc !important;
  border-radius: 8px !important;
  padding: 8px 12px !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15) !important;
  font-size: 13px !important;
  line-height: 1.4 !important;
  color: #333 !important;
  max-width: 200px !important;
}

:deep(.combat-zone-tooltip.leaflet-tooltip-top:before) {
  border-top-color: white !important;
}

:deep(.combat-zone-tooltip.leaflet-tooltip-bottom:before) {
  border-bottom-color: white !important;
}

:deep(.combat-zone-tooltip.leaflet-tooltip-left:before) {
  border-left-color: white !important;
}

:deep(.combat-zone-tooltip.leaflet-tooltip-right:before) {
  border-right-color: white !important;
}

/* Tooltip CSS pur pour les zones de combat */
:deep(.conflict-marker .marker-content[data-tooltip]) {
  position: relative;
}

:deep(.conflict-marker .marker-content[data-tooltip]:hover::before) {
  content: attr(data-tooltip) " - " attr(data-description);
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  background: var(--surface-color);
  border: 1px solid var(--border-hover);
  border-radius: 8px;
  padding: var(--spacing-sm) var(--spacing-md);
  box-shadow: var(--shadow-md);

  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-default);
  line-height: var(--line-height-sm);
  color: var(--text-color);
  width: 312px;
  white-space: normal;
  word-wrap: break-word;
  z-index: 10000;
  pointer-events: none;
  margin-bottom: 5px;
  z-index: 10000;
}

:deep(.conflict-marker .marker-content[data-tooltip]:hover::after) {
  content: "";
  position: absolute;
  bottom: 90%;
  left: 50%;
  transform: translateX(-50%);
  border: 5px solid transparent;
  border-top-color: var(--surface-color);
  z-index: 10001;
  pointer-events: none;
}

/* Tooltip CSS pour les marqueurs de pays avec rôle dans un conflit */
:deep(.country-marker .marker-content[data-role]) {
  position: relative;
}

:deep(.country-marker .marker-content[data-role]:hover::before) {
  content: attr(data-tooltip) " - Rôle: " attr(data-role);
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  background: var(--surface-color);
  border: 1px solid var(--border-hover);
  border-radius: 8px;
  padding: var(--spacing-sm) var(--spacing-md);
  box-shadow: var(--shadow-md);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-default);
  line-height: var(--line-height-sm);
  color: var(--text-color);
  width: 312px;
  white-space: normal;
  word-wrap: break-word;
  z-index: 10000;
  pointer-events: none;
  margin-bottom: 5px;
}

:deep(.country-marker .marker-content[data-role]:hover::after) {
  content: "";
  position: absolute;
  bottom: 90%;
  left: 50%;
  transform: translateX(-50%);
  border: 5px solid transparent;
  border-top-color: var(--surface-color);
  z-index: 10001;
  pointer-events: none;
}
</style>