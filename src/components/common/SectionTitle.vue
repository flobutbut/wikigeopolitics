<template>
  <div class="custom-section-title-component">
    <slot></slot>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'SectionTitle'
})
</script>

<style scoped>
.custom-section-title-component {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
  margin: 0 0 var(--spacing-sm) 0;
  padding-left: var(--spacing-sm);
  color: var(--text-dark);
  line-height: normal;
}
</style> 