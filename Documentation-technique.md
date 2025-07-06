# Documentation Technique - WikiGeopolitics

## Version
- **Version actuelle** : 2.3.0
- **Dernière mise à jour** : 23 mars 2025
- **Fonctionnalité ajoutée** : Migration complète vers PostgreSQL avec architecture client-serveur opérationnelle

## Architecture Technique

### Stack Technologique
- **Frontend** : Vue.js 3 avec Composition API
- **Backend** : Node.js avec Express
- **Langage** : TypeScript 5.x (frontend), JavaScript (backend)
- **Bundler** : Vite
- **Gestion d'état** : Pinia
- **Cartographie** : Leaflet.js
- **Base de données** : PostgreSQL avec PostGIS
- **API** : REST API avec Express
- **Package manager** : Yarn (frontend), npm (backend)
- **Conteneurisation** : Docker & Docker Compose

### Architecture Client-Serveur

#### Frontend (Vue.js)
- **Interface utilisateur** : Composants Vue.js réactifs
- **Gestion d'état** : Stores Pinia pour la synchronisation
- **Communication API** : Service API pour les requêtes HTTP
- **Cartographie** : Leaflet.js pour l'affichage des cartes

#### Backend (Node.js + Express)
- **Serveur API** : Express.js avec routes REST
- **Base de données** : PostgreSQL avec pool de connexions
- **CORS** : Configuration pour les requêtes cross-origin
- **Gestion d'erreurs** : Middleware d'erreur approprié

#### Base de Données (PostgreSQL)
- **Données géographiques** : PostGIS pour les coordonnées
- **Structure simplifiée** : Table `country` avec champs JSONB
- **Pool de connexions** : Gestion efficace des connexions

## Migration vers l'Architecture Client-Serveur

### Changements Majeurs
- **Séparation client/serveur** : Frontend et backend séparés
- **API REST** : Communication via HTTP/JSON
- **Base de données PostgreSQL** : Migration depuis les fichiers JSON
- **Architecture simplifiée** : Navigation et catégories en statique
- **Scalabilité** : Architecture modulaire et extensible

### Services API

#### Frontend (`src/services/apiService.ts`)
```typescript
// Service pour les pays
export const countryApi = {
  async getAllCountries() { /* ... */ },
  async getCountryById(id: string) { /* ... */ },
  async getCountriesGeoData() { /* ... */ },
  async getCountryDetails(id: string) { /* ... */ }
};

// Service pour la navigation
export const navigationApi = {
  async getNavigationData() { /* ... */ },
  async getCategoryData(categoryId: string) { /* ... */ }
};
```

#### Backend (`server/index.js`)
```javascript
// Routes API principales
app.get('/api/countries', async (req, res) => { /* ... */ });
app.get('/api/countries/:id', async (req, res) => { /* ... */ });
app.get('/api/countries-geo', async (req, res) => { /* ... */ });
app.get('/api/countries/:id/details', async (req, res) => { /* ... */ });
app.get('/api/navigation', async (req, res) => { /* ... */ });
app.get('/api/categories/:id', async (req, res) => { /* ... */ });
```

### Stores Mis à Jour

#### CountrySelectionStore
- **Chargement asynchrone** : Appels API au lieu de pg direct
- **Gestion d'erreurs** : Traitement des erreurs HTTP
- **Cache intelligent** : Évite les requêtes redondantes

#### AsideStore
- **Navigation dynamique** : Données via API REST
- **États de chargement** : Indicateurs visuels appropriés
- **Gestion d'erreurs** : Fallback en cas d'échec API

#### Composants Principaux

##### App.vue
```typescript
// Initialisation des données via API
const initializeData = async () => {
  await Promise.all([
    countryStore.initializeCountriesData(),
    asideStore.initializeData()
  ])
}
```

##### Map.vue
- **Marqueurs dynamiques** : Création depuis les données API
- **Sélection asynchrone** : Gestion des sélections avec chargement API

## Structure des Données

### Interface Country Mise à Jour
```typescript
export interface Country {
  id: string;
  title: string;
  flag: string;
  continent?: string;
  coordinates?: [number, number];
}
```

### Interface CountryDetail Simplifiée
```typescript
export interface CountryDetail extends Country {
  // Données de base
  generalInfo?: {
    capitale: string;
    langue: string;
    monnaie: string;
  };
  
  // Données JSONB depuis la table country
  sections?: any[];
  indicateurs?: any;
  histoire?: any;
  politique?: any;
  economie?: any;
  demographie?: any;
  frontieres?: any;
  coordonnees?: any;
  tourisme?: any;
}
```

