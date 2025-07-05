# Documentation Fonctionnelle - WikiGeopolitics

## Version
- **Version actuelle** : 2.0.0
- **Dernière mise à jour** : 22 mars 2025
- **Branche de développement** : develop

## Stratégie de Branches

### Branches Principales

#### 🌿 **main** (Production)
- **Rôle** : Code stable et déployable
- **Protection** : Ne jamais travailler directement dessus
- **Contenu** : Toutes les fonctionnalités validées et testées
- **Merge** : Uniquement depuis `develop` via Pull Request

#### 🔧 **develop** (Développement)
- **Rôle** : Branche de travail principale
- **Protection** : Branche de développement active
- **Contenu** : Nouvelles fonctionnalités en cours
- **Merge** : Depuis les feature branches

### Workflow de Développement

#### 1. **Développement de Nouvelles Fonctionnalités**
```bash
# Créer une branche feature depuis develop
git checkout develop
git checkout -b feature/nouvelle-fonctionnalite

# Développer la fonctionnalité
# ... travail sur le code ...

# Commiter les changements
git add .
git commit -m "feat: description de la nouvelle fonctionnalité"

# Pousser la branche
git push -u origin feature/nouvelle-fonctionnalite
```

#### 2. **Merge vers develop**
```bash
# Retourner sur develop
git checkout develop

# Merger la feature branch
git merge feature/nouvelle-fonctionnalite

# Pousser develop
git push origin develop

# Supprimer la feature branch
git branch -d feature/nouvelle-fonctionnalite
git push origin --delete feature/nouvelle-fonctionnalite
```

#### 3. **Release vers main**
```bash
# Quand develop est stable, merger vers main
git checkout main
git merge develop

# Pousser main
git push origin main

# Créer un tag de version
git tag -a v2.1.0 -m "Version 2.1.0"
git push origin v2.1.0
```

## Fonctionnalités Implémentées

### ✅ **Fonctionnalités Stables (main)**
- **Interface de base** : Header, Aside, Carte principale
- **Navigation** : Menu principal, sous-menus, navigation arrière
- **Carte interactive** : Leaflet.js avec tuiles OpenStreetMap
- **Sélection de pays** : Highlight visuel sur la carte
- **Liste des pays** : Organisation par continent
- **Recherche** : Filtrage par mots-clés
- **Vues détaillées** : Fiches pays avec sections collapsibles
- **Gestion d'état** : Store Pinia pour la sélection
- **Données géographiques** : Coordonnées des pays

### 🚧 **Fonctionnalités en Développement (develop)**
- **Optimisations** : Performance et UX
- **Tests** : Couverture de tests unitaires
- **Documentation** : Guides utilisateur

### 📋 **Fonctionnalités Planifiées**
- **Comparaisons** : Côte-à-côte entre pays
- **Données historiques** : Événements avant 1950
- **Export** : CSV, PDF, PNG
- **Partage** : URLs avec paramètres
- **Mode sombre** : Thème clair/sombre
- **Mobile** : Version responsive optimisée

## Conventions de Nommage

### Branches
- `main` : Branche de production
- `develop` : Branche de développement
- `feature/nom-fonctionnalite` : Nouvelles fonctionnalités
- `fix/nom-correction` : Corrections de bugs
- `hotfix/nom-urgence` : Corrections urgentes

### Commits
- `feat:` : Nouvelle fonctionnalité
- `fix:` : Correction de bug
- `docs:` : Documentation
- `style:` : Formatage, style
- `refactor:` : Refactoring
- `test:` : Tests
- `chore:` : Maintenance

## Processus de Validation

### 1. **Développement Local**
- Tests unitaires passants
- Code linté et formaté
- Documentation mise à jour

### 2. **Pull Request**
- Description claire des changements
- Tests automatisés passants
- Review par un autre développeur

### 3. **Merge vers develop**
- Tous les tests passants
- Code review approuvé
- Documentation mise à jour

### 4. **Release vers main**
- Tests complets passants
- Fonctionnalités validées
- Documentation complète

## Outils de Développement

### Git Workflow
```bash
# Vérifier l'état
git status
git branch -a

# Changer de branche
git checkout develop
git checkout main

# Créer une nouvelle branche
git checkout -b feature/nouvelle-fonctionnalite

# Voir l'historique
git log --oneline -10
```

### Scripts Utiles
```bash
# Lancer le serveur de développement
yarn dev

# Build de production
yarn build

# Tests
yarn test

# Linting
yarn lint
```

## Gestion des Erreurs

### Erreurs Courantes
1. **Conflits de merge** : Résoudre avant de continuer
2. **Branche non à jour** : Pull avant de travailler
3. **Commits non poussés** : Push régulier

### Solutions
```bash
# Mettre à jour develop
git checkout develop
git pull origin develop

# Résoudre les conflits
git status
# Éditer les fichiers en conflit
git add .
git commit -m "fix: résolution des conflits"
```

## Métriques de Qualité

### Code
- **Couverture de tests** : Objectif 80%
- **Complexité cyclomatique** : < 10 par fonction
- **Duplication de code** : < 5%

### Performance
- **Temps de chargement** : < 3 secondes
- **Taille du bundle** : < 2MB
- **Réactivité** : < 100ms

### Documentation
- **README** : Toujours à jour
- **Documentation technique** : Complète
- **Commentaires** : Code auto-documenté

## Prochaines Étapes

### Court Terme (1-2 semaines)
1. **Tests unitaires** : Couverture de base
2. **Optimisation** : Performance des marqueurs
3. **Documentation** : Guide utilisateur
4. **Linting** : Configuration ESLint

### Moyen Terme (1-2 mois)
1. **Comparaisons** : Interface côte-à-côte
2. **Export** : Fonctionnalités d'export
3. **Mobile** : Optimisation responsive
4. **Tests e2e** : Automatisation complète

### Long Terme (3-6 mois)
1. **Données historiques** : Événements avant 1950
2. **IA** : Analyse prédictive
3. **Mobile native** : Application mobile
4. **API** : Backend pour données dynamiques 