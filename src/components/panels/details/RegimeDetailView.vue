<template>
  <div class="regime-detail-view">
    <!-- Informations principales -->
    <DetailSection
      :sections="[
        { title: 'Type de régime', value: data.type || 'Non spécifié' },
        { title: 'Classification', value: data.classification || 'Non spécifiée' },
        { title: 'Système électoral', value: data.systemeElectoral || 'Non spécifié' }
      ]"
    />

    <!-- Description -->
    <CollapsibleSection
      title="Description"
      :expanded="descriptionExpanded"
      @toggle="toggleDescription"
    >
      <div class="description-content">
        {{ data.description || 'Aucune description disponible.' }}
      </div>
    </CollapsibleSection>

    <!-- Caractéristiques -->
    <CollapsibleSection
      title="Caractéristiques"
      :expanded="characteristicsExpanded"
      @toggle="toggleCharacteristics"
    >
      <div v-if="data.characteristics && data.characteristics.length > 0" class="characteristics-list">
        <div v-for="(characteristic, index) in data.characteristics" :key="index" class="characteristic-item">
          <span class="characteristic-bullet">•</span>
          <span class="characteristic-text">{{ characteristic }}</span>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune caractéristique spécifiée.
      </div>
    </CollapsibleSection>

    <!-- Pays avec ce régime -->
    <EntitySection
      title="Pays avec ce régime"
      :items="data.countries"
      :expanded="countriesExpanded"
      :config="countriesConfig"
      no-data-message="Aucun pays répertorié avec ce régime."
      @toggle="toggleCountries"
    />

    <!-- Avantages et inconvénients -->
    <CollapsibleSection
      title="Avantages et Inconvénients"
      :expanded="prosConsExpanded"
      @toggle="toggleProsCons"
    >
      <div v-if="data.avantages || data.inconvenients" class="pros-cons">
        <div v-if="data.avantages && data.avantages.length > 0" class="pros-section">
          <h4 class="section-title pros-title">✅ Avantages</h4>
          <ul class="pros-list">
            <li v-for="(advantage, index) in data.avantages" :key="index" class="pros-item">
              {{ advantage }}
            </li>
          </ul>
        </div>
        
        <div v-if="data.inconvenients && data.inconvenients.length > 0" class="cons-section">
          <h4 class="section-title cons-title">❌ Inconvénients</h4>
          <ul class="cons-list">
            <li v-for="(disadvantage, index) in data.inconvenients" :key="index" class="cons-item">
              {{ disadvantage }}
            </li>
          </ul>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune analyse avantages/inconvénients disponible.
      </div>
    </CollapsibleSection>

    <!-- Évolution historique -->
    <CollapsibleSection
      title="Évolution Historique"
      :expanded="historyExpanded"
      @toggle="toggleHistory"
    >
      <div v-if="data.evolutionHistorique" class="history-content">
        {{ data.evolutionHistorique }}
      </div>
      <div v-else class="no-data">
        Aucune information historique disponible.
      </div>
    </CollapsibleSection>

    <!-- Exemples notables -->
    <CollapsibleSection
      title="Exemples Notables"
      :expanded="examplesExpanded"
      @toggle="toggleExamples"
    >
      <div v-if="data.exemplesNotables && data.exemplesNotables.length > 0" class="examples-list">
        <div v-for="example in data.exemplesNotables" :key="example.id" class="example-item">
          <div class="example-country">
            <span v-if="example.flag">{{ example.flag }}</span>
            {{ example.nom }}
          </div>
          <div v-if="example.periode" class="example-period">{{ example.periode }}</div>
          <div v-if="example.description" class="example-description">{{ example.description }}</div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucun exemple notable répertorié.
      </div>
    </CollapsibleSection>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import DetailSection from '@/components/aside/DetailSection.vue'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'
import EntitySection from '@/components/common/EntitySection.vue'
import DetailViewContainer from '@/components/panels/DetailViewContainer.vue'
import { formatDate } from '@/utils/formatUtils'

interface RegimeData {
  id: string
  title: string
  type?: string
  classification?: string
  systemeElectoral?: string
  description?: string
  characteristics?: string[]
  countries?: Array<{
    id: string
    nom: string
    flag?: string
    chefEtat?: string
    datePrisePoste?: string
  }>
  avantages?: string[]
  inconvenients?: string[]
  evolutionHistorique?: string
  exemplesNotables?: Array<{
    id: string
    nom: string
    flag?: string
    periode?: string
    description?: string
  }>
}

