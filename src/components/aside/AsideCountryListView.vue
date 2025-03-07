<template>
  <div class="aside__section">
    <ReturnButton @click="returnToMainView" />
    
    <SectionTitle>Pays du monde</SectionTitle>
    
    <ul class="country-list">
      <CountryItem
        v-for="country in filteredCountries"
        :key="country.id"
        :country="country"
        @select="selectCountry"
      />
    </ul>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useAsideStore } from '@/stores/asideStore'
import CountryItem from '@/components/country-item/CountryItem.vue'
import SectionTitle from '@/components/section-title/SectionTitle.vue'
import ReturnButton from '@/components/return-button/ReturnButton.vue'

export default defineComponent({
  name: 'AsideCountryListView',
  
  components: {
    CountryItem,
    SectionTitle,
    ReturnButton
  },
  
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
  padding-left: var(--spacing-md);
  padding-right: 0;
}

/* Styles pour la liste des pays */
.country-list {
  list-style: none;
  padding: 0;
  margin: 0;
}
</style> 