/**
 * Service de lecture unifié utilisant les APIs spécialisées
 */

import { API } from './api'
import type { Country } from '@/types/country'

// === PAYS ===
export async function getAllCountries(): Promise<Country[]> {
  return await API.countries.getAll()
}

export async function getCountryById(id: string): Promise<Country | null> {
  try {
    return await API.countries.getById(id)
  } catch (error) {
    console.error(`Erreur lors de la récupération du pays ${id}:`, error)
    return null
  }
}

export async function getCountriesGeoData() {
  return await API.countries.getGeoData()
}

export async function getCountryDetails(id: string) {
  return await API.countries.getDetails(id)
}

export async function getCountriesByRegime(regimeId: string) {
  return await API.countries.getByRegime(regimeId)
}

export async function getCountriesByOrganization(organizationId: string) {
  return await API.countries.getByOrganization(organizationId)
}

// === NAVIGATION ===
export async function getNavigationData() {
  return await API.navigation.getNavigationData()
}

export async function getCategoryData(categoryId: string) {
  return await API.navigation.getCategoryData(categoryId)
}

// === ORGANISATIONS ===
export async function getOrganizationsByType(type?: string) {
  return await API.organizations.getByType(type)
}

// === RÉGIMES POLITIQUES ===
export async function getAllPoliticalRegimes() {
  return await API.politicalRegimes.getAll()
} 