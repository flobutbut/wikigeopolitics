# Documentation Status - WikiGéopolitics

## 📊 État du projet

### ✅ Fonctionnalités terminées

#### 🗄️ Base de données
- **Migration des régimes politiques** : Structure simplifiée avec colonnes `id`, `name`, `description`
- **Table de relation `country_political_regime`** : Remplie avec 238 pays répartis de manière crédible
- **Redistribution crédible** : 7 régimes politiques avec données géopolitiques réalistes
- **Champs chef d'État** : Ajout de `chef_etat` et `date_prise_poste` à la table `country_political_regime`

#### 🎯 Interface utilisateur
- **Navigation par régime** : Fonctionnelle avec données crédibles
- **Composants refactorisés** : `AsideDetailView` → `FloatingDetailView` (déplacé vers `/panels`)
- **API backend** : Adaptée pour utiliser la table de relation
- **Affichage chef d'État** : Informations sur le chef d'État et date de prise de poste dans les détails

### 🔧 Modifications récentes

#### Ajout des champs chef d'État
- **Script SQL** : `102-add-chef-etat-fields.sql` - Ajout des colonnes `chef_etat` et `date_prise_poste`
- **Données initiales** : `103-populate-chef-etat-data.sql` - Remplissage avec 20 pays majeurs
- **Données actuelles** : `104-update-chef-etat-current.sql` - Mise à jour avec 50+ pays et données vérifiées (2024-2025)
- **Complétion finale** : `106-final-complete-chef-etat.sql` - 100% des pays avec données chef d'État (238 pays)
- **Nettoyage** : `107-remove-obsolete-columns.sql` - Suppression des colonnes obsolètes `regimepolitique` et `chefetat` de la table `country`
- **Backend** : API `/api/countries/:id/details` adaptée pour utiliser uniquement la table `country_political_regime`
- **Frontend** : `FloatingDetailView.vue` affiche le chef d'État avec label dynamique et date de prise de poste formatée

#### Renommage et déplacement de composant
- **Ancien** : `src/components/aside/AsideDetailView.vue`
- **Nouveau** : `src/components/panels/FloatingDetailView.vue`
- **Mise à jour des imports** :
  - `src/components/aside/aside.vue`
  - `src/components/panels/FloatingDetailPanel.vue`

### 📈 Statistiques finales des régimes politiques

| Régime | Pays | % | Exemples |
|--------|------|----|----------|
| République présidentielle | 108 | 45.4% | États-Unis, Brésil, France |
| République parlementaire | 43 | 18.1% | Allemagne, Italie, Inde |
| Régime autoritaire | 29 | 12.2% | Chine, Russie, Iran |
| Monarchie constitutionnelle | 24 | 10.1% | Royaume-Uni, Japon, Espagne |
| République fédérale | 23 | 9.7% | USA, Allemagne, Suisse |
| Théocratie | 7 | 2.9% | Vatican, Iran, Arabie Saoudite |
| Démocratie directe | 4 | 1.7% | Suisse, Liechtenstein |

### 🚀 Serveurs
- **Frontend** : `http://localhost:5173` ✅
- **Backend** : `http://localhost:3000` ✅
- **Base de données** : PostgreSQL/PostGIS ✅

### 🔧 Modifications récentes

#### Navigation dynamique implémentée
- **API Backend** : Modification de `/api/navigation` pour lire dynamiquement `src/data/app/menu.json`
- **API Backend** : Modification de `/api/categories/:id` pour utiliser les données du menu.json
- **Avantages** : Modifications instantanées sans redémarrage, gestion centralisée de la navigation
- **Test** : Validation complète avec script de test - 7 catégories, 35 organisations, correspondance 100%

#### Menu "Relations internationales" implémenté
- **Nouvel endpoint** : `/api/organizations` - Récupération des organisations classées par type
- **Store Pinia** : Ajout de `navigateToOrganizationsList()` pour gérer la navigation vers les organisations
- **Composant Vue** : `AsideNavigationView.vue` - Vue spéciale pour afficher les organisations par type
- **Types d'organisations** : 12 types supportés (Alliance militaire, Cartel pétrolier, Forum économique, etc.)
- **Interface** : Affichage organisé par sections avec icônes et recherche intégrée
- **Données** : 35+ organisations internationales avec descriptions complètes
- **Correction** : Suivi du même pattern que les autres menus (utilisation de `appData.organizationList`)

### 📝 Prochaines étapes
- [ ] Tests utilisateur de la navigation dynamique
- [ ] Optimisation des performances si nécessaire
- [ ] Ajout de nouvelles fonctionnalités géopolitiques

---

*Dernière mise à jour : Navigation dynamique implémentée - lecture du menu.json via API* 