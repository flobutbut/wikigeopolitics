<template>
  <div class="tab-navigation">
    <div class="tab-list">
      <button
        v-for="tab in tabs"
        :key="tab.id"
        :class="['tab-button', { 'active': activeTab === tab.id }]"
        @click="selectTab(tab.id)"
      >
        {{ tab.label }}
      </button>
    </div>
    
    <div class="tab-content">
      <slot :active-tab="activeTab"></slot>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, watch } from 'vue'

export interface Tab {
  id: string
  label: string
}

export default defineComponent({
  name: 'TabNavigation',
  
  props: {
    tabs: {
      type: Array as () => Tab[],
      required: true
    },
    defaultTab: {
      type: String,
      default: ''
    }
  },
  
  emits: ['tab-change'],
  
  setup(props, { emit }) {
    const activeTab = ref(props.defaultTab || (props.tabs.length > 0 ? props.tabs[0].id : ''))
    
    const selectTab = (tabId: string) => {
      activeTab.value = tabId
      emit('tab-change', tabId)
    }
    
    // Surveiller les changements de props.defaultTab
    watch(() => props.defaultTab, (newValue) => {
      if (newValue && props.tabs.some(tab => tab.id === newValue)) {
        activeTab.value = newValue
      }
    })
    
    return {
      activeTab,
      selectTab
    }
  }
})
</script>

<style scoped>
.tab-navigation {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.tab-list {
  display: flex;
  border-bottom: 1px solid var(--border-color);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-md) var(--radius-md) 0 0;
}

.tab-button {
  flex: 1;
  padding: var(--spacing-sm) var(--spacing-md);
  background: none;
  border: none;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--text-muted);
  cursor: pointer;
  transition: all 0.2s ease;
  border-bottom: 2px solid transparent;
}

.tab-button:hover {
  color: var(--text-color);
  background-color: var(--surface-hover);
}

.tab-button.active {
  color: var(--primary-color);
  border-bottom-color: var(--primary-color);
  background-color: var(--surface-color);
}

.tab-content {
  flex: 1;
  overflow-y: auto;
}
</style> 