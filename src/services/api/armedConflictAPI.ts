/**
 * API spécialisée pour les conflits armés
 */

import { ApiClient } from '@/utils/apiClient'

export interface ArmedConflict {
  id: string
  name: string
  description?: string
  status: 'active' | 'inactive' | 'resolved'
  startDate?: string
  endDate?: string
  countries?: string[]
  type?: string
  casualties?: number
}

class ArmedConflictAPI {
  private client: ApiClient

  constructor() {
    this.client = new ApiClient()
  }

  async getAll(): Promise<ArmedConflict[]> {
    return await this.client.get<ArmedConflict[]>('/api/armed-conflicts')
  }

  async getById(id: string): Promise<ArmedConflict> {
    return await this.client.get<ArmedConflict>(`/api/armed-conflicts/${id}`)
  }

  async getByStatus(status: 'active' | 'inactive' | 'resolved'): Promise<ArmedConflict[]> {
    return await this.client.get<ArmedConflict[]>(`/api/armed-conflicts?status=${status}`)
  }

  async getCountries(conflictId: string): Promise<any[]> {
    return await this.client.get<any[]>(`/api/armed-conflicts/${conflictId}/countries`)
  }

  async search(query: string): Promise<ArmedConflict[]> {
    return await this.client.get<ArmedConflict[]>(`/api/armed-conflicts/search?q=${encodeURIComponent(query)}`)
  }

  async getByCountry(countryId: string): Promise<ArmedConflict[]> {
    try {
      // Essayer d'abord l'endpoint dédié (si disponible côté serveur)
      return await this.client.get<ArmedConflict[]>(`/api/countries/${countryId}/conflicts`)
    } catch (error) {
      console.warn('Endpoint dédié non disponible, utilisation de la méthode de fallback')
      // Fallback : récupérer tous les conflits et filtrer côté client
      const allConflicts = await this.getAll()
      return allConflicts.filter((conflict: any) => 
        conflict.involvedcountries && conflict.involvedcountries.includes(countryId)
      )
    }
  }
}

export const armedConflictAPI = new ArmedConflictAPI()
export default armedConflictAPI