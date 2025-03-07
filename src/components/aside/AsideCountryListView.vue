<template>
  <div class="aside__section">
    <ReturnButton @click="returnToMainView" />
    
    <SectionTitle>Pays du monde</SectionTitle>
    
    <!-- Section Europe -->
    <div v-if="continents.europe.length > 0" class="continent-section">
      <SectionTitle size="small">Europe</SectionTitle>
      <ul class="country-list">
        <CountryItem
          v-for="country in continents.europe"
          :key="country.id"
          :country="country"
          @select="selectCountry"
        />
      </ul>
    </div>
    
    <!-- Section Asie -->
    <div v-if="continents.asia.length > 0" class="continent-section">
      <SectionTitle size="small">Asie</SectionTitle>
      <ul class="country-list">
        <CountryItem
          v-for="country in continents.asia"
          :key="country.id"
          :country="country"
          @select="selectCountry"
        />
      </ul>
    </div>
    
    <!-- Section Afrique -->
    <div v-if="continents.africa.length > 0" class="continent-section">
      <SectionTitle size="small">Afrique</SectionTitle>
      <ul class="country-list">
        <CountryItem
          v-for="country in continents.africa"
          :key="country.id"
          :country="country"
          @select="selectCountry"
        />
      </ul>
    </div>
    
    <!-- Section Amérique du Nord -->
    <div v-if="continents.northAmerica.length > 0" class="continent-section">
      <SectionTitle size="small">Amérique du Nord</SectionTitle>
      <ul class="country-list">
        <CountryItem
          v-for="country in continents.northAmerica"
          :key="country.id"
          :country="country"
          @select="selectCountry"
        />
      </ul>
    </div>
    
    <!-- Section Amérique du Sud -->
    <div v-if="continents.southAmerica.length > 0" class="continent-section">
      <SectionTitle size="small">Amérique du Sud</SectionTitle>
      <ul class="country-list">
        <CountryItem
          v-for="country in continents.southAmerica"
          :key="country.id"
          :country="country"
          @select="selectCountry"
        />
      </ul>
    </div>
    
    <!-- Section Océanie -->
    <div v-if="continents.oceania.length > 0" class="continent-section">
      <SectionTitle size="small">Océanie</SectionTitle>
      <ul class="country-list">
        <CountryItem
          v-for="country in continents.oceania"
          :key="country.id"
          :country="country"
          @select="selectCountry"
        />
      </ul>
    </div>
    
    <!-- Section Autres -->
    <div v-if="continents.other.length > 0" class="continent-section">
      <SectionTitle size="small">Autres</SectionTitle>
      <ul class="country-list">
        <CountryItem
          v-for="country in continents.other"
          :key="country.id"
          :country="country"
          @select="selectCountry"
        />
      </ul>
    </div>
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
    
    // Organiser les pays par continent
    const continents = computed(() => {
      const result = {
        europe: [],
        asia: [],
        africa: [],
        northAmerica: [],
        southAmerica: [],
        oceania: [],
        other: []
      }
      
      asideStore.filteredCountries.forEach(country => {
        const continent = country.continent || 'other'
        
        // Vérifier si le continent existe dans result, sinon utiliser 'other'
        if (result[continent]) {
          result[continent].push(country)
        } else {
          console.warn(`Continent inconnu "${continent}" pour le pays "${country.title}". Placé dans "Autres".`)
          result.other.push(country)
        }
      })
      
      // Trier les pays par ordre alphabétique dans chaque continent
      Object.keys(result).forEach(continent => {
        result[continent].sort((a, b) => a.title.localeCompare(b.title))
      })
      
      return result
    })
    
    return {
      continents,
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
  padding-right: var(--spacing-md);
}

/* Styles pour la liste des pays */
.country-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

/* Style pour chaque section de continent */
.continent-section {
  margin-bottom: var(--spacing-md);
}
</style> 