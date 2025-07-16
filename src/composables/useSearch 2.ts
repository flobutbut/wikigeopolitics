/**
 * Composable pour gérer la recherche et le filtrage
 */

import { ref, computed, watch, readonly } from 'vue'
import { 
  createSearchFilter, 
  filterCountries, 
  filterOrganizations, 
  filterPoliticalRegimes, 
  filterArmedConflicts,
  filterNavigation,
  type Filterable 
} from '@/utils/filterUtils'

export interface SearchState {
  query: string
  isActive: boolean
}

export interface SearchActions {
  setQuery: (query: string) => void
  clearQuery: () => void
  toggle: () => void
}

export interface FilteredData<T> {
  original: T[]
  filtered: T[]
  count: number
  hasResults: boolean
}

/**
 * Hook pour gérer la recherche générique
 */
export function useSearch<T extends Filterable>(
  items: () => T[],
  fields: (keyof T)[] = ['title', 'name']
): SearchState & SearchActions & { results: FilteredData<T> } {
  const query = ref('')
  const isActive = computed(() => query.value.trim().length > 0)

  const results = computed<FilteredData<T>>(() => {
    const original = items()
    const filtered = createSearchFilter(original, query.value, fields)
    
    return {
      original,
      filtered,
      count: filtered.length,
      hasResults: filtered.length > 0
    }
  })

  function setQuery(newQuery: string): void {
    query.value = newQuery
  }

  function clearQuery(): void {
    query.value = ''
  }

  function toggle(): void {
    if (isActive.value) {
      clearQuery()
    }
  }

  return {
    // État
    query: readonly(query),
    isActive,
    
    // Actions
    setQuery,
    clearQuery,
    toggle,
    
    // Résultats
    results
  }
}

/**
 * Hook spécialisé pour la recherche de pays
 */
export function useCountrySearch<T extends { title?: string, flag?: string, continent?: string }>(
  countries: () => T[]
) {
  const query = ref('')
  const isActive = computed(() => query.value.trim().length > 0)

  const results = computed<FilteredData<T>>(() => {
    const original = countries()
    const filtered = filterCountries(original, query.value)
    
    return {
      original,
      filtered,
      count: filtered.length,
      hasResults: filtered.length > 0
    }
  })

  function setQuery(newQuery: string): void {
    query.value = newQuery
  }

  function clearQuery(): void {
    query.value = ''
  }

  return {
    query: readonly(query),
    isActive,
    results,
    setQuery,
    clearQuery
  }
}

/**
 * Hook spécialisé pour la recherche d'organisations
 */
export function useOrganizationSearch<T extends { title?: string, type?: string }>(
  organizations: () => T[]
) {
  const query = ref('')
  const isActive = computed(() => query.value.trim().length > 0)

  const results = computed<FilteredData<T>>(() => {
    const original = organizations()
    const filtered = filterOrganizations(original, query.value)
    
    return {
      original,
      filtered,
      count: filtered.length,
      hasResults: filtered.length > 0
    }
  })

  function setQuery(newQuery: string): void {
    query.value = newQuery
  }

  function clearQuery(): void {
    query.value = ''
  }

  return {
    query: readonly(query),
    isActive,
    results,
    setQuery,
    clearQuery
  }
}

/**
 * Hook pour la recherche avec debounce
 */
export function useDebouncedSearch<T extends Filterable>(
  items: () => T[],
  fields: (keyof T)[] = ['title', 'name'],
  delay: number = 300
): SearchState & SearchActions & { results: FilteredData<T> } {
  const immediateQuery = ref('')
  const debouncedQuery = ref('')
  
  let timeoutId: number | null = null

  // Debounce de la query
  watch(immediateQuery, (newQuery) => {
    if (timeoutId) {
      clearTimeout(timeoutId)
    }
    
    timeoutId = window.setTimeout(() => {
      debouncedQuery.value = newQuery
    }, delay)
  })

  const isActive = computed(() => debouncedQuery.value.trim().length > 0)

  const results = computed<FilteredData<T>>(() => {
    const original = items()
    const filtered = createSearchFilter(original, debouncedQuery.value, fields)
    
    return {
      original,
      filtered,
      count: filtered.length,
      hasResults: filtered.length > 0
    }
  })

  function setQuery(newQuery: string): void {
    immediateQuery.value = newQuery
  }

  function clearQuery(): void {
    immediateQuery.value = ''
    debouncedQuery.value = ''
    if (timeoutId) {
      clearTimeout(timeoutId)
      timeoutId = null
    }
  }

  function toggle(): void {
    if (isActive.value) {
      clearQuery()
    }
  }

  return {
    // État (on expose la query immédiate pour l'input)
    query: readonly(immediateQuery),
    isActive,
    
    // Actions
    setQuery,
    clearQuery,
    toggle,
    
    // Résultats (basés sur la query debouncée)
    results
  }
}

/**
 * Hook pour recherche multiple (plusieurs types d'entités)
 */
export function useMultiSearch() {
  const query = ref('')
  const isActive = computed(() => query.value.trim().length > 0)

  function createMultiFilter<T extends Filterable>(
    items: T[],
    filterFn?: (items: T[], query: string) => T[]
  ): FilteredData<T> {
    const original = items
    const filtered = filterFn ? filterFn(original, query.value) : createSearchFilter(original, query.value)
    
    return {
      original,
      filtered,
      count: filtered.length,
      hasResults: filtered.length > 0
    }
  }

  function setQuery(newQuery: string): void {
    query.value = newQuery
  }

  function clearQuery(): void {
    query.value = ''
  }

  return {
    query: readonly(query),
    isActive,
    setQuery,
    clearQuery,
    
    // Filtres spécialisés
    filterCountries: <T extends { title?: string, flag?: string, continent?: string }>(items: T[]) =>
      createMultiFilter(items, filterCountries),
    
    filterOrganizations: <T extends { title?: string, type?: string }>(items: T[]) =>
      createMultiFilter(items, filterOrganizations),
    
    filterPoliticalRegimes: <T extends { name?: string, description?: string }>(items: T[]) =>
      createMultiFilter(items, filterPoliticalRegimes),
    
    filterArmedConflicts: <T extends { name?: string, description?: string, status?: string }>(items: T[]) =>
      createMultiFilter(items, filterArmedConflicts),
    
    filterNavigation: <T extends { title?: string, items?: any[], toggleOptions?: any[] }>(items: T[]) =>
      createMultiFilter(items, filterNavigation)
  }
}