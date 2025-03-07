<template>
  <button 
    class="btn" 
    :class="[
      `btn-${variant}`, 
      { 'btn-sm': size === 'small', 'btn-lg': size === 'large' }
    ]"
    :type="type"
    :disabled="disabled"
    @click="handleClick"
  >
    <slot></slot>
  </button>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'Button',
  
  props: {
    variant: {
      type: String,
      default: 'primary',
      validator: (value: string) => ['primary', 'secondary', 'outline', 'text'].includes(value)
    },
    size: {
      type: String,
      default: 'medium',
      validator: (value: string) => ['small', 'medium', 'large'].includes(value)
    },
    type: {
      type: String,
      default: 'button',
      validator: (value: string) => ['button', 'submit', 'reset'].includes(value)
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  
  emits: ['click'],
  
  setup(props, { emit }) {
    const handleClick = (event: MouseEvent) => {
      emit('click', event)
    }
    
    return {
      handleClick
    }
  }
})
</script>

<style scoped>
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-sm) var(--spacing-md);
  border-radius: var(--radius-md);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  transition: all var(--transition-speed) var(--transition-function);
  cursor: pointer;
  border: none;
  font-family: 'Inter', sans-serif;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* Variantes */
.btn-primary {
  background-color: var(--primary-color);
  color: var(--text-on-primary);
}

.btn-primary:hover:not(:disabled) {
  background-color: var(--primary-hover);
}

.btn-primary:active:not(:disabled) {
  background-color: var(--primary-active);
}

.btn-secondary {
  background-color: var(--surface-dimmed);
  color: var(--text-dark);
}

.btn-secondary:hover:not(:disabled) {
  background-color: #CCD7E0;
}

.btn-secondary:active:not(:disabled) {
  background-color: #BCC9D4;
}

.btn-outline {
  background-color: transparent;
  color: var(--primary-color);
  border: 1px solid var(--primary-color);
}

.btn-outline:hover:not(:disabled) {
  background-color: rgba(46, 67, 255, 0.05);
}

.btn-outline:active:not(:disabled) {
  background-color: rgba(46, 67, 255, 0.1);
}

.btn-text {
  background-color: transparent;
  color: var(--primary-color);
  padding: var(--spacing-xs) var(--spacing-sm);
}

.btn-text:hover:not(:disabled) {
  background-color: rgba(46, 67, 255, 0.05);
}

.btn-text:active:not(:disabled) {
  background-color: rgba(46, 67, 255, 0.1);
}

/* Tailles */
.btn-sm {
  padding: var(--spacing-xs) var(--spacing-sm);
  font-size: var(--font-size-xs);
}

.btn-lg {
  padding: var(--spacing-md) var(--spacing-lg);
  font-size: var(--font-size-md);
}
</style> 