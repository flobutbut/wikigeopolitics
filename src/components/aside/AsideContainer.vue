<template>
  <aside class="aside">
    <Search 
      v-if="currentView.searchEnabled !== false"
      @search="handleSearch" 
      :placeholder="searchPlaceholder"
    />

    <AsideMainView v-if="currentView.type === 'main'" />
    <AsideSubmenuView v-else-if="currentView.type === 'submenu'" />
    <AsideCountryListView v-else-if="currentView.type === 'countryList'" />
  </aside>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import Search from '@components/common/Search.vue'
import AsideMainView from './AsideMainView.vue'
import AsideSubmenuView from './AsideSubmenuView.vue'
import AsideCountryListView from './AsideCountryListView.vue'
import { useAsideStore } from '@/stores/asideStore'

export default defineComponent({
  name: 'AsideNav',
  
  components: {
    Search,
    AsideMainView,
    AsideSubmenuView,
    AsideCountryListView
  },
  
  setup() {
    const asideStore = useAsideStore()
    
    // Computed pour le placeholder de recherche
    const searchPlaceholder = computed(() => {
      return asideStore.searchPlaceholder
    })
    
    // Gestion de la recherche
    const handleSearch = (query: string) => {
      asideStore.setSearchQuery(query)
    }
    
    return {
      currentView: computed(() => asideStore.currentView),
      searchPlaceholder,
      handleSearch
    }
  }
})
</script>

<style scoped>
.aside {
  position: fixed;
  left: 0;
  top: var(--header-height);
  height: calc(100vh - var(--header-height));
  background-color: var(--surface-color);
  box-shadow: var(--shadow-sm);
  width: var(--aside-width);
  overflow-y: auto;
  z-index: 1000;
  padding: var(--spacing-sm);
}
</style> 