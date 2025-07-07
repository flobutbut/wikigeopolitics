<template>
  <div class="aside__navigation-view">
    <div class="aside__section">
      <ReturnButton @click="returnToPreviousView" />
      
      <SectionTitle level="1" size="large">{{ currentView.title }}</SectionTitle>
      
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
        <div v-for="c in continentOrder" :key="c.key" class="continent-section" v-show="continents[c.key] && continents[c.key].length > 0">
          <SectionTitle level="2" size="default">{{ c.label }}</SectionTitle>
          <ul class="aside__menu">
            <MenuItem
              v-for="country in continents[c.key]"
              :key="country.id"
              :title="country.title"
              @click="selectCountry(country.id)"
            >
              <template #prepend>
                <span class="country-flag">{{ country.flag }}</span>
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
    
    // Mapping des clés internes vers les labels français
    const continentOrder = [
      { key: 'Europe', label: 'Europe' },
      { key: 'Asie', label: 'Asie' },
      { key: 'Afrique', label: 'Afrique' },
      { key: 'Amérique du Nord', label: 'Amérique du Nord' },
      { key: 'Amérique du Sud', label: 'Amérique du Sud' },
      { key: 'Océanie', label: 'Océanie' },
      { key: 'Autres', label: 'Autres' }
    ]
    
    // Organiser les pays par continent (français)
    const continents = computed(() => {
      const result = {
        'Europe': [],
        'Asie': [],
        'Afrique': [],
        'Amérique du Nord': [],
        'Amérique du Sud': [],
        'Océanie': [],
        'Autres': []
      }
      if (!asideStore.filteredCountries) return result
      asideStore.filteredCountries.forEach(country => {
        const continent = country.continent || 'Autres'
        if (result[continent]) {
          result[continent].push(country)
        } else {
          result['Autres'].push(country)
        }
      })
      // Trier les pays par ordre alphabétique dans chaque continent
      Object.keys(result).forEach(continent => {
        result[continent].sort((a, b) => a.title.localeCompare(b.title))
      })
      return result
    })
    
    // Retour à la vue précédente
    const returnToPreviousView = () => {
      // Vérifier si nous sommes dans la liste des pays
      if (currentView.value.type === 'countryList') {
        // Retourner directement à la vue principale
        asideStore.returnToMainView()
      } else {
        // Sinon, utiliser le comportement standard
        asideStore.returnToPreviousView()
      }
    }
    
    // Navigation vers un détail
    const navigateToDetail = (id) => {
      asideStore.navigateToDetail(id)
    }
    
    // Sélection d'un pays
    const selectCountry = (id) => {
      // Sélectionner le pays dans le store de sélection
      countryStore.selectCountry(id)
      
      // Charger les données du pays pour le panneau flottant
      asideStore.selectCountry(id)
    }
    
    // Sélection d'une organisation
    const selectOrganization = (id) => {
      asideStore.navigateToDetail(id)
    }
    
    return {
      currentView,
      filteredItems,
      filteredOrganizations,
      continents,
      continentOrder,
      returnToPreviousView,
      navigateToDetail,
      selectCountry,
      selectOrganization
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
</style> 