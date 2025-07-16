<template>
  <header class="header">
    <div class="logo">
      <img src="@assets/brand/logoWG.svg" alt="Logo WikiGeopolitics">
    </div>
    
    <!-- Barre de recherche centrée -->
    <div class="search-container">
      <Search 
        v-if="currentView.searchEnabled !== false"
        @search="handleSearch" 
      />
    </div>
    
    <nav>
      <ul class="flex items-center gap-md">
        <li>
          <Button variant="primary" @click="handleContribute">Contribuer</Button>
        </li>
        <li>
          <Button variant="text" @click="handleLogin">Connexion</Button>
        </li>
      </ul>
    </nav>
  </header>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import Button from '@components/common/Button.vue'
import Search from '@components/common/Search.vue'
import { useAsideStore } from '@/stores/asideStore'

export default defineComponent({
  name: 'HeaderNav',
  
  components: {
    Button,
    Search
  },
  
  setup() {
    const asideStore = useAsideStore()
    
    // Computed pour le placeholder de recherche
    const searchPlaceholder = computed(() => asideStore.searchPlaceholder)
    
    // Vue actuelle
    const currentView = computed(() => asideStore.currentView)
    
    // Gestion de la recherche
    const handleSearch = (query: string) => {
      asideStore.setSearchQuery(query)
    }
    
    const handleContribute = () => {
      console.log('Contribuer clicked')
      // Logique pour rediriger vers la page de contribution
    }
    
    const handleLogin = () => {
      console.log('Connexion clicked')
      // Logique pour ouvrir le modal de connexion
    }
    
    return {
      currentView,
      searchPlaceholder,
      handleSearch,
      handleContribute,
      handleLogin
    }
  }
})
</script>

<style scoped>
.header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: var(--header-height);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 var(--spacing-lg);
  background-color: var(--surface-color);
  border-bottom: 1px solid var(--border-color);
  box-shadow: var(--shadow-sm);
  z-index: 1001;
}

.logo img {
  height: 40px;
}

.search-container {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 400px; /* Ajustez selon vos besoins */
  max-width: 40%;
}

.header nav ul {
  display: flex;
  list-style: none;
  margin: 0;
  padding: 0;
  gap: var(--spacing-md);
}

.header nav a {
  text-decoration: none;
  color: var(--text-color);
}

.header nav a.contribuer {
  color: var(--active-text-color);
  font-weight: bold;
}
</style> 