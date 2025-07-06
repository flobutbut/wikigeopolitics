<template>
  <div class="news-view">
    <div class="news-placeholder">
      <div class="placeholder-icon">📰</div>
      <h3>Actualités</h3>
      <p>Les actualités géopolitiques seront bientôt disponibles pour ce pays.</p>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'NewsView',
  
  props: {
    countryId: {
      type: String,
      required: true
    }
  }
})
</script>

<style scoped>
.news-view {
  padding: var(--spacing-md);
  height: 100%;
}

.news-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  text-align: center;
  color: var(--text-muted);
}

.placeholder-icon {
  font-size: 48px;
  margin-bottom: var(--spacing-md);
}

.news-placeholder h3 {
  margin: 0 0 var(--spacing-sm) 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
}

.news-placeholder p {
  margin: 0;
  font-size: var(--font-size-sm);
  line-height: 1.5;
}
</style> 