<template>
  <div class="detail-section">
    <div v-if="title" class="detail-section-title">{{ title }}</div>
    <div v-if="value" class="detail-section-value">{{ value }}</div>
    
    <!-- Affichage des paires clé-valeur -->
    <div v-if="keyValues && keyValues.length > 0" class="key-value-list">
      <div v-for="(item, idx) in keyValues" :key="idx" class="key-value-item">
        <div class="key-value-key">{{ item.key }}</div>
        <div class="key-value-value">{{ item.value }}</div>
      </div>
    </div>
    
    <!-- Slot pour contenu personnalisé -->
    <slot></slot>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'DetailSection',
  
  props: {
    title: {
      type: String,
      default: ''
    },
    value: {
      type: String,
      default: ''
    },
    keyValues: {
      type: Array,
      default: () => []
    }
  }
})
</script>

<style scoped>
.detail-section {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
}

.detail-section-title {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
  margin-bottom: var(--spacing-xs);
}

.detail-section-value {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
  margin-bottom: var(--spacing-xs);
}

.key-value-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.key-value-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-xs) 0;
}

.key-value-key {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
}

.key-value-value {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
  text-align: right;
}
</style> 