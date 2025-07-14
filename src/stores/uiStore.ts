/**
 * Store dédié à la gestion de l'interface utilisateur
 */

import { defineStore } from 'pinia'

export interface UIStoreState {
  // État de l'interface
  sidebarCollapsed: boolean
  searchVisible: boolean
  
  // Modales et overlays
  showModal: boolean
  modalContent: any | null
  
  // Notifications
  notifications: Notification[]
  
  // Responsive
  isMobile: boolean
  screenWidth: number
  
  // États des sections pliables
  expandedSections: Record<string, boolean>
}

export interface Notification {
  id: string
  type: 'success' | 'error' | 'warning' | 'info'
  title: string
  message?: string
  duration?: number
  timestamp: number
}

export const useUIStore = defineStore('ui', {
  state: (): UIStoreState => ({
    sidebarCollapsed: false,
    searchVisible: false,
    showModal: false,
    modalContent: null,
    notifications: [],
    isMobile: false,
    screenWidth: window?.innerWidth || 1024,
    expandedSections: {}
  }),

  getters: {
    // Interface
    isDesktop: (state) => state.screenWidth >= 1024,
    isTablet: (state) => state.screenWidth >= 768 && state.screenWidth < 1024,
    
    // Notifications
    hasNotifications: (state) => state.notifications.length > 0,
    unreadNotifications: (state) => state.notifications.filter(n => !n.duration),
    
    // Sections
    isSectionExpanded: (state) => (sectionId: string) => !!state.expandedSections[sectionId],
    
    // Modal
    hasModal: (state) => state.showModal && !!state.modalContent
  },

  actions: {
    // Gestion de la sidebar
    toggleSidebar() {
      this.sidebarCollapsed = !this.sidebarCollapsed
    },

    setSidebarCollapsed(collapsed: boolean) {
      this.sidebarCollapsed = collapsed
    },

    // Gestion de la recherche
    showSearch() {
      this.searchVisible = true
    },

    hideSearch() {
      this.searchVisible = false
    },

    toggleSearch() {
      this.searchVisible = !this.searchVisible
    },

    // Gestion des modales
    openModal(content: any) {
      this.modalContent = content
      this.showModal = true
    },

    closeModal() {
      this.showModal = false
      this.modalContent = null
    },

    // Gestion des notifications
    addNotification(notification: Omit<Notification, 'id' | 'timestamp'>) {
      const id = `notification_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
      
      const newNotification: Notification = {
        id,
        timestamp: Date.now(),
        duration: 5000, // 5 secondes par défaut
        ...notification
      }
      
      this.notifications.unshift(newNotification)
      
      // Auto-remove après la durée spécifiée
      if (newNotification.duration && newNotification.duration > 0) {
        setTimeout(() => {
          this.removeNotification(id)
        }, newNotification.duration)
      }
      
      return id
    },

    removeNotification(id: string) {
      const index = this.notifications.findIndex(n => n.id === id)
      if (index !== -1) {
        this.notifications.splice(index, 1)
      }
    },

    clearNotifications() {
      this.notifications = []
    },

    // Méthodes de notification rapides
    notifySuccess(title: string, message?: string, duration?: number) {
      return this.addNotification({ type: 'success', title, message, duration })
    },

    notifyError(title: string, message?: string, duration?: number) {
      return this.addNotification({ type: 'error', title, message, duration: duration || 8000 })
    },

    notifyWarning(title: string, message?: string, duration?: number) {
      return this.addNotification({ type: 'warning', title, message, duration })
    },

    notifyInfo(title: string, message?: string, duration?: number) {
      return this.addNotification({ type: 'info', title, message, duration })
    },

    // Gestion responsive
    updateScreenWidth(width: number) {
      this.screenWidth = width
      this.isMobile = width < 768
      
      // Auto-collapse sidebar sur mobile
      if (this.isMobile) {
        this.sidebarCollapsed = true
      }
    },

    // Gestion des sections pliables
    toggleSection(sectionId: string) {
      this.expandedSections[sectionId] = !this.expandedSections[sectionId]
    },

    expandSection(sectionId: string) {
      this.expandedSections[sectionId] = true
    },

    collapseSection(sectionId: string) {
      this.expandedSections[sectionId] = false
    },

    expandAllSections() {
      Object.keys(this.expandedSections).forEach(key => {
        this.expandedSections[key] = true
      })
    },

    collapseAllSections() {
      Object.keys(this.expandedSections).forEach(key => {
        this.expandedSections[key] = false
      })
    },

    // Initialisation des événements responsive
    initializeResponsive() {
      if (typeof window !== 'undefined') {
        const handleResize = () => {
          this.updateScreenWidth(window.innerWidth)
        }
        
        window.addEventListener('resize', handleResize)
        handleResize() // Initialiser immédiatement
        
        // Retourner la fonction de nettoyage
        return () => {
          window.removeEventListener('resize', handleResize)
        }
      }
    },

    // Utilitaires de debugging
    logState() {
      console.log('UI Store State:', {
        sidebarCollapsed: this.sidebarCollapsed,
        searchVisible: this.searchVisible,
        showModal: this.showModal,
        notifications: this.notifications.length,
        isMobile: this.isMobile,
        screenWidth: this.screenWidth
      })
    }
  }
})