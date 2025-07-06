import { countryApi, navigationApi } from './apiService';
import { Country } from '@/types/country';

export async function getAllCountries(): Promise<Country[]> {
  return await countryApi.getAllCountries();
}

export async function getCountryById(id: string): Promise<Country | null> {
  try {
    return await countryApi.getCountryById(id);
  } catch (error) {
    console.error(`Erreur lors de la récupération du pays ${id}:`, error);
    return null;
  }
}

// Récupérer les données géographiques de tous les pays (pour la carte)
export async function getCountriesGeoData() {
  return await countryApi.getCountriesGeoData();
}

// Récupérer les données détaillées d'un pays
export async function getCountryDetails(id: string) {
  return await countryApi.getCountryDetails(id);
}

// Récupérer les données de navigation (catégories, etc.)
export async function getNavigationData() {
  return await navigationApi.getNavigationData();
}

// Récupérer les données d'une catégorie spécifique
export async function getCategoryData(categoryId: string) {
  return await navigationApi.getCategoryData(categoryId);
} 