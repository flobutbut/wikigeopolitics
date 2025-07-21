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
            <SectionTitle :level="2" size="default">{{ c.label }}</SectionTitle>
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
            :title="regime.nom"
            :selected="isPoliticalRegimeSelected(regime.id)"
            :badge-value="regime.country_count"
            :show-badge="true"
            badge-variant="secondary"
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
              :title="org.acronyme || org.title"
              :selected="isOrganizationSelected(org.id)"
              :badge-value="org.country_count"
              :show-badge="true"
              badge-variant="secondary"
              @click="selectOrganization(org.id)"
            >
              <template #prepend>
                <span class="organization-icon">🏢</span>
              </template>
            </MenuItem>
          </ul>
        </div>
      </template>

      <!-- Vue de liste des conflits armés -->
      <template v-if="currentView.type === 'armedConflictsList'">
        <ul class="aside__menu">
          <MenuItem
            v-for="conflict in filteredArmedConflicts"
            :key="conflict.id"
            :title="conflict.nom"
            :selected="isArmedConflictSelected(conflict.id)"
            @click="selectArmedConflict(conflict.id)"
          >
            <template #prepend>
              <span class="conflict-icon">⚔️</span>
            </template>
            <template #append>
              <span class="conflict-status" :class="conflict.status?.toLowerCase().replace(' ', '-')">
                {{ conflict.status || 'Inconnu' }}
              </span>
            </template>
          </MenuItem>
        </ul>
      </template>

      <!-- Vue de liste des ressources naturelles -->
      <template v-if="currentView.type === 'resourcesList'">
        <div v-for="(resources, category) in resourcesByCategory" :key="category" class="resource-category-section">
          <SectionTitle :level="2" size="default">{{ category }}</SectionTitle>
          <ul class="aside__menu">
            <MenuItem
              v-for="resource in resources"
              :key="resource.id"
              :title="resource.nom"
              :selected="isResourceSelected(resource.id)"
              :badge-value="resource.country_count"
              :show-badge="true"
              badge-variant="secondary"
              @click="selectResource(resource.id)"
            >
              <template #prepend>
                <span class="resource-icon">{{ getResourceIcon(category) }}</span>
              </template>
            </MenuItem>
          </ul>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import { defineComponent, computed, ref, watch, onMounted, toRef } from 'vue'
import MenuItem from '@/components/common/MenuItem.vue'
import SectionTitle from '@/components/common/SectionTitle.vue'
import ReturnButton from '@/components/navigation/ReturnButton.vue'
import { useAsideStore } from '@/stores/asideStore'
import { useSelectionSystem } from '@/stores/selectionSystem'
import { storeToRefs } from 'pinia'

