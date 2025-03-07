<template>
  <div class="search">
    <div class="search__wrapper">
      <input
        type="text"
        v-model="searchQuery"
        :placeholder="placeholder"
        class="search__input"
        @input="handleSearch"
      >
      <button 
        v-if="searchQuery" 
        @click="clearSearch" 
        class="search__clear"
        aria-label="Effacer la recherche"
      >
        ×
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'

export default defineComponent({
  name: 'Search',

  props: {
    placeholder: {
      type: String,
      default: 'Rechercher...'
    }
  },

  emits: ['search'],

  setup(props, { emit }) {
    const searchQuery = ref('')

    const handleSearch = () => {
      emit('search', searchQuery.value)
    }

    const clearSearch = () => {
      searchQuery.value = ''
      emit('search', '')
    }

    return {
      searchQuery,
      handleSearch,
      clearSearch
    }
  }
})
</script>

<style scoped>
.search {
  padding: var(--spacing-md) 0 var(--spacing-md) var(--spacing-md);
}

.search__wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.search__input {
  width: 100%;
  padding: var(--spacing-sm) var(--spacing-lg) var(--spacing-sm) var(--spacing-sm);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  font-size: var(--font-size-sm);
  line-height: var(--line-height-sm);
  color: var(--text-color);
  background-color: var(--surface-color);
  transition: border-color var(--transition-speed) var(--transition-function);
}

.search__input:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px rgba(46, 67, 255, 0.1);
}

.search__input::placeholder {
  color: var(--text-muted);
}

.search__clear {
  position: absolute;
  right: var(--spacing-sm);
  background: none;
  border: none;
  cursor: pointer;
  font-size: var(--font-size-lg);
  color: var(--text-muted);
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  border-radius: var(--radius-full);
}

.search__clear:hover {
  color: var(--text-color);
  background-color: var(--surface-hover);
}
</style> 