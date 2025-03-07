<template>
  <div class="aside__section">
    <div v-if="currentView.hasReturnButton" class="return-button" @click="returnToMainView">
      <span class="return-icon">←</span> Retour
    </div>
    
    <h2 class="aside__section-title">{{ currentView.title }}</h2>
    
    <ul class="aside__menu">
      <MenuItem
        v-for="item in filteredItems"
        :key="item.id"
        :title="item.title"
        @click="navigateToDetail(item.id)"
      />
    </ul>
    
    <!-- Affichage spécial pour les organisations (comme dans accords-de-libre-echanges) -->
    <div v-if="currentView.organizations" class="organizations-list">
      <div 
        v-for="org in filteredOrganizations" 
        :key="org.id"
        class="organization-item"
        @click="selectOrganization(org.id)"
      >
        {{ org.title }}
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import MenuItem from '@components/menu-item/menu-item.vue'
import { useAsideStore } from '@/stores/asideStore'

export default defineComponent({
  name: 'AsideSubmenuView',
  
  components: {
    MenuItem
  },
  
  setup() {
    const asideStore = useAsideStore()
    
    // Retour à la vue principale
    const returnToMainView = () => {
      asideStore.returnToMainView()
    }
    
    // Navigation vers un détail
    const navigateToDetail = (id: string) => {
      asideStore.navigateToDetail(id)
    }
    
    // Sélection d'une organisation
    const selectOrganization = (id: string) => {
      asideStore.selectOrganization(id)
    }
    
    return {
      currentView: computed(() => asideStore.currentView),
      filteredItems: computed(() => asideStore.filteredItems),
      filteredOrganizations: computed(() => asideStore.filteredOrganizations),
      returnToMainView,
      navigateToDetail,
      selectOrganization
    }
  }
})
</script>

<style scoped>
.aside__section {
  margin-bottom: var(--spacing-lg);
  padding-left: var(--spacing-sm);
  padding-right: var(--spacing-sm);
}

.aside__section-title {
  font-size: var(--font-size-sm);
  color: var(--text-dark);
  margin-bottom: var(--spacing-sm);
  padding-left: var(--spacing-sm);
}

.aside__menu {
  list-style: none;
  padding: 0;
  margin: 0;
}

.return-button {
  display: flex;
  align-items: center;
  padding: var(--spacing-xs) var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
  color: var(--primary-color);
  cursor: pointer;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
}

.return-icon {
  margin-right: var(--spacing-xs);
}

/* Styles pour la liste des organisations */
.organizations-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: var(--spacing-xs);
  padding: var(--spacing-xs);
}

.organization-item {
  padding: var(--spacing-xs) var(--spacing-sm);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-xs);
  text-align: center;
  cursor: pointer;
  transition: background-color var(--transition-speed) var(--transition-function);
}

.organization-item:hover {
  background-color: var(--surface-hover);
}
</style> 