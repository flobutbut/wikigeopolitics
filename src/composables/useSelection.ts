/**
 * Composable pour gérer les sélections (pays, organisations, régimes, conflits)
 */

import { ref, computed, readonly } from 'vue'
import { useMapStore } from '@/stores/mapStore'

export type SelectionType = 'country' | 'organization' | 'politicalRegime' | 'armedConflict'

export interface SelectionState {
  selectedCountries: string[]
  selectedOrganization: string | null
  selectedPoliticalRegime: string | null
  selectedArmedConflict: string | null
}

export interface SelectionData {
  currentSelection: SelectionType | null
  hasSelection: boolean
  selectedCount: number
}

export interface SelectionActions {
  selectCountry: (id: string) => void
  selectMultipleCountries: (ids: string[]) => void
  toggleCountrySelection: (id: string) => void
  selectOrganization: (id: string) => void
  selectPoliticalRegime: (id: string) => void
  selectArmedConflict: (id: string) => void
  clearSelection: (type?: SelectionType) => void
  clearAllSelections: () => void
  isSelected: (type: SelectionType, id: string) => boolean
}

/**
 * Hook pour gérer toutes les sélections de l'application
 */
export function useSelection(): SelectionState & SelectionData & SelectionActions {
  // État des sélections
  const selectedCountries = ref<string[]>([])
  const selectedOrganization = ref<string | null>(null)
  const selectedPoliticalRegime = ref<string | null>(null)
  const selectedArmedConflict = ref<string | null>(null)

  // Computed pour les données dérivées
  const currentSelection = computed<SelectionType | null>(() => {
    if (selectedCountries.value.length > 0) return 'country'
    if (selectedOrganization.value) return 'organization'
    if (selectedPoliticalRegime.value) return 'politicalRegime'
    if (selectedArmedConflict.value) return 'armedConflict'
    return null
  })

  const hasSelection = computed(() => {
    return selectedCountries.value.length > 0 ||
           selectedOrganization.value !== null ||
           selectedPoliticalRegime.value !== null ||
           selectedArmedConflict.value !== null
  })

  const selectedCount = computed(() => {
    let count = selectedCountries.value.length
    if (selectedOrganization.value) count++
    if (selectedPoliticalRegime.value) count++
    if (selectedArmedConflict.value) count++
    return count
  })

  // Actions de sélection
  function selectCountry(id: string): void {
    clearNonCountrySelections()
    selectedCountries.value = [id]
    updateMapSelection()
  }

  function selectMultipleCountries(ids: string[]): void {
    clearNonCountrySelections()
    selectedCountries.value = [...ids]
    updateMapSelection()
  }

  function toggleCountrySelection(id: string): void {
    clearNonCountrySelections()
    const index = selectedCountries.value.indexOf(id)
    
    if (index === -1) {
      selectedCountries.value.push(id)
    } else {
      selectedCountries.value.splice(index, 1)
    }
    
    updateMapSelection()
  }

  function selectOrganization(id: string): void {
    clearAllSelections()
    selectedOrganization.value = id
  }

  function selectPoliticalRegime(id: string): void {
    clearAllSelections()
    selectedPoliticalRegime.value = id
  }

  function selectArmedConflict(id: string): void {
    clearAllSelections()
    selectedArmedConflict.value = id
  }

  function clearSelection(type?: SelectionType): void {
    if (!type) {
      clearAllSelections()
      return
    }

    switch (type) {
      case 'country':
        selectedCountries.value = []
        break
      case 'organization':
        selectedOrganization.value = null
        break
      case 'politicalRegime':
        selectedPoliticalRegime.value = null
        break
      case 'armedConflict':
        selectedArmedConflict.value = null
        break
    }
    
    updateMapSelection()
  }

  function clearAllSelections(): void {
    selectedCountries.value = []
    selectedOrganization.value = null
    selectedPoliticalRegime.value = null
    selectedArmedConflict.value = null
    updateMapSelection()
  }

  function clearNonCountrySelections(): void {
    selectedOrganization.value = null
    selectedPoliticalRegime.value = null
    selectedArmedConflict.value = null
  }

  function isSelected(type: SelectionType, id: string): boolean {
    switch (type) {
      case 'country':
        return selectedCountries.value.includes(id)
      case 'organization':
        return selectedOrganization.value === id
      case 'politicalRegime':
        return selectedPoliticalRegime.value === id
      case 'armedConflict':
        return selectedArmedConflict.value === id
      default:
        return false
    }
  }

  // Synchroniser avec le store de la carte
  function updateMapSelection(): void {
    const mapStore = useMapStore()
    mapStore.selectMultipleCountries(selectedCountries.value)
  }

  return {
    // État (readonly pour l'extérieur)
    selectedCountries: readonly(selectedCountries),
    selectedOrganization: readonly(selectedOrganization),
    selectedPoliticalRegime: readonly(selectedPoliticalRegime),
    selectedArmedConflict: readonly(selectedArmedConflict),
    
    // Données dérivées
    currentSelection,
    hasSelection,
    selectedCount,
    
    // Actions
    selectCountry,
    selectMultipleCountries,
    toggleCountrySelection,
    selectOrganization,
    selectPoliticalRegime,
    selectArmedConflict,
    clearSelection,
    clearAllSelections,
    isSelected
  }
}

/**
 * Hook simplifié pour les sélections de pays uniquement
 */
export function useCountrySelection() {
  const selection = useSelection()
  
  return {
    selectedCountries: selection.selectedCountries,
    selectCountry: selection.selectCountry,
    selectMultipleCountries: selection.selectMultipleCountries,
    toggleCountrySelection: selection.toggleCountrySelection,
    clearCountrySelection: () => selection.clearSelection('country'),
    isCountrySelected: (id: string) => selection.isSelected('country', id),
    hasCountrySelection: computed(() => selection.selectedCountries.length > 0)
  }
}