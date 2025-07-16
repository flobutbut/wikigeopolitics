/**
 * Composable pour gérer la navigation et l'historique
 */

import { ref, computed, readonly } from 'vue'

export interface NavigationState {
  type: string
  id: string
  title: string
  searchEnabled: boolean
  hasReturnButton: boolean
  items: any[]
  organizations: any[] | null
  data?: any
}

export interface NavigationData {
  canGoBack: boolean
  canGoForward: boolean
  historyLength: number
  currentIndex: number
}

export interface NavigationActions {
  push: (state: NavigationState) => void
  pop: () => NavigationState | null
  replace: (state: NavigationState) => void
  goBack: () => NavigationState | null
  goForward: () => NavigationState | null
  goToIndex: (index: number) => NavigationState | null
  clear: () => void
  getCurrentState: () => NavigationState | null
}

/**
 * Hook pour gérer la navigation avec historique
 */
export function useNavigation(): NavigationData & NavigationActions {
  // Historique de navigation
  const history = ref<NavigationState[]>([])
  const currentIndex = ref(-1)

  // État initial (page principale)
  const initialState: NavigationState = {
    type: 'main',
    id: 'main',
    title: '',
    searchEnabled: true,
    hasReturnButton: false,
    items: [],
    organizations: null
  }

  // Initialiser avec l'état principal
  if (history.value.length === 0) {
    history.value.push(initialState)
    currentIndex.value = 0
  }

  // Computed properties
  const canGoBack = computed(() => currentIndex.value > 0)
  const canGoForward = computed(() => currentIndex.value < history.value.length - 1)
  const historyLength = computed(() => history.value.length)

  /**
   * Ajouter un nouvel état à l'historique
   */
  function push(state: NavigationState): void {
    // Supprimer tous les états après l'index actuel (si on était revenu en arrière)
    if (currentIndex.value < history.value.length - 1) {
      history.value = history.value.slice(0, currentIndex.value + 1)
    }
    
    // Ajouter le nouvel état
    history.value.push({ ...state })
    currentIndex.value = history.value.length - 1
  }

  /**
   * Retirer le dernier état de l'historique
   */
  function pop(): NavigationState | null {
    if (history.value.length <= 1) return null
    
    const removedState = history.value.pop()
    currentIndex.value = Math.max(0, currentIndex.value - 1)
    
    return removedState || null
  }

  /**
   * Remplacer l'état actuel
   */
  function replace(state: NavigationState): void {
    if (history.value.length === 0) {
      push(state)
    } else {
      history.value[currentIndex.value] = { ...state }
    }
  }

  /**
   * Aller à l'état précédent
   */
  function goBack(): NavigationState | null {
    if (!canGoBack.value) return null
    
    currentIndex.value--
    return getCurrentState()
  }

  /**
   * Aller à l'état suivant
   */
  function goForward(): NavigationState | null {
    if (!canGoForward.value) return null
    
    currentIndex.value++
    return getCurrentState()
  }

  /**
   * Aller à un index spécifique
   */
  function goToIndex(index: number): NavigationState | null {
    if (index < 0 || index >= history.value.length) return null
    
    currentIndex.value = index
    return getCurrentState()
  }

  /**
   * Vider l'historique
   */
  function clear(): void {
    history.value = [initialState]
    currentIndex.value = 0
  }

  /**
   * Obtenir l'état actuel
   */
  function getCurrentState(): NavigationState | null {
    if (currentIndex.value < 0 || currentIndex.value >= history.value.length) {
      return null
    }
    
    return history.value[currentIndex.value]
  }

  return {
    // Données (readonly)
    canGoBack,
    canGoForward,
    historyLength,
    currentIndex: readonly(currentIndex),
    
    // Actions
    push,
    pop,
    replace,
    goBack,
    goForward,
    goToIndex,
    clear,
    getCurrentState
  }
}

/**
 * Hook simplifié pour la navigation basique (sans historique complet)
 */
export function useSimpleNavigation() {
  const currentState = ref<NavigationState | null>(null)
  const previousState = ref<NavigationState | null>(null)

  function navigateTo(state: NavigationState): void {
    previousState.value = currentState.value
    currentState.value = { ...state }
  }

  function goBack(): NavigationState | null {
    if (!previousState.value) return null
    
    const temp = currentState.value
    currentState.value = previousState.value
    previousState.value = temp
    
    return currentState.value
  }

  function reset(): void {
    currentState.value = null
    previousState.value = null
  }

  return {
    currentState: readonly(currentState),
    previousState: readonly(previousState),
    canGoBack: computed(() => previousState.value !== null),
    navigateTo,
    goBack,
    reset
  }
}