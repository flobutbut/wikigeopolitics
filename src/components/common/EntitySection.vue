<template>
  <CollapsibleSection
    :title="title"
    :expanded="expanded"
    @toggle="handleToggle"
  >
    <div class="entity-section">
      <div v-if="items && items.length > 0" class="entity-section__list">
        <EntityItem
          v-for="item in items"
          :key="getItemKey(item)"
          :title="getItemTitle(item)"
          :subtitle="getItemSubtitle(item)"
          :description="getItemDescription(item)"
          :icon="getItemIcon(item)"
          :status="getItemStatus(item)"
          :badge="getItemBadge(item)"
          :metadata="getItemMetadata(item)"
          :is-selected="selectable && isItemSelected && isItemSelected(getItemId(item))"
          :clickable="clickable || selectable"
          :variant="itemVariant"
          @select="handleItemSelect(item)"
        />
      </div>
      
      <div v-else-if="showNoDataMessage" class="entity-section__no-data">
        {{ noDataMessage }}
      </div>
      
      <!-- Slot pour contenu personnalisé -->
      <slot :items="items"></slot>
    </div>
  </CollapsibleSection>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'
import EntityItem from '@/components/common/EntityItem.vue'

// Interface générique pour les items
export interface EntitySectionItem {
  id: string
  title?: string
  nom?: string
  name?: string
  [key: string]: any
}

// Interface pour les mappings de champs
export interface EntitySectionConfig {
  titleField?: string
  subtitleField?: string
  descriptionField?: string
  iconField?: string
  statusField?: string
  badgeField?: string
  metadataFields?: Array<{
    key: string
    label: string
    field: string
    formatter?: (value: any) => string
  }>
}

interface Props {
  title: string
  items?: EntitySectionItem[]
  expanded?: boolean
  clickable?: boolean
  selectable?: boolean  // Nouvelle prop pour activer la sélection
  itemVariant?: 'default' | 'compact' | 'detailed'
  noDataMessage?: string
  showNoDataMessage?: boolean
  isItemSelected?: (itemId: string) => boolean
  config?: EntitySectionConfig
}

const props = withDefaults(defineProps<Props>(), {
  expanded: true,
  clickable: false,
  selectable: false,
  itemVariant: 'default',
  noDataMessage: 'Aucun élément disponible.',
  showNoDataMessage: true,
  config: () => ({
    titleField: 'title',
    subtitleField: 'subtitle',
    descriptionField: 'description',
    iconField: 'icon',
    statusField: 'status',
    badgeField: 'badge'
  })
})

const emit = defineEmits<{
  toggle: [expanded: boolean]
  select: [item: EntitySectionItem]
}>()

const isExpanded = ref(props.expanded)

const handleToggle = () => {
  isExpanded.value = !isExpanded.value
  emit('toggle', isExpanded.value)
}

const handleItemSelect = (item: EntitySectionItem) => {
  if (props.selectable) {
    emit('select', item)
  }
}

// Fonctions utilitaires pour extraire les données des items
const getItemKey = (item: EntitySectionItem): string => {
  return item.id || item.key || String(Math.random())
}

const getItemId = (item: EntitySectionItem): string => {
  return item.id
}

const getItemTitle = (item: EntitySectionItem): string => {
  const titleField = props.config?.titleField || 'title'
  return item[titleField] || item.title || item.nom || item.name || 'Sans titre'
}

const getItemSubtitle = (item: EntitySectionItem): string | undefined => {
  const subtitleField = props.config?.subtitleField || 'subtitle'
  return item[subtitleField] || item.role || item.type
}

const getItemDescription = (item: EntitySectionItem): string | undefined => {
  const descriptionField = props.config?.descriptionField || 'description'
  return item[descriptionField]
}

const getItemIcon = (item: EntitySectionItem): string | undefined => {
  const iconField = props.config?.iconField || 'icon'
  return item[iconField] || item.flag
}

const getItemStatus = (item: EntitySectionItem): string | undefined => {
  const statusField = props.config?.statusField || 'status'
  return item[statusField] || item.statut
}

const getItemBadge = (item: EntitySectionItem): string | undefined => {
  const badgeField = props.config?.badgeField || 'badge'
  return item[badgeField]
}

const getItemMetadata = (item: EntitySectionItem) => {
  if (!props.config?.metadataFields) return undefined
  
  return props.config.metadataFields
    .filter(field => item[field.field] !== undefined && item[field.field] !== null)
    .map(field => ({
      key: field.key,
      label: field.label,
      value: field.formatter ? field.formatter(item[field.field]) : String(item[field.field])
    }))
}
</script>

<style scoped>
.entity-section {
  /* Styles de base hérités de CollapsibleSection */
}

.entity-section__list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.entity-section__no-data {
  padding: var(--spacing-sm);
  color: var(--text-muted);
  font-style: italic;
  text-align: center;
}
</style>