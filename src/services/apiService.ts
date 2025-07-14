/**
 * Service API legacy - migration vers les nouvelles APIs spécialisées
 * @deprecated Utiliser les APIs spécialisées dans /services/api/ à la place
 */

// Re-export des nouvelles APIs pour la compatibilité
export { countryAPI as countryApi } from './api/countryAPI'
export { organizationAPI as organizationApi } from './api/organizationAPI'
export { politicalRegimeAPI as politicalRegimeApi } from './api/politicalRegimeAPI'
export { armedConflictAPI as armedConflictApi } from './api/armedConflictAPI'
export { navigationAPI as navigationApi } from './api/navigationAPI'

// Avertissement pour encourager la migration
console.warn('⚠️  Utilisation du service API legacy détectée. Veuillez migrer vers les APIs spécialisées dans /services/api/')

import { countryAPI } from './api/countryAPI'
import { organizationAPI } from './api/organizationAPI'
import { politicalRegimeAPI } from './api/politicalRegimeAPI'
import { armedConflictAPI } from './api/armedConflictAPI'
import { navigationAPI } from './api/navigationAPI'

export default {
  countries: countryAPI,
  organizations: organizationAPI,
  politicalRegimes: politicalRegimeAPI,
  armedConflicts: armedConflictAPI,
  navigation: navigationAPI
} as const