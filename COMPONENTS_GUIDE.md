# Guide des Composants - WikiGeopolitics

## 📋 Vue d'ensemble

WikiGeopolitics utilise une architecture de composants modulaire et réutilisable basée sur Vue 3 et TypeScript. Ce guide détaille chaque composant et son utilisation.

## 🎯 Architecture des composants

```
src/components/
├── aside/              # Panneau latéral et navigation
├── common/             # Composants réutilisables
├── header/             # En-tête de l'application  
├── map/                # Cartographie interactive
├── panels/             # Panneaux flottants et détails
└── timeline/           # Chronologie des événements
```

---

## 🔧 Composants Common (Réutilisables)

### EntitySection.vue

**Usage** : Affichage unifié de listes d'entités (pays, organisations, conflits)

```vue
<EntitySection
  title="Conflits armés"
  :items="conflicts"
  :expanded="true"
  :selectable="true"
  :config="conflictsConfig"
  @select="onConflictSelect"
/>
```

**Props** :
- `title: string` - Titre de la section
- `items: EntitySectionItem[]` - Liste des éléments à afficher
- `expanded: boolean` - État d'expansion initial
- `selectable: boolean` - Permet la sélection des éléments
- `config: EntitySectionConfig` - Configuration du mapping des champs
- `isItemSelected: (id: string) => boolean` - Fonction de vérification de sélection

**Configuration** :
```typescript
const conflictsConfig = {
  titleField: 'nom',        // Champ pour le titre
  subtitleField: 'status',  // Champ pour le sous-titre
  descriptionField: 'description',
  iconField: 'flag',
  metadataFields: [
    { key: 'startDate', label: 'Début', field: 'date_debut' }
  ]
}
```

### EntityItem.vue

**Usage** : Élément individuel dans une liste d'entités

```vue
<EntityItem
  :title="item.nom"
  :subtitle="item.status"
  :description="item.description"
  :is-selected="isSelected"
  :clickable="true"
  @select="onSelect"
/>
```

**Props** :
- `title: string` - Titre principal
- `subtitle?: string` - Sous-titre optionnel
- `description?: string` - Description
- `icon?: string` - Icône ou image
- `status?: string` - Statut de l'élément
- `isSelected: boolean` - État de sélection
- `clickable: boolean` - Élément cliquable

### Search.vue

**Usage** : Composant de recherche réutilisable

```vue
<Search
  v-model="searchQuery"
  placeholder="Rechercher un pays..."
  :debounce="300"
  @clear="onClearSearch"
/>
```

**Props** :
- `modelValue: string` - Valeur de recherche (v-model)
- `placeholder: string` - Texte d'indication
- `debounce?: number` - Délai de debounce en ms

### Button.vue

**Usage** : Boutons standardisés avec variantes

```vue
<Button
  variant="primary"
  size="medium"
  :disabled="isLoading"
  @click="onAction"
>
  Sauvegarder
</Button>
```

**Props** :
- `variant: 'primary' | 'secondary' | 'danger'` - Style du bouton
- `size: 'small' | 'medium' | 'large'` - Taille
- `disabled: boolean` - État désactivé
- `loading: boolean` - Affichage du loader

---

## 🗂️ Composants Aside (Panneau latéral)

### aside.vue

**Usage** : Conteneur principal du panneau latéral

Gère l'état global du panneau et la navigation entre les différentes vues.

**Fonctionnalités** :
- Gestion de l'état collapsed/expanded
- Navigation entre les vues (principale, listes, détails)
- Intégration avec les stores Pinia

### AsideMainView.vue

**Usage** : Vue principale du panneau avec menu de navigation

```vue
<AsideMainView
  :search-enabled="true"
  :navigation-items="mainMenuItems"
  @navigate="onNavigate"
/>
```

**Fonctionnalités** :
- Menu principal de navigation
- Recherche globale
- Accès rapide aux différentes sections

### AsideNavigationView.vue

**Usage** : Vue de navigation pour les listes (pays, organisations, etc.)

**Fonctionnalités** :
- Affichage de listes filtrables
- Navigation par catégories
- Recherche contextuelle
- Bouton de retour vers le menu principal

### CollapsibleSection.vue

**Usage** : Section repliable avec titre et contenu

```vue
<CollapsibleSection
  title="Informations économiques"
  :expanded="economyExpanded"
  @toggle="toggleEconomy"
>
  <div>Contenu économique...</div>
</CollapsibleSection>
```

**Props** :
- `title: string` - Titre de la section
- `expanded: boolean` - État d'expansion
- `icon?: string` - Icône optionnelle

### DetailSection.vue

**Usage** : Affichage de données structurées clé-valeur

```vue
<DetailSection
  :sections="[
    { title: 'Population', value: formatNumber(country.population) },
    { title: 'Superficie', value: formatArea(country.superficie) }
  ]"
/>
```

**Props** :
- `sections: Array<{title: string, value: string}>` - Données à afficher
- `value?: string` - Valeur unique (mode simplifié)

---

## 🗺️ Composants Map (Cartographie)

### map.vue

**Usage** : Carte interactive principale avec Leaflet

**Fonctionnalités** :
- Carte mondiale interactive
- Marqueurs de pays avec données géographiques
- Marqueurs de conflits avec épicentres
- Zones de combat géolocalisées
- Intégration avec le système de sélection

**Configuration** :
```typescript
const mapConfig = {
  center: [20, 0] as L.LatLngTuple,
  zoom: 2,
  minZoom: 1,
  maxZoom: 18
}
```

### ConflictMarker.vue

**Usage** : Marqueur spécialisé pour les conflits armés