## Fonctionnalités Implémentées

### 1. Architecture Client-Serveur
- **API REST** : Communication standardisée entre client et serveur
- **Séparation des responsabilités** : Frontend UI, Backend logique métier
- **Base de données PostgreSQL** : Migration complète depuis les fichiers JSON
- **Sécurité** : Validation côté serveur

### 2. Base de Données PostgreSQL
- **Table country** : Structure centralisée avec champs JSONB
- **82 pays** : Données complètes avec coordonnées géographiques
- **PostGIS** : Extension géospatiale pour les coordonnées
- **Backup/restore** : Système de sauvegarde et restauration

### 3. Navigation Simplifiée
- **Données statiques** : Navigation et catégories servies par le backend
- **Pas de tables SQL** : Évite la complexité des tables de navigation
- **Performance** : Chargement rapide des données de navigation

### 4. Chargement Asynchrone
- **Indicateur de chargement** : Overlay avec spinner pendant l'initialisation
- **Gestion d'erreurs** : Messages d'erreur appropriés en cas de problème
- **Chargement en parallèle** : Initialisation simultanée des stores

### 5. Sélection depuis la Carte
- **Marqueurs de pays** : Création depuis les données API
- **Sélection par clic** : Chargement asynchrone des détails
- **Sélection par proximité** : Algorithme amélioré avec données géographiques

### 6. Navigation dans l'Aside
- **Catégories dynamiques** : Chargement depuis l'API
- **Sous-pages à la demande** : Chargement lazy des données de catégories
- **Cache intelligent** : Évite les rechargements inutiles

## Gestion des Erreurs

### Connexion à l'API
- **Test de connexion** : Vérification automatique au démarrage
- **Fallback** : Données par défaut en cas d'échec
- **Messages utilisateur** : Indication claire des problèmes

### Chargement des Données
- **Timeout** : Limitation du temps de chargement
- **Retry** : Tentatives de reconnexion automatiques
- **Cache** : Utilisation des données en cache en cas d'erreur

## Performance

### Optimisations
- **Chargement lazy** : Données chargées à la demande
- **Cache intelligent** : Évite les requêtes redondantes
- **Requêtes optimisées** : Utilisation de Promise.all pour les requêtes parallèles
- **Pool de connexions** : Gestion efficace des connexions PostgreSQL
- **Données statiques** : Navigation et catégories sans requêtes SQL

### Monitoring
- **Logs détaillés** : Suivi des opérations API
- **Métriques** : Temps de réponse et taux d'erreur
- **Debug** : Mode debug pour le développement

## Démarrage du Projet

### Prérequis
- Node.js 16+
- Docker et Docker Compose
- Yarn (frontend), npm (backend)

### Démarrage
```bash
# 1. Démarrer la base de données PostgreSQL
docker-compose up -d

# 2. Restaurer la base de données (si nécessaire)
./database/init/init-db-from-backup.sh

# 3. Démarrer le serveur backend
cd server && yarn dev

# 4. Dans un autre terminal, démarrer le frontend
yarn dev

# 5. Ouvrir http://localhost:5176
```

## Tests Recommandés

- [x] Test de connexion à l'API
- [x] Test de chargement des données de base
- [x] Test de sélection de pays avec détails
- [x] Test de navigation dans les catégories
- [x] Test de gestion d'erreurs de connexion
- [ ] Test de performance avec de nombreux pays
- [ ] Test de cache et rechargement

## Prochaines Étapes

### Améliorations Techniques
1. **Optimisation des requêtes** : Indexation et optimisation des requêtes fréquentes
2. **Sécurité renforcée** : Authentification et autorisation
3. **Monitoring** : Métriques de performance en temps réel
4. **Tests automatisés** : Couverture de tests complète

### Fonctionnalités Futures
1. **Mode hors ligne** : Cache local pour utilisation sans connexion
2. **Export de données** : Fonctionnalités d'export en différents formats
3. **API REST complète** : Interface programmatique pour les développeurs
4. **Notifications** : Système de notifications pour les mises à jour

### Améliorations UX
1. **Tooltips informatifs** : Informations contextuelles sur les pays
2. **Mode sombre** : Thème sombre pour l'interface
3. **Accessibilité** : Support clavier et lecteur d'écran
4. **Responsive design** : Optimisation pour mobile et tablette
