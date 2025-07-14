/**
 * API spécialisée pour les zones de combat
 */

import { ApiClient } from '@/utils/apiClient'

export interface CombatZone {
  id: string
  name: string
  description?: string
  status: 'active' | 'inactive'
  conflict_id: number
  intensity: 'low' | 'medium' | 'high' | 'very_high'
  zone_type: string
  civilian_impact: string
  epicenter: [number, number]
  conflict_name?: string
  startyear?: number
  endyear?: number
}

class CombatZoneAPI {
  private client: ApiClient

  constructor() {
    this.client = new ApiClient()
  }

  async getAll(): Promise<CombatZone[]> {
    return await this.client.get<CombatZone[]>('/api/combat-zones')
  }

  async getByConflictId(conflictId: string | number): Promise<CombatZone[]> {
    return await this.client.get<CombatZone[]>(`/api/armed-conflicts/${conflictId}/combat-zones`)
  }
}

export const combatZoneAPI = new CombatZoneAPI()
export default combatZoneAPI