/**
 * Utilitaires de formatage des données
 */

/**
 * Formate un nombre de population
 */
export function formatPopulation(population: number | null | undefined): string {
  if (!population || isNaN(population)) return 'Non disponible'
  
  if (population >= 1_000_000_000) {
    return `${(population / 1_000_000_000).toFixed(1)}B habitants`
  } else if (population >= 1_000_000) {
    return `${(population / 1_000_000).toFixed(1)}M habitants`
  } else if (population >= 1_000) {
    return `${(population / 1_000).toFixed(1)}K habitants`
  }
  
  return `${population.toLocaleString('fr-FR')} habitants`
}

/**
 * Formate une devise
 */
export function formatCurrency(
  amount: number | null | undefined, 
  currency: string = 'USD'
): string {
  if (!amount || isNaN(amount)) return 'Non disponible'
  
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency,
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(amount)
}

/**
 * Formate une superficie
 */
export function formatArea(area: number | null | undefined): string {
  if (!area || isNaN(area)) return 'Non disponible'
  
  if (area >= 1_000_000) {
    return `${(area / 1_000_000).toFixed(1)}M km²`
  } else if (area >= 1_000) {
    return `${(area / 1_000).toFixed(1)}K km²`
  }
  
  return `${area.toLocaleString('fr-FR')} km²`
}

/**
 * Tronque un texte
 */
export function truncateText(text: string | null | undefined, maxLength: number): string {
  if (!text) return ''
  
  if (text.length <= maxLength) return text
  
  return text.substring(0, maxLength).replace(/\s+\S*$/, '') + '...'
}

/**
 * Formate une date
 */
export function formatDate(
  date: string | Date | null | undefined, 
  format: 'short' | 'long' | 'year' = 'short'
): string {
  if (!date) return 'Non disponible'
  
  const dateObj = typeof date === 'string' ? new Date(date) : date
  
  if (isNaN(dateObj.getTime())) return 'Date invalide'
  
  switch (format) {
    case 'year':
      return dateObj.getFullYear().toString()
    case 'long':
      return new Intl.DateTimeFormat('fr-FR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      }).format(dateObj)
    default:
      return new Intl.DateTimeFormat('fr-FR').format(dateObj)
  }
}

/**
 * Formate un pourcentage
 */
export function formatPercentage(value: number | null | undefined, decimals: number = 1): string {
  if (value === null || value === undefined || isNaN(value)) return 'Non disponible'
  
  return `${value.toFixed(decimals)}%`
}

/**
 * Formate un statut (première lettre en majuscule)
 */
export function formatStatus(status: string | null | undefined): string {
  if (!status) return 'Non défini'
  
  return status.charAt(0).toUpperCase() + status.slice(1).toLowerCase()
}

/**
 * Formate une période (années)
 */
export function formatPeriod(startYear: number | null, endYear: number | null): string {
  if (!startYear && !endYear) return 'Non défini'
  if (!startYear) return `Jusqu'en ${endYear}`
  if (!endYear) return `Depuis ${startYear}`
  if (startYear === endYear) return startYear.toString()
  
  return `${startYear} - ${endYear}`
}

/**
 * Formate un nom de pays avec son drapeau
 */
export function formatCountryWithFlag(country: { title?: string, flag?: string }): string {
  if (!country.title) return 'Pays inconnu'
  
  return country.flag ? `${country.flag} ${country.title}` : country.title
}

/**
 * Formate une liste d'éléments
 */
export function formatList(items: string[], separator: string = ', ', lastSeparator: string = ' et '): string {
  if (!items || items.length === 0) return ''
  if (items.length === 1) return items[0]
  if (items.length === 2) return items.join(lastSeparator)
  
  const allButLast = items.slice(0, -1).join(separator)
  const last = items[items.length - 1]
  
  return `${allButLast}${lastSeparator}${last}`
}