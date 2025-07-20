<template>
  <aside class="aside" v-scrollbar="{ stable: true, hover: true }">
    <!-- La barre de recherche a été déplacée vers le header -->
    
    <div class="aside__content">
      <!-- Vue principale (niveau 0) -->
      <AsideMainView v-if="currentView.type === 'main'" />
      
      <!-- Vue intermédiaire (niveaux 1 à n) -->
      <AsideNavigationView 
        v-else-if="['submenu', 'countryList', 'politicalRegimeList', 'organizationsList', 'armedConflictsList', 'resourcesList'].includes(currentView.type)" 
      />
      
      <!-- Vue détail (fiche finale) -->
      <FloatingDetailView v-else-if="currentView.type === 'detail'" />
    </div>
  </aside>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import AsideMainView from './AsideMainView.vue'
import AsideNavigationView from './AsideNavigationView.vue'
import FloatingDetailView from '@/components/panels/FloatingDetailView.vue'
import { useAsideStore } from '@/stores/asideStore'

// Utiliser le store Pinia
const asideStore = useAsideStore()

// Vue actuelle
const currentView = computed(() => asideStore.currentView)

// Assurer que la barre de défilement est toujours visible
onMounted(() => {
  // Forcer un rafraîchissement du composant pour s'assurer que la barre de défilement est correctement affichée
  setTimeout(() => {
    const asideElement = document.querySelector('.aside') as HTMLElement;
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
  border-right: 1px solid var(--border-color);
  box-shadow: var(--shadow-sm);
  width: var(--aside-width);
  /* overflow-y est géré par la directive */
  z-index: 1000;
  box-sizing: border-box;
}

.aside__content {
  padding-top: var(--spacing-xl);
  padding-right: var(--spacing-sm);
  padding-bottom: var(--spacing-sm);
  padding-left: var(--spacing-md);
}

/* Style global pour les sections dans l'aside */
:deep(.aside__section) {
  margin-bottom: var(--spacing-lg);
}
</style> 