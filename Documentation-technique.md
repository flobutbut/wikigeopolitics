# Documentation Technique - WikiGeopolitics

## Version
- **Version actuelle** : 2.1.0
- **Dernière mise à jour** : 22 mars 2025
- **Fonctionnalité ajoutée** : Base de données complète avec 82 pays et données détaillées

## Architecture Technique

### Stack Technologique
- **Frontend** : Vue.js 3 avec Composition API
- **Langage** : TypeScript 5.x
- **Bundler** : Vite
- **Gestion d'état** : Pinia
- **Cartographie** : Leaflet.js
- **Base de données** : PostgreSQL avec PostGIS
- **Package manager** : Yarn

### Structure des Données

#### Données Géographiques (`src/data/countries-geo.json`)
```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "id": "france",
        "name": "France",
        "flag": "🇫🇷"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [2.2137, 46.2276]
      }
    }
  ]
}
```

#### Store de Sélection (`src/stores/countrySelectionStore.ts`)
- **État** : Pays sélectionné, données des pays, état de chargement
- **Getters** : Pays sélectionné, vérification de sélection, récupération par ID
- **Actions** : Initialisation, sélection, désélection, sélection par coordonnées

## Fonctionnalités Implémentées

### 1. Sélection depuis la Carte
- **Marqueurs de pays** : Chaque pays est représenté par un drapeau
- **Sélection par clic** : Cliquer sur un marqueur sélectionne le pays
- **Sélection par proximité** : Cliquer près d'un pays le sélectionne automatiquement
- **Highlight visuel** : Animation de pulsation rouge pour le pays sélectionné

### 2. Sélection depuis l'Aside
- **Liste organisée** : Pays groupés par continent
- **Navigation intuitive** : Cliquer sur un pays le sélectionne
- **Synchronisation** : La sélection met à jour la carte

### 3. Composants Principaux

#### Map.vue
```typescript
// Fonctionnalités ajoutées
- createCountryMarkers() : Création des marqueurs pour tous les pays
- updateSelectedMarker() : Mise à jour du marqueur sélectionné
- selectCountryByCoordinates() : Sélection par coordonnées
```

#### AsideNavigationView.vue
```typescript
// Intégration avec le store
- selectCountry() : Sélection depuis la liste
- Synchronisation avec countrySelectionStore
```

## Styles CSS

### Marqueurs de Pays
```css
.country-marker {
  /* Marqueur de base */
}

.marker-content {
  /* Style du drapeau */
  width: 30px;
  height: 30px;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.marker-content.selected {
  /* Style du marqueur sélectionné */
  width: 40px;
  height: 40px;
  background: #ff6b6b;
  animation: pulse 2s infinite;
}
```

## Flux de Données

1. **Initialisation** : `countrySelectionStore.initializeCountriesData()`
2. **Sélection depuis la carte** : `selectCountryByCoordinates()` → `selectCountry()`
3. **Sélection depuis l'aside** : `selectCountry()` → Mise à jour du store
4. **Réaction** : `watch()` sur `selectedCountry` → `updateSelectedMarker()`

## Gestion des Erreurs

- **Données manquantes** : Fallback vers des données par défaut
- **Sélection invalide** : Logs d'avertissement dans la console
- **Erreurs de chargement** : Messages d'erreur dans le store

## Performance

- **Lazy loading** : Données chargées à la demande
- **Cache** : Données mises en cache dans le store
- **Optimisation** : Marqueurs créés une seule fois au montage

## Tests Recommandés

- [ ] Test de sélection depuis la carte
- [ ] Test de sélection depuis l'aside
- [ ] Test de synchronisation entre carte et aside
- [ ] Test de performance avec de nombreux pays
- [ ] Test de gestion d'erreurs

## Prochaines Étapes

1. **Amélioration de l'UX** : Tooltips informatifs
2. **Optimisation** : Lazy loading des marqueurs
3. **Accessibilité** : Support clavier et lecteur d'écran
4. **Tests** : Couverture de tests complète

## Base de Données PostgreSQL

### Configuration
- **Base de données** : PostgreSQL 15 avec PostGIS
- **Conteneur Docker** : `wikigeopolitics-db` sur le port 5433
- **Interface d'administration** : PgAdmin sur le port 5050
- **Données** : 82 pays avec informations détaillées

### Structure des Données
- **Table principale** : `country` (82 pays)
- **Tables de données détaillées** :
  - `political_regime` : Régimes politiques
  - `agricultural_production` : Production agricole
  - `technology_development` : Développement technologique
  - `demographic_society` : Données démographiques
  - `armed_conflicts` : Conflits armés
  - `natural_resources` : Ressources naturelles
  - `industrial_production` : Production industrielle
  - `transport_merchandise` : Transport de marchandises

### Accès à la base de données (lecture/écriture)

#### Connexion (db.ts)
- Utilise le package `pg` et un pool de connexions.
- Configuration centralisée (variables d'environnement ou valeurs par défaut).
- Fonction utilitaire `query<T>(sql, params)` pour exécuter des requêtes typées.

#### Service de lecture (readService.ts)
- Exemples :
  - `getAllCountries()` : retourne la liste des pays (id, nom, drapeau, continent)
  - `getCountryById(id)` : retourne un pays par son id
- Utilise la fonction générique `query`.
- Peut être étendu à toutes les entités (organization, conflict, etc.)

#### Service d'écriture (writeService.ts)
- Exemples :
  - `addCountry(country)` : ajoute un pays
  - `updateCountry(country)` : met à jour un pays
- Utilise la fonction générique `query`.
- Peut être étendu à toutes les entités.

#### Exemple d'utilisation
```typescript
import { getAllCountries, getCountryById } from '@/services/readService';
import { addCountry, updateCountry } from '@/services/writeService';

// Lecture
const countries = await getAllCountries();
const france = await getCountryById('france');

// Écriture
await addCountry({ id: 'test', title: 'Test', flag: 'test.svg', continent: 'Europe' });
await updateCountry({ id: 'test', title: 'Test modifié', flag: 'test.svg', continent: 'Europe' });
```

#### Sécurité
- Les requêtes sont paramétrées (anti-injection SQL)
- Les accès en écriture sont séparés (pas de delete par défaut)

#### Extension
- Ajouter des méthodes pour chaque entité (organization, conflict, etc.)
- Ajouter des transactions si besoin
- Ajouter la gestion fine des erreurs

### Identifiants de Connexion
- **Host** : localhost
- **Port** : 5433
- **Base de données** : wikigeopolitics
- **Utilisateur** : wikigeo_user
- **Mot de passe** : wikigeo_password

### PgAdmin
- **URL** : http://localhost:5050
- **Email** : admin@wikigeopolitics.com
- **Mot de passe** : admin_password

## Initialisation simplifiée de la base de données

Pour initialiser ou réinitialiser la base PostgreSQL avec toutes les données (structure + contenu), il suffit d'utiliser le script suivant :

```sh
sh database/init/init-db-from-backup.sh
```

Ce script :
- Copie le backup SQL complet dans le conteneur Docker
- Supprime la base si elle existe
- Recrée la base
- Restaure toutes les données et la structure depuis le backup SQL

**Le fichier de backup** :
- `database/backup/wikigeopolitics_complete_backup.sql`
- Généré avec `pg_dump` depuis la base de référence

> Il n'est donc plus nécessaire d'exécuter tous les scripts d'insertion un par un. Un seul script et un seul fichier suffisent pour une initialisation complète et rapide. 