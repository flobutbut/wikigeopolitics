<template>
  <div class="aside__navigation-view">
    <div class="aside__section">
      <ReturnButton @click="returnToPreviousView" />
      
      <SectionTitle :level="1" size="large">{{ currentView.title }}</SectionTitle>
      
      <!-- Vue de sous-menu standard -->
      <template v-if="currentView.type === 'submenu'">
        <ul class="aside__menu">
          <MenuItem
            v-for="item in filteredItems"
            :key="item.id"
            :title="item.title"
            @click="navigateToDetail(item.id)"
          />
        </ul>
        
        <!-- Affichage spécial pour les organisations -->
        <div v-if="currentView.organizations" class="organizations-list">
          <div 
            v-for="org in filteredOrganizations" 
            :key="org.id"
            class="organization-item"
            @click="selectOrganization(org.id)"
          >
            {{ org.title }}
          </div>
        </div>
      </template>
      
      <!-- Vue de liste de pays -->
      <template v-if="currentView.type === 'countryList'">
        <!-- Vue simple pour les pays par régime politique -->
        <template v-if="currentView.id && currentView.id.startsWith('regime-')">
          <ul class="aside__menu">
            <MenuItem
              v-for="country in countriesByRegime"
              :key="country.id"
              :title="country.title"
              :selected="isCountrySelected(country.id)"
              @click="selectCountry(country.id)"
            >
              <template #prepend>
                <span class="country-flag">{{ country.flag }}</span>
              </template>
            </MenuItem>
          </ul>
        </template>
        
        <!-- Vue avec classification par continent pour la liste générale des pays -->
        <template v-else>
          <div v-for="c in continentOrder" :key="c.key" class="continent-section" v-show="continents[c.key] && continents[c.key].length > 0">
            <SectionTitle level="2" size="default">{{ c.label }}</SectionTitle>
            <ul class="aside__menu">
              <MenuItem
                v-for="country in continents[c.key]"
                :key="country.id"
                :title="country.title"
                :selected="isCountrySelected(country.id)"
                @click="selectCountry(country.id)"
              >
                <template #prepend>
                  <span class="country-flag">{{ country.flag }}</span>
                </template>
              </MenuItem>
            </ul>
          </div>
        </template>
      </template>

      <!-- Vue de liste de régimes politiques -->
      <template v-if="currentView.type === 'politicalRegimeList'">
        <ul class="aside__menu">
          <MenuItem
            v-for="regime in filteredPoliticalRegimes"
            :key="regime.id"
            :title="regime.name"
            :selected="isPoliticalRegimeSelected(regime.id)"
            @click="selectPoliticalRegime(regime.id)"
          >
            <template #prepend>
              <span class="regime-icon">🏛️</span>
            </template>
          </MenuItem>
        </ul>
      </template>

      <!-- Vue de liste d'organisations -->
      <template v-if="currentView.type === 'organizationsList'">
        <div v-for="(organizations, type) in organizationsByType" :key="type" class="organization-type-section">
          <SectionTitle :level="2" size="default">{{ type }}</SectionTitle>
          <ul class="aside__menu">
            <MenuItem
              v-for="org in organizations"
              :key="org.id"
              :title="org.title"
              :selected="isOrganizationSelected(org.id)"
              @click="selectOrganization(org.id)"
            >
              <template #prepend>
                <span class="organization-icon">🏢</span>
              </template>
            </MenuItem>
          </ul>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import { defineComponent, computed } from 'vue'
import MenuItem from '@/components/common/MenuItem.vue'
import SectionTitle from '@/components/common/SectionTitle.vue'
import ReturnButton from '@/components/navigation/ReturnButton.vue'
import { useAsideStore } from '@/stores/asideStore'
import { useCountrySelectionStore } from '@/stores/countrySelectionStore'

