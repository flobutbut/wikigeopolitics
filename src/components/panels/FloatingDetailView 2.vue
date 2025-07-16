<template>
  <div class="aside__detail-view">
    <div class="aside__section">
      <div class="detail-content">


        <!-- Bloc principal : Forme de l'État + Chef d'État -->
        <DetailSection
          :sections="[
            { title: 'Forme de l\'État', value: detailData.regimePolitique || 'Data' },
            { title: chefEtatLabel, value: chefEtatInfo },
            { title: 'Prise de poste', value: datePrisePosteInfo }
          ].filter(section => section.title)"
        />



        <!-- Bloc indicateurs économiques -->
        <DetailSection
          :sections="[
            { title: 'PIB', value: displayValue(detailData.pib, formatCurrency) },
            { title: 'Population', value: displayValue(detailData.population, formatNumber) },
            { title: 'Revenus médians', value: displayValue(detailData.revenuMedian, formatCurrency) },
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
              <div class="coalition-title">{{ coalition.title }}</div>
              <div v-if="coalition.role" class="coalition-role">{{ coalition.role }}</div>
              <div v-if="coalition.dateAdhesion" class="coalition-date">
                Adhésion: {{ formatDate(coalition.dateAdhesion) }}
              </div>
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
            <div v-for="accord in detailData.accords" :key="accord.id" class="trade-agreement-item">
              <div class="accord-title">{{ accord.title }}</div>
              <div v-if="accord.role" class="accord-role">{{ accord.role }}</div>
              <div v-if="accord.dateAdhesion" class="accord-date">
                Adhésion: {{ formatDate(accord.dateAdhesion) }}
              </div>
            </div>
            <div v-if="!detailData.accords || detailData.accords.length === 0" class="no-data">
              Aucun accord de libre-échange disponible.
            </div>
          </div>
        </CollapsibleSection>

        <!-- Conflits armés -->
        <CollapsibleSection
          title="Conflits armés"
          :expanded="conflictsExpanded"
          @toggle="toggleConflicts"
        >
          <div class="conflicts-list">
            <div 
              v-for="conflict in detailData.conflitsArmes" 
              :key="conflict.id" 
              class="conflict-item"
              :class="{ 'selected': isConflictSelected(conflict.id) }"
              @click="selectConflict(conflict.id)"
            >
              <div class="conflict-title">{{ conflict.name }}</div>
              <div v-if="conflict.status" class="conflict-status">{{ conflict.status }}</div>
              <div v-if="isConflictSelected(conflict.id)" class="selection-indicator">✓ Sélectionné</div>
              <div v-if="conflict.startDate" class="conflict-date">
                Début: {{ formatDate(conflict.startDate) }}
              </div>
              <div v-if="conflict.endDate" class="conflict-date">
                Fin: {{ formatDate(conflict.endDate) }}
              </div>
              <div v-if="conflict.description" class="conflict-description">
                {{ conflict.description }}
              </div>
            </div>
            <div v-if="!detailData.conflitsArmes || detailData.conflitsArmes.length === 0" class="no-data">
              Aucun conflit armé disponible.
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
import { useSelectionSystem } from '@/stores/selectionSystem'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'
import DetailSection from '@/components/aside/DetailSection.vue'

