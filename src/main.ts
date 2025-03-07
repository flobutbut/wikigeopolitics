import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import { useAsideStore } from './stores/asideStore'
import directives from './directives'

// Import des styles globaux
import '@styles/global.css'

// Import de Leaflet si nécessaire
import 'leaflet/dist/leaflet.css'

// Styles
import './styles/tokens.css'
import './styles/typography.css'
import './styles/global.css'
import './styles/components.css'
import './styles/scrollbar.css'

// Créer l'instance Pinia
const pinia = createPinia()

// Créer l'application Vue et utiliser Pinia
const app = createApp(App)
app.use(pinia)

// Initialiser le store après avoir installé Pinia
const asideStore = useAsideStore()
asideStore.initializeData()

// Enregistrer les directives personnalisées
app.use(directives)

// Monter l'application
app.mount('#app')