<template>
  <header class="header">
    <div class="logo">
      <img src="@assets/brand/logoWG.svg" alt="Logo WikiGeopolitics">
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

export default defineComponent({
  name: 'HeaderNav',
  
  components: {
    Button
  },
  
  setup() {
    const handleContribute = () => {
      console.log('Contribuer clicked')
      // Logique pour rediriger vers la page de contribution
    }
    
    const handleLogin = () => {
      console.log('Connexion clicked')
      // Logique pour ouvrir le modal de connexion
    }
    
    return {
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
  box-shadow: var(--shadow-sm);
  z-index: 1001;
}

.logo img {
  height: 40px;
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