<template>
  <DetailViewContainer>
    <!-- Informations principales -->
    <DetailSection
      :sections="mainSections"
    />

    <!-- Informations géographiques -->
    <DetailSection
      :sections="geoSections"
    />

    <!-- Victimes et impact -->
    <CollapsibleSection
      title="Victimes et Impact"
      :expanded="victimsExpanded"
      @toggle="toggleVictims"
    >
      <div v-if="data.victimes" class="victims-info">
        <div v-for="(value, key) in data.victimes" :key="key" class="victim-stat">
          <span class="stat-label">{{ formatVictimLabel(key) }}:</span>
          <span class="stat-value">{{ formatVictimValue(value) }}</span>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune information sur les victimes disponible.
      </div>
    </CollapsibleSection>

    <!-- Pays impliqués -->
    <EntitySection
      title="Pays Impliqués"
      :items="data.paysImpliques"
      :expanded="countriesExpanded"
      :config="countriesConfig"
      no-data-message="Aucun pays impliqué répertorié."
      @toggle="toggleCountries"
    />

    <!-- Timeline -->
    <CollapsibleSection
      title="Chronologie"
      :expanded="timelineExpanded"
      @toggle="toggleTimeline"
    >
      <div v-if="data.timeline && data.timeline.length > 0" class="timeline">
        <div v-for="event in data.timeline" :key="event.id" class="timeline-event">
          <div class="event-date">{{ formatDate(event.date) }}</div>
          <div class="event-title">{{ event.titre }}</div>
          <div v-if="event.description" class="event-description">{{ event.description }}</div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune chronologie disponible.
      </div>
    </CollapsibleSection>

    <!-- Efforts de paix -->
    <CollapsibleSection
      title="Efforts de Paix"
      :expanded="peaceExpanded"
      @toggle="togglePeace"
    >
      <div v-if="data.effortsPaix" class="peace-efforts">
        <div v-for="effort in data.effortsPaix" :key="effort.id" class="peace-effort">
          <div class="effort-type">{{ effort.type }}</div>
          <div class="effort-description">{{ effort.description }}</div>
          <div v-if="effort.date" class="effort-date">{{ formatDate(effort.date) }}</div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucun effort de paix documenté.
      </div>
    </CollapsibleSection>

    <!-- Conséquences -->
    <CollapsibleSection
      title="Conséquences"
      :expanded="consequencesExpanded"
      @toggle="toggleConsequences"
    >
      <div v-if="data.consequences" class="consequences">
        <div v-for="consequence in data.consequences" :key="consequence.type" class="consequence-item">
          <div class="consequence-type">{{ consequence.type }}</div>
          <div class="consequence-description">{{ consequence.description }}</div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune conséquence documentée.
      </div>
    </CollapsibleSection>
  </DetailViewContainer>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import DetailSection from '@/components/aside/DetailSection.vue'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'
import EntitySection from '@/components/common/EntitySection.vue'
import DetailViewContainer from '@/components/panels/DetailViewContainer.vue'
import { formatDate } from '@/utils/formatUtils'
import type { ConflictDetailData } from '@/types/conflict'

const props = defineProps<{
  data: ConflictDetailData
}>()

// États des sections collapsibles
const victimsExpanded = ref(false)
const countriesExpanded = ref(true)
const timelineExpanded = ref(false)
const peaceExpanded = ref(false)
const consequencesExpanded = ref(false)

// Configuration pour les pays impliqués
const countriesConfig = {
  titleField: 'nom',
  subtitleField: 'role',
  iconField: 'flag',
  metadataFields: [
    {
      key: 'dateEntree',
      label: 'Impliqué depuis',
      field: 'dateEntree',
      formatter: (date: string) => formatDate(date)
    }
  ]
}

