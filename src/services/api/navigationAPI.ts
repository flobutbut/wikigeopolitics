/**
 * API spécialisée pour la navigation
 */

import { ApiClient } from '@/utils/apiClient'

export interface NavigationCategory {
  id: string
  title: string
  isSubPage?: boolean
  searchEnabled?: boolean
  hasReturnButton?: boolean
  items?: any[]
  organizations?: any[]
}

export interface NavigationData {
  categories: NavigationCategory[]
}

class NavigationAPI {
  private client: ApiClient

  constructor() {
    this.client = new ApiClient()
  }

  async getNavigationData(): Promise<NavigationData> {
    return await this.client.get<NavigationData>('/api/navigation')
  }

  async getCategoryData(categoryId: string): Promise<{
    category: NavigationCategory
    items?: any[]
    organizations?: any[]
  }> {
    return await this.client.get(`/api/categories/${categoryId}`)
  }

  async getSubPage(id: string): Promise<any> {
    return await this.client.get(`/api/subpages/${id}`)
  }
}

export const navigationAPI = new NavigationAPI()
export default navigationAPI