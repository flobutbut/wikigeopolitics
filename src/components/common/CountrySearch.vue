<template>
  <div class="country-search">
    <div class="search__wrapper">
      <input
        ref="searchInput"
        type="text"
        v-model="searchQuery"
        :placeholder="placeholder"
        class="search__input"
        @input="handleInput"
        @focus="showSuggestions = true"
        @keydown="handleKeydown"
        autocomplete="off"
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

    <!-- Suggestions dropdown -->
    <div 
      v-if="showSuggestions && (isLoading || filteredCountries.length > 0)" 
      class="suggestions"
    >
      <!-- Loading state -->
      <div v-if="isLoading" class="suggestion-item loading">
        <div class="loading-spinner"></div>
        <span>Recherche en cours...</span>
      </div>

      <!-- Country suggestions -->
      <div 
        v-else
        v-for="(country, index) in filteredCountries" 
        :key="country.id"
        :class="['suggestion-item', { 'highlighted': index === highlightedIndex }]"
        @click="selectCountry(country)"
        @mouseenter="highlightedIndex = index"
      >
        <div class="country-flag">
          <!-- Debug: voir le contenu du drapeau -->
          <!-- {{ country.drapeau ? `Drapeau: ${country.drapeau}` : 'Pas de drapeau' }} -->
          
          <!-- Si le drapeau est une URL (commence par http) -->
          <img 
            v-if="country.drapeau && (country.drapeau.startsWith('http') || country.drapeau.startsWith('/'))" 
            :src="country.drapeau" 
            :alt="`Drapeau ${country.nom}`"
            class="flag-image"
          >
          <!-- Si le drapeau est un emoji -->
          <div 
            v-else-if="country.drapeau && country.drapeau.length <= 4"
            class="flag-emoji"
          >
            {{ country.drapeau }}
          </div>
          <!-- Fallback -->
          <div v-else class="flag-placeholder">🏴</div>
        </div>
        <div class="country-info">
          <div class="country-name">{{ country.nom }}</div>
          <div class="country-details">
            <span class="population">{{ formatPopulation(country.population) }}</span>
            <span class="separator">•</span>
            <span class="regime">{{ country.regimePolitique || 'Régime non spécifié' }}</span>
          </div>
        </div>
      </div>

      <!-- No results -->
      <div v-if="!isLoading && searchQuery && filteredCountries.length === 0" class="suggestion-item no-results">
        <span>Aucun pays trouvé pour "{{ searchQuery }}"</span>
      </div>
    </div>

    <!-- Overlay to close suggestions -->
    <div 
      v-if="showSuggestions" 
      class="suggestions-overlay"
      @click="showSuggestions = false"
    ></div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { useAsideStore } from '@/stores/asideStore'
import { useSelectionSystem } from '@/stores/selectionSystem'
import { supabaseService } from '@/services/supabaseService'

interface Country {
  id: string
  nom: string
  population?: number
  drapeau?: string
  regimePolitique?: string
}

interface Props {
  placeholder?: string
  debounce?: number
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Rechercher un pays...',
  debounce: 300
})

const emit = defineEmits<{
  countrySelected: [country: Country]
}>()

// Refs
const searchInput = ref<HTMLInputElement>()
const searchQuery = ref('')
const showSuggestions = ref(false)
const highlightedIndex = ref(-1)
const isLoading = ref(false)
const countries = ref<Country[]>([])

// Stores
const asideStore = useAsideStore()
const selectionSystem = useSelectionSystem()

// Debounce timer
let debounceTimer: number | null = null

// Computed
const filteredCountries = computed(() => {
  if (!searchQuery.value || searchQuery.value.length < 2) return []
  
  const query = searchQuery.value.toLowerCase().trim()
  return countries.value
    .filter(country => 
      country.nom.toLowerCase().includes(query) ||
      country.nom.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').includes(query)
    )
    .slice(0, 8) // Limiter à 8 résultats
})

// Methods
const loadCountries = async () => {
  try {
    isLoading.value = true
    // Utiliser la méthode optimisée qui récupère pays + régimes en une seule requête
    const loadedCountries = await supabaseService.getCountriesWithRegimes()
    countries.value = loadedCountries
    
    // Debug pour voir la structure des données
    console.log('🔍 CountrySearch: Pays chargés:', loadedCountries.length)
    if (loadedCountries.length > 0) {
      console.log('🔍 CountrySearch: Premier pays:', loadedCountries[0])
      console.log('🔍 CountrySearch: Drapeau du premier pays:', loadedCountries[0].drapeau)
    }
  } catch (error) {
    console.error('Erreur chargement pays:', error)
    // Fallback vers la méthode basique
    try {
      const basicCountries = await supabaseService.getCountries()
      countries.value = basicCountries.map(country => ({
        id: country.id,
        nom: country.nom,
        population: country.population,
        drapeau: country.drapeau,
        regimePolitique: 'Non spécifié'
      }))
      
      // Debug pour le fallback
      console.log('🔍 CountrySearch: Fallback - Pays chargés:', countries.value.length)
      if (countries.value.length > 0) {
        console.log('🔍 CountrySearch: Fallback - Premier pays:', countries.value[0])
      }
    } catch (fallbackError) {
      console.error('Erreur chargement pays (fallback):', fallbackError)
    }
  } finally {
    isLoading.value = false
  }
}

const handleInput = () => {
  if (debounceTimer) {
    clearTimeout(debounceTimer)
  }
  
  debounceTimer = window.setTimeout(() => {
    if (searchQuery.value.length >= 2) {
      showSuggestions.value = true
      highlightedIndex.value = -1
    } else {
      showSuggestions.value = false
    }
  }, props.debounce)
}

