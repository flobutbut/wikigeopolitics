<template>
  <DetailViewContainer>
    <!-- Informations principales -->
    <DetailSection
      :sections="[
        { title: 'Type d\'organisation', value: data.type || 'Non spécifié' },
        { title: 'Statut', value: data.statut || 'Non spécifié' },
        { title: 'Domaine d\'action', value: data.domaineAction || 'Non spécifié' },
        { title: 'Créée en', value: formatDate(data.dateCreation) }
      ]"
    />

    <!-- Informations sur le siège -->
    <DetailSection
      :sections="[
        { title: 'Siège social', value: data.siege || 'Non spécifié' },
        { title: 'Adresse', value: data.adresse || 'Non spécifiée' }
      ].filter(section => section.value && section.value !== 'Non spécifiée')"
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

    <!-- Objectifs -->
    <CollapsibleSection
      title="Objectifs"
      :expanded="objectivesExpanded"
      @toggle="toggleObjectives"
    >
      <div v-if="data.objectifs && data.objectifs.length > 0" class="objectives-list">
        <div v-for="(objective, index) in data.objectifs" :key="index" class="objective-item">
          <span class="objective-bullet">•</span>
          <span class="objective-text">{{ objective }}</span>
        </div>
      </div>
      <div v-else class="no-data">
        Aucun objectif spécifié.
      </div>
    </CollapsibleSection>

    <!-- Pays membres -->
    <EntitySection
      title="Pays Membres"
      :items="data.paysMembres"
      :expanded="membersExpanded"
      :config="membersConfig"
      no-data-message="Aucun pays membre répertorié."
      @toggle="toggleMembers"
    />

    <!-- Structure et gouvernance -->
    <CollapsibleSection
      title="Structure et Gouvernance"
      :expanded="governanceExpanded"
      @toggle="toggleGovernance"
    >
      <div v-if="data.structure" class="governance-content">
        <div v-if="data.structure.organigramme" class="governance-section">
          <h4 class="section-title">Organigramme</h4>
          <div class="governance-text">{{ data.structure.organigramme }}</div>
        </div>
        
        <div v-if="data.structure.secretaireGeneral" class="governance-section">
          <h4 class="section-title">Direction</h4>
          <div class="leadership-info">
            <span class="leader-title">Secrétaire général:</span>
            <span class="leader-name">{{ data.structure.secretaireGeneral }}</span>
          </div>
          <div v-if="data.structure.mandatDebut" class="leader-mandate">
            En fonction depuis: {{ formatDate(data.structure.mandatDebut) }}
          </div>
        </div>

        <div v-if="data.structure.organesDecision && data.structure.organesDecision.length > 0" class="governance-section">
          <h4 class="section-title">Organes de décision</h4>
          <ul class="decision-organs-list">
            <li v-for="organ in data.structure.organesDecision" :key="organ" class="organ-item">
              {{ organ }}
            </li>
          </ul>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune information sur la structure disponible.
      </div>
    </CollapsibleSection>

    <!-- Activités et programmes -->
    <CollapsibleSection
      title="Activités et Programmes"
      :expanded="activitiesExpanded"
      @toggle="toggleActivities"
    >
      <div v-if="data.activites && data.activites.length > 0" class="activities-list">
        <div v-for="activity in data.activites" :key="activity.id" class="activity-item">
          <div class="activity-title">{{ activity.nom }}</div>
          <div v-if="activity.description" class="activity-description">{{ activity.description }}</div>
          <div v-if="activity.budget" class="activity-budget">
            Budget: {{ formatCurrency(activity.budget) }}
          </div>
          <div v-if="activity.statut" class="activity-status">{{ activity.statut }}</div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune activité documentée.
      </div>
    </CollapsibleSection>

    <!-- Financement -->
    <CollapsibleSection
      title="Financement"
      :expanded="financingExpanded"
      @toggle="toggleFinancing"
    >
      <div v-if="data.financement" class="financing-content">
        <div v-if="data.financement.budgetAnnuel" class="financing-section">
          <div class="budget-info">
            <span class="budget-label">Budget annuel:</span>
            <span class="budget-value">{{ formatCurrency(data.financement.budgetAnnuel) }}</span>
          </div>
        </div>
        
        <div v-if="data.financement.sources && data.financement.sources.length > 0" class="financing-section">
          <h4 class="section-title">Sources de financement</h4>
          <div class="funding-sources">
            <div v-for="source in data.financement.sources" :key="source.type" class="funding-source">
              <span class="source-type">{{ source.type }}:</span>
              <span class="source-amount">{{ formatPercentage(source.pourcentage) }}</span>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune information financière disponible.
      </div>
    </CollapsibleSection>
  </DetailViewContainer>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import DetailSection from '@/components/aside/DetailSection.vue'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'
import EntitySection from '@/components/common/EntitySection.vue'
import DetailViewContainer from '@/components/panels/DetailViewContainer.vue'
import { formatDate } from '@/utils/formatUtils'

