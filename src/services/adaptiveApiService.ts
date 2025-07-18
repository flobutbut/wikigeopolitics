// 🔄 Service adaptatif - Bascule entre API locale et Supabase
// Permet une migration progressive sans casser l'existant

import SupabaseService from './supabaseService'
import { getAllCountries as getLocalCountries } from './readService'
import type { Country } from '@/types/country'
import type { PoliticalRegime, Organization, ArmedConflict } from '@/types/supabase'

// Configuration basée sur les variables d'environnement
const USE_SUPABASE = import.meta.env.VITE_USE_SUPABASE === 'true'
const USE_LOCAL_API = import.meta.env.VITE_USE_LOCAL_API === 'true'

console.log('🔄 Service adaptatif:', { USE_SUPABASE, USE_LOCAL_API })

/**
 * Service unifié qui bascule automatiquement entre Supabase et l'API locale
 */
export class AdaptiveApiService {
  
  // ===== STRATÉGIE DE BASCULEMENT =====
  
  /**
   * Exécute une opération avec fallback automatique
   */
  private static async executeWithFallback<T>(
    supabaseOperation: () => Promise<T>,
    localOperation: () => Promise<T>,
    operationName: string
  ): Promise<T> {
    // Mode Supabase prioritaire
    if (USE_SUPABASE && !USE_LOCAL_API) {
      try {
        console.log(`📡 ${operationName} via Supabase`)
        return await supabaseOperation()
      } catch (error) {
        console.warn(`⚠️ ${operationName} Supabase failed, falling back to local:`, error)
        return await localOperation()
      }
    }
    
    // Mode local prioritaire
    if (USE_LOCAL_API && !USE_SUPABASE) {
      try {
        console.log(`🏠 ${operationName} via API locale`)
        return await localOperation()
      } catch (error) {
        console.warn(`⚠️ ${operationName} local failed, falling back to Supabase:`, error)
        return await supabaseOperation()
      }
    }
    
    // Mode double (développement) - priorité Supabase
    try {
      console.log(`📡 ${operationName} via Supabase (mode double)`)
      return await supabaseOperation()
    } catch (error) {
      console.warn(`⚠️ ${operationName} Supabase failed, trying local:`, error)
      return await localOperation()
    }
  }
  
  // ===== PAYS =====
  
  /**
   * Récupère tous les pays (avec fallback)
   */
  static async getAllCountries(): Promise<Country[]> {
    return this.executeWithFallback(
      () => SupabaseService.getAllCountries(),
      () => getLocalCountries(),
      'getAllCountries'
    )
  }
  
  /**
   * Récupère un pays par ID
   */
  static async getCountryById(id: string): Promise<Country | null> {
    return this.executeWithFallback(
      () => SupabaseService.getCountryById(id),
      async () => {
        // Fallback vers l'API locale (à adapter selon votre implémentation)
        const allCountries = await getLocalCountries()
        return allCountries.find(c => c.id === id) || null
      },
      'getCountryById'
    )
  }
  
  /**
   * Recherche de pays par nom
   */
  static async searchCountries(query: string): Promise<Country[]> {
    return this.executeWithFallback(
      () => SupabaseService.searchCountries(query),
      async () => {
        // Fallback vers recherche locale
        const allCountries = await getLocalCountries()
        return allCountries.filter(c => 
          c.title?.toLowerCase().includes(query.toLowerCase()) ||
          c.name?.toLowerCase().includes(query.toLowerCase())
        )
      },
      'searchCountries'
    )
  }
  
  // ===== RÉGIMES POLITIQUES =====
  
  /**
   * Récupère tous les régimes politiques
   */
  static async getAllPoliticalRegimes(): Promise<PoliticalRegime[]> {
    return this.executeWithFallback(
      () => SupabaseService.getAllPoliticalRegimes(),
      async () => {
        // TODO: Implémenter le fallback local
        console.warn('⚠️ Fallback local pour getAllPoliticalRegimes non implémenté')
        return []
      },
      'getAllPoliticalRegimes'
    )
  }
  
  // ===== ORGANISATIONS =====
  
  /**
   * Récupère toutes les organisations
   */
  static async getAllOrganizations(): Promise<Organization[]> {
    return this.executeWithFallback(
      () => SupabaseService.getAllOrganizations(),
      async () => {
        // TODO: Implémenter le fallback local
        console.warn('⚠️ Fallback local pour getAllOrganizations non implémenté')
        return []
      },
      'getAllOrganizations'
    )
  }
  
  // ===== CONFLITS ARMÉS =====
  
  /**
   * Récupère tous les conflits armés
   */
  static async getAllArmedConflicts(): Promise<ArmedConflict[]> {
    return this.executeWithFallback(
      () => SupabaseService.getAllArmedConflicts(),
      async () => {
        // TODO: Implémenter le fallback local
        console.warn('⚠️ Fallback local pour getAllArmedConflicts non implémenté')
        return []
      },
      'getAllArmedConflicts'
    )
  }
  
  // ===== UTILITAIRES =====
  
  /**
   * Teste la connexion Supabase
   */
  static async testSupabaseConnection(): Promise<boolean> {
    try {
      const stats = await SupabaseService.getGlobalStats()
      console.log('✅ Connexion Supabase OK:', stats)
      return true
    } catch (error) {
      console.error('❌ Connexion Supabase failed:', error)
      return false
    }
  }
  
  /**
   * Récupère le statut du service
   */
  static getServiceStatus() {
    return {
      useSupabase: USE_SUPABASE,
      useLocalApi: USE_LOCAL_API,
      mode: USE_SUPABASE && USE_LOCAL_API ? 'double' : 
            USE_SUPABASE ? 'supabase' : 'local'
    }
  }
}

// Export par défaut
export default AdaptiveApiService

// Exports nommés pour compatibilité
export const {
  getAllCountries,
  getCountryById,
  searchCountries,
  getAllPoliticalRegimes,
  getAllOrganizations,
  getAllArmedConflicts,
  testSupabaseConnection,
  getServiceStatus
} = AdaptiveApiService