<template>
  <div class="return-button" @click="$emit('click')">
    <span class="return-icon">
      <ChevronIcon direction="left" :size="12" />
    </span>
    {{ text || 'Retour' }}
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import ChevronIcon from '@/components/icons/ChevronIcon.vue'

export default defineComponent({
  name: 'ReturnButton',
  
  components: {
    ChevronIcon
  },
  
  props: {
    text: {
      type: String,
      default: 'Retour'
    }
  },
  
  emits: ['click']
})
</script>

<style scoped>
.return-button {
  display: flex;
  align-items: center;
  padding: var(--spacing-xs) 0;
  margin-bottom: var(--spacing-sm);
  color: var(--text-muted);
  cursor: pointer;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  transition: color var(--transition-speed) var(--transition-function);
}

.return-button:hover {
  color: var(--text-color);
}

.return-icon {
  display: flex;
  align-items: center;
  margin-right: var(--spacing-xs);
}
</style> 