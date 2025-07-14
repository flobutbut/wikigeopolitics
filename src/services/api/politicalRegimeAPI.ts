/**
 * API spécialisée pour les régimes politiques
 */

import { ApiClient } from '@/utils/apiClient'

export interface PoliticalRegime {
  id: string
  name: string
  description?: string
  characteristics?: string[]
  countries?: string[]
}

class PoliticalRegimeAPI {
  private client: ApiClient

  constructor() {
    this.client = new ApiClient()
  }

  async getAll(): Promise<PoliticalRegime[]> {
    return await this.client.get<PoliticalRegime[]>('/api/political-regimes')
  }

  async getById(id: string): Promise<PoliticalRegime> {
    return await this.client.get<PoliticalRegime>(`/api/political-regimes/${id}`)
  }

  async getCountries(regimeId: string): Promise<any[]> {
    return await this.client.get<any[]>(`/api/political-regimes/${regimeId}/countries`)
  }

  async search(query: string): Promise<PoliticalRegime[]> {
    return await this.client.get<PoliticalRegime[]>(`/api/political-regimes/search?q=${encodeURIComponent(query)}`)
  }
}

export const politicalRegimeAPI = new PoliticalRegimeAPI()
export default politicalRegimeAPI