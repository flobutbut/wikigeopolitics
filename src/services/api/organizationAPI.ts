/**
 * API spécialisée pour les organisations
 */

import { ApiClient } from '@/utils/apiClient'

export interface Organization {
  id: string
  title: string
  type: string
  description?: string
  countries?: string[]
  founded?: number
  headquarters?: string
}

class OrganizationAPI {
  private client: ApiClient

  constructor() {
    this.client = new ApiClient()
  }

  async getAll(): Promise<Organization[]> {
    return await this.client.get<Organization[]>('/api/organizations')
  }

  async getById(id: string): Promise<Organization> {
    return await this.client.get<Organization>(`/api/organizations/${id}`)
  }

  async getByType(type?: string): Promise<Record<string, Organization[]> | Organization[]> {
    if (type) {
      return await this.client.get<Organization[]>(`/api/organizations?type=${type}`)
    }
    // L'endpoint /api/organizations retourne déjà les organisations groupées par type
    return await this.client.get<Record<string, Organization[]>>('/api/organizations')
  }

  async getCountries(organizationId: string): Promise<any[]> {
    return await this.client.get<any[]>(`/api/organizations/${organizationId}/countries`)
  }

  async search(query: string): Promise<Organization[]> {
    return await this.client.get<Organization[]>(`/api/organizations/search?q=${encodeURIComponent(query)}`)
  }
}

export const organizationAPI = new OrganizationAPI()
export default organizationAPI