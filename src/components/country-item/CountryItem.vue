<template>
  <li class="country-item" @click="handleSelect">
    <span class="country-flag">{{ country.flag }}</span>
    <span class="country-name">{{ country.title }}</span>
  </li>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue'

interface Country {
  id: string;
  title: string;
  flag: string;
}

export default defineComponent({
  name: 'CountryItem',
  
  props: {
    country: {
      type: Object as PropType<Country>,
      required: true
    }
  },
  
  emits: ['select'],
  
  setup(props, { emit }) {
    const handleSelect = () => {
      emit('select', props.country.id)
    }
    
    return {
      handleSelect
    }
  }
})
</script>

<style scoped>
.country-item {
  display: flex;
  align-items: center;
  padding: var(--spacing-xs) var(--spacing-sm);
  cursor: pointer;
  transition: background-color var(--transition-speed) var(--transition-function);
}

.country-item:hover {
  background-color: var(--surface-hover);
}

.country-flag {
  margin-right: var(--spacing-sm);
  font-size: var(--font-size-md);
}

.country-name {
  font-size: var(--font-size-sm);
  color: var(--text-color);
}
</style> 