const handleKeydown = (event: KeyboardEvent) => {
  if (!showSuggestions.value || filteredCountries.value.length === 0) return

  switch (event.key) {
    case 'ArrowDown':
      event.preventDefault()
      highlightedIndex.value = Math.min(
        highlightedIndex.value + 1,
        filteredCountries.value.length - 1
      )
      break
    case 'ArrowUp':
      event.preventDefault()
      highlightedIndex.value = Math.max(highlightedIndex.value - 1, -1)
      break
    case 'Enter':
      event.preventDefault()
      if (highlightedIndex.value >= 0) {
        selectCountry(filteredCountries.value[highlightedIndex.value])
      }
      break
    case 'Escape':
      showSuggestions.value = false
      highlightedIndex.value = -1
      searchInput.value?.blur()
      break
  }
}

const selectCountry = async (country: Country) => {
  console.log('🔍 CountrySearch: Sélection du pays:', country.nom, 'ID:', country.id)
  
  searchQuery.value = country.nom
  showSuggestions.value = false
  highlightedIndex.value = -1
  
  try {
    // Utiliser le système de sélection unifié qui ouvrira automatiquement le floating panel
    console.log('🔍 CountrySearch: Appel selectionSystem.selectCountry avec ID:', country.id)
    await selectionSystem.selectCountry(country.id, 'search')
    console.log('🔍 CountrySearch: Sélection terminée')
    
    // Émettre l'événement
    emit('countrySelected', country)
  } catch (error) {
    console.error('🔍 CountrySearch: Erreur lors de la sélection du pays:', error)
  }
  
  // Blur input
  await nextTick()
  searchInput.value?.blur()
}

const clearSearch = async () => {
  searchQuery.value = ''
  showSuggestions.value = false
  highlightedIndex.value = -1
  
  try {
    // Utiliser le système de sélection unifié pour tout réinitialiser
    console.log('🔍 CountrySearch: Reset du système de sélection')
    await selectionSystem.resetToInitial()
    console.log('🔍 CountrySearch: Reset terminé')
  } catch (error) {
    console.error('🔍 CountrySearch: Erreur lors du reset:', error)
  }
  
  searchInput.value?.focus()
}

const formatPopulation = (population?: number): string => {
  if (!population) return 'Population inconnue'
  
  if (population >= 1e9) {
    return `${(population / 1e9).toFixed(1)}Md hab.`
  } else if (population >= 1e6) {
    return `${(population / 1e6).toFixed(1)}M hab.`
  } else if (population >= 1e3) {
    return `${(population / 1e3).toFixed(0)}k hab.`
  } else {
    return `${population.toLocaleString()} hab.`
  }
}

// Click outside handler
const handleClickOutside = (event: Event) => {
  const target = event.target as Element
  if (!target.closest('.country-search')) {
    showSuggestions.value = false
  }
}

// Lifecycle
onMounted(() => {
  loadCountries()
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  if (debounceTimer) {
    clearTimeout(debounceTimer)
  }
  document.removeEventListener('click', handleClickOutside)
})

// Watch pour fermer les suggestions quand on sélectionne ailleurs
watch(() => asideStore.selectedCountryId, () => {
  showSuggestions.value = false
})
</script>

<style scoped>
.country-search {
  position: relative;
  width: 100%;
}

.search__wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.search__input {
  width: 100%;
  padding: 10px 40px 10px 16px;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  font-size: 14px;
  line-height: 1.4;
  color: var(--text-color);
  background-color: var(--surface-color);
  transition: all var(--transition-speed) var(--transition-function);
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.search__input:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(46, 67, 255, 0.1), 0 2px 4px rgba(0, 0, 0, 0.1);
  transform: translateY(-1px);
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

.suggestions {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15), 0 2px 8px rgba(0, 0, 0, 0.1);
  z-index: 1000;
  max-height: 320px;
  overflow-y: auto;
  margin-top: 4px;
  backdrop-filter: blur(10px);
}

.suggestion-item {
  display: flex;
  align-items: center;
  padding: var(--spacing-sm) var(--spacing-md);
  cursor: pointer;
  border-bottom: 1px solid var(--border-light);
  transition: background-color var(--transition-speed);
}

.suggestion-item:last-child {
  border-bottom: none;
}

.suggestion-item:hover,
.suggestion-item.highlighted {
  background-color: var(--surface-hover);
}

.suggestion-item.loading,
.suggestion-item.no-results {
  justify-content: center;
  cursor: default;
  color: var(--text-muted);
  font-style: italic;
}

.suggestion-item.loading {
  gap: var(--spacing-sm);
}

.country-flag {
  flex-shrink: 0;
  width: 24px;
  height: 18px;
  margin-right: var(--spacing-sm);
  display: flex;
  align-items: center;
  justify-content: center;
}

.flag-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 2px;
  border: 1px solid var(--border-light);
}

.flag-emoji {
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}

.flag-placeholder {
  font-size: 14px;
  color: var(--text-muted);
}

.country-info {
  flex: 1;
  min-width: 0;
}

.country-name {
  font-weight: var(--font-weight-medium);
  color: var(--text-dark);
  margin-bottom: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.country-details {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
  font-size: var(--font-size-xs);
  color: var(--text-muted);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.separator {
  color: var(--border-color);
}

.regime {
  overflow: hidden;
  text-overflow: ellipsis;
}

.suggestions-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 999;
}

.loading-spinner {
  width: 14px;
  height: 14px;
  border: 2px solid var(--border-color);
  border-top: 2px solid var(--primary-color);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Responsive */
@media (max-width: 768px) {
  .suggestions {
    left: -16px;
    right: -16px;
  }
  
  .country-details {
    font-size: 11px;
  }
  
  .country-name {
    font-size: var(--font-size-sm);
  }
}
</style>