<template>
  <component :is="titleTag" class="custom-section-title-component" :class="sizeClass">
    <slot></slot>
  </component>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'

export default defineComponent({
  name: 'SectionTitle',
  
  props: {
    level: {
      type: Number,
      default: 2,
      validator: (value: number) => value >= 1 && value <= 6
    },
    size: {
      type: String,
      default: 'default',
      validator: (value: string) => ['small', 'default', 'large'].includes(value)
    }
  },
  
  setup(props) {
    // Déterminer le tag HTML à utiliser (h1, h2, h3, etc.)
    const titleTag = computed(() => `h${props.level}`)
    
    // Déterminer la classe CSS à appliquer en fonction de la taille
    const sizeClass = computed(() => {
      if (props.size === 'small') return 'title-small'
      if (props.size === 'large') return 'title-large'
      return 'title-default'
    })
    
    return {
      titleTag,
      sizeClass
    }
  }
})
</script>

<style scoped>
.custom-section-title-component {
  font-weight: var(--font-weight-bold);
  margin: 0 0 var(--spacing-sm) 0;
  padding-left: var(--spacing-sm);
  color: var(--text-dark);
  line-height: normal;
}

.title-small {
  font-size: var(--font-size-md);
  margin-bottom: var(--spacing-xs);
}

.title-default {
  font-size: var(--font-size-sm);
  margin-bottom: var(--spacing-sm);
}

.title-large {
  font-size: var(--font-size-lg);
  margin-bottom: var(--spacing-lg);
}
</style> 