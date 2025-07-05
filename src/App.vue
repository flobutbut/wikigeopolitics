<template>
  <div class="app-container">
    <!-- Header en haut -->
    <HeaderNav />

    <div class="content-wrapper">
      <!-- Aside à gauche, toujours visible -->
      <AsideNav />
      
      <!-- Contenu principal à droite -->
      <main class="main-content">
        <MapComponent 
          ref="mapComponent"
          @map-click="handleMapClick"
          @map-ready="handleMapReady"
          @country-selected="handleCountrySelected"
        />
        
        <!-- Panneau flottant de détails -->
        <FloatingDetailPanel />
      </main>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import AsideNav from '@components/aside/aside.vue'
import MapComponent from '@components/map/map.vue'
import HeaderNav from '@components/header/header.vue'
import FloatingDetailPanel from '@components/panels/FloatingDetailPanel.vue'
import type { LatLng } from 'leaflet'
import { useCountrySelectionStore } from '@/stores/countrySelectionStore'

export default defineComponent({
  name: 'App',
  components: {
    AsideNav,
    MapComponent,
    HeaderNav,
    FloatingDetailPanel
  },
  
  setup() {
    const mapInstance = ref(null)
    const mapComponent = ref(null)
    
    // Utiliser le store de sélection de pays
    const countryStore = useCountrySelectionStore()
    
    const handleMapClick = (latlng: LatLng) => {
      console.log(`Carte cliquée à: ${latlng.lat}, ${latlng.lng}`)
    }
    
    const handleMapReady = (map: any) => {
      mapInstance.value = map
      console.log('Carte initialisée et prête')
    }
    
    const handleCountrySelected = (country: any) => {
      console.log(`Pays sélectionné depuis la carte: ${country.name}`)
    }
    
    return {
      mapInstance,
      mapComponent,
      handleMapClick,
      handleMapReady,
      handleCountrySelected
    }
  }
})
</script>

<style>
body {
  margin: 0;
  padding: 0;
  font-family: 'Inter', sans-serif;
  height: 100vh;
  overflow: hidden;
}

.app-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  overflow: hidden;
}

.content-wrapper {
  display: flex;
  flex: 1;
  margin-top: var(--header-height); /* Espace pour le header */
  height: calc(100vh - var(--header-height)); /* Hauteur restante */
  position: relative;
  overflow: hidden;
}

.main-content {
  flex: 1;
  margin-left: var(--aside-width); /* Espace pour l'aside */
  position: relative;
  overflow: hidden;
  height: 100%;
}
</style> 