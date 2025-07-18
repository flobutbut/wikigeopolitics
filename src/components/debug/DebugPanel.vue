<template>
  <div v-if="isDevelopment" class="debug-panel" :class="{ expanded: isExpanded }">
    <div class="debug-header" @click="togglePanel">
      <span class="debug-icon">🔧</span>
      <span class="debug-title">Debug Panel</span>
      <span class="toggle-icon">{{ isExpanded ? '▼' : '▶' }}</span>
    </div>
    
    <div v-if="isExpanded" class="debug-content">
      <div class="debug-tabs">
        <button 
          v-for="tab in tabs" 
          :key="tab.id"
          @click="activeTab = tab.id"
          :class="{ active: activeTab === tab.id }"
          class="debug-tab"
        >
          {{ tab.label }}
        </button>
      </div>
      
      <div class="debug-tab-content">
        <!-- Supabase Migration -->
        <div v-if="activeTab === 'supabase'" class="tab-panel">
          <SupabaseDiagnostic />
        </div>
        
        <!-- Store State -->
        <div v-if="activeTab === 'stores'" class="tab-panel">
          <h4>📊 État des stores</h4>
          <details>
            <summary>AsideStore</summary>
            <pre>{{ JSON.stringify(asideStoreDebug, null, 2) }}</pre>
          </details>
          <details>
            <summary>SelectionSystem</summary>
            <pre>{{ JSON.stringify(selectionSystemDebug, null, 2) }}</pre>
          </details>
        </div>
        
        <!-- Environment -->
        <div v-if="activeTab === 'env'" class="tab-panel">
          <h4>🌍 Variables d'environnement</h4>
          <div class="env-vars">
            <div v-for="[key, value] in envVars" :key="key" class="env-var">
              <span class="env-key">{{ key }}</span>
              <span class="env-value">{{ value || '❌ Non défini' }}</span>
            </div>
          </div>
        </div>
        
        <!-- Performance -->
        <div v-if="activeTab === 'perf'" class="tab-panel">
          <h4>⚡ Performance</h4>
          <div class="perf-metrics">
            <div class="metric">
              <span class="metric-label">Temps de rendu :</span>
              <span class="metric-value">{{ renderTime }}ms</span>
            </div>
            <div class="metric">
              <span class="metric-label">Mémoire utilisée :</span>
              <span class="metric-value">{{ memoryUsage }}MB</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAsideStore } from '@/stores/asideStore'
import { useSelectionSystem } from '@/stores/selectionSystem'
import SupabaseDiagnostic from '@/components/common/SupabaseDiagnostic.vue'

// État du panel
const isExpanded = ref(false)
const activeTab = ref('supabase')

// Développement seulement
const isDevelopment = computed(() => import.meta.env.DEV)

// Onglets disponibles
const tabs = [
  { id: 'supabase', label: '🚀 Supabase' },
  { id: 'stores', label: '📊 Stores' },
  { id: 'env', label: '🌍 Env' },
  { id: 'perf', label: '⚡ Perf' }
]

// Stores pour debug
const asideStore = useAsideStore()
const selectionSystem = useSelectionSystem()

// Debug des stores
const asideStoreDebug = computed(() => ({
  currentView: asideStore.currentView?.type,
  searchQuery: asideStore.searchQuery,
  currentEntityType: asideStore.currentEntityType,
  hasDetailData: !!asideStore.currentDetailData
}))

const selectionSystemDebug = computed(() => ({
  type: selectionSystem.type,
  selectedCountry: selectionSystem.selectedCountry,
  selectedConflict: selectionSystem.selectedConflict,
  selectedOrganization: selectionSystem.selectedOrganization,
  floatingPanelOpen: selectionSystem.floatingPanelOpen,
  floatingPanelType: selectionSystem.floatingPanelType,
  visibleCountries: selectionSystem.visibleCountries.length,
  conflictZonesVisible: selectionSystem.conflictZonesVisible
}))

// Variables d'environnement
const envVars = computed(() => [
  ['VITE_SUPABASE_URL', import.meta.env.VITE_SUPABASE_URL],
  ['VITE_SUPABASE_ANON_KEY', import.meta.env.VITE_SUPABASE_ANON_KEY ? '***' + import.meta.env.VITE_SUPABASE_ANON_KEY.slice(-4) : ''],
  ['VITE_USE_SUPABASE', import.meta.env.VITE_USE_SUPABASE],
  ['VITE_USE_LOCAL_API', import.meta.env.VITE_USE_LOCAL_API],
  ['MODE', import.meta.env.MODE],
  ['DEV', import.meta.env.DEV]
])

