// Service API pour communiquer avec le serveur backend
const API_BASE_URL = (import.meta as any).env?.VITE_API_URL || 'http://localhost:3000/api';

// Fonction utilitaire pour les requêtes API
async function apiRequest<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
  const url = `${API_BASE_URL}${endpoint}`;
  
  try {
    const response = await fetch(url, {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    });

    if (!response.ok) {
      throw new Error(`Erreur HTTP: ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error(`Erreur API pour ${endpoint}:`, error);
    throw error;
  }
}

// Service pour les pays
export const countryApi = {
  // Récupérer tous les pays
  async getAllCountries() {
    console.log('[apiService] Appel getAllCountries...')
    const result = await apiRequest<any[]>('/countries');
    console.log('[apiService] getAllCountries résultat:', result.length, 'pays')
    return result;
  },

  // Récupérer un pays par ID
  async getCountryById(id: string) {
    return apiRequest<any>(`/countries/${id}`);
  },

  // Récupérer les données géographiques
  async getCountriesGeoData() {
    return apiRequest<any>('/countries-geo');
  },

  // Récupérer les détails d'un pays
  async getCountryDetails(id: string) {
    return apiRequest<any>(`/countries/${id}/details`);
  }
};

// Service pour la navigation
export const navigationApi = {
  // Récupérer les données de navigation
  async getNavigationData() {
    return apiRequest<any>('/navigation');
  },

  // Récupérer les données d'une catégorie
  async getCategoryData(categoryId: string) {
    return apiRequest<any>(`/categories/${categoryId}`);
  }
};

// Service pour la santé de l'API
export const healthApi = {
  // Test de connexion
  async checkHealth() {
    return apiRequest<any>('/health');
  }
}; 