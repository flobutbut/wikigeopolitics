<template>
  <header class="header">
    <div class="logo">
      <span class="logo-text">WikiGeopolitics</span>
    </div>
    
    <!-- Barre de recherche centrée -->
    <div class="search-container">
      <CountrySearch 
        placeholder="Rechercher un pays..."
        @country-selected="handleCountrySelected"
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
import { defineComponent } from 'vue'
import Button from '@components/common/Button.vue'
import CountrySearch from '@components/common/CountrySearch.vue'

interface Country {
  id: string
  nom: string
  population?: number
  drapeau?: string
  regimePolitique?: string
}

export default defineComponent({
  name: 'HeaderNav',
  
  components: {
    Button,
    CountrySearch
  },
  
  setup() {
    // Gestion de la sélection de pays
    const handleCountrySelected = (country: Country) => {
      console.log('Pays sélectionné depuis header:', country.nom)
      // La sélection est déjà gérée dans le composant CountrySearch
      // via asideStore.selectCountry()
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
      handleCountrySelected,
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

.logo {
  display: flex;
  align-items: center;
}

.logo-text {
  font-family: 'Lora', serif;
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--text-dark);
  letter-spacing: 0.02em;
  line-height: 1.3;
  text-decoration: none;
  transition: color 0.2s ease;
  padding: var(--spacing-sm) 0;
  border-radius: var(--radius-sm);
}

.logo-text:hover {
  color: var(--primary-color);
}

.search-container {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 420px;
  max-width: 45%;
}

@media (max-width: 1024px) {
  .search-container {
    width: 350px;
    max-width: 40%;
  }
}

@media (max-width: 768px) {
  .search-container {
    position: relative;
    left: auto;
    transform: none;
    width: 100%;
    max-width: none;
    order: 3;
    margin-top: var(--spacing-sm);
  }
  
  .header {
    flex-wrap: wrap;
    padding: var(--spacing-sm) var(--spacing-md);
  }
  
  .header nav {
    order: 2;
  }
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