// Métriques de performance
const renderTime = ref(0)
const memoryUsage = ref(0)

const updatePerformanceMetrics = () => {
  // Temps de rendu approximatif
  const start = performance.now()
  requestAnimationFrame(() => {
    renderTime.value = Math.round(performance.now() - start)
  })
  
  // Mémoire (si disponible)
  if ('memory' in performance) {
    const memory = (performance as any).memory
    memoryUsage.value = Math.round(memory.usedJSHeapSize / 1024 / 1024)
  }
}

const togglePanel = () => {
  isExpanded.value = !isExpanded.value
  if (isExpanded.value) {
    updatePerformanceMetrics()
  }
}

// Raccourci clavier pour ouvrir/fermer
onMounted(() => {
  const handleKeydown = (event: KeyboardEvent) => {
    if (event.ctrlKey && event.shiftKey && event.key === 'D') {
      event.preventDefault()
      togglePanel()
    }
  }
  
  document.addEventListener('keydown', handleKeydown)
  
  // Nettoyage
  return () => {
    document.removeEventListener('keydown', handleKeydown)
  }
})
</script>

<style scoped>
.debug-panel {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 10000;
  background: var(--surface-color);
  border: 2px solid var(--primary-color);
  border-radius: var(--radius-md);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  max-width: 500px;
  font-family: var(--font-family-mono, monospace);
  font-size: var(--font-size-sm);
}

.debug-header {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  padding: var(--spacing-sm) var(--spacing-md);
  background: var(--primary-color);
  color: white;
  cursor: pointer;
  user-select: none;
}

.debug-icon {
  font-size: var(--font-size-lg);
}

.debug-title {
  flex: 1;
  font-weight: var(--font-weight-medium);
}

.toggle-icon {
  font-size: var(--font-size-xs);
  transition: transform 0.2s;
}

.debug-content {
  max-height: 80vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.debug-tabs {
  display: flex;
  background: var(--surface-dimmed);
  border-bottom: 1px solid var(--border-color);
}

.debug-tab {
  padding: var(--spacing-xs) var(--spacing-sm);
  background: none;
  border: none;
  border-right: 1px solid var(--border-color);
  cursor: pointer;
  transition: background-color 0.2s;
  font-size: var(--font-size-xs);
}

.debug-tab:hover {
  background: var(--surface-hover);
}

.debug-tab.active {
  background: var(--primary-color);
  color: white;
}

.debug-tab-content {
  overflow-y: auto;
  max-height: 60vh;
}

.tab-panel {
  padding: var(--spacing-md);
}

.tab-panel h4 {
  margin: 0 0 var(--spacing-md) 0;
  color: var(--primary-color);
}

.tab-panel details {
  margin-bottom: var(--spacing-sm);
}

.tab-panel summary {
  cursor: pointer;
  font-weight: var(--font-weight-medium);
  padding: var(--spacing-xs);
  background: var(--surface-dimmed);
  border-radius: var(--radius-sm);
}

.tab-panel pre {
  background: var(--surface-dimmed);
  padding: var(--spacing-sm);
  border-radius: var(--radius-sm);
  overflow-x: auto;
  font-size: var(--font-size-xs);
  margin: var(--spacing-xs) 0 0 0;
  max-height: 200px;
  overflow-y: auto;
}

.env-vars {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.env-var {
  display: flex;
  justify-content: space-between;
  padding: var(--spacing-xs) var(--spacing-sm);
  background: var(--surface-dimmed);
  border-radius: var(--radius-sm);
}

.env-key {
  font-weight: var(--font-weight-medium);
  color: var(--primary-color);
}

.env-value {
  font-family: var(--font-family-mono, monospace);
  color: var(--text-muted);
}

.perf-metrics {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.metric {
  display: flex;
  justify-content: space-between;
  padding: var(--spacing-sm);
  background: var(--surface-dimmed);
  border-radius: var(--radius-sm);
}

.metric-label {
  font-weight: var(--font-weight-medium);
}

.metric-value {
  font-family: var(--font-family-mono, monospace);
  color: var(--primary-color);
  font-weight: var(--font-weight-bold);
}

/* Animation d'expansion */
.debug-panel:not(.expanded) .debug-content {
  display: none;
}

.debug-panel.expanded {
  animation: expandPanel 0.2s ease-out;
}

@keyframes expandPanel {
  from {
    transform: scale(0.95);
    opacity: 0.8;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}
</style>