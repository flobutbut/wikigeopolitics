// 🚀 Service Supabase pour WikiGeopolitics
// Remplace l'API service existant pour utiliser Supabase

import { createClient } from '@supabase/supabase-js'

// Configuration Supabase
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL as string
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY as string

if (!supabaseUrl || !supabaseKey) {
  throw new Error('Configuration Supabase manquante. Vérifiez vos variables d\'environnement.')
}

export const supabase = createClient(supabaseUrl, supabaseKey)

// Types pour la compatibilité avec l'API existante
export interface Country {
  id: string
  nom: string
  capitale: string
  population: number
  superficie: number
  latitude: number
  longitude: number
  drapeau: string
  regime_politique: string
  continent: string
  chef_etat: string
}

export interface Organization {
  id: string
  nom: string
  acronyme: string
  type: string
  description: string
  date_creation: string
  siege: string
}

export interface PoliticalRegime {
  id: string
  nom: string
  description: string
  caracteristiques: string[]
}

export interface ArmedConflict {
  id: string
  nom: string
  description: string
  date_debut: string
  date_fin: string
  type: string
  intensite: string
  pays_impliques: string[]
}

// Service Supabase avec les mêmes méthodes que l'API locale
export const supabaseService = {
  // Récupérer tous les pays
  async getCountries(): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .order('nom')
    
    if (error) throw error
    return data || []
  },

  // Récupérer un pays par ID
  async getCountryById(id: string): Promise<Country | null> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .eq('id', id)
      .single()
    
    if (error) throw error
    return data
  },

  // Récupérer les organisations par type
  async getOrganizationsByType(): Promise<Record<string, Organization[]>> {
    const { data, error } = await supabase
      .from('organization')
      .select(`
        *,
        country_organization(countryid)
      `)
      .order('nom')
    
    if (error) throw error

    // Grouper par type et ajouter le nombre de pays membres
    const grouped = (data || []).reduce((acc, org) => {
      const type = org.type || 'Autre'
      if (!acc[type]) acc[type] = []
      
      // Ajouter le nombre de pays membres
      const countryCount = org.country_organization?.length || 0
      acc[type].push({
        ...org,
        country_count: countryCount
      })
      
      return acc
    }, {} as Record<string, (Organization & { country_count: number })[]>)

    return grouped
  },

  // Récupérer les régimes politiques
  async getPoliticalRegimes(): Promise<PoliticalRegime[]> {
    const { data, error } = await supabase
      .from('political_regime')
      .select(`
        *,
        country_political_regime(country_id)
      `)
      .order('nom')
    
    if (error) throw error

    // Ajouter le nombre de pays pour chaque régime
    return (data || []).map(regime => ({
      ...regime,
      country_count: regime.country_political_regime?.length || 0
    }))
  },

  // Récupérer les conflits armés
  async getArmedConflicts(): Promise<ArmedConflict[]> {
    const { data, error } = await supabase
      .from('armed_conflict')
      .select(`
        *,
        conflict_country(countryid)
      `)
      .order('date_debut', { ascending: false })
    
    if (error) throw error

    // Transformer les données pour correspondre à l'interface
    return (data || []).map(conflict => ({
      id: conflict.id,
      nom: conflict.nom,
      description: conflict.description || '',
      date_debut: conflict.date_debut,
      date_fin: conflict.date_fin,
      type: conflict.type || '',
      intensite: conflict.intensite || '',
      pays_impliques: conflict.conflict_country?.map((cc: any) => cc.countryid) || []
    }))
  },

  // Rechercher des pays
  async searchCountries(query: string): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .or(`nom.ilike.%${query}%,capitale.ilike.%${query}%`)
      .order('nom')
      .limit(20)
    
    if (error) throw error
    return data || []
  },

  // Récupérer les pays par continent
  async getCountriesByContinent(continent: string): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .eq('continent', continent)
      .order('nom')
    
    if (error) throw error
    return data || []
  }
}

// Export par défaut pour la compatibilité
export default supabaseService 