import type { Directive } from 'vue'

/**
 * Directive v-scrollbar
 * Applique des styles de barre de défilement personnalisés à un élément
 * 
 * Usage:
 * <div v-scrollbar>Contenu avec défilement</div>
 * 
 * Options:
 * <div v-scrollbar="{ thin: true }">Barre de défilement fine</div>
 * <div v-scrollbar="{ stable: true }">Réserve l'espace pour la barre de défilement</div>
 */
export const scrollbar: Directive = {
  mounted(el, binding) {
    // Appliquer les styles de base
    el.classList.add('custom-scrollbar')
    
    // Options
    const options = binding.value || {}
    
    if (options.thin) {
      el.classList.add('custom-scrollbar--thin')
    }
    
    if (options.dark) {
      el.classList.add('custom-scrollbar--dark')
    }
    
    if (options.hover) {
      el.classList.add('custom-scrollbar--hover')
    }
    
    if (options.stable) {
      el.classList.add('custom-scrollbar--stable')
      
      // Forcer l'affichage de la barre de défilement
      el.style.overflowY = 'scroll';
    }
  },
  
  updated(el, binding) {
    // Mettre à jour les classes si les options changent
    const oldOptions = binding.oldValue || {}
    const newOptions = binding.value || {}
    
    if (oldOptions.thin !== newOptions.thin) {
      el.classList.toggle('custom-scrollbar--thin', !!newOptions.thin)
    }
    
    if (oldOptions.dark !== newOptions.dark) {
      el.classList.toggle('custom-scrollbar--dark', !!newOptions.dark)
    }
    
    if (oldOptions.hover !== newOptions.hover) {
      el.classList.toggle('custom-scrollbar--hover', !!newOptions.hover)
    }
    
    if (oldOptions.stable !== newOptions.stable) {
      el.classList.toggle('custom-scrollbar--stable', !!newOptions.stable)
      
      if (newOptions.stable) {
        // Forcer l'affichage de la barre de défilement
        el.style.overflowY = 'scroll';
      } else {
        // Réinitialiser
        el.style.overflowY = 'auto';
      }
    }
  }
}

/**
 * Calcule la largeur de la barre de défilement du navigateur
 */
function getScrollbarWidth(): number {
  // Créer un div avec une barre de défilement
  const outer = document.createElement('div')
  outer.style.visibility = 'hidden'
  outer.style.overflow = 'scroll'
  document.body.appendChild(outer)
  
  // Créer un div interne
  const inner = document.createElement('div')
  outer.appendChild(inner)
  
  // Calculer la différence de largeur
  const scrollbarWidth = outer.offsetWidth - inner.offsetWidth
  
  // Nettoyer
  outer.parentNode?.removeChild(outer)
  
  return scrollbarWidth
} 