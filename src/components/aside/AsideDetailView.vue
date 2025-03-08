<template>
  <div class="aside__section">
    <ReturnButton @click="returnToPreviousView" />
    
    <SectionTitle>{{ detailData.title }}</SectionTitle>
    
    <div class="detail-content">
      <!-- Informations principales -->
      <div v-for="(section, index) in detailData.sections" :key="index" class="detail-section">
        <h3 v-if="section.title" class="detail-section-title">{{ section.title }}</h3>
        <div v-if="section.value" class="detail-section-value">{{ section.value }}</div>
        
        <!-- Affichage des paires clé-valeur -->
        <div v-if="section.keyValues" class="key-value-list">
          <div v-for="(item, idx) in section.keyValues" :key="idx" class="key-value-item">
            <div class="key-value-key">{{ item.key }}</div>
            <div class="key-value-value">{{ item.value }}</div>
          </div>
        </div>
      </div>
      
      <!-- Sections collapsibles -->
      <CollapsibleSection 
        v-for="section in detailData.collapsibleSections" 
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
      <CollapsibleSection
        v-if="detailData.coalitions && detailData.coalitions.length > 0"
        title="Coalitions diplomatiques"
        :expanded="coalitionsExpanded"
        @toggle="toggleCoalitions"
      >
        <div class="coalitions-list">
          <div v-for="coalition in detailData.coalitions" :key="coalition.id" class="coalition-item">
            {{ coalition.title }}
          </div>
        </div>
      </CollapsibleSection>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, ref } from 'vue'
import { useAsideStore } from '@/stores/asideStore'
import CollapsibleSection from './CollapsibleSection.vue'
import SectionTitle from '@/components/common/SectionTitle.vue'
import ReturnButton from '@/components/navigation/ReturnButton.vue'

export default defineComponent({
  name: 'AsideDetailView',
  
  components: {
    CollapsibleSection,
    SectionTitle,
    ReturnButton
  },
  
  setup() {
    const asideStore = useAsideStore()
    const coalitionsExpanded = ref(true)
    
    // Retour à la vue précédente
    const returnToPreviousView = () => {
      asideStore.returnToPreviousView()
    }
    
    // Toggle pour les sections collapsibles
    const toggleSection = (sectionId: string, expanded: boolean) => {
      asideStore.toggleDetailSection(sectionId)
    }
    
    // Toggle pour les coalitions
    const toggleCoalitions = () => {
      coalitionsExpanded.value = !coalitionsExpanded.value
    }
    
    return {
      detailData: computed(() => asideStore.currentDetailData),
      coalitionsExpanded,
      returnToPreviousView,
      toggleSection,
      toggleCoalitions
    }
  }
})
</script>

<style scoped>
.aside__section {
  padding: var(--spacing-md) 0 var(--spacing-sm) var(--spacing-md);
  box-sizing: border-box;
}

.detail-content {
  padding: 0;
}

.detail-section {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
  margin-bottom: var(--spacing-sm);
}

.detail-section-title {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
  margin-bottom: var(--spacing-xs);
}

.detail-section-value {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
  margin-bottom: var(--spacing-xs);
}

.key-value-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.key-value-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-xs) 0;
}

.key-value-key {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
}

.key-value-value {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
  text-align: right;
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
  transition: background-color var(--transition-speed) var(--transition-function);
}

.coalition-item:hover {
  background-color: var(--surface-hover);
}
</style> 