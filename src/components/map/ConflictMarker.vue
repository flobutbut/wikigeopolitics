<template>
  <div class="conflict-marker" :class="conflictStatusClass">
    <div class="explosion-icon">💥</div>
    <div v-if="showTooltip" class="conflict-tooltip">
      <div class="tooltip-title">{{ conflict.name }}</div>
      <div class="tooltip-status">{{ formatStatus(conflict.status) }}</div>
      <div v-if="conflict.startYear" class="tooltip-period">
        {{ formatPeriod(conflict.startYear, conflict.endYear) }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'

interface Conflict {
  id: string
  name: string
  status: 'active' | 'inactive' | 'resolved'
  startYear?: number
  endYear?: number
  description?: string
}

const props = defineProps<{
  conflict: Conflict
  isSelected?: boolean
}>()

const showTooltip = ref(false)

// Classe CSS en fonction du statut et de l'intensité
const conflictStatusClass = computed(() => {
  const classes = [`status-${props.conflict.status}`]
  if (props.conflict.intensity) {
    classes.push(`intensity-${props.conflict.intensity}`)
  }
  if (props.isSelected) {
    classes.push('selected')
  }
  return classes.join(' ')
})

// Formatage du statut
const formatStatus = (status: string) => {
  const statusMap: Record<string, string> = {
    'active': '🔴 Actif',
    'inactive': '🟡 Inactif', 
    'resolved': '🟢 Résolu'
  }
  return statusMap[status] || status
}

// Formatage de la période
const formatPeriod = (startYear?: number, endYear?: number) => {
  if (!startYear) return 'Période inconnue'
  if (!endYear) return `Depuis ${startYear}`
  return `${startYear} - ${endYear}`
}

// Événements pour afficher/masquer le tooltip
const handleMouseEnter = () => {
  showTooltip.value = true
}

const handleMouseLeave = () => {
  showTooltip.value = false
}

// Exposer les événements pour que le parent puisse les écouter
defineExpose({
  handleMouseEnter,
  handleMouseLeave
})
</script>

<style scoped>
.conflict-marker {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 1000;
  transition: all 0.3s ease;
}

.explosion-icon {
  font-size: 20px;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
  transition: transform 0.2s ease;
}

.conflict-marker:hover .explosion-icon {
  transform: scale(1.2);
}

.conflict-marker.selected .explosion-icon {
  transform: scale(1.3);
  filter: drop-shadow(0 4px 8px rgba(255, 0, 0, 0.5));
}

/* Styles selon le statut du conflit */
.conflict-marker.status-active .explosion-icon {
  animation: pulse 2s infinite;
}

.conflict-marker.status-inactive .explosion-icon {
  opacity: 0.7;
  filter: grayscale(30%);
}

.conflict-marker.status-resolved .explosion-icon {
  opacity: 0.5;
  filter: grayscale(70%);
}

/* Styles selon l'intensité */
.conflict-marker.intensity-very_high .explosion-icon {
  font-size: 20px;
  animation: pulse-intense 1.5s infinite;
  filter: drop-shadow(0 3px 6px rgba(255, 0, 0, 0.6));
}

.conflict-marker.intensity-high .explosion-icon {
  font-size: 20px;
  animation: pulse 2s infinite;
  filter: drop-shadow(0 2px 5px rgba(255, 100, 0, 0.5));
}

.conflict-marker.intensity-medium .explosion-icon {
  font-size: 20px;
  filter: drop-shadow(0 2px 4px rgba(255, 150, 0, 0.4));
}

.conflict-marker.intensity-low .explosion-icon {
  font-size: 20px;
  opacity: 0.8;
  filter: drop-shadow(0 1px 3px rgba(200, 200, 0, 0.3));
}

/* Animation de pulsation pour les conflits actifs */
@keyframes pulse {
  0% {
    transform: scale(1);
    filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
  }
  50% {
    transform: scale(1.1);
    filter: drop-shadow(0 4px 8px rgba(255, 0, 0, 0.6));
  }
  100% {
    transform: scale(1);
    filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
  }
}

/* Animation intense pour très haute intensité */
@keyframes pulse-intense {
  0% {
    transform: scale(1);
    filter: drop-shadow(0 3px 6px rgba(255, 0, 0, 0.6));
  }
  25% {
    transform: scale(1.2);
    filter: drop-shadow(0 5px 10px rgba(255, 0, 0, 0.8));
  }
  50% {
    transform: scale(1.1);
    filter: drop-shadow(0 4px 8px rgba(255, 50, 0, 0.7));
  }
  75% {
    transform: scale(1.15);
    filter: drop-shadow(0 6px 12px rgba(255, 0, 0, 0.9));
  }
  100% {
    transform: scale(1);
    filter: drop-shadow(0 3px 6px rgba(255, 0, 0, 0.6));
  }
}

/* Tooltip */
.conflict-tooltip {
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  background-color: rgba(0, 0, 0, 0.9);
  color: white;
  padding: var(--spacing-xs) var(--spacing-sm);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-xs);
  white-space: nowrap;
  margin-bottom: var(--spacing-xs);
  z-index: 1001;
  pointer-events: none;
}

.conflict-tooltip::after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%);
  width: 0;
  height: 0;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
  border-top: 5px solid rgba(0, 0, 0, 0.9);
}

.tooltip-title {
  font-weight: var(--font-weight-bold);
  margin-bottom: var(--spacing-xs);
}

.tooltip-status {
  font-size: var(--font-size-xs);
  margin-bottom: var(--spacing-xs);
}

.tooltip-period {
  font-size: var(--font-size-xs);
  color: #ccc;
  font-style: italic;
}

/* Effets de survol */
.conflict-marker:hover {
  z-index: 1002;
}

.conflict-marker:hover .conflict-tooltip {
  display: block;
}
</style>