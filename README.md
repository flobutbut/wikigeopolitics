# WikiGeopolitics V2

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://semver.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Vue.js](https://img.shields.io/badge/Vue.js-3.x-brightgreen.svg)](https://vuejs.org/)
[![yarn](https://img.shields.io/badge/package%20manager-yarn-2188b6)](https://yarnpkg.com/)

## Table des matières
- [Description](#description)
- [Fonctionnalités](#fonctionnalités)

- [Technologies utilisées](#technologies-utilisées)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Structure du projet](#structure-du-projet)
- [Architecture](#architecture)
- [Déploiement](#déploiement)
- [Tests](#tests)
- [Roadmap](#roadmap)
- [FAQ](#faq)
- [Contribution](#contribution)
- [Licence](#licence)
- [Remerciements](#remerciements)
- [Contact](#contact)

## Description
WikiGeopolitics est une application web interactive permettant d'explorer les données géopolitiques mondiales. Cette plateforme offre une visualisation cartographique des relations internationales, des conflits, et des données économiques et sociales par pays.

## Fonctionnalités
- **Carte interactive mondiale** avec visualisation des données par pays
- **Sélection de pays** avec highlight visuel sur la carte
- **Navigation intuitive** par pays et par région
- **Chronologie dynamique** des événements géopolitiques majeurs
- **Recherche avancée** par mots-clés, régions, périodes et thématiques
- **Mode clair/sombre** pour une utilisation confortable jour et nuit
- **Interface utilisateur responsive** avec panneau latéral pour les détails
- **Données en temps réel** sur les relations internationales et conflits
- **Profils détaillés** des pays avec indicateurs économiques et sociaux
- **Export de données** au format CSV, PDF et PNG
- **Partage facile** des visualisations via URL ou réseaux sociaux

## Technologies utilisées
- **Frontend**:
  - Vue.js 3 (Composition API)
  - TypeScript 5.x
  - Vite comme bundler
  - Pinia pour la gestion d'état
  - Vue Router pour la navigation
  - CSS personnalisé avec variables
  - Leaflet.js pour les cartes interactives
  - D3.js pour les visualisations de données
  - i18n pour l'internationalisation
- **Outils de développement**:
  - ESLint et Prettier pour le linting et le formatage
  - Vitest pour les tests unitaires
  - Cypress pour les tests e2e
  - GitHub Actions pour CI/CD

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

L'application suit une architecture modulaire basée sur les principes SOLID :

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Vue.js      │    │     Pinia       │    │      APIs       │
│   Components    │◄───┤    Stores       │◄───┤   & Services    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        ▲                      ▲                      ▲
        │                      │                      │
        └──────────────────────┴──────────────────────┘
```

Les données circulent de manière unidirectionnelle, ce qui facilite le debugging et améliore les performances.

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

## Roadmap

- **Q2 2025** : Ajout de comparaisons côte-à-côte entre pays
- **Q3 2025** : Intégration de données historiques supplémentaires (avant 1950)
- **Q4 2025** : Version mobile native avec React Native
- **Q1 2026** : Intégration d'intelligence artificielle pour l'analyse prédictive

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