<template>
  <DetailViewContainer>


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
        <EntitySection
          title="Coalitions diplomatiques"
          :items="detailData.coalitions || []"
          :expanded="coalitionsExpanded"
          :config="coalitionsConfig"
          no-data-message="Aucune coalition diplomatique disponible."
          @toggle="toggleCoalitions"
        />

        <!-- Accords de libre-échange -->
        <EntitySection
          title="Accords de libre-échange"
          :items="detailData.accords || []"
          :expanded="tradeAgreementsExpanded"
          :config="tradeAgreementsConfig"
          no-data-message="Aucun accord de libre-échange disponible."
          @toggle="toggleTradeAgreements"
        />

        <!-- Conflits armés -->
        <EntitySection
          title="Conflits armés"
          :items="detailData.conflitsArmes || []"
          :expanded="conflictsExpanded"
          :selectable="true"
          :is-item-selected="isConflictSelected"
          :config="conflictsConfig"
          no-data-message="Aucun conflit armé disponible."
          @toggle="toggleConflicts"
          @select="selectConflict"
        />
  </DetailViewContainer>
</template>

<script lang="ts">
import { defineComponent, computed, ref, PropType } from 'vue'
import { useAsideStore } from '@/stores/asideStore'
import { useSelectionSystem } from '@/stores/selectionSystem'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'
import DetailSection from '@/components/aside/DetailSection.vue'
import EntitySection from '@/components/common/EntitySection.vue'
import DetailViewContainer from '@/components/panels/DetailViewContainer.vue'

interface CountryData {
  id: string
  title: string
  regimePolitique?: string
  chefEtat?: string
  datePrisePoste?: string
  pib?: number
  population?: number
  revenuMedian?: number
  superficieKm2?: number
  histoire?: string
  coalitions?: Array<{
    id: string
    title: string
    role?: string
    dateAdhesion?: string
  }>
  accords?: Array<{
    id: string
    title: string
    role?: string
    dateAdhesion?: string
  }>
  conflitsArmes?: Array<{
    id: string
    name: string
    status?: string
    startDate?: string
    endDate?: string
    description?: string
  }>
}

export default defineComponent({
  name: 'FloatingDetailView',
  
  components: {
    CollapsibleSection,
    DetailSection,
    EntitySection,
    DetailViewContainer
  },
  
  props: {
    data: {
      type: Object as PropType<CountryData>,
      default: null
    }
  },
  
  setup(props) {
    const asideStore = useAsideStore()
    const selectionSystem = useSelectionSystem()
    const coalitionsExpanded = ref(true)
    const tradeAgreementsExpanded = ref(true)
    const historyExpanded = ref(true) // Added for history section
    const conflictsExpanded = ref(true) // Added for conflicts section
    
    // Configuration pour les sections d'entités
    const coalitionsConfig = {
      titleField: 'title',
      subtitleField: 'role',
      metadataFields: [
        {
          key: 'dateAdhesion',
          label: 'Adhésion',
          field: 'dateAdhesion',
          formatter: (date: string) => formatDate(date)
        }
      ]
    }
    
    const tradeAgreementsConfig = {
      titleField: 'title',
      subtitleField: 'role',
      metadataFields: [
        {
          key: 'dateAdhesion',
          label: 'Adhésion',
          field: 'dateAdhesion',
          formatter: (date: string) => formatDate(date)
        }
      ]
    }
    
    const conflictsConfig = {
      titleField: 'name',
      subtitleField: 'status',
      descriptionField: 'description',
      metadataFields: [
        {
          key: 'startDate',
          label: 'Début',
          field: 'startDate',
          formatter: (date: string) => formatDate(date)
        },
        {
          key: 'endDate',
          label: 'Fin',
          field: 'endDate',
          formatter: (date: string) => formatDate(date)
        }
      ].filter(field => field.field)
    }
    
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
    const selectConflict = async (item: any) => {
      const conflictId = item.id
      console.log('🔥 Sélection conflit depuis fiche pays:', conflictId)
      await selectionSystem.selectConflict(conflictId, 'panel')
    }
    
    // Utiliser les props si disponibles, sinon fallback sur asideStore
    const detailData = computed(() => {
      return props.data || asideStore.currentDetailData
    })
    
    return {
      detailData,
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
      coalitionsConfig,
      tradeAgreementsConfig,
      conflictsConfig,
      isConflictSelected, // Added for conflict selection status
      selectConflict // Added for conflict selection
    }
  }
})
</script>

<style scoped>
/* Styles maintenant gérés par DetailViewContainer, EntitySection et EntityItem */
</style> 