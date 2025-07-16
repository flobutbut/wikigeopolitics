<template>
  <CollapsibleSection
    title="Conflits armés"
    :expanded="expanded"
    @toggle="handleToggle"
  >
    <div class="conflicts-list">
      <ConflictItem
        v-for="conflict in conflicts"
        :key="conflict.id"
        :conflict="conflict"
        :is-selected="props.isConflictSelected(conflict.id)"
        @select="handleConflictSelect"
      />
      <div v-if="!conflicts || conflicts.length === 0" class="no-data">
        Aucun conflit armé disponible.
      </div>
    </div>
  </CollapsibleSection>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'
import ConflictItem from '@/components/panels/details/ConflictItem.vue'
import type { Conflict } from '@/types/conflict'

interface Props {
  conflicts: Conflict[]
  expanded?: boolean
  isConflictSelected?: (conflictId: string) => boolean
}

const props = withDefaults(defineProps<Props>(), {
  expanded: true,
  isConflictSelected: () => false
})

const emit = defineEmits<{
  toggle: [expanded: boolean]
  select: [conflictId: string]
}>()

const isExpanded = ref(props.expanded)

const handleToggle = () => {
  isExpanded.value = !isExpanded.value
  emit('toggle', isExpanded.value)
}

const handleConflictSelect = (conflictId: string) => {
  emit('select', conflictId)
}


</script>

<style scoped>
.conflicts-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.no-data {
  padding: var(--spacing-sm);
  color: var(--text-muted);
  font-style: italic;
  text-align: center;
}
</style> 