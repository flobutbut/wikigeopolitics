// Types pour Supabase - WikiGeopolitics

export interface PoliticalRegime {
  id: string;
  name: string;
  description?: string;
  type?: string;
  characteristics?: string[];
  examples?: string[];
  created_at?: string;
  updated_at?: string;
}

export interface Organization {
  id: string;
  name: string;
  type: string;
  description?: string;
  headquarters?: string;
  founded_date?: string;
  member_countries?: string[];
  objectives?: string[];
  website?: string;
  created_at?: string;
  updated_at?: string;
}

export interface ArmedConflict {
  id: string;
  name: string;
  description?: string;
  start_date?: string;
  end_date?: string;
  status: 'active' | 'resolved' | 'frozen';
  countries_involved: string[];
  conflict_type?: string;
  casualties_estimate?: number;
  intensity_level?: 'low' | 'medium' | 'high';
  resolution_attempts?: string[];
  created_at?: string;
  updated_at?: string;
}

export interface CombatZone {
  id: string;
  armed_conflict_id: string;
  name: string;
  description?: string;
  coordinates?: [number, number];
  area_km2?: number;
  intensity_level?: 'low' | 'medium' | 'high';
  active_since?: string;
  last_activity?: string;
  created_at?: string;
  updated_at?: string;
}

export interface SupabaseConfig {
  url: string;
  anonKey: string;
  serviceRoleKey?: string;
}

// Types pour les réponses Supabase
export interface SupabaseResponse<T> {
  data: T | null;
  error: any;
  count?: number;
}

// Types pour les requêtes géographiques
export interface LocationSearch {
  lat: number;
  lng: number;
  radiusKm: number;
}

// Types pour les statistiques
export interface GlobalStats {
  countries: number;
  politicalRegimes: number;
  organizations: number;
  armedConflicts: number;
} 