<template>
  <div 
    class="entity-item"
    :class="{ 
      'selected': isSelected, 
      'clickable': clickable,
      [`entity-item--${variant}`]: variant
    }"
    @click="handleClick"
  >
    <!-- En-tête avec titre et badge/statut -->
    <div class="entity-item__header">
      <div class="entity-item__info">
        <span v-if="icon" class="entity-item__icon">{{ icon }}</span>
        <span class="entity-item__title">{{ title }}</span>
      </div>
      <div v-if="status || badge" class="entity-item__status">
        <span v-if="status" class="entity-item__status-text">{{ status }}</span>
        <span v-if="badge" class="entity-item__badge">{{ badge }}</span>
      </div>
    </div>
    
    <!-- Contenu détaillé -->
    <div v-if="hasContent" class="entity-item__content">
      <div v-if="subtitle" class="entity-item__subtitle">{{ subtitle }}</div>
      <div v-if="description" class="entity-item__description">{{ description }}</div>
      
      <!-- Métadonnées avec formatage flexible -->
      <div v-if="metadata && metadata.length > 0" class="entity-item__metadata">
        <div v-for="meta in metadata" :key="meta.key" class="entity-item__meta">
          <span class="entity-item__meta-label">{{ meta.label }}:</span>
          <span class="entity-item__meta-value">{{ meta.value }}</span>
        </div>
      </div>
      
      <!-- Slot pour contenu personnalisé -->
      <slot></slot>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

export interface EntityItemMetadata {
  key: string
  label: string
  value: string
}

interface Props {
  title: string
  subtitle?: string
  description?: string
  icon?: string
  status?: string
  badge?: string
  metadata?: EntityItemMetadata[]
  isSelected?: boolean
  clickable?: boolean
  variant?: 'default' | 'compact' | 'detailed'
}

const props = withDefaults(defineProps<Props>(), {
  isSelected: false,
  clickable: false,
  variant: 'default'
})

const emit = defineEmits<{
  click: [event: MouseEvent]
  select: []
}>()

const hasContent = computed(() => {
  return props.subtitle || props.description || (props.metadata && props.metadata.length > 0)
})

const handleClick = (event: MouseEvent) => {
  if (props.clickable) {
    emit('click', event)
    emit('select')
  }
}
</script>

<style scoped>
.entity-item {
  background-color: var(--surface-color);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
  transition: all var(--transition-speed) var(--transition-function);
  border: 1px solid var(--border-color);
}

.entity-item.clickable {
  cursor: pointer;
}

.entity-item.clickable:hover {
  background-color: var(--surface-color);
  border-color: var(--border-hover);
}

.entity-item.selected {
  background-color: var(--surface-color);
  border-color: var(--border-active);
}

.entity-item__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-xs);
}

.entity-item__info {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
  flex: 1;
}

.entity-item__icon {
  font-size: var(--font-size-md);
  flex-shrink: 0;
}

.entity-item__title {
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
  flex: 1;
}

.entity-item__status {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
  flex-shrink: 0;
}

.entity-item__status-text {
  font-size: var(--font-size-sm);
  color: var(--text-muted);
  font-style: italic;
}

.entity-item__badge {
  background-color: var(--primary-color);
  color: var(--text-muted);
  padding: var(--spacing-xs) var(--spacing-sm);
  border-radius: var(--radius-xs);
  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-medium);
}

.entity-item__content {
  margin-top: var(--spacing-xs);
}

.entity-item__subtitle {
  font-size: var(--font-size-sm);
  color: var(--text-muted);
  margin-bottom: var(--spacing-xs);
}

.entity-item__description {
  color: var(--text-dark);
  line-height: 1.5;
  margin-bottom: var(--spacing-xs);
}

.entity-item__metadata {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.entity-item__meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: var(--font-size-sm);
}

.entity-item__meta-label {
  color: var(--text-muted);
  font-weight: var(--font-weight-medium);
}

.entity-item__meta-value {
  color: var(--text-dark);
  font-weight: var(--font-weight-medium);
}

/* Variants */
.entity-item--compact {
  padding: var(--spacing-xs) var(--spacing-sm);
}

.entity-item--compact .entity-item__header {
  margin-bottom: 0;
}

.entity-item--detailed {
  padding: var(--spacing-md);
  border-left: 3px solid var(--primary-color);
}

.entity-item--detailed .entity-item__title {
  font-size: var(--font-size-md);
  font-weight: var(--font-weight-bold);
}
</style>