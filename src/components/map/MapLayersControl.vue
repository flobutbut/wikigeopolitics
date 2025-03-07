<template>
  <div class="map-layers-control">
    <div class="layers-control-header">
      <h3>Couches</h3>
    </div>
    
    <div class="layers-list">
      <div 
        v-for="(layer, key) in availableLayers" 
        :key="key"
        class="layer-item"
      >
        <label class="layer-toggle">
          <input 
            type="checkbox" 
            :checked="visibleLayers[key]"
            @change="toggleLayer(key)"
          >
          <span class="layer-name">{{ layer.name }}</span>
        </label>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'MapLayersControl',
  
  props: {
    visibleLayers: {
      type: Object,
      required: true
    }
  },
  
  emits: ['toggle-layer'],
  
  setup(props, { emit }) {
    const availableLayers = {
      countries: {
        name: 'Pays'
      },
      tradeRoutes: {
        name: 'Routes commerciales'
      },
      conflictZones: {
        name: 'Zones de conflit'
      }
    }
    
    const toggleLayer = (layerKey: string) => {
      emit('toggle-layer', layerKey)
    }
    
    return {
      availableLayers,
      toggleLayer
    }
  }
})
</script>

<style scoped>
.map-layers-control {
  position: absolute;
  top: var(--spacing-md);
  right: var(--spacing-md);
  background-color: white;
  border-radius: var(--radius-md);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  width: 200px;
  z-index: 1000;
  overflow: hidden;
}

.layers-control-header {
  padding: var(--spacing-sm);
  background-color: var(--surface-dimmed);
  border-bottom: 1px solid var(--border-color);
}

.layers-control-header h3 {
  margin: 0;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
  color: var(--text-dark);
}

.layers-list {
  padding: var(--spacing-xs);
}

.layer-item {
  padding: var(--spacing-xs) var(--spacing-sm);
}

.layer-toggle {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.layer-toggle input {
  margin-right: var(--spacing-sm);
}

.layer-name {
  font-size: var(--font-size-sm);
  color: var(--text-color);
}
</style> 