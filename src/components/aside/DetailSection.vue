<template>
  <div class="detail-section">
    <div class="detail-content">
      <!-- Affichage d'une seule valeur -->
      <div v-if="value && !keyValues?.length" class="detail-section-value">{{ value }}</div>
      
      <!-- Affichage des paires clé-valeur -->
      <div v-if="keyValues && keyValues.length > 0" class="key-value-list">
        <div v-for="(item, idx) in keyValues" :key="idx" class="key-value-item">
          <div class="key-value-key">{{ item.key }}</div>
          <div class="key-value-value">{{ item.value }}</div>
        </div>
      </div>
      
      <!-- Affichage de plusieurs sections -->
      <div v-if="sections && sections.length > 0" class="sections-list">
        <div v-for="(section, idx) in sections" :key="idx" class="section-item">
          <div class="section-title">{{ section.title }}</div>
          <div class="section-value">{{ section.value }}</div>
        </div>
      </div>
      
      <!-- Slot pour contenu personnalisé -->
      <slot></slot>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

interface KeyValue {
  key: string;
  value: string;
}

interface Section {
  title: string;
  value: string;
}

export default defineComponent({
  name: 'DetailSection',
  
  props: {
    value: {
      type: String,
      default: ''
    },
    keyValues: {
      type: Array as () => KeyValue[],
      default: () => []
    },
    sections: {
      type: Array as () => Section[],
      default: () => []
    }
  }
})
</script>

<style scoped>
.detail-section {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  overflow: hidden;
  margin-bottom: var(--spacing-sm);
}

.detail-content {
  padding: var(--spacing-sm);
  background-color: var(--surface-dimmed);
}

.detail-section-value {
  font-size: var(--font-size-sm);
  color: var(--text-color);
  line-height: 1.5;
  margin-bottom: var(--spacing-sm);
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

.sections-list {
  display: flex;
  flex-direction: column;
}

.section-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-xs) 0;
}

.section-title {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
}

.section-value {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
  text-align: right;
}
</style> 