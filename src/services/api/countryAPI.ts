/**
 * API spécialisée pour les pays
 */

import { ApiClient } from '@/utils/apiClient'
import type { Country, CountryDetail } from '@/types/country'

class CountryAPI {
  private client: ApiClient

  constructor() {
    this.client = new ApiClient()
  }

  async getAll(): Promise<Country[]> {
    console.log('[CountryAPI] Appel getAll...')
    const result = await this.client.get<Country[]>('/api/countries')
    console.log('[CountryAPI] getAll résultat:', result.length, 'pays')
    return result
  }

  async getById(id: string): Promise<Country> {
    return await this.client.get<Country>(`/api/countries/${id}`)
  }

  async getDetails(id: string): Promise<CountryDetail> {
    return await this.client.get<CountryDetail>(`/api/countries/${id}/details`)
  }

  async getGeoData(): Promise<any> {
    return await this.client.get('/api/countries-geo')
  }

  async getByRegime(regimeId: string): Promise<Country[]> {
    return await this.client.get<Country[]>(`/api/political-regimes/${regimeId}/countries`)
  }

  async getByOrganization(organizationId: string): Promise<Country[]> {
    return await this.client.get<Country[]>(`/api/organizations/${organizationId}/countries`)
  }

  async search(query: string): Promise<Country[]> {
    return await this.client.get<Country[]>(`/api/countries/search?q=${encodeURIComponent(query)}`)
  }
}

export const countryAPI = new CountryAPI()
export default countryAPI