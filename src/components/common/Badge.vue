<template>
  <span 
    class="badge" 
    :class="[
      `badge-${variant}`, 
      { 'badge-sm': size === 'small', 'badge-lg': size === 'large' }
    ]"
  >
    {{ value }}
  </span>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'Badge',
  
  props: {
    value: {
      type: [Number, String],
      required: true
    },
    variant: {
      type: String,
      default: 'primary',
      validator: (value: string) => ['primary', 'secondary', 'success', 'warning', 'danger', 'info'].includes(value)
    },
    size: {
      type: String,
      default: 'medium',
      validator: (value: string) => ['small', 'medium', 'large'].includes(value)
    }
  }
})
</script>

<style scoped>
.badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-xs) var(--spacing-sm);
  border-radius: var(--radius-full);
  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-semibold);
  line-height: 1;
  white-space: nowrap;
  font-family: 'Inter', sans-serif;
  min-width: 1.5rem;
  height: 1.5rem;
}

/* Variantes */
.badge-primary {
  background-color: var(--primary-color);
  color: var(--text-on-primary);
}

.badge-secondary {
  background-color: var(--surface-dimmed);
  color: var(--text-dark);
}

.badge-success {
  background-color: #10B981;
  color: white;
}

.badge-warning {
  background-color: #F59E0B;
  color: white;
}

.badge-danger {
  background-color: #EF4444;
  color: white;
}

.badge-info {
  background-color: #3B82F6;
  color: white;
}

/* Tailles */
.badge-sm {
  padding: 2px var(--spacing-xs);
  font-size: 10px;
  min-width: 1.25rem;
  height: 1.25rem;
}

.badge-lg {
  padding: var(--spacing-sm) var(--spacing-md);
  font-size: var(--font-size-sm);
  min-width: 2rem;
  height: 2rem;
}
</style> 