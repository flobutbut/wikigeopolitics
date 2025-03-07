<template>
  <div class="map-view">
    <div v-if="isLoading" class="loading-overlay">
      <div class="loading-spinner"></div>
      <p>Chargement de la carte...</p>
    </div>
    
    <div v-if="error" class="error-message">
      {{ error }}
      <button @click="loadData">Réessayer</button>
    </div>
    
    <MapComponent 
      v-if="countriesGeoJson"
      :initialView="[20, 0]" 
      :initialZoom="2"
      :selectedCountries="selectedCountries"
      :countriesGeoJson="countriesGeoJson"
      :tradeRoutes="tradeRoutes"
      :conflictZones="conflictZones"
      :visibleLayers="visibleLayers"
      :isLoading="isLoading"
      @country-selected="handleCountrySelected"
      @map-ready="handleMapReady"
    />
    
    <MapLayersControl 
      :visibleLayers="visibleLayers"
      @toggle-layer="toggleMapLayer"
    />
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, computed } from 'vue'
import MapComponent from '@/components/map/map.vue'
import MapLayersControl from '@/components/map/MapLayersControl.vue'
import { useMapStore } from '@/stores/mapStore'
import { useAsideStore } from '@/stores/asideStore'

export default defineComponent({
  name: 'MapView',
  
  components: {
    MapComponent,
    MapLayersControl
  },
  
  setup() {
    const mapStore = useMapStore()
    const asideStore = useAsideStore()
    
    // Charger les données au montage du composant
    onMounted(() => {
      loadData()
    })
    
    const loadData = async () => {
      await mapStore.loadCountriesData()
    }
    
    // Charger les couches additionnelles
    const loadTradeRoutes = async () => {
      await mapStore.loadTradeRoutes()
    }
    
    const loadConflictZones = async () => {
      await mapStore.loadConflictZones()
    }
    
    // Gérer la sélection d'un pays sur la carte
    const handleCountrySelected = (country) => {
      // Sélectionner le pays sur la carte
      mapStore.selectSingleCountry(country.code)
      
      // Naviguer vers les détails du pays dans le panneau latéral
      asideStore.navigateToCountryDetail(country.code)
    }
    
    // Gérer l'activation/désactivation des couches
    const toggleMapLayer = (layerName) => {
      mapStore.toggleLayer(layerName)
      
      // Charger les données si nécessaire
      if (layerName === 'tradeRoutes' && !mapStore.tradeRoutes) {
        loadTradeRoutes()
      } else if (layerName === 'conflictZones' && !mapStore.conflictZones) {
        loadConflictZones()
      }
    }
    
    // Gérer l'événement map-ready
    const handleMapReady = (mapInstance) => {
      console.log('La carte est prête', mapInstance)
    }
    
    return {
      countriesGeoJson: computed(() => mapStore.countriesGeoJson),
      selectedCountries: computed(() => mapStore.selectedCountries),
      tradeRoutes: computed(() => mapStore.tradeRoutes),
      conflictZones: computed(() => mapStore.conflictZones),
      visibleLayers: computed(() => mapStore.visibleLayers),
      isLoading: computed(() => mapStore.isLoading),
      error: computed(() => mapStore.error),
      handleCountrySelected,
      handleMapReady,
      toggleMapLayer,
      loadData
    }
  }
})
</script>

<style scoped>
.map-view {
  position: relative;
  height: 100%;
  width: 100%;
}

.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(255, 255, 255, 0.8);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.loading-spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  border-top: 4px solid var(--primary-color);
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
  margin-bottom: var(--spacing-md);
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-message {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: var(--surface-color);
  padding: var(--spacing-md);
  border-radius: var(--radius-md);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  z-index: 1000;
  text-align: center;
}

.error-message button {
  margin-top: var(--spacing-sm);
  padding: var(--spacing-xs) var(--spacing-sm);
  background-color: var(--primary-color);
  color: white;
  border: none;
  border-radius: var(--radius-sm);
  cursor: pointer;
  font-size: var(--font-size-sm);
}

.error-message button:hover {
  background-color: var(--primary-dark);
}
</style> 