# WikiGeopolitics V3

[![Version](https://img.shields.io/badge/version-3.1.0-blue.svg)](https://semver.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Vue.js](https://img.shields.io/badge/Vue.js-3.x-brightgreen.svg)](https://vuejs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue.svg)](https://typescriptlang.org/)
[![Supabase](https://img.shields.io/badge/Supabase-Cloud-green.svg)](https://supabase.com/)
[![yarn](https://img.shields.io/badge/package%20manager-yarn-2188b6)](https://yarnpkg.com/)

## 🚀 Mise à jour majeure - Version 3.1.0

**WikiGeopolitics** vient de subir une **transformation complète** avec :
- ✅ **Migration Supabase** pour une architecture cloud moderne
- ✅ **Conflits armés** avec zones de combat géolocalisées  
- ✅ **Architecture refactorisée** avec stores spécialisés et composables
- ✅ **Interface unifiée** pour toutes les entités géopolitiques
- ✅ **Performance optimisée** avec cache intelligent et requêtes asynchrones

## Table des matières
- [🎯 Description](#description)
- [✨ Fonctionnalités](#fonctionnalités)
- [🔧 Technologies utilisées](#technologies-utilisées)
- [📦 Installation](#installation)
- [🚀 Utilisation](#utilisation)
- [📁 Structure du projet](#structure-du-projet)
- [🏗️ Architecture](#architecture)
- [📚 Documentation](#documentation)
- [🌐 Déploiement](#déploiement)
- [🧪 Tests](#tests)
- [🗺️ Roadmap](#roadmap)
- [❓ FAQ](#faq)
- [🤝 Contribution](#contribution)
- [📄 Licence](#licence)
- [🙏 Remerciements](#remerciements)
- [📧 Contact](#contact)

## Description
WikiGeopolitics est une application web interactive permettant d'explorer les données géopolitiques mondiales. Cette plateforme offre une visualisation cartographique des relations internationales, des conflits, et des données économiques et sociales par pays.

## ✨ Fonctionnalités

### 🗺️ Cartographie avancée
- **Carte interactive mondiale** avec visualisation multi-couches
- **Marqueurs géolocalisés** pour pays, conflits et organisations
- **Zones de combat** en temps réel pour les conflits armés
- **Épicentres de conflits** avec données précises
- **Contrôles de couches** pour filtrer les informations

### 🎯 Sélection et navigation
- **Sélection unifiée** entre carte, menus et panneaux
- **Navigation contextuelle** par entités (pays, conflits, organisations)
- **Système de retour** intelligent avec historique
- **Recherche universelle** avec filtrage temps réel

### 📊 Données géopolitiques
- **195+ pays** avec données complètes (économie, politique, démographie)
- **Conflits armés actifs** avec zones de combat géolocalisées
- **Organisations internationales** et leurs pays membres
- **Régimes politiques** et leurs classifications
- **Relations diplomatiques** (coalitions, accords, traités)

### 🎨 Interface moderne
- **Panneaux flottants** adaptatifs pour tous types d'entités
- **Composants réutilisables** avec design cohérent
- **Interface responsive** optimisée mobile et desktop
- **Architecture modulaire** avec stores spécialisés

### ⚡ Performance
- **Cache intelligent** avec TTL configurable
- **Chargement asynchrone** avec gestion d'erreurs
- **Requêtes optimisées** via Supabase
- **État réactif** avec Pinia et Vue 3

## 🔧 Technologies utilisées

### 🎨 Frontend
- **Vue.js 3** (Composition API) - Framework réactif moderne
- **TypeScript 5.x** - Typage statique et sécurité
- **Vite** - Build tool ultra-rapide
- **Pinia** - Gestion d'état modulaire et typée
- **Leaflet.js** - Cartographie interactive
- **CSS moderne** - Variables, Grid, Flexbox

### ☁️ Backend & Données  
- **Supabase** - Backend-as-a-Service avec PostgreSQL
- **PostGIS** - Extensions géospatiales pour données géographiques
- **Row Level Security** - Sécurité au niveau des données
- **Real-time subscriptions** - Mises à jour en temps réel

### 🏗️ Architecture
- **Stores spécialisés** - asideStore, mapStore, selectionSystem, uiStore
- **Composables réutilisables** - useAsyncState, useSelection, useSearch
- **Services modulaires** - API unifiée avec gestion d'erreurs
- **Types TypeScript** - Interface strictement typée

### 🛠️ Outils de développement
- **ESLint & Prettier** - Qualité et formatage du code
- **Vitest** - Tests unitaires rapides 
- **Vue DevTools** - Debug et inspection
- **Git hooks** - Validation pré-commit

## Installation

### Prérequis
- Node.js (version 16 ou supérieure)
- Yarn ou npm

### Étapes d'installation
1. Cloner le dépôt
```bash
git clone https://github.com/votre-nom-utilisateur/WikiGeopolitics-V2.git
cd WikiGeopolitics-V2
```

2. Installer les dépendances
```bash
yarn install
```
ou
```bash
npm install # Nous recommandons d'utiliser Yarn
```

3. Lancer le serveur de développement
```bash
yarn dev
```
ou
```bash
npm run dev # Nous recommandons d'utiliser Yarn
```

4. Accéder à l'application
Ouvrez votre navigateur et accédez à `http://localhost:5173`

## Structure du projet
```
src/
├── assets/        # Ressources statiques (images, icônes)
├── components/    # Composants Vue réutilisables
│   ├── aside/     # Panneau latéral et ses sous-composants
│   ├── button/    # Composants de boutons
│   ├── header/    # En-tête de l'application
│   ├── map/       # Composant de carte interactive
│   ├── menu-item/ # Éléments de menu
│   ├── search/    # Fonctionnalité de recherche
│   ├── switch/    # Interrupteurs (ex: mode clair/sombre)
│   └── timeline/  # Chronologie des événements
├── data/          # Données JSON et sources
├── stores/        # Gestion d'état (Pinia/Vuex)
└── styles/        # Fichiers CSS globaux et tokens
```



## Utilisation

Une fois l'application lancée, vous pouvez :

1. **Sélectionner un pays** :
   - Cliquer sur un marqueur de pays sur la carte
   - Ou naviguer vers la liste des pays dans l'aside
2. Naviguer sur la carte en utilisant la souris (zoom avec la molette)
3. Cliquer sur un pays pour afficher ses informations détaillées
4. Utiliser la barre de recherche pour trouver rapidement un pays ou un événement
5. Filtrer les données par année, par région ou par type d'événement
6. Basculer entre les différentes visualisations (carte, graphiques, tableaux)
7. Changer le thème via le bouton en haut à droite

## Architecture

L'application suit une **architecture modulaire moderne** basée sur Vue 3 et Supabase :

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Vue 3 + TS    │    │     Pinia       │    │    Supabase     │
│   Components    │◄───┤  Stores + Cache │◄───┤   PostgreSQL    │
│   Composables   │    │   Reactive      │    │    PostGIS      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        ▲                      ▲                      ▲
        │                      │                      │
        └─────── Unified Selection System ──────────────┘
```

**Avantages** :
- 🔄 **Réactivité** : Synchronisation automatique entre carte et panneaux
- 🚀 **Performance** : Cache intelligent et requêtes optimisées  
- 🧩 **Modularité** : Composants et stores spécialisés
- 🔒 **Sécurité** : Validation TypeScript et RLS Supabase

## 📚 Documentation

### 📖 Guides complets
- **[Documentation Technique](./Documentation-technique.md)** - Architecture détaillée
- **[Guide Supabase](./SUPABASE_INTEGRATION.md)** - Migration et intégration cloud
- **[Guide Composants](./COMPONENTS_GUIDE.md)** - Utilisation des composants Vue
- **[Guide Stores](./STORES_GUIDE.md)** - Gestion d'état avec Pinia

### 🗃️ Documentation fonctionnelle  
- **[Documentation Fonctionnelle](./Documentation-fonctionnelle.md)** - Spécifications métier
- **[Statut Documentation](./Documentation-status.md)** - État d'avancement
- **[Schéma BDD](./Documentation-schema-bdd.md)** - Structure de données

### 🛠️ Ressources développeur
- **[Migration Supabase](./MIGRATION_SUPABASE.md)** - Guide de migration
- **[Structure Database](./database/STRUCTURE.md)** - Architecture de données

## Déploiement

Pour déployer l'application en production :

1. Créer une build optimisée
```bash
yarn build
```
ou
```bash
npm run build # Nous recommandons d'utiliser Yarn
```

2. Les fichiers générés se trouvent dans le dossier `dist/` 

3. Déployer ces fichiers sur votre serveur web ou sur une plateforme comme Netlify, Vercel ou GitHub Pages

## Tests

Pour exécuter les tests unitaires :
```bash
yarn test:unit
```

Pour exécuter les tests end-to-end :
```bash
yarn test:e2e
```

## 🗺️ Roadmap

### ✅ Version 3.1.0 (Juillet 2025) - COMPLÈTE
- ✅ Migration Supabase complète
- ✅ Conflits armés avec zones de combat
- ✅ Architecture refactorisée avec stores spécialisés
- ✅ Interface unifiée pour toutes les entités
- ✅ Documentation complète mise à jour

### 🔄 Version 3.2.0 (Q3 2025) - EN COURS
- 🔄 Authentification utilisateur avec Supabase Auth
- 🔄 Mode collaboratif avec annotations partagées
- 🔄 API publique pour développeurs tiers
- 📋 Notifications temps réel sur les événements géopolitiques

### 📋 Version 3.3.0 (Q4 2025) - PLANIFIÉ
- 📋 Intelligence artificielle pour l'analyse prédictive
- 📋 Comparaisons côte-à-côte entre pays
- 📋 Export avancé (PDF, datasets, API)
- 📋 Mode offline avec Service Workers

### 🚀 Version 4.0.0 (Q1 2026) - VISION
- 🚀 Application mobile native (React Native)
- 🚀 Réalité augmentée pour la visualisation 3D
- 🚀 Intégration IoT pour données temps réel
- 🚀 Marketplace de plugins communautaires

## FAQ

**Q: Comment puis-je contribuer au projet ?**  
R: Consultez la section Contribution ci-dessus et le fichier CONTRIBUTING.md pour les directives détaillées.

**Q: L'application fonctionne-t-elle hors ligne ?**  
R: Une version basique fonctionne hors ligne après le premier chargement, mais certaines fonctionnalités nécessitent une connexion internet.

**Q: Comment puis-je signaler un bug ou suggérer une fonctionnalité ?**  
R: Ouvrez une issue sur notre dépôt GitHub en utilisant les modèles fournis pour les bugs ou les suggestions de fonctionnalités.

## Contribution

En tant que projet open source contributif, nous encourageons vivement la participation de la communauté ! Pour contribuer :

1. Forker le projet
2. Créer une branche pour votre fonctionnalité (`git checkout -b feature/amazing-feature`)
3. Commiter vos changements (`git commit -m 'Add some amazing feature'`)
4. Pousser vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

### Guide de contribution

- Consultez d'abord les issues existantes pour voir si votre idée ou bug a déjà été signalé
- Pour les nouvelles fonctionnalités, ouvrez d'abord une issue pour discussion
- Suivez les conventions de code du projet
- Ajoutez des tests pour les nouvelles fonctionnalités
- Mettez à jour la documentation si nécessaire

Veuillez consulter le fichier [CONTRIBUTING.md](CONTRIBUTING.md) pour les détails sur notre code de conduite, nos normes de codage et le processus de revue de code.

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE.md](LICENSE.md) pour plus de détails.

La licence MIT a été choisie pour encourager une large adoption et faciliter la réutilisation du code dans d'autres projets, y compris commerciaux, tout en maintenant l'attribution aux auteurs originaux.

## Remerciements

* [Leaflet.js](https://leafletjs.com/) pour la bibliothèque de cartographie
* [Natural Earth](https://www.naturalearthdata.com/) pour les données géographiques
* [Vue.js](https://vuejs.org/) et sa communauté pour le framework
* Les contributeurs open source qui ont participé à ce projet

Un grand merci à tous ceux qui rendent ce projet possible par leurs contributions. Consultez notre [fichier de contributeurs](CONTRIBUTORS.md) pour voir la liste complète des personnes impliquées.

## Contact

Pour toute question ou suggestion, n'hésitez pas à :
- Ouvrir une issue sur GitHub
- Rejoindre notre communauté sur [Discord](https://discord.gg/wikigeopolitics)  
- Suivre l'avancement du projet sur notre [tableau Kanban](https://github.com/orgs/wikigeopolitics/projects)

---

## 🎉 WikiGeopolitics V3.1.0 - Transformation réussie !

L'application a été **entièrement modernisée** avec une architecture cloud, des fonctionnalités avancées et une expérience utilisateur optimale. 

**Prochaine étape** : Authentification utilisateur et mode collaboratif pour une expérience encore plus riche ! 🚀
