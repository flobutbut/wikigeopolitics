<template>
  <div 
    class="conflict-item"
    :class="{ 'selected': isSelected }"
    @click="handleClick"
  >
    <div class="conflict-header">
      <div class="conflict-title">{{ conflict.name }}</div>
      <div v-if="conflict.status" class="conflict-status">{{ conflict.status }}</div>
    </div>
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
</template>

<script setup lang="ts">
import type { Conflict } from '@/types/conflict'

interface Props {
  conflict: Conflict
  isSelected: boolean
}

const props = defineProps<Props>()

const emit = defineEmits<{
  select: [conflictId: string]
}>()

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

const handleClick = () => {
  emit('select', props.conflict.id)
}
</script>

<style scoped>
.conflict-item {
  background-color: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-sm);
  margin-bottom: var(--spacing-xs);
  transition: all var(--transition-speed) var(--transition-function);
  cursor: pointer;
  padding: var(--spacing-sm);
}

.conflict-item:hover:not(.selected) {
  background-color: var(--surface-color);
  border: 1px solid var(--border-hover);
}

.conflict-item.selected {
  background-color: var(--surface-color);
  border: 1px solid var(--border-focus);
}


.conflict-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-xs);
}

.conflict-title {
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
  flex: 1;
}

.conflict-status {
  font-size: var(--font-size-xs);
  line-height: var(--line-height-xs);
  color: var(--text-muted);
  font-weight: var(--font-weight-medium);
  text-transform: uppercase;
  margin-left: var(--spacing-sm);
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
</style> 