interface OrganizationData {
  id: string
  title: string
  type?: string
  statut?: string
  domaineAction?: string
  dateCreation?: string
  siege?: string
  adresse?: string
  description?: string
  objectifs?: string[]
  paysMembres?: Array<{
    id: string
    nom: string
    flag?: string
    statut?: string
    dateAdhesion?: string
    role?: string
  }>
  structure?: {
    organigramme?: string
    secretaireGeneral?: string
    mandatDebut?: string
    organesDecision?: string[]
  }
  activites?: Array<{
    id: string
    nom: string
    description?: string
    budget?: number
    statut?: string
  }>
  financement?: {
    budgetAnnuel?: number
    sources?: Array<{
      type: string
      pourcentage: number
    }>
  }
}

defineProps<{
  data: OrganizationData
}>()

// États des sections collapsibles
const descriptionExpanded = ref(true)
const objectivesExpanded = ref(true)
const membersExpanded = ref(true)
const governanceExpanded = ref(false)
const activitiesExpanded = ref(false)
const financingExpanded = ref(false)

// Configuration pour les pays membres
const membersConfig = {
  titleField: 'nom',
  subtitleField: 'statut',
  iconField: 'flag',
  metadataFields: [
    {
      key: 'dateAdhesion',
      label: 'Membre depuis',
      field: 'dateAdhesion',
      formatter: (date: string) => formatDate(date)
    },
    {
      key: 'role',
      label: 'Rôle',
      field: 'role'
    }
  ]
}

// Fonctions de toggle
const toggleDescription = () => { descriptionExpanded.value = !descriptionExpanded.value }
const toggleObjectives = () => { objectivesExpanded.value = !objectivesExpanded.value }
const toggleMembers = () => { membersExpanded.value = !membersExpanded.value }
const toggleGovernance = () => { governanceExpanded.value = !governanceExpanded.value }
const toggleActivities = () => { activitiesExpanded.value = !activitiesExpanded.value }
const toggleFinancing = () => { financingExpanded.value = !financingExpanded.value }

// Fonctions de formatage
const formatCurrency = (amount?: number) => {
  if (!amount) return 'Non spécifié'
  if (amount >= 1e9) {
    return `${(amount / 1e9).toFixed(1)} milliards €`
  } else if (amount >= 1e6) {
    return `${(amount / 1e6).toFixed(1)} millions €`
  } else {
    return `${amount.toLocaleString('fr-FR')} €`
  }
}

const formatPercentage = (percentage?: number) => {
  if (!percentage) return 'Non spécifié'
  return `${percentage.toFixed(1)}%`
}
</script>

<style scoped>
/* Container maintenant géré par DetailViewContainer */

.description-content {
  line-height: 1.6;
  color: var(--text-dark);
}

.objectives-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.objective-item {
  display: flex;
  align-items: flex-start;
  gap: var(--spacing-sm);
  padding: var(--spacing-xs) 0;
}

.objective-bullet {
  color: var(--primary-color);
  font-weight: var(--font-weight-bold);
  margin-top: 2px;
}

.objective-text {
  flex: 1;
  line-height: 1.5;
}

/* Styles pour les membres supprimés - maintenant gérés par EntitySection */

.governance-content {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-md);
}

.governance-section {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
}

.section-title {
  margin: 0 0 var(--spacing-sm) 0;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
  color: var(--primary-color);
}

.governance-text {
  line-height: 1.5;
  color: var(--text-dark);
}

.leadership-info {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
}

.leader-title {
  color: var(--text-muted);
  font-weight: var(--font-weight-medium);
}

.leader-name {
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
}

.leader-mandate {
  margin-top: var(--spacing-xs);
  font-size: var(--font-size-xs);
  color: var(--text-muted);
  font-style: italic;
}

.decision-organs-list {
  margin: 0;
  padding-left: var(--spacing-md);
}

.organ-item {
  margin-bottom: var(--spacing-xs);
  line-height: 1.5;
}

.activities-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.activity-item {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
  border-left: 3px solid var(--primary-color);
}

.activity-title {
  font-weight: var(--font-weight-medium);
  color: var(--text-dark);
}

.activity-description {
  margin-top: var(--spacing-xs);
  line-height: 1.5;
  color: var(--text-dark);
}

.activity-budget {
  margin-top: var(--spacing-xs);
  font-size: var(--font-size-sm);
  color: var(--text-muted);
  font-weight: var(--font-weight-medium);
}

.activity-status {
  margin-top: var(--spacing-xs);
  font-size: var(--font-size-sm);
  color: var(--primary-color);
  font-style: italic;
}

.financing-content {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-md);
}

.financing-section {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
}

.budget-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.budget-label {
  font-weight: var(--font-weight-medium);
  color: var(--text-dark);
}

.budget-value {
  font-weight: var(--font-weight-bold);
  color: var(--primary-color);
}

.funding-sources {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.funding-source {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-xs);
  background-color: var(--surface-color);
  border-radius: var(--radius-xs);
}

.source-type {
  font-weight: var(--font-weight-medium);
  color: var(--text-dark);
}

.source-amount {
  font-weight: var(--font-weight-bold);
  color: var(--text-muted);
}

.no-data {
  padding: var(--spacing-sm);
  color: var(--text-muted);
  font-style: italic;
  text-align: center;
}
</style>