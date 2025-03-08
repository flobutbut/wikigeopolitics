<template>
  <div class="aside__section">
    <ReturnButton v-if="currentView.hasReturnButton" @click="returnToMainView" />
    
    <SectionTitle>{{ currentView.title }}</SectionTitle>
    
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
import MenuItem from '@components/common/MenuItem.vue'
import { useAsideStore } from '@/stores/asideStore'
import SectionTitle from '@/components/common/SectionTitle.vue'
import ReturnButton from '@/components/navigation/ReturnButton.vue'

export default defineComponent({
  name: 'AsideSubmenuView',
  
  components: {
    MenuItem,
    SectionTitle,
    ReturnButton
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
  padding-left: var(--spacing-md);
  padding-right: 0;
}

.aside__menu {
  list-style: none;
  padding: 0;
  margin: 0;
}

/* Styles pour la liste des organisations */
.organizations-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: var(--spacing-xs);
  padding: 0;
}

.organization-item {
  padding: var(--spacing-xs);
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