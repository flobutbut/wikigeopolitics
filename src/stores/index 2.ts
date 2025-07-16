/**
 * Point d'entrée centralisé pour tous les stores
 */

// Exports des stores principaux
export { useNavigationStore } from './navigationStore'
export { useSelectionStore } from './selectionStore'
export { useDataStore } from './dataStore'
export { useUIStore } from './uiStore'

// Exports des stores existants
export { useMapStore } from './mapStore'
export { useCountrySelectionStore } from './countrySelectionStore'

// Types principaux
export type {
  NavigationStoreState,
} from './navigationStore'

export type {
  SelectionStoreState,
  CountryDetailData,
  CollapsibleSection,
  AppData
} from './selectionStore'

export type {
  DataStoreState
} from './dataStore'

export type {
  UIStoreState,
  Notification
} from './uiStore'

// Fonction utilitaire pour initialiser tous les stores
export async function initializeStores() {
  const dataStore = useDataStore()
  const uiStore = useUIStore()
  
  try {
    // Initialiser les données
    await dataStore.initializeData()
    
    // Initialiser l'interface responsive
    uiStore.initializeResponsive()
    
    console.log('Stores initialisés avec succès')
  } catch (error) {
    console.error('Erreur lors de l\'initialisation des stores:', error)
    throw error
  }
}