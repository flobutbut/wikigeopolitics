<template>
  <div class="layer-switcher" :class="theme">
    <TransitionGroup name="list">
      <div 
        v-for="(group, groupName) in groupedLayers" 
        :key="groupName"
        class="layer-group"
      >
        <h3 v-if="groupName !== 'default'" class="group-title">
          {{ groupName }}
          <button 
            class="group-toggle" 
            @click="toggleGroup(groupName)"
          >
            {{ isGroupExpanded(groupName) ? '−' : '+' }}
          </button>
        </h3>
        
        <div 
          v-show="isGroupExpanded(groupName)"
          class="group-content"
        >
          <div 
            v-for="layer in group" 
            :key="layer.id"
            class="layer-item"
          >
            <label :class="{ disabled: !layer.enabled }" class="switch-label">
              <input 
                type="checkbox" 
                v-model="layer.checked" 
                @change="() => handleChange(layer)"
                :disabled="!layer.enabled"
                class="switch-input"
              >
              <span class="switch-slider"></span>
              <span class="layer-name">{{ layer.name }}</span>
              <span v-if="layer.description" class="layer-description">
                {{ layer.description }}
              </span>
            </label>
          </div>
        </div>
      </div>
    </TransitionGroup>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, computed } from 'vue'

// Types
interface Layer {
  id: string
  name: string
  checked: boolean
  group?: string
  enabled?: boolean
  description?: string
  order?: number
}

interface LayerChangeEvent {
  layer: Layer
  checked: boolean
  timestamp: Date
}

interface GroupState {
  [key: string]: boolean
}

interface ThemeStyles {
  backgroundColor?: string
  textColor?: string
  accentColor?: string
}

export default defineComponent({
  name: 'LayerSwitcher',

  props: {
    initialLayers: {
      type: Array as () => Layer[],
      required: true,
      default: () => []
    },
    theme: {
      type: String,
      default: 'light',
      validator: (value: string) => ['light', 'dark'].includes(value)
    },
    styles: {
      type: Object as () => ThemeStyles,
      default: () => ({})
    },
    persistState: {
      type: Boolean,
      default: true
    }
  },

  emits: ['layer-change', 'group-toggle'],

  setup(props, { emit }) {
    // Fonction de chargement des états des groupes
    const loadGroupState = (): GroupState => {
      const saved = localStorage.getItem('layer-groups')
      return saved ? JSON.parse(saved) : { default: true }
    }

    const layers = ref<Layer[]>(props.initialLayers.map(layer => ({
      ...layer,
      enabled: layer.enabled !== false,
      group: layer.group || 'default'
    })))
    
    const expandedGroups = ref<GroupState>(loadGroupState())

    const groupedLayers = computed(() => {
      const groups: { [key: string]: Layer[] } = {}
      layers.value.forEach(layer => {
        const group = layer.group || 'default'
        if (!groups[group]) groups[group] = []
        groups[group].push(layer)
      })
      return groups
    })

    const handleChange = (layer: Layer): void => {
      const changeEvent: LayerChangeEvent = {
        layer,
        checked: layer.checked,
        timestamp: new Date()
      }
      emit('layer-change', changeEvent)
      localStorage.setItem(`layer-${layer.id}`, JSON.stringify({
        checked: layer.checked
      }))
    }

    const toggleGroup = (groupName: string): void => {
      expandedGroups.value[groupName] = !expandedGroups.value[groupName]
      emit('group-toggle', groupName, expandedGroups.value[groupName])
      localStorage.setItem('layer-groups', JSON.stringify(expandedGroups.value))
    }

    const isGroupExpanded = (groupName: string): boolean => {
      return expandedGroups.value[groupName] !== false
    }

    return {
      layers,
      groupedLayers,
      handleChange,
      toggleGroup,
      isGroupExpanded
    }
  }
})
</script>

<style scoped>
.layer-switcher {
  padding: var(--spacing-md);
  border-radius: var(--radius-lg);
  background-color: var(--surface-color);
  box-shadow: var(--shadow-sm);
}

.layer-switcher.light {
  color: var(--text-color);
}

.layer-switcher.dark {
  background-color: #2c3e50;
  color: var(--text-on-primary);
}

.layer-group {
  margin-bottom: var(--spacing-md);
}

.group-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: var(--spacing-sm) 0;
  font-size: var(--font-size-md);
  font-weight: var(--font-weight-medium);
}

.group-toggle {
  background: none;
  border: none;
  cursor: pointer;
  font-size: var(--font-size-lg);
  padding: 0 var(--spacing-sm);
  color: var(--text-color);
}

.layer-item {
  margin: var(--spacing-sm) 0;
}

.layer-name {
  font-size: var(--font-size-sm);
  line-height: var(--line-height-sm);
}

.layer-description {
  font-size: var(--font-size-xs);
  color: var(--text-muted);
  margin-left: var(--spacing-sm);
}

label.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Animations */
.list-enter-active,
.list-leave-active {
  transition: all var(--transition-speed) var(--transition-function);
}

.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.group-content {
  transition: all var(--transition-speed) var(--transition-function);
}

/* Style pour le switch */
.switch-label {
  position: relative;
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  cursor: pointer;
}

.switch-input {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

.switch-slider {
  position: relative;
  display: inline-block;
  width: 36px;
  height: 18px;
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-full);
  transition: background-color var(--transition-speed) var(--transition-function);
  flex-shrink: 0;
}

.switch-slider:before {
  position: absolute;
  content: "";
  height: 14px;
  width: 14px;
  left: 2px;
  bottom: 2px;
  background-color: var(--surface-color);
  border-radius: 50%;
  transition: transform var(--transition-speed) var(--transition-function);
}

.switch-input:checked + .switch-slider {
  background-color: var(--primary-color);
}

.switch-input:checked + .switch-slider:before {
  transform: translateX(18px);
}

.switch-input:disabled + .switch-slider {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Styles pour le thème sombre */
.layer-switcher.dark .switch-slider {
  background-color: #4a5568;
}

.layer-switcher.dark .switch-input:checked + .switch-slider {
  background-color: var(--primary-color);
}

.layer-switcher.dark .layer-description {
  color: #a0aec0;
}
</style>
