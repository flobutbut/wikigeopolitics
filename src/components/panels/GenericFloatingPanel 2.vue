<template>
  <div v-if="entityData && entityData.title" class="floating-detail-panel">
    <div class="panel-header">
      <div class="header-content">
        <div class="entity-info">
          <span 
            v-if="entityIcon" 
            class="entity-icon"
            :title="entityIconTitle"
          >
            {{ entityIcon }}
          </span>
          <h3>{{ entityData.title }}</h3>
        </div>
      </div>
      <button @click="closePanel" class="close-button">×</button>
    </div>
    
    <TabNavigation 
      :tabs="tabs" 
      :default-tab="'details'"
      @tab-change="handleTabChange"
    >
      <template #default="{ activeTab }">
        <div v-if="activeTab === 'details'" class="details-view">
          <slot name="content" :data="entityData" />
        </div>
        
        <!-- Vue Actualités (optionnelle) -->
        <div v-if="activeTab === 'news' && showNewsTab" class="news-view">
          <slot name="news" :data="entityData">
            <NewsView :entity-id="entityData.id" :entity-type="entityType" />
          </slot>
        </div>
        
        <!-- Vues supplémentaires -->
        <div v-if="activeTab === 'analysis' && showAnalysisTab" class="analysis-view">
          <slot name="analysis" :data="entityData" />
        </div>
      </template>
    </TabNavigation>
  </div>
</template>

<script setup lang="ts">
import { computed, defineProps, defineEmits } from 'vue'
import TabNavigation from '@/components/common/TabNavigation.vue'
import NewsView from '@/components/panels/NewsView.vue'

export interface EntityData {
  id: string
  title: string
  [key: string]: any
}

export interface Tab {
  id: string
  label: string
  icon?: string
}

const props = defineProps<{
  entityData: EntityData | null
  entityType: 'country' | 'conflict' | 'regime' | 'organization' | 'resource'
  entityIcon?: string
  entityIconTitle?: string
  entitySubtitle?: string
  tabs?: Tab[]
  showNewsTab?: boolean
  showAnalysisTab?: boolean
}>()

const emit = defineEmits<{
  close: []
  tabChange: [tabId: string]
}>()

// Tabs par défaut selon le type d'entité
const defaultTabs = computed(() => {
  const baseTabs = [{ id: 'details', label: 'Détails' }]
  
  if (props.showNewsTab) {
    baseTabs.push({ id: 'news', label: 'Actualités' })
  }
  
  if (props.showAnalysisTab) {
    baseTabs.push({ id: 'analysis', label: 'Analyse' })
  }
  
  return baseTabs
})

const tabs = computed(() => props.tabs || defaultTabs.value)

const handleTabChange = (tabId: string) => {
  emit('tabChange', tabId)
}

const closePanel = () => {
  emit('close')
}
</script>

<style scoped>
.floating-detail-panel {
  position: fixed;
  top: 80px;
  right: 20px;
  width: 350px;
  max-height: calc(100vh - 100px);
  background-color: var(--surface-color);
  border-radius: var(--radius-md);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  z-index: 9999;
  overflow-y: auto;
  border: 1px solid var(--border-color);
  display: flex;
  flex-direction: column;
  /* Masquer la scrollbar */
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* Internet Explorer 10+ */
}

/* Masquer la scrollbar pour WebKit (Chrome, Safari, Edge) */
.floating-detail-panel::-webkit-scrollbar {
  display: none;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-sm) var(--spacing-md) var(--spacing-sm) var(--spacing-md);
  border-bottom: 1px solid var(--border-color);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-md) var(--radius-md) 0 0;
  position: sticky;
  top: 0;
  z-index: 10;
  flex-shrink: 0;
}

.header-content {
  display: flex;
  align-items: center;
  flex: 1;
}

.entity-info {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
}

.entity-icon {
  font-size: var(--font-size-lg);
}

.panel-header h3 {
  margin: 0;
  font-size: var(--font-size-md);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
}


.close-button {
  background: none;
  border: none;
  font-size: 20px;
  color: var(--text-muted);
  cursor: pointer;
  padding: 0;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--radius-sm);
  transition: all 0.2s ease;
}

.close-button:hover {
  background-color: var(--surface-hover);
  color: var(--text-dark);
}

.details-view,
.news-view,
.analysis-view {
  padding: var(--spacing-md);
  flex: 1;
  overflow-y: auto;
  /* Masquer la scrollbar */
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* Internet Explorer 10+ */
}

/* Masquer la scrollbar pour WebKit (Chrome, Safari, Edge) */
.details-view::-webkit-scrollbar,
.news-view::-webkit-scrollbar,
.analysis-view::-webkit-scrollbar {
  display: none;
}
</style>