export default defineComponent({
  name: 'AsideNavigationView',
  
  components: {
    MenuItem,
    SectionTitle,
    ReturnButton
  },
  
  setup() {
    const asideStore = useAsideStore()
    const countryStore = useCountrySelectionStore()
    
    // Vue actuelle
    const currentView = computed(() => asideStore.currentView)
    
    // Getters pour les sélections
    const isCountrySelected = (countryId) => asideStore.isCountrySelected(countryId)
    const isOrganizationSelected = (orgId) => asideStore.isOrganizationSelected(orgId)
    const isPoliticalRegimeSelected = (regimeId) => asideStore.isPoliticalRegimeSelected(regimeId)
    
    // Éléments filtrés
    const filteredItems = computed(() => {
      if (!currentView.value || !currentView.value.items) return []
      
      if (!asideStore.searchQuery) {
        return currentView.value.items
      }
      
      const query = asideStore.searchQuery.toLowerCase()
      return currentView.value.items.filter(item => 
        item.title.toLowerCase().includes(query)
      )
    })
    
    // Organisations filtrées
    const filteredOrganizations = computed(() => {
      if (!currentView.value || !currentView.value.organizations) return []
      
      if (!asideStore.searchQuery) {
        return currentView.value.organizations
      }
      
      const query = asideStore.searchQuery.toLowerCase()
      return currentView.value.organizations.filter(org => 
        org.title.toLowerCase().includes(query)
      )
    })

    // Régimes politiques filtrés
    const filteredPoliticalRegimes = computed(() => {
      if (!asideStore.appData.politicalRegimeList) {
        return []
      }
      
      if (!asideStore.searchQuery) {
        return asideStore.appData.politicalRegimeList
      }
      
      const query = asideStore.searchQuery.toLowerCase()
      const filtered = asideStore.appData.politicalRegimeList.filter(regime => 
        regime.name.toLowerCase().includes(query) || 
        regime.description?.toLowerCase().includes(query)
      )
      return filtered
    })
    
    // Pays par régime politique (pour la vue simple)
    const countriesByRegime = computed(() => {
      console.log('AsideNavigationView: countriesByRegime computed')
      console.log('AsideNavigationView: appData.countryList:', asideStore.appData.countryList)
      console.log('AsideNavigationView: appData.countryList.length:', asideStore.appData.countryList?.length || 0)
      return asideStore.appData.countryList || []
    })
    
    // Organisations classées par type
    const organizationsByType = computed(() => {
      if (!asideStore.appData.organizationList) {
        return {}
      }
      
      const organizations = asideStore.appData.organizationList
      
      if (!asideStore.searchQuery) {
        return organizations
      }
      
      const query = asideStore.searchQuery.toLowerCase()
      const filtered = {}
      
      Object.keys(organizations).forEach(type => {
        const filteredOrgs = organizations[type].filter(org => 
          org.title.toLowerCase().includes(query) ||
          org.description?.toLowerCase().includes(query)
        )
        if (filteredOrgs.length > 0) {
          filtered[type] = filteredOrgs
        }
      })
      
      return filtered
    })
    
    // Continents pour la classification des pays
    const continents = computed(() => {
      if (!asideStore.filteredCountries) return {}
      
      const result = {}
      
      asideStore.filteredCountries.forEach(country => {
        const continent = country.continent || 'Autres'
        if (!result[continent]) {
          result[continent] = []
        }
        result[continent].push(country)
      })
      
      return result
    })
    
    // Ordre des continents
    const continentOrder = [
      { key: 'Europe', label: 'Europe' },
      { key: 'Asie', label: 'Asie' },
      { key: 'Afrique', label: 'Afrique' },
      { key: 'Amérique du Nord', label: 'Amérique du Nord' },
      { key: 'Amérique du Sud', label: 'Amérique du Sud' },
      { key: 'Océanie', label: 'Océanie' },
      { key: 'Autres', label: 'Autres' }
    ]
    
    // Méthodes de navigation
    const returnToPreviousView = () => {
      asideStore.returnToPreviousView()
    }
    
    const navigateToDetail = (id) => {
      asideStore.navigateToDetail(id)
    }
    
    const selectCountry = (id) => {
      console.log('Country selected in AsideNavigationView:', id)
      countryStore.selectCountry(id)
      asideStore.selectCountry(id)
    }
    
    const selectOrganization = (id) => {
      console.log('Organization selected in AsideNavigationView:', id)
      asideStore.selectOrganization(id)
    }
    
    const selectPoliticalRegime = (id) => {
      console.log('Political regime selected in AsideNavigationView:', id)
      asideStore.selectPoliticalRegime(id)
    }
    
    return {
      currentView,
      filteredItems,
      filteredOrganizations,
      filteredPoliticalRegimes,
      countriesByRegime,
      organizationsByType,
      continents,
      continentOrder,
      isCountrySelected,
      isOrganizationSelected,
      isPoliticalRegimeSelected,
      returnToPreviousView,
      navigateToDetail,
      selectCountry,
      selectOrganization,
      selectPoliticalRegime
    }
  }
})
</script>

<style scoped>
.aside__navigation-view {
  /* Supprimer les paddings spécifiques */
}

.aside__menu {
  list-style: none;
  padding: 0;
  margin: 0;
}

/* Styles pour la liste des organisations */
.organizations-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: var(--spacing-xs);
  padding: 0;
}

.organization-item {
  padding: var(--spacing-xs);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-xs);
  text-align: center;
  cursor: pointer;
  transition: background-color var(--transition-speed) var(--transition-function);
}

.organization-item:hover {
  background-color: var(--surface-hover);
}

/* Style pour chaque section de continent */
.continent-section {
  margin-bottom: var(--spacing-md);
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
  padding: var(--spacing-xs) 0;
  cursor: pointer;
  transition: color var(--transition-speed) var(--transition-function);
}

.country-item:hover {
  color: var(--primary-color);
}

.country-flag {
  margin-right: var(--spacing-xs);
  font-size: var(--font-size-md);
}

.country-name {
  font-size: var(--font-size-sm);
}

.regime-icon {
  margin-right: var(--spacing-xs);
  font-size: var(--font-size-md);
}

.organization-icon {
  margin-right: var(--spacing-xs);
  font-size: var(--font-size-md);
}

.organization-type-section {
  margin-bottom: var(--spacing-md);
}
</style> 