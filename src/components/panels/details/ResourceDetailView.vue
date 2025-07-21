<template>
  <DetailViewContainer>
    <!-- Informations principales -->
    <DetailSection
      :sections="mainSections"
    />

    <!-- Informations techniques -->
    <DetailSection
      :sections="technicalSections"
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

    <!-- Enjeux géopolitiques -->
    <CollapsibleSection
      title="Enjeux Géopolitiques"
      :expanded="geopoliticsExpanded"
      @toggle="toggleGeopolitics"
    >
      <div v-if="data.geopoliticalIssues" class="geopolitics-info">
        {{ data.geopoliticalIssues }}
      </div>
      <div v-else class="no-data">
        Aucun enjeu géopolitique documenté.
      </div>
    </CollapsibleSection>

    <!-- Pays producteurs -->
    <EntitySection
      title="Pays Producteurs"
      :items="enrichedPaysProducteurs"
      :expanded="countriesExpanded"
      :config="countriesConfig"
      :selectable="true"
      :is-item-selected="isCountrySelected"
      no-data-message="Aucun pays producteur répertorié."
      @toggle="toggleCountries"
      @select="selectCountry"
    />

    <!-- Impact environnemental -->
    <CollapsibleSection
      title="Impact Environnemental"
      :expanded="environmentExpanded"
      @toggle="toggleEnvironment"
    >
      <div v-if="data.environmentalImpact" class="environment-info">
        {{ data.environmentalImpact }}
      </div>
      <div v-else class="no-data">
        Aucune information environnementale disponible.
      </div>
    </CollapsibleSection>
  </DetailViewContainer>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import DetailSection from '@/components/aside/DetailSection.vue'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'
import EntitySection from '@/components/common/EntitySection.vue'
import DetailViewContainer from '@/components/panels/DetailViewContainer.vue'
import { useSelectionSystem } from '@/stores/selectionSystem'
import { useAsideStore } from '@/stores/asideStore'

const props = defineProps<{
  data: any
}>()

const selectionSystem = useSelectionSystem()
const asideStore = useAsideStore()

// Enrichir les pays producteurs avec leurs données de production
const enrichedPaysProducteurs = computed(() => {
  console.log('🔍 [ResourceDetailView] Pays producteurs reçus:', props.data.paysProducteurs)
  return props.data.paysProducteurs || []
})

// États des sections collapsibles
const descriptionExpanded = ref(true)
const countriesExpanded = ref(true)
const environmentExpanded = ref(false)
const geopoliticsExpanded = ref(false)

// Configuration pour les pays producteurs
const countriesConfig = {
  titleField: 'nom',
  subtitleField: 'role',
  iconField: 'flag',
  metadataFields: [
    {
      key: 'production',
      label: 'Production',
      field: 'production',
      formatter: (item: any) => {
        console.log('🔍 [ResourceDetailView] Formatter reçoit item complet:', item)
        const quantite = item.quantite
        const unite = item.unite || ''
        console.log('🔍 [ResourceDetailView] Quantite:', quantite, 'Unite:', unite)
        if (quantite === undefined || quantite === null) {
          return 'Non spécifié'
        }
        return `${formatQuantity(quantite)} ${unite}`
      }
    }
  ]
}

// Computed pour les sections principales
const mainSections = computed(() => [
  { title: 'Catégorie', value: props.data.categorie || 'Non spécifiée' },
  { title: 'État des réserves', value: props.data.etatReserves || 'Non spécifié' },
  { title: 'Rareté', value: props.data.rarete || 'Non spécifiée' }
].filter(section => section.value && section.value !== 'Non spécifié'))

// Computed pour les sections techniques
const technicalSections = computed(() => [
  { title: 'Valeur d\'échange', value: formatExchangeValue() },
  { title: 'Production annuelle', value: formatAnnualProduction() },
  { title: 'Dernière mise à jour', value: formatDate(props.data.priceUpdateDate) }
].filter(section => section.value && section.value !== 'Non spécifié'))

// Fonctions de toggle
const toggleDescription = () => { descriptionExpanded.value = !descriptionExpanded.value }
const toggleCountries = () => { countriesExpanded.value = !countriesExpanded.value }
const toggleEnvironment = () => { environmentExpanded.value = !environmentExpanded.value }
const toggleGeopolitics = () => { geopoliticsExpanded.value = !geopoliticsExpanded.value }

// Fonctions utilitaires
const formatQuantity = (quantity: number | string) => {
  if (quantity === undefined || quantity === null) {
    return 'Non spécifié'
  }
  
  // Convertir en nombre si c'est une chaîne
  const numQuantity = typeof quantity === 'string' ? parseFloat(quantity) : quantity
  
  if (isNaN(numQuantity)) {
    return quantity.toString() // Retourner la valeur brute si pas un nombre
  }
  
  if (numQuantity >= 1000000) {
    return (numQuantity / 1000000).toFixed(1) + 'M'
  } else if (numQuantity >= 1000) {
    return (numQuantity / 1000).toFixed(1) + 'K'
  }
  return numQuantity.toString()
}

const formatExchangeValue = () => {
  if (!props.data.exchangeValue) return 'Non spécifiée'
  return `${props.data.exchangeValue} ${props.data.valueUnit || ''} (${props.data.currency || ''})`
}

const formatAnnualProduction = () => {
  // Utiliser les champs de la table resource
  if (!props.data.annual_production) return 'Non spécifiée'
  
  const production = formatQuantity(props.data.annual_production)
  const unite = props.data.annual_production_unit || ''
  
  return `${production} ${unite}`.trim()
}

const formatDate = (dateString: string) => {
  if (!dateString) return 'Non spécifiée'
  return new Date(dateString).toLocaleDateString('fr-FR')
}

// Vérifier si un pays est sélectionné
const isCountrySelected = (countryId: string) => {
  return selectionSystem.isCountrySelected(countryId)
}

// Sélectionner un pays depuis la ressource
const selectCountry = async (country: any) => {
  console.log('🏳️ Sélection pays depuis ressource:', country.id)
  await asideStore.selectCountryFromResource(country.id)
}
</script>

<style scoped>
.description-content {
  line-height: 1.6;
  color: var(--text-dark);
}

.environment-info,
.geopolitics-info {
  line-height: 1.6;
  color: var(--text-dark);
}

.no-data {
  padding: var(--spacing-sm);
  color: var(--text-muted);
  font-style: italic;
  text-align: center;
}
</style> 