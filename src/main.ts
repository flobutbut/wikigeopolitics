import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import { useAsideStore } from './stores/asideStore'

// Import des styles globaux
import '@styles/global.css'

// Import de Leaflet si nécessaire
import 'leaflet/dist/leaflet.css'

// Créer l'instance Pinia
const pinia = createPinia()

// Créer l'application Vue et utiliser Pinia
const app = createApp(App)
app.use(pinia)

// Initialiser le store après avoir installé Pinia
const asideStore = useAsideStore()
asideStore.initializeData()

// Monter l'application
app.mount('#app')