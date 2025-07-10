<template>
  <div class="aside__detail-view">
    <div class="aside__section">
      <div class="detail-content">
        <!-- Bloc principal : Forme de l'État + Chef d'État -->
        <DetailSection
          :sections="[
            { title: 'Forme de l\'État', value: detailData.regimePolitique || 'Data' },
            { title: chefEtatLabel, value: detailData.chefEtat || 'Data' }
          ].filter(section => section.title)"
        />

        <!-- Bloc indicateurs économiques -->
        <DetailSection
          :sections="[
            { title: 'PIB', value: displayValue(detailData.pib, formatCurrency) },
            { title: 'Population', value: displayValue(detailData.population, formatNumber) },
            { title: 'Revenus médiants', value: displayValue(detailData.revenuMedian, formatCurrency) },
            { title: 'Superficie', value: displayValue(detailData.superficieKm2, formatArea) }
          ]"
        />

        <!-- Bloc Histoire -->
        <CollapsibleSection
          title="Histoire"
          :expanded="historyExpanded"
          @toggle="toggleHistory"
        >
          {{ detailData.histoire || 'Aucune information historique disponible.' }}
        </CollapsibleSection>

        <!-- Coalitions diplomatiques -->
        <CollapsibleSection
          title="Coalitions diplomatiques"
          :expanded="coalitionsExpanded"
          @toggle="toggleCoalitions"
        >
          <div class="coalitions-list">
            <div v-for="coalition in detailData.coalitions" :key="coalition.id" class="coalition-item">
              {{ coalition.title }}
            </div>
            <div v-if="!detailData.coalitions || detailData.coalitions.length === 0" class="no-data">
              Aucune coalition diplomatique disponible.
            </div>
          </div>
        </CollapsibleSection>

        <!-- Accords de libre-échange -->
        <CollapsibleSection
          title="Accords de libre-échange"
          :expanded="tradeAgreementsExpanded"
          @toggle="toggleTradeAgreements"
        >
          <div class="trade-agreements-list">
            <div v-if="detailData.tradeAgreements && detailData.tradeAgreements.length > 0">
              <div v-for="agreement in detailData.tradeAgreements" :key="agreement.id" class="trade-agreement-item">
                {{ agreement.title }}
              </div>
            </div>
            <div v-else class="no-data">
              Aucun accord de libre-échange disponible.
            </div>
          </div>
        </CollapsibleSection>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, ref } from 'vue'
import { useAsideStore } from '@/stores/asideStore'
import CollapsibleSection from './CollapsibleSection.vue'
import DetailSection from './DetailSection.vue'

export default defineComponent({
  name: 'AsideDetailView',
  
  components: {
    CollapsibleSection,
    DetailSection
  },
  
  setup() {
    const asideStore = useAsideStore()
    const coalitionsExpanded = ref(true)
    const tradeAgreementsExpanded = ref(true)
    const historyExpanded = ref(true) // Added for history section
    
    // Label dynamique pour le chef d'État
    const chefEtatLabel = computed(() => {
      const regime = asideStore.currentDetailData.regimePolitique?.toLowerCase() || ''
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
    
    // Toggle pour les sections collapsibles
    const toggleSection = (sectionId: string, expanded: boolean) => {
      // TODO: Implémenter la logique de toggle si nécessaire
      console.log('Toggle section:', sectionId, expanded)
    }
    
    // Toggle pour les coalitions
    const toggleCoalitions = () => {
      coalitionsExpanded.value = !coalitionsExpanded.value
    }
    
    // Toggle pour les accords de libre-échange
    const toggleTradeAgreements = () => {
      tradeAgreementsExpanded.value = !tradeAgreementsExpanded.value
    }

    // Toggle pour l'histoire
    const toggleHistory = () => {
      historyExpanded.value = !historyExpanded.value
    }
    
    return {
      detailData: computed(() => asideStore.currentDetailData),
      coalitionsExpanded,
      tradeAgreementsExpanded,
      historyExpanded, // Added to return
      chefEtatLabel,
      formatCurrency,
      formatNumber,
      formatArea,
      displayValue,
      toggleSection,
      toggleCoalitions,
      toggleTradeAgreements,
      toggleHistory // Added to return
    }
  }
})
</script>

<style scoped>
.aside__detail-view {
  /* Supprimer les paddings spécifiques */
}

.detail-content {
  padding: 0;
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
  transition: background-color var(--transition-speed) var(--transition-function);
}

.coalition-item:hover {
  background-color: var(--surface-hover);
}

.trade-agreements-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.trade-agreement-item {
  padding: var(--spacing-xs);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  cursor: pointer;
  transition: background-color var(--transition-speed) var(--transition-function);
}

.trade-agreement-item:hover {
  background-color: var(--surface-hover);
}

.no-data {
  padding: var(--spacing-sm);
  color: var(--text-muted);
  font-style: italic;
  text-align: center;
}
</style> 