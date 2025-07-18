# Intégration Supabase - WikiGeopolitics

## 📊 Vue d'ensemble

WikiGeopolitics a migré avec succès de PostgreSQL local vers **Supabase** pour une architecture cloud moderne et scalable. Cette migration maintient toutes les fonctionnalités existantes tout en apportant des améliorations significatives.

## 🔧 Configuration Supabase

### Variables d'environnement

```bash
# .env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

### Initialisation du client

```typescript
// src/services/supabaseService.ts
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseKey)
```

## 🗃️ Structure de base de données

### Tables principales

#### Countries (`country`)
```sql
- id: string (primary key)
- nom: string
- capitale: string
- population: bigint
- superficie: numeric
- latitude: numeric
- longitude: numeric
- drapeau: string
- continent: string
- pib: numeric
- revenumedian: numeric
- langue: string
- monnaie: string
- histoire: text
```

#### Political Regimes (`political_regime`)
```sql
- id: string (primary key)
- name: string
- description: text
```

#### Country Political Regime (relation) (`country_political_regime`)
```sql
- country_id: string (foreign key)
- regime_id: string (foreign key)
- chef_etat: string
- date_prise_poste: date
- current_regime: boolean
```

#### Armed Conflicts (`armed_conflict`)
```sql
- id: string (primary key)
- name: string
- description: text
- startyear: integer
- endyear: integer
- status: string
- casualtyestimates: jsonb
- involvedcountries: text[]
- epicenter: geometry(Point,4326)
- geopoliticalimpact: text
```

#### Combat Zones (`armed_conflict_combat_zone`)
```sql
- id: string (primary key)
- conflict_id: string (foreign key)
- name: string
- description: text
- coordinates: geometry(Point,4326)
- status: string
```

#### Organizations (`organization`)
```sql
- id: string (primary key)
- nom: string
- acronyme: string
- type: string
- description: text
- datecreation: date
- siege: string
```

#### Country Organization (relation) (`country_organization`)
```sql
- countryid: string (foreign key)
- organizationid: string (foreign key)
```

#### Conflict Country (relation) (`conflict_country`)
```sql
- conflictid: string (foreign key)
- countryid: string (foreign key)
```

## 🔌 Service API unifié

### Structure du service

```typescript
export const supabaseService = {
  // === PAYS ===
  async getCountries(): Promise<Country[]>
  async getCountryById(id: string): Promise<any | null>
  async searchCountries(query: string): Promise<Country[]>
  async getCountriesByContinent(continent: string): Promise<Country[]>
  async getCountriesByRegime(regimeId: string): Promise<Country[]>
  async getCountriesByOrganization(organizationId: string): Promise<Country[]>
  
  // === ORGANISATIONS ===
  async getOrganizationsByType(): Promise<Record<string, Organization[]>>
  async getOrganizationsByCountry(countryId: string): Promise<any[]>
  async getOrganizationById(id: string): Promise<any | null>
  async searchOrganizations(query: string): Promise<any[]>
  
  // === RÉGIMES POLITIQUES ===
  async getPoliticalRegimes(): Promise<PoliticalRegime[]>
  
  // === CONFLITS ARMÉS ===
  async getArmedConflicts(): Promise<ArmedConflict[]>
  async getArmedConflictById(id: string): Promise<any | null>
  async getArmedConflictsByStatus(status: string): Promise<ArmedConflict[]>
  async getConflictsByCountry(countryId: string): Promise<ArmedConflict[]>
  async getCountriesByConflict(conflictId: string): Promise<Country[]>
  async searchArmedConflicts(query: string): Promise<ArmedConflict[]>
  
  // === ZONES DE COMBAT ===
  async getCombatZonesByConflict(conflictId: string): Promise<any[]>
  async getActiveCombatZones(): Promise<any[]>
}
```

### Exemples d'utilisation

#### Récupération des pays avec données politiques
```typescript
const countryData = await supabaseService.getCountryById('france')
// Retourne:
// {
//   id: 'france',
//   nom: 'France',
//   capitale: 'Paris',
//   regime_politique: 'République',
//   chef_etat: 'Emmanuel Macron',
//   datePrisePoste: '2017-05-14',
//   conflitsArmes: [...],
//   coalitions: [...],
//   accords: [...]
// }
```

#### Conflits avec zones de combat
```typescript
const conflict = await supabaseService.getArmedConflictById('ukraine-war')
const combatZones = await supabaseService.getCombatZonesByConflict('ukraine-war')
// Retourne les zones géolocalisées du conflit
```

#### Recherche multi-critères
```typescript
const conflicts = await supabaseService.searchArmedConflicts('ukraine')
const countries = await supabaseService.searchCountries('france')
const organizations = await supabaseService.searchOrganizations('union')
```

## 🔄 Migration des données

### Mapping des champs

| Ancien (PostgreSQL) | Nouveau (Supabase) | Type |
|-------------------|-------------------|------|
| `coordonnees` | `latitude`/`longitude` | Geographic |
| `regimePolitique` | `political_regime.name` | Relational |
| `chefEtat` | `country_political_regime.chef_etat` | Relational |
| `casualtyEstimates` | `casualtyestimates` (JSONB) | Enhanced |
| `combatZones` | `armed_conflict_combat_zone` | Normalized |

### Gestion des données JSON

Les estimations de victimes sont stockées en format JSON pour plus de flexibilité :

```typescript
// Format des données de victimes
interface CasualtyEstimates {
  total_casualties_2024?: string
  ukrainian_civilian_deaths?: string
  ukrainian_military_deaths?: string
  russian_civilian_deaths?: string
  russian_military_deaths?: string
  prisoners_of_war?: string
  displaced_refugees?: string
  internally_displaced?: string
  monthly_russian_casualties_2024?: string
}
```

### Données géospatiales

Supabase supporte PostGIS nativement :

```sql
-- Recherche géospatiale
SELECT * FROM country 
WHERE ST_DWithin(
  ST_GeogFromText('POINT(2.3522 48.8566)'), -- Paris
  ST_GeogFromText(ST_AsText(coordonnees)),
  100000 -- 100km
);

