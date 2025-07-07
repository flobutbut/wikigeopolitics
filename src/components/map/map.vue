<template>
  <div id="map" ref="mapContainer" class="map-container"></div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, onUnmounted, watch, nextTick } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

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
  
  emits: ['map-click', 'map-ready', 'country-selected'],
  
  setup(props, { emit }) {
    const mapContainer = ref<HTMLElement | null>(null)
    let map: L.Map | null = null
    let countryMarkers: L.Marker[] = []
    let selectedMarker: L.Marker | null = null
    
    onMounted(() => {
      if (!mapContainer.value) return
      
      // Initialisation de la carte avec Leaflet
      map = L.map(mapContainer.value).setView(props.initialView, props.initialZoom)
      
      // Ajouter une couche de tuiles OpenStreetMap
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
      }).addTo(map)
      

      
      // Créer les marqueurs pour tous les pays
      createCountryMarkers()
      
      // Gérer les évènements
      map.on('click', (e: L.LeafletMouseEvent) => {
        emit('map-click', e.latlng)
      })
      
      // Émettre un événement quand la carte est prête
      emit('map-ready', map)
    })
    
    onUnmounted(() => {
      // Nettoyer la carte lors de la destruction du composant
      if (map) {
        map.remove()
        map = null
      }
      clearMarkers()
    })
    
    // Créer les marqueurs pour tous les pays
    const createCountryMarkers = () => {
      if (!map || !props.countriesData) return
      
      clearMarkers()
      
      props.countriesData.forEach((country: any) => {
        if (country.coordinates && Array.isArray(country.coordinates) && country.coordinates.length === 2) {
          try {
            const [lng, lat] = country.coordinates
            const coords: [number, number] = [lat, lng] // Leaflet attend [lat, lng]
            
            const marker = L.marker(coords, {
              icon: L.divIcon({
                className: 'country-marker',
                html: `<div class="marker-content">${country.flag}</div>`,
                iconSize: [30, 30],
                iconAnchor: [15, 15]
              }),
              zIndexOffset: 1000 // Forcer un Z-index élevé
            }).addTo(map!)
            
            // Gérer le clic sur le marqueur
            marker.on('click', () => {
              // Mettre en évidence le marqueur sélectionné
              highlightSelectedMarker(marker, country)
              emit('country-selected', country)
            })
            
            countryMarkers.push(marker)
          } catch (error) {
            console.warn(`Erreur lors de la création du marqueur pour ${country.title}:`, error)
          }
        }
      })
    }
    
    // Mettre en évidence le marqueur sélectionné
    const highlightSelectedMarker = (marker: L.Marker, country: any) => {
      // Retirer la mise en évidence précédente
      if (selectedMarker && map) {
        map.removeLayer(selectedMarker)
        selectedMarker = null
      }
      
      // Créer un marqueur de sélection plus grand
      const [lng, lat] = country.coordinates
      const coords: [number, number] = [lat, lng]
      
      selectedMarker = L.marker(coords, {
        icon: L.divIcon({
          className: 'country-marker selected',
          html: `<div class="marker-content selected">${country.flag}</div>`,
          iconSize: [40, 40],
          iconAnchor: [20, 20]
        }),
        zIndexOffset: 2000 // Au-dessus des autres marqueurs
      }).addTo(map!)
    }
    
    // Nettoyer tous les marqueurs
    const clearMarkers = () => {
      countryMarkers.forEach(marker => {
        if (map) map.removeLayer(marker)
      })
      countryMarkers = []
      
      if (selectedMarker && map) {
        map.removeLayer(selectedMarker)
        selectedMarker = null
      }
    }
    
    // Surveiller les changements de données
    watch(() => props.countriesData, async (newData) => {
      // Attendre que Vue ait terminé ses mises à jour
      await nextTick()
      
      if (map && newData && newData.length > 0) {
        createCountryMarkers()
      } else if (!map) {
        setTimeout(() => {
          if (map && newData && newData.length > 0) {
            createCountryMarkers()
          }
        }, 100)
      }
    }, { immediate: true })
    
    // Méthodes exposées pour interagir avec la carte
    const addMarker = (position: L.LatLngExpression, popupContent?: string) => {
      if (!map) return null
      
      const marker = L.marker(position).addTo(map)
      
      if (popupContent) {
        marker.bindPopup(popupContent)
      }
      
      return marker
    }
    
    const setView = (center: L.LatLngExpression, zoom: number) => {
      if (map) {
        map.setView(center, zoom)
      }
    }
    
    // Méthode pour zoomer sur un pays
    const zoomToCountry = (countryId: string) => {
      if (!map) return
      
      const country = props.countriesData.find((c: any) => c.id === countryId)
      if (country && (country as any).coordinates) {
        const [lng, lat] = (country as any).coordinates
        map.setView([lat, lng], 6)
        
        // Mettre en évidence le marqueur
        const marker = countryMarkers.find(m => {
          const markerLatLng = m.getLatLng()
          return markerLatLng.lat === lat && markerLatLng.lng === lng
        })
        
        if (marker) {
          highlightSelectedMarker(marker, country)
        }
      }
    }
    
    return {
      mapContainer,
      addMarker,
      setView,
      zoomToCountry
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

/* Assurez-vous que le conteneur parent a une hauteur définie */
:deep(.leaflet-container) {
  height: 100%;
  width: 100%;
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

:deep(.marker-content.selected) {
  width: 40px;
  height: 40px;
  font-size: 20px;
  background: #ff6b6b;
  border-color: #ff4757;
  box-shadow: 0 0 0 4px rgba(255, 107, 107, 0.3);
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(255, 107, 107, 0.7);
  }
  70% {
    box-shadow: 0 0 0 10px rgba(255, 107, 107, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(255, 107, 107, 0);
  }
}
</style> 