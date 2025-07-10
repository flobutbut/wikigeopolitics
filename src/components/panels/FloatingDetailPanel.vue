<template>
  <div v-if="selectedCountry && selectedCountry.title" class="floating-detail-panel">
    <div class="panel-header">
      <div class="header-content">
        <div class="country-info">
          <span 
            v-if="selectedCountry.drapeau" 
            class="country-flag"
            :title="`Drapeau de ${selectedCountry.title}`"
          >
            {{ selectedCountry.drapeau }}
          </span>
          <h3>{{ selectedCountry.title }}</h3>
        </div>
      </div>
      <button @click="closePanel" class="close-button">×</button>
    </div>
    
    <TabNavigation 
      :tabs="tabs" 
      :default-tab="'details'"
      @tab-change="handleTabChange"
    >
      <template #default="{ activeTab }">
        <div v-if="activeTab === 'details'" class="details-view">
          <!-- Utilisation d'AsideDetailView pour afficher les détails -->
          <AsideDetailView />
        </div>
        
        <!-- Vue Actualités -->
        <NewsView 
          v-if="activeTab === 'news'" 
          :country-id="selectedCountry.id"
        />
      </template>
    </TabNavigation>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useAsideStore } from '@/stores/asideStore'
import AsideDetailView from '@/components/aside/AsideDetailView.vue'
import TabNavigation from '@/components/common/TabNavigation.vue'
import NewsView from '@/components/panels/NewsView.vue'

export default defineComponent({
  name: 'FloatingDetailPanel',
  
  components: {
    AsideDetailView,
    TabNavigation,
    NewsView
  },
  
  setup() {
    const asideStore = useAsideStore()
    
    const selectedCountry = computed(() => asideStore.currentDetailData)

    const handleTabChange = (tabId: string) => {}
    
    const closePanel = () => {
      asideStore.currentDetailData = {
        id: '',
        title: '',
        drapeau: '',
        capitale: '',
        langue: '',
        monnaie: '',
        pib: undefined,
        population: undefined,
        revenuMedian: undefined,
        superficieKm2: undefined,
        regimePolitique: '',
        appartenanceGeographique: '',
        chefEtat: '',
        histoire: '',
        indiceSouverainete: undefined,
        indiceDependance: undefined,
        statutStrategique: '',
        dateCreation: '',
        dateDerniereMiseAJour: '',
        sections: [],
        collapsibleSections: [],
        coalitions: []
      }
    }
    
    const tabs = [
      { id: 'details', label: 'Détails' },
      { id: 'news', label: 'Actualités' }
    ]
    
    return {
      selectedCountry,
      handleTabChange,
      closePanel,
      tabs
    }
  }
})
</script>

<style scoped>
.floating-detail-panel {
  position: fixed;
  top: 80px;
  right: 20px;
  width: 350px;
  max-height: calc(100vh - 100px);
  background-color: var(--surface-color);
  border-radius: var(--radius-md);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  z-index: 9999;
  overflow-y: auto;
  border: 1px solid var(--border-color);
  display: flex;
  flex-direction: column;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-sm) var(--spacing-md) var(--spacing-sm) var(--spacing-md);
  border-bottom: 1px solid var(--border-color);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-md) var(--radius-md) 0 0;
  position: sticky;
  top: 0;
  z-index: 10;
  flex-shrink: 0;
}

.header-content {
  display: flex;
  align-items: center;
  flex: 1;
}

.country-info {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
}

.country-flag {
  font-size: var(--font-size-lg);

}

.panel-header h3 {
  margin: 0;
  font-size: var(--font-size-md);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
}

.close-button {
  background: none;
  border: none;
  font-size: 20px;
  color: var(--text-muted);
  cursor: pointer;
  padding: 0;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--radius-sm);
  transition: all 0.2s ease;
}

.close-button:hover {
  background-color: var(--surface-hover);
  color: var(--text-dark);
}

.details-view {
  padding: var(--spacing-md);
  flex: 1;
  overflow-y: auto;
}
</style> 