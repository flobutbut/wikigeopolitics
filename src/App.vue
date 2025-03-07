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
          @map-click="handleMapClick"
          @map-ready="handleMapReady"
        />
      </main>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import AsideNav from '@components/aside/aside.vue'
import MapComponent from '@components/map/map.vue'
import HeaderNav from '@components/header/header.vue'
import type { LatLng } from 'leaflet'

export default defineComponent({
  name: 'App',
  components: {
    AsideNav,
    MapComponent,
    HeaderNav
  },
  
  setup() {
    const mapInstance = ref(null)
    
    const handleMapClick = (latlng: LatLng) => {
      console.log(`Carte cliquée à: ${latlng.lat}, ${latlng.lng}`)
    }
    
    const handleMapReady = (map: any) => {
      mapInstance.value = map
      console.log('Carte initialisée et prête')
    }
    
    return {
      handleMapClick,
      handleMapReady
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