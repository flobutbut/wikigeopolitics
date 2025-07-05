<template>
  <div v-if="selectedCountry && selectedCountry.title" class="floating-detail-panel">
    <div class="panel-header">
      <h3>{{ selectedCountry.title }}</h3>
      <button @click="closePanel" class="close-button">×</button>
    </div>
    
    <div class="panel-content">
      <!-- Sections principales -->
      <DetailSection
        v-for="(section, index) in selectedCountry.sections"
        :key="index"
        :title="section.title"
        :value="section.value"
        :keyValues="section.keyValues"
      />
      
      <!-- Sections collapsibles -->
      <CollapsibleSection 
        v-for="section in selectedCountry.collapsibleSections" 
        :key="section.id"
        :title="section.title"
        :content="section.content"
        :source="section.source"
        :sourceUrl="section.sourceUrl"
        :expanded="section.expanded"
        :sectionId="section.id"
        @toggle="toggleSection"
      />
      
      <!-- Coalitions diplomatiques -->
      <div v-if="selectedCountry.coalitions && selectedCountry.coalitions.length > 0" class="coalitions-section">
        <SectionTitle level="4" size="small">Coalitions diplomatiques</SectionTitle>
        <div class="coalitions-list">
          <div v-for="coalition in selectedCountry.coalitions" :key="coalition.id" class="coalition-item">
            {{ coalition.title }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useAsideStore } from '@/stores/asideStore'
import DetailSection from '@/components/aside/DetailSection.vue'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'
import SectionTitle from '@/components/common/SectionTitle.vue'

export default defineComponent({
  name: 'FloatingDetailPanel',
  
  components: {
    DetailSection,
    CollapsibleSection,
    SectionTitle
  },
  
  setup() {
    const asideStore = useAsideStore()
    
    const selectedCountry = computed(() => {
      console.log('FloatingDetailPanel - selectedCountry:', asideStore.currentDetailData)
      return asideStore.currentDetailData
    })
    
    const toggleSection = (sectionId: string, expanded: boolean) => {
      // Toggle l'état d'expansion de la section
      const section = selectedCountry.value.collapsibleSections.find((s: any) => s.id === sectionId)
      if (section) {
        section.expanded = expanded
      }
    }
    
    const closePanel = () => {
      // Vider les données du pays sélectionné sans changer la vue
      asideStore.currentDetailData = {
        id: '',
        title: '',
        sections: [],
        collapsibleSections: [],
        coalitions: []
      }
    }
    
    return {
      selectedCountry,
      toggleSection,
      closePanel
    }
  }
})
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
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-md);
  border-bottom: 1px solid var(--border-color);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-md) var(--radius-md) 0 0;
}

.panel-header h3 {
  margin: 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
}

.close-button {
  background: none;
  border: none;
  font-size: 24px;
  color: var(--text-muted);
  cursor: pointer;
  padding: 0;
  width: 24px;
  height: 24px;
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

.panel-content {
  padding: var(--spacing-md);
}



.coalitions-section {
  margin-top: var(--spacing-md);
}



.coalitions-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.coalition-item {
  padding: var(--spacing-xs);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.coalition-item:hover {
  background-color: var(--surface-hover);
}
</style> 