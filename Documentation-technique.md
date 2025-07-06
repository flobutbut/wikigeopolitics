# Documentation Technique - WikiGeopolitics

## Version
- **Version actuelle** : 2.3.0
- **Dernière mise à jour** : 23 mars 2025
- **Fonctionnalité ajoutée** : Base de données PostgreSQL restaurée et API fonctionnelle

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
- **Tables relationnelles** : Structure normalisée
- **Pool de connexions** : Gestion efficace des connexions

## Migration vers l'Architecture Client-Serveur

#### Changements Majeurs
- **Séparation client/serveur** : Frontend et backend séparés
- **API REST** : Communication via HTTP/JSON
- **Sécurité** : Validation côté serveur
- **Scalabilité** : Architecture modulaire et extensible

#### Services API

##### Frontend (`src/services/apiService.ts`)
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

##### Backend (`server/index.js`)
```javascript
// Routes API
app.get('/api/countries', async (req, res) => { /* ... */ });
app.get('/api/countries/:id', async (req, res) => { /* ... */ });
app.get('/api/countries-geo', async (req, res) => { /* ... */ });
app.get('/api/countries/:id/details', async (req, res) => { /* ... */ });
app.get('/api/navigation', async (req, res) => { /* ... */ });
app.get('/api/categories/:id', async (req, res) => { /* ... */ });
```

#### Stores Mis à Jour

##### CountrySelectionStore
- **Chargement asynchrone** : Appels API au lieu de pg direct
- **Gestion d'erreurs** : Traitement des erreurs HTTP
- **Cache intelligent** : Évite les requêtes redondantes

##### AsideStore
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

### Interface CountryDetail Étendue
```typescript
export interface CountryDetail extends Country {
  // Données de base
  generalInfo?: {
    capitale: string;
    langue: string;
    monnaie: string;
  };
  
  // Données détaillées depuis les tables liées
  politicalRegime?: any;
  agriculturalData?: any;
  technologyData?: any;
  demographicData?: any;
  conflictsData?: any;
  naturalResources?: any;
  industrialData?: any;
  transportData?: any;
}
```

## Fonctionnalités Implémentées

### 1. Architecture Client-Serveur
- **API REST** : Communication standardisée entre client et serveur
- **Séparation des responsabilités** : Frontend UI, Backend logique métier
- **Scalabilité** : Possibilité d'ajouter des microservices
- **Sécurité** : Validation côté serveur

### 2. Chargement Asynchrone
- **Indicateur de chargement** : Overlay avec spinner pendant l'initialisation
- **Gestion d'erreurs** : Messages d'erreur appropriés en cas de problème
- **Chargement en parallèle** : Initialisation simultanée des stores

### 3. Sélection depuis la Carte
- **Marqueurs de pays** : Création depuis les données API
- **Sélection par clic** : Chargement asynchrone des détails
- **Sélection par proximité** : Algorithme amélioré avec données géographiques

### 4. Navigation dans l'Aside
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

### Monitoring
- **Logs détaillés** : Suivi des opérations API
- **Métriques** : Temps de réponse et taux d'erreur
- **Debug** : Mode debug pour le développement

## Tests Recommandés

- [ ] Test de connexion à l'API
- [ ] Test de chargement des données de base
- [ ] Test de sélection de pays avec détails
- [ ] Test de navigation dans les catégories
- [ ] Test de gestion d'erreurs de connexion
- [ ] Test de performance avec de nombreux pays
- [ ] Test de cache et rechargement

## Prochaines Étapes

1. **Optimisation** : Indexation des requêtes fréquentes
2. **Sécurité** : Validation des données côté serveur
3. **Monitoring** : Métriques de performance en temps réel
4. **Tests** : Couverture de tests complète pour les services

## Démarrage du Projet

### Prérequis
- Node.js 16+ installé
- PostgreSQL avec PostGIS
- Base de données configurée

### Démarrage du Backend
```bash
# Installer les dépendances
cd server
npm install

# Démarrer le serveur
npm run dev
```

### Démarrage du Frontend
```bash
# Installer les dépendances
yarn install

# Démarrer le serveur de développement
yarn dev
```

### Script de Démarrage Automatique
```bash
# Démarrer le serveur backend
./start-server.sh

# Dans un autre terminal, démarrer le frontend
yarn dev
```

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

#### Backend (server/index.js)
- Utilise le package `pg` et un pool de connexions.
- Configuration centralisée (variables d'environnement ou valeurs par défaut).
- Fonction utilitaire `query(text, params)` pour exécuter des requêtes typées.
- **Routes API** : Endpoints REST pour toutes les opérations.

#### Frontend (src/services/apiService.ts)
- **Service API** : Communication HTTP avec le backend
- **Gestion d'erreurs** : Traitement approprié des erreurs HTTP
- **Cache** : Évite les requêtes redondantes
- **Typage** : TypeScript pour la sécurité du code

#### Exemple d'utilisation
```typescript
// Frontend
import { countryApi, navigationApi } from '@/services/apiService';

// Récupération des données
const countries = await countryApi.getAllCountries();
const france = await countryApi.getCountryById('france');
const franceDetails = await countryApi.getCountryDetails('france');
const navigation = await navigationApi.getNavigationData();
```

```javascript
// Backend (routes API)
app.get('/api/countries', async (req, res) => {
  const countries = await query('SELECT * FROM country ORDER BY nom');
  res.json(countries);
});
```

#### Sécurité
- Les requêtes sont paramétrées (anti-injection SQL)
- Validation des données côté serveur
- CORS configuré pour les requêtes cross-origin
- Gestion d'erreurs appropriée

#### Extension
- Ajouter des routes API pour de nouvelles fonctionnalités
- Implémenter l'authentification et l'autorisation
- Ajouter des middlewares pour la validation
- Implémenter la pagination et le filtrage

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