-- Epicenters des conflits
SELECT 
  name,
  ST_AsGeoJSON(epicenter) as epicenter_geojson
FROM armed_conflict 
WHERE epicenter IS NOT NULL;
```

## 📱 Intégration frontend

### Stores mis à jour

Les stores utilisent maintenant `supabaseService` :

```typescript
// src/stores/asideStore.ts
import { supabaseService } from '@/services/supabaseService'

export const useAsideStore = defineStore('aside', {
  actions: {
    async loadCountryDetails(id: string) {
      try {
        const countryData = await supabaseService.getCountryById(id)
        this.currentDetailData = this.mapCountryData(countryData)
      } catch (error) {
        console.error('Erreur chargement pays:', error)
      }
    },
    
    async loadArmedConflicts() {
      try {
        const conflicts = await supabaseService.getArmedConflicts()
        this.appData.armedConflictList = conflicts || []
      } catch (error) {
        console.error('Erreur chargement conflits:', error)
      }
    }
  }
})
```

### Composants optimisés

```typescript
// src/components/panels/FloatingDetailView.vue
<script setup lang="ts">
import { supabaseService } from '@/services/supabaseService'

// Chargement asynchrone avec Supabase
const { data: countryDetails, isLoading } = useAsyncState(
  () => supabaseService.getCountryById(props.countryId),
  { immediate: true }
)
</script>
```

## 🚀 Avantages de l'intégration

### Performance
- **Cache intelligent** : Supabase Edge optimise automatiquement les requêtes
- **CDN global** : Distribution mondiale des données
- **Connexions poolées** : Gestion optimisée des connexions

### Scalabilité
- **Auto-scaling** : Adaptation automatique à la charge
- **Backup automatique** : Sauvegardes quotidiennes
- **Haute disponibilité** : 99.9% d'uptime garanti

### Développement
- **Real-time** : Subscriptions aux changements de données
- **APIs auto-générées** : Endpoints REST et GraphQL
- **Dashboard intégré** : Interface d'administration

### Sécurité
- **Row Level Security (RLS)** : Sécurité au niveau des lignes
- **Authentification intégrée** : Système d'auth complet
- **Chiffrement** : Données chiffrées en transit et au repos

## 🔧 Configuration avancée

### Policies de sécurité (RLS)

```sql
-- Politique pour l'accès aux pays (lecture publique)
CREATE POLICY "Public read access for countries" 
ON country FOR SELECT 
USING (true);

-- Politique pour les conflits actifs uniquement
CREATE POLICY "Active conflicts only" 
ON armed_conflict FOR SELECT 
USING (status IN ('active', 'ongoing'));
```

### Indexes de performance

```sql
-- Index géospatial pour les recherches par proximité
CREATE INDEX idx_country_coordinates 
ON country USING GIST (coordonnees);

-- Index pour les recherches textuelles
CREATE INDEX idx_country_search 
ON country USING GIN (to_tsvector('french', nom || ' ' || capitale));

-- Index pour les relations pays-conflits
CREATE INDEX idx_conflict_country_composite 
ON conflict_country (conflictid, countryid);
```

### Subscriptions temps réel

```typescript
// Écoute des changements en temps réel
const subscription = supabase
  .channel('public:armed_conflict')
  .on('postgres_changes', 
    { event: '*', schema: 'public', table: 'armed_conflict' },
    (payload) => {
      console.log('Conflit mis à jour:', payload)
      // Mise à jour automatique de l'interface
      store.refreshConflicts()
    }
  )
  .subscribe()
```

## 🔍 Monitoring et diagnostics

### Métriques disponibles

Le composant `SupabaseDiagnostic.vue` fournit :
- **Statut de connexion** : Vérification en temps réel
- **Performance des requêtes** : Temps de réponse
- **Compteurs de données** : Nombre d'enregistrements par table
- **Santé de la base** : État des services

### Debugging

```typescript
// Activation des logs détaillés
localStorage.setItem('supabase.debug', 'true')

// Trace des requêtes
const { data, error } = await supabase
  .from('country')
  .select('*')
  .limit(10)
  .explain() // Affiche le plan d'exécution
```

## 📋 Checklist de migration

### ✅ Complété
- [x] Migration du schéma de base de données
- [x] Adaptation du service API unifié  
- [x] Mise à jour des stores Pinia
- [x] Migration des composants principaux
- [x] Gestion des données relationnelles
- [x] Support des données géospatiales
- [x] Optimisation des requêtes

### 🔄 En cours
- [ ] Tests de charge et performance
- [ ] Documentation API complète
- [ ] Monitoring avancé

### 📋 À prévoir
- [ ] Authentification utilisateur
- [ ] APIs collaboratives
- [ ] Cache Redis pour les requêtes complexes
- [ ] Backup/restore personnalisé

## 🚀 Migration réussie !

L'intégration Supabase est **complète et opérationnelle**. L'application bénéficie maintenant d'une architecture cloud moderne, scalable et performante, tout en conservant toutes ses fonctionnalités existantes.

**Prochaines étapes** : Optimisation continue et ajout de fonctionnalités temps réel pour une expérience utilisateur encore plus riche.