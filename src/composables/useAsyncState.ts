/**
 * Composable pour gérer l'état asynchrone (loading, data, error)
 */

import { ref, readonly, Ref } from 'vue'

export interface AsyncState<T> {
  data: Readonly<Ref<T | null>>
  isLoading: Readonly<Ref<boolean>>
  error: Readonly<Ref<string | null>>
}

export interface AsyncActions<T> {
  execute: (asyncFn: () => Promise<T>) => Promise<T | null>
  reset: () => void
  setData: (data: T) => void
  setError: (error: string) => void
}

export interface UseAsyncStateOptions {
  immediate?: boolean
  retryAttempts?: number
  retryDelay?: number
  onSuccess?: (data: any) => void
  onError?: (error: string) => void
}

/**
 * Hook pour gérer l'état d'une opération asynchrone
 */
export function useAsyncState<T>(
  asyncFn?: () => Promise<T>,
  options: UseAsyncStateOptions = {}
): AsyncState<T> & AsyncActions<T> {
  const {
    immediate = false,
    retryAttempts = 0,
    retryDelay = 1000,
    onSuccess,
    onError
  } = options

  const data = ref<T | null>(null)
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  /**
   * Exécuter la fonction asynchrone
   */
  async function execute(fn: () => Promise<T>): Promise<T | null> {
    let attempts = 0
    
    while (attempts <= retryAttempts) {
      try {
        isLoading.value = true
        error.value = null
        
        const result = await fn()
        
        data.value = result
        onSuccess?.(result)
        
        return result
      } catch (err) {
        attempts++
        
        if (attempts > retryAttempts) {
          const errorMessage = err instanceof Error ? err.message : 'Unknown error'
          error.value = errorMessage
          onError?.(errorMessage)
          return null
        }
        
        // Attendre avant de retry
        if (retryDelay > 0) {
          await new Promise(resolve => setTimeout(resolve, retryDelay))
        }
      } finally {
        if (attempts > retryAttempts) {
          isLoading.value = false
        }
      }
    }
    
    return null
  }

  /**
   * Réinitialiser l'état
   */
  function reset(): void {
    data.value = null
    isLoading.value = false
    error.value = null
  }

  /**
   * Définir les données manuellement
   */
  function setData(newData: T): void {
    data.value = newData
    error.value = null
  }

  /**
   * Définir une erreur manuellement
   */
  function setError(errorMessage: string): void {
    error.value = errorMessage
    data.value = null
  }

  // Exécution immédiate si demandée
  if (immediate && asyncFn) {
    execute(asyncFn)
  }

  return {
    // État en lecture seule
    data: readonly(data),
    isLoading: readonly(isLoading),
    error: readonly(error),
    
    // Actions
    execute,
    reset,
    setData,
    setError
  }
}

/**
 * Version simplifiée pour une seule requête
 */
export function useAsyncData<T>(
  asyncFn: () => Promise<T>,
  options: UseAsyncStateOptions = {}
): AsyncState<T> & { refresh: () => Promise<T | null> } {
  const state = useAsyncState<T>(asyncFn, { ...options, immediate: true })
  
  return {
    ...state,
    refresh: () => state.execute(asyncFn)
  }
}

/**
 * Hook pour gérer le cache avec l'état asynchrone
 */
export function useAsyncStateWithCache<T>(
  key: string,
  asyncFn: () => Promise<T>,
  options: UseAsyncStateOptions & { ttl?: number } = {}
): AsyncState<T> & AsyncActions<T> & { refresh: () => Promise<T | null> } {
  const { ttl = 5 * 60 * 1000, ...asyncOptions } = options // 5 minutes par défaut
  
  const state = useAsyncState<T>(undefined, asyncOptions)
  
  // Vérifier le cache
  const cachedData = sessionStorage.getItem(`async_cache_${key}`)
  if (cachedData) {
    try {
      const { data: cached, timestamp } = JSON.parse(cachedData)
      if (Date.now() - timestamp < ttl) {
        state.setData(cached)
      }
    } catch {
      // Ignorer les erreurs de parsing du cache
    }
  }

  async function executeWithCache(): Promise<T | null> {
    const result = await state.execute(asyncFn)
    
    if (result) {
      // Sauvegarder en cache
      sessionStorage.setItem(`async_cache_${key}`, JSON.stringify({
        data: result,
        timestamp: Date.now()
      }))
    }
    
    return result
  }

  // Charger initialement si pas de cache
  if (!state.data.value) {
    executeWithCache()
  }

  return {
    ...state,
    refresh: executeWithCache
  }
}