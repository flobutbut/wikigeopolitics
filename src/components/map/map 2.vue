<template>
  <div id="map" ref="mapContainer" class="map-container"></div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, onUnmounted, watch } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import { useCountrySelectionStore } from '@/stores/countrySelectionStore'
import { useAsideStore } from '@/stores/asideStore'

export default defineComponent({
  name: 'MapComponent',
  
  props: {
    initialView: {
      type: Array as () => [number, number],
      default: () => [0, 0]
    },
    initialZoom: {
      type: Number,
      default: 2
    }
  },
  
  emits: ['map-click', 'map-ready', 'country-selected'],
  
  setup(props, { emit }) {
    const mapContainer = ref<HTMLElement | null>(null)
    let map: L.Map | null = null
    let countryMarkers: L.Marker[] = []
    let selectedMarker: L.Marker | null = null
    
    // Utiliser les stores
    const countryStore = useCountrySelectionStore()
    const asideStore = useAsideStore()
    
    onMounted(() => {
      if (!mapContainer.value) return
      
      // Initialiser les données des pays
      countryStore.initializeCountriesData()
      
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
        
        // Essayer de sélectionner un pays par les coordonnées
        const selectedCountry = countryStore.selectCountryByCoordinates(e.latlng.lat, e.latlng.lng)
        if (selectedCountry) {
          // Charger les données du pays dans le store aside
          asideStore.selectCountry(selectedCountry.id)
          emit('country-selected', selectedCountry)
          updateSelectedMarker()
        }
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
      if (!map) return
      
      clearMarkers()
      
      countryStore.allCountries.forEach(country => {
        const marker = L.marker([country.coordinates[1], country.coordinates[0]], {
          icon: L.divIcon({
            className: 'country-marker',
            html: `<div class="marker-content">${country.flag}</div>`,
            iconSize: [30, 30],
            iconAnchor: [15, 15]
          })
        }).addTo(map!)
        
        // Gérer le clic sur le marqueur
        marker.on('click', () => {
          const selectedCountry = countryStore.selectCountry(country.id)
          if (selectedCountry) {
            // Charger les données du pays dans le store aside
            asideStore.selectCountry(country.id)
            emit('country-selected', selectedCountry)
            updateSelectedMarker()
          }
        })
        
        countryMarkers.push(marker)
      })
    }
    
    // Mettre à jour le marqueur sélectionné
    const updateSelectedMarker = () => {
      // Supprimer l'ancien marqueur de sélection
      if (selectedMarker) {
        map?.removeLayer(selectedMarker)
        selectedMarker = null
      }
      
      // Créer un nouveau marqueur de sélection si un pays est sélectionné
      if (countryStore.hasSelectedCountry && map) {
        const country = countryStore.currentSelectedCountry!
        selectedMarker = L.marker([country.coordinates[1], country.coordinates[0]], {
          icon: L.divIcon({
            className: 'country-marker selected',
            html: `<div class="marker-content selected">${country.flag}</div>`,
            iconSize: [40, 40],
            iconAnchor: [20, 20]
          })
        }).addTo(map)
        
        // Centrer la carte sur le pays sélectionné
        map.setView([country.coordinates[1], country.coordinates[0]], 4)
      }
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
    
    // Surveiller les changements de sélection
    watch(() => countryStore.selectedCountry, () => {
      updateSelectedMarker()
    })
    
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
    
    const selectCountryFromOutside = (countryId: string) => {
      const country = countryStore.selectCountry(countryId)
      if (country) {
        emit('country-selected', country)
        updateSelectedMarker()
      }
    }
    
    return {
      mapContainer,
      addMarker,
      setView,
      selectCountryFromOutside
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