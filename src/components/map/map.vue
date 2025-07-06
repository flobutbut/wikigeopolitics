<template>
  <div id="map" ref="mapContainer" class="map-container"></div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, onUnmounted } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

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
  
  emits: ['map-click', 'map-ready'],
  
  setup(props, { emit }) {
    const mapContainer = ref<HTMLElement | null>(null)
    let map: L.Map | null = null
    
    onMounted(() => {
      if (!mapContainer.value) return
      
      // Initialisation de la carte avec Leaflet
      map = L.map(mapContainer.value).setView(props.initialView, props.initialZoom)
      
      // Ajouter une couche de tuiles OpenStreetMap
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
      }).addTo(map)
      
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
    
    return {
      mapContainer,
      addMarker,
      setView
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
</style> 