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
          :countriesData="countryStore.countriesData"
          @map-click="handleMapClick"
          @map-ready="handleMapReady"
          @country-selected="handleCountrySelected"
        />
        
        <!-- Panneau flottant de détails -->
        <FloatingDetailPanel />
      </main>
    </div>

    <!-- Indicateur de chargement -->
    <div v-if="isLoading" class="loading-overlay">
      <div class="loading-spinner">
        <div class="spinner"></div>
        <p>Chargement des données depuis la base de données...</p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, watch } from 'vue'
import AsideNav from '@components/aside/aside.vue'
import MapComponent from '@components/map/Map.vue'
import HeaderNav from '@components/header/header.vue'
import FloatingDetailPanel from '@components/panels/FloatingDetailPanel.vue'
import type { LatLng } from 'leaflet'
import { useCountrySelectionStore } from '@/stores/countrySelectionStore'
import { useAsideStore } from '@/stores/asideStore'

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
    const isLoading = ref(true)
    
    // Utiliser les stores
    const countryStore = useCountrySelectionStore()
    const asideStore = useAsideStore()
    
    // Initialiser les données depuis la base de données
    const initializeData = async () => {
      try {
        isLoading.value = true
        
        // Initialiser les données en parallèle
        await Promise.all([
          countryStore.initializeCountriesData(),
          asideStore.initializeData()
        ])
        

      } catch (error) {
        console.error('Erreur lors de l\'initialisation des données:', error)
      } finally {
        isLoading.value = false
      }
    }
    
    const handleMapClick = (latlng: LatLng) => {
      console.log(`Carte cliquée à: ${latlng.lat}, ${latlng.lng}`)
    }
    
    const handleMapReady = (map: any) => {
      mapInstance.value = map
    }
    
    const handleCountrySelected = (country: any) => {
      console.log(`Pays sélectionné depuis la carte: ${country.name}`)
      
      // Sélectionner le pays dans le store
      countryStore.selectCountry(country.id)
      
      // Zoomer sur le pays sélectionné
      if (mapInstance.value && country.coordinates) {
        const [lng, lat] = country.coordinates
        ;(mapInstance.value as any).setView([lat, lng], 6) // Zoom niveau 6 pour voir le pays
      }
      
      // Afficher les détails du pays dans le panneau flottant
      asideStore.selectCountry(country.id)
    }
    
    // Méthode pour zoomer sur un pays depuis l'aside
    const zoomToCountryFromAside = (countryId: string) => {
      if (mapComponent.value) {
        ;(mapComponent.value as any).zoomToCountry(countryId)
      }
    }
    
    // Surveiller les changements de pays sélectionné dans le store
    watch(() => countryStore.selectedCountry, (newCountry) => {
      if (newCountry && newCountry.id) {
        console.log(`Pays sélectionné dans le store: ${newCountry.name}`)
        zoomToCountryFromAside(newCountry.id)
      }
    })
    
    // Initialiser les données au montage du composant
    onMounted(() => {
      initializeData()
    })
    
    return {
      mapInstance,
      mapComponent,
      isLoading,
      countryStore,
      handleMapClick,
      handleMapReady,
      handleCountrySelected,
      zoomToCountryFromAside
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

/* Styles pour l'indicateur de chargement */
.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.loading-spinner {
  text-align: center;
  color: white;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top: 4px solid white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style> 