// Computed pour les sections principales
const mainSections = computed(() => [
  { title: 'Type de conflit', value: props.data.type || 'Non spécifié' },
  { title: 'Statut', value: formatStatus(props.data.statut) },
  { title: 'Intensité', value: props.data.intensite || 'Non spécifiée' },
  { title: 'Période', value: formatPeriod(props.data.dateDebut, props.data.dateFin) }
].filter(section => section.value && section.value !== 'Non spécifié'))

// Computed pour les sections géographiques
const geoSections = computed(() => [
  { title: 'Localisation', value: props.data.localisation || 'Non spécifiée' },
  { title: 'Zones affectées', value: formatZones(props.data.zones) }
].filter(section => section.value && section.value !== 'Non spécifiée'))

// Fonctions de toggle
const toggleVictims = () => { victimsExpanded.value = !victimsExpanded.value }
const toggleCountries = () => { countriesExpanded.value = !countriesExpanded.value }
const toggleTimeline = () => { timelineExpanded.value = !timelineExpanded.value }
const togglePeace = () => { peaceExpanded.value = !peaceExpanded.value }
const toggleConsequences = () => { consequencesExpanded.value = !consequencesExpanded.value }

// Fonctions de formatage
const formatStatus = (status?: string) => {
  if (!status) return 'Non spécifié'
  const statusMap: Record<string, string> = {
    'active': '🔴 Actif',
    'inactive': '🟡 Inactif',
    'resolved': '🟢 Résolu',
    'frozen': '🔵 Gelé'
  }
  return statusMap[status.toLowerCase()] || status
}

const formatPeriod = (startDate?: string, endDate?: string) => {
  if (!startDate) return 'Période inconnue'
  const start = formatDate(startDate)
  if (!endDate) return `Depuis ${start}`
  return `${start} - ${formatDate(endDate)}`
}

const formatZones = (zones?: string[]) => {
  if (!zones || zones.length === 0) return 'Non spécifiée'
  return zones.join(', ')
}

const formatVictimLabel = (key: string) => {
  const labelMap: Record<string, string> = {
    'morts': 'Décès',
    'blesses': 'Blessés',
    'deplaces': 'Déplacés',
    'refugies': 'Réfugiés',
    'disparus': 'Disparus'
  }
  return labelMap[key] || key
}

const formatVictimValue = (value: any) => {
  if (typeof value === 'number') {
    return value.toLocaleString('fr-FR')
  }
  return value
}
</script>

<style scoped>
/* Container maintenant géré par DetailViewContainer */

.victims-info {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.victim-stat {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-xs) var(--spacing-sm);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
}

.stat-label {
  font-weight: var(--font-weight-medium);
  color: var(--text-dark);
}

.stat-value {
  font-weight: var(--font-weight-bold);
  color: var(--text-muted);
}

/* Styles pour les pays supprimés - maintenant gérés par EntitySection */

.timeline {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.timeline-event {
  border-left: 3px solid var(--primary-color);
  padding-left: var(--spacing-sm);
  margin-left: var(--spacing-xs);
}

.event-date {
  font-size: var(--font-size-xs);
  color: var(--text-muted);
  font-weight: var(--font-weight-medium);
}

.event-title {
  font-weight: var(--font-weight-medium);
  margin-top: var(--spacing-xs);
}

.event-description {
  font-size: var(--font-size-sm);
  color: var(--text-muted);
  margin-top: var(--spacing-xs);
}

.peace-efforts, .consequences {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.peace-effort, .consequence-item {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
}

.effort-type, .consequence-type {
  font-weight: var(--font-weight-medium);
  color: var(--primary-color);
}

.effort-description, .consequence-description {
  margin-top: var(--spacing-xs);
  color: var(--text-dark);
}

.effort-date {
  font-size: var(--font-size-xs);
  color: var(--text-muted);
  margin-top: var(--spacing-xs);
  font-style: italic;
}

.no-data {
  padding: var(--spacing-sm);
  color: var(--text-muted);
  font-style: italic;
  text-align: center;
}
</style>