export default defineComponent({
  name: 'FloatingDetailView',
  
  components: {
    CollapsibleSection,
    DetailSection
  },
  
  setup() {
    const asideStore = useAsideStore()
    const selectionSystem = useSelectionSystem()
    const coalitionsExpanded = ref(true)
    const tradeAgreementsExpanded = ref(true)
    const historyExpanded = ref(true) // Added for history section
    const conflictsExpanded = ref(true) // Added for conflicts section
    
    // Label dynamique pour le chef d'État
    const chefEtatLabel = computed(() => {
      const regime = asideStore.currentDetailData.regimePolitique?.toLowerCase() || ''
      if (regime.includes('république')) return 'Président de la République'
      if (regime.includes('monarchie')) return 'Monarque'
      if (regime.includes('fédération')) return 'Chef d\'État'
      if (regime) return 'Chef d\'État'
      return ''
    })

    // Informations sur le chef d'État
    const chefEtatInfo = computed(() => {
      const chefEtat = asideStore.currentDetailData.chefEtat
      return chefEtat || 'Data'
    })

    // Informations sur la date de prise de poste
    const datePrisePosteInfo = computed(() => {
      const datePrisePoste = asideStore.currentDetailData.datePrisePoste
      
      if (!datePrisePoste) return 'Data'
      
      const date = new Date(datePrisePoste)
      return date.toLocaleDateString('fr-FR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      })
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

    // Formater une date en français
    const formatDate = (dateString: string) => {
      if (!dateString) return ''
      const date = new Date(dateString)
      return date.toLocaleDateString('fr-FR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      })
    }
    
    // Toggle pour les sections collapsibles
    const toggleSection = (sectionId: string, expanded: boolean) => {
      switch (sectionId) {
        case 'coalitions':
          coalitionsExpanded.value = expanded
          break
        case 'trade-agreements':
          tradeAgreementsExpanded.value = expanded
          break
        case 'history':
          historyExpanded.value = expanded
          break
        case 'conflicts':
          conflictsExpanded.value = expanded
          break
        default:
          console.log('Section inconnue:', sectionId)
      }
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

    // Toggle pour les conflits armés
    const toggleConflicts = () => {
      conflictsExpanded.value = !conflictsExpanded.value
    }

    // Vérifier si un conflit est sélectionné
    const isConflictSelected = (conflictId: string) => {
      return selectionSystem.isConflictSelected(conflictId)
    }

    // Sélectionner un conflit
    const selectConflict = async (conflictId: string) => {
      console.log('🔥 Sélection conflit depuis fiche pays:', conflictId)
      await selectionSystem.selectConflict(conflictId, 'panel')
    }
    
    return {
      detailData: computed(() => {
        // Utiliser les données de l'asideStore (qui reste responsable du chargement des données)
        return asideStore.currentDetailData
      }),
      coalitionsExpanded,
      tradeAgreementsExpanded,
      historyExpanded, // Added to return
      conflictsExpanded, // Added for conflicts
      chefEtatLabel,
      chefEtatInfo,
      datePrisePosteInfo,
      formatCurrency,
      formatNumber,
      formatArea,
      formatDate,
      displayValue,
      toggleSection,
      toggleCoalitions,
      toggleTradeAgreements,
      toggleHistory, // Added to return
      toggleConflicts, // Added for conflicts
      isConflictSelected, // Added for conflict selection status
      selectConflict // Added for conflict selection
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
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-sm);
  margin-bottom: var(--spacing-xs);
  transition: background-color var(--transition-speed) var(--transition-function);
}

.coalition-item:hover {
  background-color: var(--surface-hover);
}

.coalition-title {
  font-weight: var(--font-weight-medium);
}

.coalition-role {
  font-size: var(--font-size-xs);
  line-height: var(--line-height-xs);
  color: var(--text-muted);
}

.coalition-date {
  font-size: var(--font-size-xs);
  line-height: var(--line-height-xs);
  color: var(--text-muted);
  font-style: italic;
}

.trade-agreements-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.trade-agreement-item {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-sm);
  margin-bottom: var(--spacing-xs);
  transition: background-color var(--transition-speed) var(--transition-function);
}

.trade-agreement-item:hover {
  background-color: var(--surface-hover);
}

.accord-title {
  font-weight: var(--font-weight-medium);
}

.accord-role {
  font-size: var(--font-size-xs);
  line-height: var(--line-height-xs);
  color: var(--text-muted);
}

.accord-date {
  font-size: var(--font-size-xs);
  line-height: var(--line-height-xs);
  color: var(--text-muted);
  font-style: italic;
}

.no-data {
  padding: var(--spacing-sm);
  color: var(--text-muted);
  font-style: italic;
  text-align: center;
}

/* Styles pour les conflits armés */
.conflicts-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.conflict-item {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-sm);
  margin-bottom: var(--spacing-xs);
  transition: all var(--transition-speed) var(--transition-function);
  cursor: pointer;
  border-left: 3px solid #ff4444;
  padding: var(--spacing-sm);
}

.conflict-item:hover {
  background-color: var(--surface-hover);
  transform: translateX(2px);
}

.conflict-item.selected {
  background-color: rgba(255, 68, 68, 0.1);
  border-left: 3px solid #ff4444;
  box-shadow: 0 2px 8px rgba(255, 68, 68, 0.2);
}

.conflict-title {
  font-weight: var(--font-weight-medium);
  color: #d32f2f;
}

.conflict-status {
  font-size: var(--font-size-xs);
  line-height: var(--line-height-xs);
  color: var(--text-muted);
  font-weight: var(--font-weight-medium);
  text-transform: uppercase;
}

.conflict-date {
  font-size: var(--font-size-xs);
  line-height: var(--line-height-xs);
  color: var(--text-muted);
  font-style: italic;
}

.conflict-description {
  font-size: var(--font-size-xs);
  line-height: var(--line-height-xs);
  color: var(--text-muted);
  margin-top: var(--spacing-xs);
}

.selection-indicator {
  font-size: var(--font-size-xs);
  color: #22c55e;
  font-weight: var(--font-weight-medium);
  margin-top: var(--spacing-xs);
}
</style> 