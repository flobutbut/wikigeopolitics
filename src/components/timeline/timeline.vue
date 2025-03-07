<template>
  <div class="timeline">
    <div class="timeline__selector">
      <button
        v-for="year in years"
        :key="year"
        :class="{ 'timeline__year--active': year === selectedYear }"
        class="timeline__year"
        @click="selectYear(year)"
      >
        {{ year }}
      </button>
    </div>
    <div class="timeline__controls">
      <button 
        class="timeline__control timeline__control--plus" 
        @click="displayMonths" 
        :disabled="isPlusDisabled"
        aria-label="Zoom in"
      >
        <img src="@assets/triggers/Timeline-plus.svg" alt="+" />
      </button>
      <button 
        class="timeline__control timeline__control--minus" 
        @click="reloadYears" 
        :disabled="isMinusDisabled"
        aria-label="Zoom out"
      >
        <img src="@assets/triggers/Timeline-minus.svg" alt="-" />
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, PropType } from 'vue'

// Constants
const DEFAULT_START_YEAR = 2012
const DEFAULT_END_YEAR = 2024
const CURRENT_YEAR = new Date().getFullYear()

// Types
type Year = number

enum ViewMode {
  YEARS = 'years',
  MONTHS = 'months'
}

interface TimelineConfig {
  startYear: Year
  endYear: Year
  initialYear?: Year
}

interface TimelineEmits {
  (e: 'year-selected', year: Year): void
  (e: 'mode-changed', mode: ViewMode): void
}

export default defineComponent({
  name: 'Timeline',

  props: {
    config: {
      type: Object as PropType<TimelineConfig>,
      default: () => ({
        startYear: DEFAULT_START_YEAR,
        endYear: DEFAULT_END_YEAR,
        initialYear: CURRENT_YEAR
      })
    }
  },

  emits: ['year-selected', 'mode-changed'],

  setup(props, { emit }) {
    const years = ref<Year[]>([])
    const selectedYear = ref<Year>(props.config.initialYear || CURRENT_YEAR)
    const isPlusDisabled = ref<boolean>(false)
    const isMinusDisabled = ref<boolean>(true)
    const currentMode = ref<ViewMode>(ViewMode.YEARS)

    const validateYearRange = (start: Year, end: Year): boolean => {
      return start <= end && start > 1900 && end <= CURRENT_YEAR + 10
    }

    const generateYears = (startYear: Year, endYear: Year): void => {
      if (!validateYearRange(startYear, endYear)) {
        console.error('Invalid year range')
        return
      }

      years.value = []
      for (let year = startYear; year <= endYear; year++) {
        years.value.push(year)
      }
    }

    const selectYear = (year: Year): void => {
      selectedYear.value = year
      isPlusDisabled.value = false
      isMinusDisabled.value = true
      emit('year-selected', year)
    }

    const displayMonths = (): void => {
      currentMode.value = ViewMode.MONTHS
      isPlusDisabled.value = true
      isMinusDisabled.value = false
      emit('mode-changed', ViewMode.MONTHS)
    }

    const reloadYears = (): void => {
      currentMode.value = ViewMode.YEARS
      generateYears(props.config.startYear, props.config.endYear)
      isPlusDisabled.value = false
      isMinusDisabled.value = true
      emit('mode-changed', ViewMode.YEARS)
    }

    // Initialisation
    generateYears(props.config.startYear, props.config.endYear)

    return {
      years,
      selectedYear,
      selectYear,
      displayMonths,
      reloadYears,
      isPlusDisabled,
      isMinusDisabled,
      currentMode
    }
  }
})
</script>

<style scoped>
.timeline {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: var(--spacing-md);
  background-color: var(--surface-color);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
}

.timeline__selector {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: var(--spacing-xs);
  margin-bottom: var(--spacing-md);
}

.timeline__year {
  padding: var(--spacing-xs) var(--spacing-sm);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-sm);
  background-color: var(--surface-color);
  color: var(--text-color);
  font-size: var(--font-size-sm);
  cursor: pointer;
  transition: all var(--transition-speed) var(--transition-function);
}

.timeline__year:hover {
  background-color: var(--surface-hover);
}

.timeline__year--active {
  background-color: var(--primary-color);
  color: var(--text-on-primary);
  border-color: var(--primary-color);
}

.timeline__controls {
  display: flex;
  gap: var(--spacing-md);
}

.timeline__control {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 30px;
  border-radius: var(--radius-full);
  border: 1px solid var(--border-color);
  background-color: var(--surface-color);
  cursor: pointer;
  transition: all var(--transition-speed) var(--transition-function);
}

.timeline__control:hover:not(:disabled) {
  background-color: var(--surface-hover);
}

.timeline__control:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.timeline__control img {
  width: 14px;
  height: 14px;
}
</style>
