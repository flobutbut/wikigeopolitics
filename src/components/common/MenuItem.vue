<template>
  <li class="menu-item" :class="{ 'menu-item--active': isActive }">
    <template v-if="isLayer">
      <label class="menu-item__layer">
        <span class="menu-item__title">{{ title }}</span>
        <input 
          type="checkbox" 
          v-model="isChecked"
          @change="handleToggle"
          class="switch-input"
        >
        <span class="switch-slider"></span>
      </label>
    </template>
    <template v-else>
      <a 
        :href="link" 
        class="menu-item__link"
        @click="handleClick"
      >
        <span class="menu-item__title">{{ title }}</span>
        <span 
          v-if="hasChildren" 
          class="menu-item__chevron"
          :class="{ 'menu-item__chevron--expanded': isExpanded }"
        >
          <ChevronIcon direction="right" :size="12" />
        </span>
      </a>
      
      <!-- Sous-menu pour les éléments enfants -->
      <transition name="submenu">
        <ul v-if="hasChildren && isExpanded" class="menu-item__submenu">
          <slot name="children"></slot>
        </ul>
      </transition>
    </template>
  </li>
</template>

<script lang="ts">
import { defineComponent, ref, computed } from 'vue'
import ChevronIcon from '@/components/icons/ChevronIcon.vue'

export default defineComponent({
  name: 'MenuItem',

  components: {
    ChevronIcon
  },

  props: {
    title: {
      type: String,
      required: true
    },
    link: {
      type: String,
      default: '#'
    },
    isLayer: {
      type: Boolean,
      default: false
    },
    initialState: {
      type: Boolean,
      default: false
    },
    hasChildren: {
      type: Boolean,
      default: false
    },
    depth: {
      type: Number,
      default: 0
    }
  },

  emits: ['toggle', 'click', 'expand'],

  setup(props, { emit }) {
    const isChecked = ref(props.initialState)
    const isExpanded = ref(false)
    const isActive = computed(() => 
      window.location.pathname === props.link
    )

    const handleToggle = () => {
      emit('toggle', {
        title: props.title,
        state: isChecked.value
      })
    }

    const handleClick = (event: MouseEvent) => {
      if (props.hasChildren) {
        event.preventDefault()
        isExpanded.value = !isExpanded.value
        emit('expand', {
          title: props.title,
          expanded: isExpanded.value,
          depth: props.depth
        })
      }
      emit('click', {
        title: props.title,
        depth: props.depth
      })
    }

    return {
      isChecked,
      isExpanded,
      isActive,
      handleToggle,
      handleClick
    }
  }
})
</script>

<style scoped>
.menu-item {
  list-style: none;
  margin: var(--spacing-xs) 0;
}

.menu-item__link,
.menu-item__layer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--spacing-xs) var(--spacing-sm);
  text-decoration: none;
  color: var(--text-color);
  border-radius: var(--radius-sm);
  transition: background-color var(--transition-speed) var(--transition-function);
  font-size: var(--font-size-sm);
  line-height: var(--line-height-sm);
}

.menu-item__link:hover {
  background-color: var(--surface-hover);
}

.menu-item--active .menu-item__link {
  background-color: rgba(46, 67, 255, 0.1);
  color: var(--primary-color);
}

.menu-item__title {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.menu-item__chevron {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-left: var(--spacing-xs);
  transition: transform var(--transition-speed) var(--transition-function);
  color: var(--text-muted);
}

.menu-item__chevron--expanded {
  transform: rotate(90deg);
  color: var(--primary-color);
}

.menu-item__layer {
  cursor: pointer;
}

/* Styles pour le sous-menu */
.menu-item__submenu {
  padding-left: var(--spacing-md);
  margin-top: var(--spacing-xs);
  border-left: 1px solid var(--border-color);
}

/* Animation du sous-menu */
.submenu-enter-active,
.submenu-leave-active {
  transition: all var(--transition-speed) var(--transition-function);
  max-height: 1000px;
  opacity: 1;
  overflow: hidden;
}

.submenu-enter-from,
.submenu-leave-to {
  max-height: 0;
  opacity: 0;
}

/* Styles pour le switch */
.switch-input {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

.switch-slider {
  position: relative;
  display: inline-block;
  width: 32px;
  height: 16px;
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-full);
  transition: background-color var(--transition-speed) var(--transition-function);
}

.switch-slider:before {
  position: absolute;
  content: "";
  height: 12px;
  width: 12px;
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
  transform: translateX(16px);
}
</style> 