```vue
<ConflictMarker
  :conflict="conflictData"
  :selected="isSelected"
  @select="onConflictSelect"
/>
```

**Props** :
- `conflict: ArmedConflict` - Données du conflit
- `selected: boolean` - État de sélection
- `interactive: boolean` - Marqueur interactif

### MapLayersControl.vue

**Usage** : Contrôles des couches de carte

**Fonctionnalités** :
- Basculement entre les couches (pays, conflits, organisations)
- Contrôle de la visibilité des marqueurs
- Filtres par type d'entité

---

## 📱 Composants Panels (Panneaux détails)

### UniversalFloatingPanel.vue

**Usage** : Panneau flottant universel pour toutes les entités

```vue
<UniversalFloatingPanel
  :entity-type="currentEntityType"
  :entity-data="currentEntity"
  :visible="panelVisible"
  @close="onPanelClose"
/>
```

**Props** :
- `entityType: 'country' | 'conflict' | 'organization' | 'regime'`
- `entityData: any` - Données de l'entité
- `visible: boolean` - Visibilité du panneau

### FloatingDetailView.vue

**Usage** : Vue détaillée pour les pays

**Fonctionnalités** :
- Informations générales (régime, chef d'état, économie)
- Sections collapsibles (histoire, coalitions, accords)
- Liste des conflits armés avec sélection
- Formatage intelligent des données

### ConflictDetailView.vue

**Usage** : Vue détaillée pour les conflits armés

```vue
<ConflictDetailView
  :data="conflictDetailData"
/>
```

**Fonctionnalités** :
- Informations principales (type, statut, intensité)
- Données géographiques et zones de combat
- Victimes et impact avec formatage JSON
- Pays impliqués avec liens
- Chronologie des événements

### OrganizationDetailView.vue

**Usage** : Vue détaillée pour les organisations internationales

**Fonctionnalités** :
- Informations générales (type, siège, description)
- Pays membres avec statuts
- Structure organisationnelle
- Activités et financement

### DetailViewContainer.vue

**Usage** : Conteneur standardisé pour les vues de détail

Fournit la structure de base et les styles cohérents pour tous les panneaux de détail.

---

## 🕒 Composants Timeline

### Timeline.vue

**Usage** : Chronologie interactive des événements géopolitiques

```vue
<Timeline
  :events="timelineEvents"
  :current-year="selectedYear"
  @year-select="onYearSelect"
/>
```

**Fonctionnalités** :
- Navigation temporelle
- Événements géopolitiques majeurs
- Filtrage par année/période
- Synchronisation avec la carte

---

## 🎨 Composants Header

### header.vue

**Usage** : En-tête de l'application

**Fonctionnalités** :
- Logo et titre de l'application
- Navigation principale
- Boutons d'action globaux
- Indicateurs de statut

---

## 🔧 Composants Debug

### SupabaseDiagnostic.vue

**Usage** : Diagnostic et monitoring Supabase

```vue
<SupabaseDiagnostic
  :visible="debugMode"
  @close="closeDebug"
/>
```

**Fonctionnalités** :
- Test de connexion Supabase
- Métriques de performance
- Compteurs de données par table
- Logs d'erreurs en temps réel

---

## 🎯 Bonnes pratiques

### 1. Naming conventions

```typescript
// Composants : PascalCase
EntitySection.vue
ConflictDetailView.vue

// Props : camelCase
isSelected: boolean
entityType: string

// Events : kebab-case
@item-select="onSelect"
@panel-close="onClose"
```

### 2. Props validation

```typescript
// Définition stricte des props
interface Props {
  title: string
  items?: EntityItem[]
  expanded?: boolean
  selectable?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  expanded: true,
  selectable: false
})
```

### 3. Émission d'événements

```typescript
// Typage des événements émis
const emit = defineEmits<{
  select: [item: EntityItem]
  toggle: [expanded: boolean]
  close: []
}>()

// Utilisation
emit('select', selectedItem)
```

### 4. Composables integration

```vue
<script setup lang="ts">
import { useAsyncState } from '@/composables/useAsyncState'
import { useSelection } from '@/composables/useSelection'

// État asynchrone avec gestion d'erreurs
const { data: countries, isLoading, error } = useAsyncState(
  () => supabaseService.getCountries(),
  { immediate: true }
)

// Système de sélection unifié
const { selectCountry, isSelected } = useSelection()
</script>
```

### 5. Responsive design

```vue
<template>
  <div 
    class="component"
    :class="{
      'component--mobile': isMobile,
      'component--collapsed': isCollapsed
    }"
  >
    <!-- Contenu adaptatif -->
  </div>
</template>

<script setup lang="ts">
import { useUIStore } from '@/stores/uiStore'

const uiStore = useUIStore()
const { isMobile } = storeToRefs(uiStore)
</script>
```

---

## 🚀 Évolutions futures

### Composants prévus

1. **DataVisualization.vue** - Graphiques et charts
2. **ExportPanel.vue** - Export de données
3. **FilterPanel.vue** - Filtres avancés
4. **NotificationCenter.vue** - Centre de notifications
5. **UserProfile.vue** - Profil utilisateur
6. **CollaborationPanel.vue** - Fonctionnalités collaboratives

### Améliorations

1. **Virtual scrolling** pour les grandes listes
2. **Lazy loading** des composants lourds
3. **Animations** et transitions fluides
4. **Accessibility** (ARIA, navigation clavier)
5. **Tests unitaires** complets
6. **Storybook** pour la documentation interactive

---

L'architecture des composants de WikiGeopolitics est conçue pour être **modulaire**, **réutilisable** et **facilement extensible**. Chaque composant a une responsabilité claire et s'intègre harmonieusement dans l'écosystème global de l'application.