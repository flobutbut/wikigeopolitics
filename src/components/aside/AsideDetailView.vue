<template>
  <div class="aside__detail-view">
    <div class="aside__section">
      <ReturnButton @click="returnToPreviousView" />
      
      <SectionTitle level="1" size="large">{{ detailData.title }}</SectionTitle>
      
      <div class="detail-content">
        <!-- Informations principales -->
        <DetailSection
          v-for="(section, index) in detailData.sections"
          :key="index"
          :title="section.title"
          :value="section.value"
          :keyValues="section.keyValues"
        />
        
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
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, ref } from 'vue'
import { useAsideStore } from '@/stores/asideStore'
import CollapsibleSection from './CollapsibleSection.vue'
import DetailSection from './DetailSection.vue'
import SectionTitle from '@/components/common/SectionTitle.vue'
import ReturnButton from '@/components/navigation/ReturnButton.vue'

export default defineComponent({
  name: 'AsideDetailView',
  
  components: {
    CollapsibleSection,
    DetailSection,
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
.aside__detail-view {
  /* Supprimer les paddings spécifiques */
}

.detail-content {
  padding: 0;
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