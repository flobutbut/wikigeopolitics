<template>
  <aside class="aside" v-scrollbar="{ stable: true, hover: true }">
    <Search 
      v-if="currentView.searchEnabled !== false"
      @search="handleSearch" 
      :placeholder="searchPlaceholder"
    />

    <!-- Vue principale (niveau 0) -->
    <AsideMainView v-if="currentView.type === 'main'" />
    
    <!-- Vue intermédiaire (niveaux 1 à n) -->
    <AsideNavigationView 
      v-else-if="['submenu', 'countryList'].includes(currentView.type)" 
    />
    
    <!-- Vue détail (fiche finale) -->
    <AsideDetailView v-else-if="currentView.type === 'detail'" />
  </aside>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import Search from '@components/common/Search.vue'
import AsideMainView from './AsideMainView.vue'
import AsideNavigationView from './AsideNavigationView.vue'
import AsideDetailView from './AsideDetailView.vue'
import { useAsideStore } from '@/stores/asideStore'

// Utiliser le store Pinia
const asideStore = useAsideStore()

// Computed pour le placeholder de recherche
const searchPlaceholder = computed(() => asideStore.searchPlaceholder)

// Vue actuelle
const currentView = computed(() => asideStore.currentView)

// Gestion de la recherche
const handleSearch = (query: string) => {
  asideStore.setSearchQuery(query)
}

// Assurer que la barre de défilement est toujours visible
onMounted(() => {
  // Forcer un rafraîchissement du composant pour s'assurer que la barre de défilement est correctement affichée
  setTimeout(() => {
    const asideElement = document.querySelector('.aside');
    if (asideElement) {
      asideElement.style.overflowY = 'auto';
      asideElement.style.overflowY = 'scroll';
    }
  }, 100);
})
</script>

<style scoped>
.aside {
  position: fixed;
  left: 0;
  top: var(--header-height);
  height: calc(100vh - var(--header-height));
  background-color: var(--surface-color);
  box-shadow: var(--shadow-sm);
  width: var(--aside-width);
  /* overflow-y est géré par la directive */
  z-index: 1000;
  padding: var(--spacing-sm) 0;
  box-sizing: border-box;
}
</style> 