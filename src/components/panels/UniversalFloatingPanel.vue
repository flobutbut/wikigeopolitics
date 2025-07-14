<template>
  <GenericFloatingPanel
    v-if="asideStore.currentDetailData && asideStore.currentEntityType"
    :entity-data="asideStore.currentDetailData"
    :entity-type="asideStore.currentEntityType"
    :entity-icon="getEntityIcon(asideStore.currentEntityType)"
    :entity-icon-title="getEntityIconTitle(asideStore.currentEntityType)"
    :show-news-tab="asideStore.currentEntityType === 'country'"
    :show-analysis-tab="false"
    @close="closePanel"
    @tab-change="handleTabChange"
  >
    <template #content="{ data }">
      <!-- Vue spécialisée selon le type d'entité -->
      <FloatingDetailView 
        v-if="asideStore.currentEntityType === 'country'" 
      />
      
      <ConflictDetailView 
        v-else-if="asideStore.currentEntityType === 'conflict'" 
        :data="data as ConflictData"
      />
      
      <RegimeDetailView 
        v-else-if="asideStore.currentEntityType === 'regime'" 
        :data="data as RegimeData"
      />
      
      <OrganizationDetailView 
        v-else-if="asideStore.currentEntityType === 'organization'" 
        :data="data as OrganizationData"
      />
      
      <ResourceDetailView 
        v-else-if="asideStore.currentEntityType === 'resource'" 
        :data="data as ResourceData"
      />
      
      <!-- Fallback pour types non supportés -->
      <div v-else class="unsupported-entity">
        <p>Type d'entité non supporté: {{ asideStore.currentEntityType }}</p>
      </div>
    </template>
  </GenericFloatingPanel>
</template>

<script setup lang="ts">
import { computed, watch } from 'vue'
import { useAsideStore } from '@/stores/asideStore'
import GenericFloatingPanel from './GenericFloatingPanel.vue'
import FloatingDetailView from './FloatingDetailView.vue'
import ConflictDetailView from './details/ConflictDetailView.vue'
import RegimeDetailView from './details/RegimeDetailView.vue'
import OrganizationDetailView from './details/OrganizationDetailView.vue'
import ResourceDetailView from './details/ResourceDetailView.vue'

// Types pour les données spécialisées
interface ConflictData {
  id: string
  title: string
  type?: string
  statut?: string
  intensite?: string
  dateDebut?: string
  dateFin?: string
  localisation?: string
  zones?: string[]
  victimes?: Record<string, any>
  paysImpliques?: Array<{
    id: string
    nom: string
    flag?: string
    role?: string
    dateEntree?: string
  }>
  timeline?: Array<{
    id: string
    date: string
    titre: string
    description?: string
  }>
}

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
}

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
}

interface ResourceData {
  id: string
  title: string
  type?: string
  categorie?: string
  etatReserves?: string
  rarete?: string
  localisationPrincipale?: string
  zonesExtraction?: string[]
  description?: string
  unite?: string
  reservesMondiales?: {
    total?: number
    principauxGisements?: Array<{
      id: string
      localisation: string
      pays?: { flag?: string }
      quantite?: number
      pourcentageMondial?: number
    }>
  }
}

const asideStore = useAsideStore()

// Watcher pour déboguer les changements d'entité
watch([() => asideStore.currentDetailData, () => asideStore.currentEntityType], ([newData, newType], [oldData, oldType]) => {
  console.log('🔄 Entity data changed:', {
    newType,
    oldType,
    newData: newData?.title,
    oldData: oldData?.title
  })
}, { immediate: true })

// Fonctions utilitaires pour les icônes et métadonnées
const getEntityIcon = (entityType: string) => {
  if (entityType === 'country' && asideStore.currentDetailData) {
    // Pour les pays, utiliser le drapeau
    const countryData = asideStore.currentDetailData as any
    return countryData.drapeau || '🏳️'
  }
  
  const iconMap: Record<string, string> = {
    'country': '🏳️',
    'conflict': '⚔️',
    'regime': '🏛️',
    'organization': '🌐',
    'resource': '⛽'
  }
  return iconMap[entityType] || '📄'
}

const getEntityIconTitle = (entityType: string) => {
  const titleMap: Record<string, string> = {
    'country': 'Pays',
    'conflict': 'Conflit armé',
    'regime': 'Régime politique',
    'organization': 'Organisation internationale',
    'resource': 'Ressource naturelle'
  }
  return titleMap[entityType] || 'Entité'
}


// Gestion des événements
const handleTabChange = (tabId: string) => {
  console.log('Tab changed:', tabId)
}

const closePanel = () => {
  asideStore.clearCurrentEntity()
}
</script>

<style scoped>
.unsupported-entity {
  padding: var(--spacing-md);
  text-align: center;
  color: var(--text-muted);
  font-style: italic;
}
</style>