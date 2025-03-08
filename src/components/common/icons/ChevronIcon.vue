<template>
  <svg 
    xmlns="http://www.w3.org/2000/svg" 
    :width="size" 
    :height="size" 
    viewBox="0 0 24 24" 
    fill="none" 
    stroke="currentColor" 
    :stroke-width="strokeWidth" 
    stroke-linecap="round" 
    stroke-linejoin="round"
    :class="['chevron-icon', `chevron-icon--${direction}`]"
  >
    <polyline 
      v-if="direction === 'down'" 
      points="6 9 12 15 18 9"
    ></polyline>
    <polyline 
      v-else-if="direction === 'up'" 
      points="18 15 12 9 6 15"
    ></polyline>
    <polyline 
      v-else-if="direction === 'left'" 
      points="15 18 9 12 15 6"
    ></polyline>
    <polyline 
      v-else 
      points="9 18 15 12 9 6"
    ></polyline>
  </svg>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'ChevronIcon',
  
  props: {
    direction: {
      type: String,
      default: 'down',
      validator: (value: string) => ['up', 'down', 'left', 'right'].includes(value)
    },
    size: {
      type: [Number, String],
      default: 16
    },
    strokeWidth: {
      type: [Number, String],
      default: 2
    }
  }
})
</script>

<style scoped>
.chevron-icon {
  transition: transform var(--transition-speed) var(--transition-function);
}

.chevron-icon--up {
  transform: rotate(0deg);
}

.chevron-icon--right {
  transform: rotate(0deg);
}

.chevron-icon--down {
  transform: rotate(0deg);
}

.chevron-icon--left {
  transform: rotate(0deg);
}
</style> 