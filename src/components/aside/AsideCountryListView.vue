<template>
  <div class="aside__section">
    <div class="return-button" @click="returnToMainView">
      <span class="return-icon">←</span> Retour
    </div>
    
    <h2 class="aside__section-title">Pays du monde</h2>
    
    <ul class="country-list">
      <li 
        v-for="country in filteredCountries" 
        :key="country.id"
        class="country-item"
        @click="selectCountry(country.id)"
      >
        <span class="country-flag">{{ country.flag }}</span>
        <span class="country-name">{{ country.title }}</span>
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useAsideStore } from '@/stores/asideStore'

export default defineComponent({
  name: 'AsideCountryListView',
  
  setup() {
    const asideStore = useAsideStore()
    
    // Retour à la vue principale
    const returnToMainView = () => {
      asideStore.returnToMainView()
    }
    
    // Sélection d'un pays
    const selectCountry = (id: string) => {
      asideStore.selectCountry(id)
    }
    
    return {
      filteredCountries: computed(() => asideStore.filteredCountries),
      returnToMainView,
      selectCountry
    }
  }
})
</script>

<style scoped>
.aside__section {
  margin-bottom: var(--spacing-lg);
  padding-left: var(--spacing-sm);
  padding-right: var(--spacing-sm);
}

.aside__section-title {
  font-size: var(--font-size-sm);
  color: var(--text-dark);
  margin-bottom: var(--spacing-sm);
  padding-left: var(--spacing-sm);
}

.return-button {
  display: flex;
  align-items: center;
  padding: var(--spacing-xs) var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
  color: var(--primary-color);
  cursor: pointer;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
}

.return-icon {
  margin-right: var(--spacing-xs);
}

/* Styles pour la liste des pays */
.country-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

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