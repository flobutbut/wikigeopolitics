<template>
  <div class="collapsible-section">
    <div class="collapsible-header" @click="toggleExpanded">
      <h3 class="detail-section-title">{{ title }}</h3>
      <span class="collapsible-icon" :class="{ 'expanded': isExpanded }">
        <ChevronIcon 
          direction="down" 
          :size="12" 
        />
      </span>
    </div>
    
    <div v-if="isExpanded" class="collapsible-content">
      <div v-if="content" class="section-content" v-html="content"></div>
      
      <div v-if="source" class="section-source">
        <a :href="sourceUrl" target="_blank" class="source-link">{{ source }}</a>
      </div>
      
      <slot></slot>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, watch } from 'vue'
import ChevronIcon from '@/components/icons/ChevronIcon.vue'

export default defineComponent({
  name: 'CollapsibleSection',
  
  components: {
    ChevronIcon
  },
  
  props: {
    title: {
      type: String,
      required: true
    },
    content: {
      type: String,
      default: ''
    },
    source: {
      type: String,
      default: ''
    },
    sourceUrl: {
      type: String,
      default: '#'
    },
    expanded: {
      type: Boolean,
      default: false
    },
    sectionId: {
      type: String,
      default: ''
    }
  },
  
  emits: ['toggle'],
  
  setup(props, { emit }) {
    const isExpanded = ref(props.expanded)
    
    // Surveiller les changements de la prop expanded
    watch(() => props.expanded, (newValue) => {
      isExpanded.value = newValue
    })
    
    const toggleExpanded = () => {
      isExpanded.value = !isExpanded.value
      emit('toggle', props.sectionId, isExpanded.value)
    }
    
    return {
      isExpanded,
      toggleExpanded
    }
  }
})
</script>

<style scoped>
.collapsible-section {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  overflow: hidden;
  margin-bottom: var(--spacing-sm);
}

.collapsible-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-sm);
  cursor: pointer;
  background-color: var(--surface-dimmed);
}

.detail-section-title {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
  margin: 0;
}

.collapsible-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-light);
  transition: transform var(--transition-speed) var(--transition-function);
}

.collapsible-icon.expanded {
  transform: rotate(180deg);
}

.collapsible-content {
  padding: 0 var(--spacing-sm) var(--spacing-sm) var(--spacing-sm);
  background-color: var(--surface-dimmed);
}

.section-content {
  font-size: var(--font-size-sm);
  color: var(--text-color);
  line-height: 1.5;
  margin-bottom: var(--spacing-sm);
}

.section-source {
  font-size: var(--font-size-xs);
  text-align: right;
}

.source-link {
  color: var(--primary-color);
  text-decoration: none;
}

.source-link:hover {
  text-decoration: underline;
}
</style> 