// 🚀 Service Supabase pour WikiGeopolitics
// Remplace l'API service existant pour utiliser Supabase

import { createClient, SupabaseClient } from '@supabase/supabase-js'
import type { Country } from '@/types/country'
import type { PoliticalRegime, Organization, ArmedConflict, CombatZone, GlobalStats } from '@/types/supabase'

// Configuration Supabase
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Variables d\'environnement Supabase manquantes')
  throw new Error('Configuration Supabase requise')
}

// Client Supabase
export const supabase: SupabaseClient = createClient(supabaseUrl, supabaseKey)

// Types pour les réponses Supabase
interface SupabaseResponse<T> {
  data: T | null
  error: any
  count?: number
}

// Service principal pour WikiGeopolitics
export class SupabaseService {
  
  // ===== PAYS =====
  
  /**
   * Récupère tous les pays
   */
  static async getAllCountries(): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .order('name')
    
    if (error) {
      console.error('Erreur récupération pays:', error)
      throw new Error(`Erreur récupération pays: ${error.message}`)
    }
    
    return data || []
  }
  
  /**
   * Récupère un pays par ID
   */
  static async getCountryById(id: string): Promise<Country | null> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .eq('id', id)
      .single()
    
    if (error) {
      console.error('Erreur récupération pays:', error)
      return null
    }
    
    return data
  }
  
  /**
   * Recherche de pays par nom
   */
  static async searchCountries(query: string): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .ilike('name', `%${query}%`)
      .order('name')
    
    if (error) {
      console.error('Erreur recherche pays:', error)
      return []
    }
    
    return data || []
  }
  
  /**
   * Récupère les pays par continent
   */
  static async getCountriesByContinent(continent: string): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .eq('continent', continent)
      .order('name')
    
    if (error) {
      console.error('Erreur récupération pays par continent:', error)
      return []
    }
    
    return data || []
  }
  
  // ===== RÉGIMES POLITIQUES =====
  
  /**
   * Récupère tous les régimes politiques
   */
  static async getAllPoliticalRegimes(): Promise<PoliticalRegime[]> {
    const { data, error } = await supabase
      .from('political_regime')
      .select('*')
      .order('name')
    
    if (error) {
      console.error('Erreur récupération régimes politiques:', error)
      return []
    }
    
    return data || []
  }
  
  /**
   * Récupère les pays par régime politique
   */
  static async getCountriesByRegime(regimeId: string): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .eq('political_regime_id', regimeId)
      .order('name')
    
    if (error) {
      console.error('Erreur récupération pays par régime:', error)
      return []
    }
    
    return data || []
  }
  
  // ===== ORGANISATIONS =====
  
  /**
   * Récupère toutes les organisations
   */
  static async getAllOrganizations(): Promise<Organization[]> {
    const { data, error } = await supabase
      .from('organization')
      .select('*')
      .order('name')
    
    if (error) {
      console.error('Erreur récupération organisations:', error)
      return []
    }
    
    return data || []
  }
  
  /**
   * Récupère les organisations par type
   */
  static async getOrganizationsByType(type: string): Promise<Organization[]> {
    const { data, error } = await supabase
      .from('organization')
      .select('*')
      .eq('type', type)
      .order('name')
    
    if (error) {
      console.error('Erreur récupération organisations par type:', error)
      return []
    }
    
    return data || []
  }
  
  // ===== CONFLITS ARMÉS =====
  
  /**
   * Récupère tous les conflits armés
   */
  static async getAllArmedConflicts(): Promise<ArmedConflict[]> {
    const { data, error } = await supabase
      .from('armed_conflict')
      .select('*')
      .order('name')
    
    if (error) {
      console.error('Erreur récupération conflits armés:', error)
      return []
    }
    
    return data || []
  }
  
  /**
   * Récupère les conflits par pays
   */
  static async getConflictsByCountry(countryId: string): Promise<ArmedConflict[]> {
    const { data, error } = await supabase
      .from('armed_conflict')
      .select('*')
      .contains('countries_involved', [countryId])
      .order('name')
    
    if (error) {
      console.error('Erreur récupération conflits par pays:', error)
      return []
    }
    
    return data || []
  }
  
  /**
   * Récupère les zones de combat d'un conflit
   */
  static async getCombatZones(conflictId: string): Promise<any[]> {
    const { data, error } = await supabase
      .from('combat_zone')
      .select('*')
      .eq('armed_conflict_id', conflictId)
    
    if (error) {
      console.error('Erreur récupération zones de combat:', error)
      return []
    }
    
    return data || []
  }
  
  // ===== RECHERCHE GÉOGRAPHIQUE =====
  
  /**
   * Recherche géographique avec PostGIS
   */
  static async searchByLocation(lat: number, lng: number, radiusKm: number = 100): Promise<Country[]> {
    const { data, error } = await supabase
      .rpc('search_countries_by_location', {
        search_lat: lat,
        search_lng: lng,
        search_radius: radiusKm * 1000 // Conversion en mètres
      })
    
    if (error) {
      console.error('Erreur recherche géographique:', error)
      return []
    }
    
    return data || []
  }
  
  // ===== STATISTIQUES =====
  
  /**
   * Récupère les statistiques globales
   */
  static async getGlobalStats(): Promise<any> {
    const [countriesCount, regimesCount, orgsCount, conflictsCount] = await Promise.all([
      supabase.from('country').select('*', { count: 'exact', head: true }),
      supabase.from('political_regime').select('*', { count: 'exact', head: true }),
      supabase.from('organization').select('*', { count: 'exact', head: true }),
      supabase.from('armed_conflict').select('*', { count: 'exact', head: true })
    ])
    
    return {
      countries: countriesCount.count || 0,
      politicalRegimes: regimesCount.count || 0,
      organizations: orgsCount.count || 0,
      armedConflicts: conflictsCount.count || 0
    }
  }
  
  // ===== GESTION DU CACHE =====
  
  private static cache = new Map<string, { data: any, timestamp: number }>()
  private static CACHE_TTL = 5 * 60 * 1000 // 5 minutes
  
  /**
   * Récupère des données avec cache
   */
  static async getCached<T>(key: string, fetcher: () => Promise<T>): Promise<T> {
    const cached = this.cache.get(key)
    const now = Date.now()
    
    if (cached && (now - cached.timestamp) < this.CACHE_TTL) {
      return cached.data
    }
    
    const data = await fetcher()
    this.cache.set(key, { data, timestamp: now })
    return data
  }
  
  /**
   * Vide le cache
   */
  static clearCache(): void {
    this.cache.clear()
  }
}

// Export des fonctions utilitaires
export const {
  getAllCountries,
  getCountryById,
  searchCountries,
  getCountriesByContinent,
  getAllPoliticalRegimes,
  getCountriesByRegime,
  getAllOrganizations,
  getOrganizationsByType,
  getAllArmedConflicts,
  getConflictsByCountry,
  getCombatZones,
  searchByLocation,
  getGlobalStats,
  getCached,
  clearCache
} = SupabaseService

// Export par défaut
export default SupabaseService 