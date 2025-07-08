<template>
  <div v-if="selectedCountry && selectedCountry.title" class="floating-detail-panel">
    <div class="panel-header">
      <div class="header-content">
        <div class="country-info">
          <img 
            v-if="selectedCountry.drapeau" 
            :src="selectedCountry.drapeau" 
            :alt="`Drapeau de ${selectedCountry.title}`"
            class="country-flag"
          />
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
          <!-- Bloc principal : Forme de l'État + Chef d'État -->
          <div class="main-block">
            <DetailSection
              title="Forme de l'État"
              :value="selectedCountry.regimePolitique || 'Data'"
            />
            <DetailSection
              :title="chefEtatLabel"
              :value="selectedCountry.chefEtat || 'Data'"
              v-if="chefEtatLabel"
            />
          </div>

          <!-- Bloc indicateurs économiques -->
          <div class="eco-block">
            <DetailSection
              title="PIB"
              :value="displayValue(selectedCountry.pib, formatCurrency)"
            />
            <DetailSection
              title="Population"
              :value="displayValue(selectedCountry.population, formatNumber)"
            />
            <DetailSection
              title="Revenus médiants"
              :value="displayValue(selectedCountry.revenuMedian, formatCurrency)"
            />
            <DetailSection
              title="Superficie"
              :value="displayValue(selectedCountry.superficieKm2, formatArea)"
            />
          </div>

          <!-- Bloc Histoire (CollapsibleSection) -->
          <CollapsibleSection
            title="Histoire"
            :expanded="true"
            :content="selectedCountry.histoire || 'Aucune information historique disponible.'"
          />

          <!-- Bloc Coalitions diplomatiques (CollapsibleSection) -->
          <CollapsibleSection
            title="Coalitions diplomatiques"
            :expanded="true"
          >
            <div class="coalitions-list">
              <div v-for="coalition in selectedCountry.coalitions" :key="coalition.id" class="coalition-item">
                {{ coalition.title }}
              </div>
            </div>
          </CollapsibleSection>
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
import DetailSection from '@/components/aside/DetailSection.vue'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'
import SectionTitle from '@/components/common/SectionTitle.vue'
import TabNavigation from '@/components/common/TabNavigation.vue'
import NewsView from '@/components/panels/NewsView.vue'

export default defineComponent({
  name: 'FloatingDetailPanel',
  
  components: {
    DetailSection,
    CollapsibleSection,
    SectionTitle,
    TabNavigation,
    NewsView
  },
  
  setup() {
    const asideStore = useAsideStore()
    
    const selectedCountry = computed(() => asideStore.currentDetailData)

    // Label dynamique pour le chef d'État
    const chefEtatLabel = computed(() => {
      const regime = selectedCountry.value.regimePolitique?.toLowerCase() || ''
      if (regime.includes('république')) return 'Président de la République'
      if (regime.includes('monarchie')) return 'Monarque'
      if (regime.includes('fédération')) return 'Chef d\'État'
      if (regime) return 'Chef d\'État'
      return ''
    })

    // Fonctions utilitaires pour le formatage
    const formatCurrency = (value: number) => {
      if (value === undefined || value === null) return ''
      if (value >= 1e12) {
        return `${(value / 1e12).toFixed(1)} T€`
      } else if (value >= 1e9) {
        return `${(value / 1e9).toFixed(1)} milliards d'euros`
      } else if (value >= 1e6) {
        return `${(value / 1e6).toFixed(1)} M€`
      } else {
        return `${value.toLocaleString()} €`
      }
    }
    const formatNumber = (value: number) => (value === undefined || value === null) ? '' : value.toLocaleString()
    const formatArea = (value: number) => (value === undefined || value === null) ? '' : `${value.toLocaleString()} km²`

    // Affiche la valeur formatée ou "Data" si absente
    const displayValue = (val: any, formatter: (v: any) => string) => {
      return (val !== undefined && val !== null) ? formatter(val) : 'Data'
    }

    const handleTabChange = (tabId: string) => {}
    const toggleSection = (sectionId: string, expanded: boolean) => {}
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
        histoire: '',
        indiceSouverainete: undefined,
        indiceDependance: undefined,
        statutStrategique: '',
        dateCreation: '',
        dateDerniereMiseAJour: '',
        chefEtat: '',
        definition: '',
        definitionSource: '',
        definitionSourceUrl: '',
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
      chefEtatLabel,
      formatCurrency,
      formatNumber,
      formatArea,
      displayValue,
      handleTabChange,
      toggleSection,
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
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-md);
  border-bottom: 1px solid var(--border-color);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-md) var(--radius-md) 0 0;
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
  width: 24px;
  height: 16px;
  border-radius: var(--radius-xs);
  object-fit: cover;
  border: 1px solid var(--border-color);
}

.panel-header h3 {
  margin: 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
}

.close-button {
  background: none;
  border: none;
  font-size: 24px;
  color: var(--text-muted);
  cursor: pointer;
  padding: 0;
  width: 24px;
  height: 24px;
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
}

.main-block, .eco-block {
  background: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
}

.coalitions-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.coalition-item {
  padding: var(--spacing-xs);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.coalition-item:hover {
  background-color: var(--surface-hover);
}
</style> 