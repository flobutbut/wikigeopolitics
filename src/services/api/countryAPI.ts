/**
 * API spécialisée pour les pays - Utilise Supabase
 */

import { supabase } from '@/services/supabaseService'
import type { Country, CountryDetail } from '@/types/country'

class CountryAPI {
  async getAll(): Promise<Country[]> {
    console.log('[CountryAPI] Appel getAll via Supabase...')
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .order('nom')
    
    if (error) {
      console.error('[CountryAPI] Erreur getAll:', error)
      throw error
    }
    
    // Transformer les données pour correspondre au type Country
    const countries = (data || []).map(country => ({
      id: country.id,
      title: country.nom,
      flag: country.drapeau,
      continent: country.continent,
      coordonnees: country.coordonnees?.coordinates ? [country.coordonnees.coordinates[0], country.coordonnees.coordinates[1]] as [number, number] : undefined,
      drapeau: country.drapeau,
      capitale: country.capitale,
      population: country.population,
      superficieKm2: country.superficie,
      regimePolitique: country.regime_politique,
      chefEtat: country.chef_etat
    }))
    
    console.log('[CountryAPI] getAll résultat:', countries.length, 'pays')
    return countries
  }

  async getById(id: string): Promise<Country> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .eq('id', id)
      .single()
    
    if (error) throw error
    
    // Transformer les données pour correspondre au type Country
    return {
      id: data.id,
      title: data.nom,
      flag: data.drapeau,
      continent: data.continent,
      coordonnees: data.coordonnees?.coordinates ? [data.coordonnees.coordinates[0], data.coordonnees.coordinates[1]] as [number, number] : undefined,
      drapeau: data.drapeau,
      capitale: data.capitale,
      population: data.population,
      superficieKm2: data.superficie,
      regimePolitique: data.regime_politique,
      chefEtat: data.chef_etat
    }
  }

  async getDetails(id: string): Promise<CountryDetail> {
    // Pour l'instant, retourner les mêmes données que getById
    // TODO: Implémenter les détails complets avec les relations
    const country = await this.getById(id)
    return country as CountryDetail
  }

  async getGeoData(): Promise<any> {
    // TODO: Implémenter les données géographiques
    return []
  }

  async getByRegime(regimeId: string): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .eq('regime_politique', regimeId)
      .order('nom')
    
    if (error) throw error
    
    // Transformer les données pour correspondre au type Country
    return (data || []).map(country => ({
      id: country.id,
      title: country.nom,
      flag: country.drapeau,
      continent: country.continent,
      coordonnees: country.coordonnees?.coordinates ? [country.coordonnees.coordinates[0], country.coordonnees.coordinates[1]] as [number, number] : undefined,
      drapeau: country.drapeau,
      capitale: country.capitale,
      population: country.population,
      superficieKm2: country.superficie,
      regimePolitique: country.regime_politique,
      chefEtat: country.chef_etat
    }))
  }

  async getByOrganization(organizationId: string): Promise<Country[]> {
    // TODO: Implémenter la récupération des pays par organisation
    // Pour l'instant, retourner un tableau vide
    console.warn('[CountryAPI] getByOrganization pas encore implémenté avec Supabase')
    return []
  }

  async search(query: string): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .or(`nom.ilike.%${query}%,capitale.ilike.%${query}%`)
      .order('nom')
      .limit(20)
    
    if (error) throw error
    
    // Transformer les données pour correspondre au type Country
    return (data || []).map(country => ({
      id: country.id,
      title: country.nom,
      flag: country.drapeau,
      continent: country.continent,
      coordonnees: country.coordonnees?.coordinates ? [country.coordonnees.coordinates[0], country.coordonnees.coordinates[1]] as [number, number] : undefined,
      drapeau: country.drapeau,
      capitale: country.capitale,
      population: country.population,
      superficieKm2: country.superficie,
      regimePolitique: country.regime_politique,
      chefEtat: country.chef_etat
    }))
  }
}

export const countryAPI = new CountryAPI()
export default countryAPI