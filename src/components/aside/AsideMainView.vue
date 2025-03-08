<template>
  <div v-for="category in filteredNavigation" :key="category.id" class="aside__section">
    <h2 class="aside__section-title">{{ category.title }}</h2>
    
    <!-- Toggles pour les options (comme dans "Tous les pays") -->
    <div v-if="category.toggleOptions" class="aside__toggles">
      <div v-for="option in category.toggleOptions" :key="option.id" class="toggle-item">
        <label class="switch-label">
          <span class="toggle-title">{{ option.title }}</span>
          <input 
            type="checkbox" 
            v-model="option.enabled"
            @change="handleToggleOption(option)"
            class="switch-input"
          >
          <span class="switch-slider"></span>
        </label>
      </div>
    </div>
    
    <!-- Éléments de menu standard -->
    <ul v-if="category.items" class="aside__menu">
      <MenuItem
        v-for="item in category.items"
        :key="item.id"
        :title="item.title"
        :has-children="item.hasSubmenu"
        @click="navigateToSubmenu(item.id)"
      />
    </ul>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import MenuItem from '@components/common/MenuItem.vue'
import { useAsideStore } from '@/stores/asideStore'

export default defineComponent({
  name: 'AsideMainView',
  
  components: {
    MenuItem
  },
  
  setup() {
    const asideStore = useAsideStore()
    
    // Filtrer les éléments de navigation en fonction de la recherche
    const filteredNavigation = computed(() => {
      return asideStore.filteredNavigation
    })
    
    // Navigation vers un sous-menu
    const navigateToSubmenu = (id: string) => {
      asideStore.navigateToSubmenu(id)
    }
    
    const handleToggleOption = (option: { id: string, enabled: boolean }) => {
      asideStore.handleToggleOption(option)
    }
    
    return {
      filteredNavigation,
      navigateToSubmenu,
      handleToggleOption
    }
  }
})
</script>

<style scoped>
.aside__section {
  margin-bottom: var(--spacing-lg);
  padding-left: var(--spacing-sm);
  padding-right: var(--spacing-sm);
}

.aside__section-title {
  font-size: var(--font-size-sm);
  color: var(--text-dark);
  margin-bottom: var(--spacing-sm);
  padding-left: var(--spacing-sm);
}

.aside__menu {
  list-style: none;
  padding: 0;
  margin: 0;
}

.toggle-item {
  margin-bottom: var(--spacing-xs);
}

.toggle-title {
  font-size: var(--font-size-sm);
  color: var(--text-color);
}

.switch-label {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-xs) var(--spacing-sm);
  cursor: pointer;
}

/* Styles pour le switch */
.switch-input {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

.switch-slider {
  position: relative;
  display: inline-block;
  width: 32px;
  height: 16px;
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-full);
  transition: background-color var(--transition-speed) var(--transition-function);
}

.switch-slider:before {
  position: absolute;
  content: "";
  height: 12px;
  width: 12px;
  left: 2px;
  bottom: 2px;
  background-color: var(--surface-color);
  border-radius: 50%;
  transition: transform var(--transition-speed) var(--transition-function);
}

.switch-input:checked + .switch-slider {
  background-color: var(--primary-color);
}

.switch-input:checked + .switch-slider:before {
  transform: translateX(16px);
}
</style> 