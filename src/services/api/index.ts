/**
 * Point d'entrée centralisé pour toutes les APIs spécialisées
 */

// Imports des APIs
import { countryAPI } from './countryAPI'
import { organizationAPI } from './organizationAPI'
import { politicalRegimeAPI } from './politicalRegimeAPI'
import { armedConflictAPI } from './armedConflictAPI'
import { navigationAPI } from './navigationAPI'

// Exports des APIs
export { countryAPI } from './countryAPI'
export { organizationAPI } from './organizationAPI'
export { politicalRegimeAPI } from './politicalRegimeAPI'
export { armedConflictAPI } from './armedConflictAPI'
export { navigationAPI } from './navigationAPI'

// Exports des types
export type { Organization } from './organizationAPI'
export type { PoliticalRegime } from './politicalRegimeAPI'
export type { ArmedConflict } from './armedConflictAPI'
export type { NavigationCategory, NavigationData } from './navigationAPI'

// API unifiée pour un accès facile
export const API = {
  countries: countryAPI,
  organizations: organizationAPI,
  politicalRegimes: politicalRegimeAPI,
  armedConflicts: armedConflictAPI,
  navigation: navigationAPI
}

export default API