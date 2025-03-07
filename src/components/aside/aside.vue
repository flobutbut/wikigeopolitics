<template>
  <aside class="aside">
    <Search 
      v-if="currentView.searchEnabled !== false"
      @search="handleSearch" 
      :placeholder="searchPlaceholder"
    />

    <!-- Vue principale -->
    <template v-if="currentView.type === 'main'">
      <div v-for="category in filteredNavigation" :key="category.id" class="aside__section">
        <h2 class="aside__section-title">{{ category.title }}</h2>
        
        <!-- Toggles pour les options (comme dans "Tous les pays") -->
        <div v-if="category.toggleOptions" class="aside__toggles">
          <div v-for="option in category.toggleOptions" :key="option.id" class="toggle-item">
            <label class="switch-label">
              <span class="toggle-title">{{ option.title }}</span>
              <input 
                type="checkbox" 
                v-model="option.enabled"
                @change="handleToggleOption(option)"
                class="switch-input"
              >
              <span class="switch-slider"></span>
            </label>
          </div>
        </div>
        
        <!-- Éléments de menu standard -->
        <ul v-if="category.items" class="aside__menu">
          <MenuItem
            v-for="item in category.items"
            :key="item.id"
            :title="item.title"
            :has-children="item.hasSubmenu"
            @click="navigateToSubmenu(item.id)"
          />
        </ul>
      </div>
    </template>

    <!-- Vue de sous-menu -->
    <template v-else-if="currentView.type === 'submenu'">
      <div class="aside__section">
        <div v-if="currentView.hasReturnButton" class="return-button" @click="returnToMainView">
          <span class="return-icon">←</span> Retour
        </div>
        
        <h2 class="aside__section-title">{{ currentView.title }}</h2>
        
        <ul class="aside__menu">
          <MenuItem
            v-for="item in filteredItems"
            :key="item.id"
            :title="item.title"
            @click="navigateToDetail(item.id)"
          />
        </ul>
        
        <!-- Affichage spécial pour les organisations (comme dans accords-de-libre-echanges) -->
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
      </div>
    </template>

    <!-- Vue de liste de pays -->
    <template v-else-if="currentView.type === 'countryList'">
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
  </aside>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import MenuItem from '@components/menu-item/menu-item.vue'
import Search from '@components/search/search.vue'
import { useAsideStore } from '@/stores/asideStore'

// Utiliser le store Pinia
const asideStore = useAsideStore()

// Computed pour le placeholder de recherche
const searchPlaceholder = computed(() => asideStore.searchPlaceholder)

// Filtrer les éléments de navigation en fonction de la recherche
const filteredNavigation = computed(() => asideStore.filteredNavigation)

// Filtrer les éléments du sous-menu actuel
const filteredItems = computed(() => asideStore.filteredItems)

// Filtrer les organisations
const filteredOrganizations = computed(() => asideStore.filteredOrganizations)

// Filtrer les pays
const filteredCountries = computed(() => asideStore.filteredCountries)

// Vue actuelle
const currentView = computed(() => asideStore.currentView)

// Navigation vers un sous-menu
const navigateToSubmenu = (id: string) => {
  asideStore.navigateToSubmenu(id)
}

// Retour à la vue principale
const returnToMainView = () => {
  asideStore.returnToMainView()
}

// Navigation vers un détail
const navigateToDetail = (id: string) => {
  asideStore.navigateToDetail(id)
}

// Sélection d'un pays
const selectCountry = (id: string) => {
  asideStore.selectCountry(id)
}

// Sélection d'une organisation
const selectOrganization = (id: string) => {
  asideStore.selectOrganization(id)
}

// Gestion de la recherche
const handleSearch = (query: string) => {
  asideStore.setSearchQuery(query)
}

const handleToggleOption = (option: { id: string, enabled: boolean }) => {
  asideStore.handleToggleOption(option)
}
</script>

<style scoped>
.aside {
  position: fixed;
  left: 0;
  top: var(--header-height);
  height: calc(100vh - var(--header-height));
  background-color: var(--surface-color);
  box-shadow: var(--shadow-sm);
  width: var(--aside-width);
  overflow-y: auto;
  z-index: 1000;
  padding: var(--spacing-sm);
}

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

.aside__menu {
  list-style: none;
  padding: 0;
  margin: 0;
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

.toggle-item {
  margin-bottom: var(--spacing-xs);
}

.toggle-title {
  font-size: var(--font-size-sm);
  color: var(--text-color);
}

.switch-label {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-xs) var(--spacing-sm);
  cursor: pointer;
}

/* Styles pour le switch */
.switch-input {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

.switch-slider {
  position: relative;
  display: inline-block;
  width: 32px;
  height: 16px;
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-full);
  transition: background-color var(--transition-speed) var(--transition-function);
}

.switch-slider:before {
  position: absolute;
  content: "";
  height: 12px;
  width: 12px;
  left: 2px;
  bottom: 2px;
  background-color: var(--surface-color);
  border-radius: 50%;
  transition: transform var(--transition-speed) var(--transition-function);
}

.switch-input:checked + .switch-slider {
  background-color: var(--primary-color);
}

.switch-input:checked + .switch-slider:before {
  transform: translateX(16px);
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

/* Styles pour la liste des organisations */
.organizations-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: var(--spacing-xs);
  padding: var(--spacing-xs);
}

.organization-item {
  padding: var(--spacing-xs) var(--spacing-sm);
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
</style> 