const props = defineProps<{
  data: RegimeData
}>()

// États des sections collapsibles
const descriptionExpanded = ref(true)
const characteristicsExpanded = ref(true)
const countriesExpanded = ref(true)
const prosConsExpanded = ref(false)
const historyExpanded = ref(false)
const examplesExpanded = ref(false)

// Configuration pour les pays
const countriesConfig = computed(() => ({
  titleField: 'nom',
  iconField: 'flag',
  metadataFields: [
    {
      key: 'chefEtat',
      label: getLeaderTitle(props.data.type),
      field: 'chefEtat'
    },
    {
      key: 'datePrisePoste',
      label: 'En poste depuis',
      field: 'datePrisePoste',
      formatter: (date: string) => formatDate(date)
    }
  ].filter(field => field.field)
}))

// Fonctions de toggle
const toggleDescription = () => { descriptionExpanded.value = !descriptionExpanded.value }
const toggleCharacteristics = () => { characteristicsExpanded.value = !characteristicsExpanded.value }
const toggleCountries = () => { countriesExpanded.value = !countriesExpanded.value }
const toggleProsCons = () => { prosConsExpanded.value = !prosConsExpanded.value }
const toggleHistory = () => { historyExpanded.value = !historyExpanded.value }
const toggleExamples = () => { examplesExpanded.value = !examplesExpanded.value }

// Fonction pour obtenir le titre du dirigeant selon le régime
const getLeaderTitle = (regimeType?: string) => {
  if (!regimeType) return 'Dirigeant'
  
  const type = regimeType.toLowerCase()
  if (type.includes('république')) return 'Président'
  if (type.includes('monarchie')) return 'Monarque'
  if (type.includes('dictature') || type.includes('autoritaire')) return 'Dirigeant'
  if (type.includes('théocratie')) return 'Guide spirituel'
  if (type.includes('démocratie')) return 'Président/Premier ministre'
  
  return 'Chef d\'État'
}
</script>

<style scoped>
/* Container maintenant géré par DetailViewContainer */

.description-content {
  line-height: 1.6;
  color: var(--text-dark);
}

.characteristics-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.characteristic-item {
  display: flex;
  align-items: flex-start;
  gap: var(--spacing-sm);
  padding: var(--spacing-xs) 0;
}

.characteristic-bullet {
  color: var(--primary-color);
  font-weight: var(--font-weight-bold);
  margin-top: 2px;
}

.characteristic-text {
  flex: 1;
  line-height: 1.5;
}

.countries-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.country-item {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
  transition: background-color var(--transition-speed) var(--transition-function);
}

.country-item:hover {
  background-color: var(--surface-hover);
}

.country-info {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
  font-weight: var(--font-weight-medium);
}

.country-flag {
  font-size: var(--font-size-md);
}

.country-leader {
  margin-top: var(--spacing-xs);
  font-size: var(--font-size-sm);
}

.leader-title {
  color: var(--text-muted);
  margin-right: var(--spacing-xs);
}

.leader-name {
  font-weight: var(--font-weight-medium);
  color: var(--text-dark);
}

.country-since {
  margin-top: var(--spacing-xs);
  font-size: var(--font-size-xs);
  color: var(--text-muted);
  font-style: italic;
}

.pros-cons {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-md);
}

.pros-section, .cons-section {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
}

.section-title {
  margin: 0 0 var(--spacing-sm) 0;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
}

.pros-title {
  color: var(--success-color, #22c55e);
}

.cons-title {
  color: var(--error-color, #ef4444);
}

.pros-list, .cons-list {
  margin: 0;
  padding-left: var(--spacing-md);
}

.pros-item, .cons-item {
  margin-bottom: var(--spacing-xs);
  line-height: 1.5;
}

.history-content {
  line-height: 1.6;
  color: var(--text-dark);
}

.examples-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.example-item {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
  border-left: 3px solid var(--primary-color);
}

.example-country {
  font-weight: var(--font-weight-medium);
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
}

.example-period {
  font-size: var(--font-size-sm);
  color: var(--text-muted);
  margin-top: var(--spacing-xs);
  font-style: italic;
}

.example-description {
  margin-top: var(--spacing-xs);
  line-height: 1.5;
  color: var(--text-dark);
}

.no-data {
  padding: var(--spacing-sm);
  color: var(--text-muted);
  font-style: italic;
  text-align: center;
}
</style>