export default defineComponent({
  name: 'AsideNavigationView',
  
  components: {
    MenuItem,
    SectionTitle,
    ReturnButton
  },
  
  setup() {
    const asideStore = useAsideStore()
    const selectionSystem = useSelectionSystem()
    
    // Extraire les refs réactives du selectionSystem
    const { selectedConflict, selectedResource } = storeToRefs(selectionSystem)
    
    // Vue actuelle
    const currentView = computed(() => {
      console.log('🔍 [AsideNavigationView] currentView computed:', asideStore.currentView)
      console.log('🔍 [AsideNavigationView] currentView.type:', asideStore.currentView?.type)
      return asideStore.currentView
    })
    
    // Getters pour les sélections - utiliser le nouveau système
    const isCountrySelected = (countryId) => selectionSystem.isCountrySelected(countryId)
    const isOrganizationSelected = (orgId) => selectionSystem.selectedOrganization === orgId
    const isPoliticalRegimeSelected = (regimeId) => selectionSystem.selectedRegime === regimeId
    
    // Fonction réactive pour la sélection des ressources
    const isResourceSelected = (resourceId) => {
      const isSelected = selectedResource.value === resourceId
      console.log(`🔍 AsideNav: Ressource ${resourceId} sélectionnée ?`, isSelected)
      return isSelected
    }
    
    // Computed pour la sélection actuelle des conflits armés - utilise la ref réactive
    const conflictSelectionMap = computed(() => {
      const selectedId = selectedConflict.value
      console.log(`🔍 AsideNav: Recalcul du conflictSelectionMap, selectedConflict:`, selectedId, 'type:', typeof selectedId)
      
      // Créer un objet qui mappe chaque conflit à son état de sélection
      const map = {}
      if (currentView.value.type === 'armedConflictsList' && currentView.value.items) {
        currentView.value.items.forEach(conflict => {
          // Assurer la comparaison en convertissant les deux en string
          const conflictIdStr = String(conflict.id)
          const selectedIdStr = String(selectedId)
          const isSelected = (conflictIdStr === selectedIdStr)
          
          console.log(`🔍 AsideNav: Comparaison conflit ${conflict.id} (${typeof conflict.id}) === ${selectedId} (${typeof selectedId}) = ${isSelected}`)
          map[conflict.id] = isSelected
        })
      }
      return map
    })
    
    // Fonction réactive pour la sélection des conflits armés
    const isArmedConflictSelected = (conflictId) => {
      const isSelected = conflictSelectionMap.value[conflictId] || false
      console.log(`🔍 AsideNav: Conflit ${conflictId} sélectionné ?`, isSelected)
      return isSelected
    }
    
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
        regime.nom.toLowerCase().includes(query) || 
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

    // Conflits armés filtrés
    const filteredArmedConflicts = computed(() => {
      if (!asideStore.appData.armedConflictList) {
        return []
      }
      
      if (!asideStore.searchQuery) {
        return asideStore.appData.armedConflictList
      }
      
      const query = asideStore.searchQuery.toLowerCase()
      const filtered = asideStore.appData.armedConflictList.filter(conflict => 
        conflict.nom.toLowerCase().includes(query) || 
        conflict.description?.toLowerCase().includes(query) ||
        conflict.type?.toLowerCase().includes(query)
      )
      return filtered
    })

    // Ressources classées par catégorie
    const resourcesByCategory = computed(() => {
      console.log('🔍 [AsideNavigationView] resourcesByCategory computed')
      console.log('🔍 [AsideNavigationView] appData.resourceList:', asideStore.appData.resourceList)
      
      if (!asideStore.appData.resourceList) {
        console.log('❌ [AsideNavigationView] Pas de resourceList dans appData')
        return {}
      }
      
      const resources = asideStore.appData.resourceList
      console.log('📊 [AsideNavigationView] Nombre de catégories:', Object.keys(resources).length)
      console.log('📋 [AsideNavigationView] Catégories:', Object.keys(resources))
      
      // Filtrer les catégories à exclure (Agriculture et Ressource alimentaire)
      const excludedCategories = ['Agriculture', 'Ressource alimentaire']
      const filteredResources = {}
      
      Object.keys(resources).forEach(category => {
        if (!excludedCategories.includes(category)) {
          filteredResources[category] = resources[category]
        }
      })
      
      // Trier les catégories par ordre alphabétique
      const sortedCategories = Object.keys(filteredResources).sort((a, b) => a.localeCompare(b, 'fr'))
      
      // Créer un nouvel objet avec les catégories triées
      const sortedResources = {}
      sortedCategories.forEach(category => {
        sortedResources[category] = filteredResources[category]
      })
      
      if (!asideStore.searchQuery) {
        console.log('✅ [AsideNavigationView] Retour des ressources sans filtre (catégories exclues)')
        return sortedResources
      }
      
      const query = asideStore.searchQuery.toLowerCase()
      const filtered = {}
      
      Object.keys(sortedResources).forEach(category => {
        const filteredResourcesInCategory = sortedResources[category].filter(resource => 
          resource.nom.toLowerCase().includes(query) ||
          resource.description?.toLowerCase().includes(query) ||
          resource.categorie?.toLowerCase().includes(query)
        )
        if (filteredResourcesInCategory.length > 0) {
          filtered[category] = filteredResourcesInCategory
        }
      })
      
      console.log('🔍 [AsideNavigationView] Ressources filtrées:', filtered)
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
    const returnToPreviousView = async () => {
      // Si on retourne à la racine (pas de vue précédente), reset le système de sélection
      if (!asideStore.currentView?.previousView) {
        await selectionSystem.returnToRoot()
      }
      asideStore.returnToPreviousView()
    }
    
    const navigateToDetail = (id) => {
      asideStore.navigateToDetail(id)
    }
    
    const selectCountry = async (id) => {
      console.log('🏳️ Country selected in AsideNavigationView:', id)
      await selectionSystem.selectCountry(id, 'aside')
    }
    
    const selectOrganization = async (id) => {
      console.log('🏢 Organization selected in AsideNavigationView:', id)
      await selectionSystem.selectEntity('organization', id, 'aside')
    }
    
    const selectPoliticalRegime = async (id) => {
      console.log('⚖️ Political regime selected in AsideNavigationView:', id)
      await selectionSystem.selectEntity('regime', id, 'aside')
    }

    const selectArmedConflict = async (id) => {
      console.log('🎯 Armed conflict selected in AsideNavigationView:', id)
      await selectionSystem.selectConflict(id, 'aside')
    }

    const selectResource = async (id) => {
      console.log('💎 Resource selected in AsideNavigationView:', id)
      await selectionSystem.selectEntity('resource', id, 'aside')
    }
    
    // Fonction pour obtenir l'icône selon la catégorie
    const getResourceIcon = (category) => {
      const iconMap = {
        'Métaux': '🔩',
        'Métaux précieux': '🥇',
        'Métaux rares': '🔋',
        'Minéral': '⛏️',
        'Pierre précieuse': '💎',
        'Énergie': '⚡',
        'Énergie fossile': '🛢️',
        'Énergie nucléaire': '☢️',
        'Ressource renouvelable': '🌱',
        'Ressource vitale': '💧',
        'Ressource alimentaire': '🍽️'
      }
      return iconMap[category] || '💎'
    }
    
    // Watcher pour écouter les changements de sélection de conflit avec la ref réactive
    watch(selectedConflict, (newConflictId, oldConflictId) => {
      console.log('🔍 AsideNav: Changement de sélection conflit (via storeToRefs):', oldConflictId, '->', newConflictId)
      console.log('🔍 AsideNav: Vue actuelle:', currentView.value.type)
      
      // Force le re-render des éléments de la liste si on est dans armedConflictsList
      if (currentView.value.type === 'armedConflictsList' && newConflictId) {
        console.log('🔍 AsideNav: Dans la vue conflits, forçage du refresh')
        // La réactivité de Vue devrait automatiquement mettre à jour l'état selected
      }
    })

    // Watcher pour écouter les changements de sélection de ressource avec la ref réactive
    watch(selectedResource, (newResourceId, oldResourceId) => {
      console.log('🔍 AsideNav: Changement de sélection ressource (via storeToRefs):', oldResourceId, '->', newResourceId)
      console.log('🔍 AsideNav: Vue actuelle:', currentView.value.type)
      
      // Force le re-render des éléments de la liste si on est dans resourcesList
      if (currentView.value.type === 'resourcesList' && newResourceId) {
        console.log('🔍 AsideNav: Dans la vue ressources, forçage du refresh')
        // La réactivité de Vue devrait automatiquement mettre à jour l'état selected
      }
    })

    return {
      currentView,
      filteredItems,
      filteredOrganizations,
      filteredPoliticalRegimes,
      filteredArmedConflicts,
      resourcesByCategory,
      countriesByRegime,
      organizationsByType,
      continents,
      continentOrder,
      isCountrySelected,
      isOrganizationSelected,
      isPoliticalRegimeSelected,
      isArmedConflictSelected,
      isResourceSelected,
      returnToPreviousView,
      navigateToDetail,
      selectCountry,
      selectOrganization,
      selectPoliticalRegime,
      selectArmedConflict,
      selectResource,
      getResourceIcon
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

.conflict-icon {
  margin-right: var(--spacing-xs);
  font-size: var(--font-size-md);
}

.conflict-status {
  font-size: var(--font-size-xs);
  padding: 2px 6px;
  border-radius: var(--radius-xs);
  font-weight: 500;
  background-color: var(--surface-dimmed);
  color: var(--text-secondary);
}

.conflict-status.en-cours {
  background-color: rgba(239, 68, 68, 0.1);
  color: #ef4444;
}

.conflict-status.terminé {
  background-color: rgba(34, 197, 94, 0.1);
  color: #22c55e;
}

.conflict-status.suspendu {
  background-color: rgba(251, 191, 36, 0.1);
  color: #fbbf24;
}

.organization-type-section {
  margin-bottom: var(--spacing-md);
}

.resource-category-section {
  margin-bottom: var(--spacing-md);
}

.resource-icon {
  margin-right: var(--spacing-xs);
  font-size: var(--font-size-md);
}
</style> 