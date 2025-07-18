<template>
  <div class="detail-view-container">
    <slot />
  </div>
</template>

<script setup lang="ts">
// Composant container unifié pour tous les DetailViews
</script>

<style scoped>
.detail-view-container {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
  padding: 0;
}
</style>