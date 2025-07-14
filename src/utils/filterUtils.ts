/**
 * Utilitaires de filtrage et recherche réutilisables
 */

export interface Filterable {
  title?: string
  name?: string
  description?: string
  [key: string]: any
}

/**
 * Créer un filtre de recherche générique
 */
export function createSearchFilter<T extends Filterable>(
  items: T[], 
  query: string, 
  fields: (keyof T)[] = ['title', 'name']
): T[] {
  if (!query || query.trim() === '') return items
  
  const searchTerm = query.toLowerCase().trim()
  
  return items.filter(item => 
    fields.some(field => {
      const value = item[field]
      return value && typeof value === 'string' && 
             value.toLowerCase().includes(searchTerm)
    })
  )
}

/**
 * Filtre pour les pays (logique spécialisée)
 */
export function filterCountries<T extends { title?: string, flag?: string, continent?: string }>(
  countries: T[],
  query: string
): T[] {
  if (!query || query.trim() === '') return countries
  
  const searchTerm = query.toLowerCase().trim()
  
  return countries.filter(country => 
    (country.title?.toLowerCase().includes(searchTerm)) ||
    (country.flag?.toLowerCase().includes(searchTerm)) ||
    (country.continent?.toLowerCase().includes(searchTerm))
  )
}

/**
 * Filtre pour les organisations (logique spécialisée)
 */
export function filterOrganizations<T extends { title?: string, type?: string }>(
  organizations: T[],
  query: string
): T[] {
  if (!query || query.trim() === '') return organizations
  
  const searchTerm = query.toLowerCase().trim()
  
  return organizations.filter(org => 
    (org.title?.toLowerCase().includes(searchTerm)) ||
    (org.type?.toLowerCase().includes(searchTerm))
  )
}

/**
 * Filtre pour les régimes politiques
 */
export function filterPoliticalRegimes<T extends { name?: string, description?: string }>(
  regimes: T[],
  query: string
): T[] {
  if (!query || query.trim() === '') return regimes
  
  const searchTerm = query.toLowerCase().trim()
  
  return regimes.filter(regime => 
    (regime.name?.toLowerCase().includes(searchTerm)) ||
    (regime.description?.toLowerCase().includes(searchTerm))
  )
}

/**
 * Filtre pour les conflits armés
 */
export function filterArmedConflicts<T extends { name?: string, description?: string, status?: string }>(
  conflicts: T[],
  query: string
): T[] {
  if (!query || query.trim() === '') return conflicts
  
  const searchTerm = query.toLowerCase().trim()
  
  return conflicts.filter(conflict => 
    (conflict.name?.toLowerCase().includes(searchTerm)) ||
    (conflict.description?.toLowerCase().includes(searchTerm)) ||
    (conflict.status?.toLowerCase().includes(searchTerm))
  )
}

/**
 * Filtre pour les éléments de navigation
 */
export function filterNavigation<T extends { title?: string, items?: any[], toggleOptions?: any[] }>(
  categories: T[],
  query: string
): T[] {
  if (!query || query.trim() === '') return categories
  
  const searchTerm = query.toLowerCase().trim()
  
  return categories.filter(category => {
    // Vérifier si le titre de la catégorie correspond
    if (category.title?.toLowerCase().includes(searchTerm)) return true
    
    // Vérifier les options de toggle
    if (category.toggleOptions && category.toggleOptions.some((opt: any) => 
      opt.title?.toLowerCase().includes(searchTerm)
    )) return true
    
    // Vérifier les éléments
    if (category.items && category.items.some((item: any) => 
      item.title?.toLowerCase().includes(searchTerm)
    )) return true
    
    return false
  })
}