# Migration vers Supabase

## ✅ État de la migration

### Base de données
- ✅ Migration des données vers Supabase terminée
- ✅ Toutes les tables principales migrées
- ✅ Relations entre tables préservées

### Application Frontend
- ✅ Client Supabase installé (`@supabase/supabase-js`)
- ✅ Service Supabase créé (`src/services/supabaseService.ts`)
- ✅ Types Vite configurés (`src/vite-env.d.ts`)
- ✅ API Country migrée vers Supabase
- ⏳ Autres APIs en cours de migration

## 🔧 Configuration requise

### 1. Variables d'environnement

Créez un fichier `.env.local` à la racine du projet :

```env
VITE_SUPABASE_URL=https://tiwrzklmwcqmetucrgib.supabase.co
VITE_SUPABASE_ANON_KEY=votre_cle_anon_public_ici
```

### 2. Obtenir votre clé API

1. Allez sur https://supabase.com/dashboard
2. Sélectionnez votre projet `wikigeopolitics`
3. Allez dans **Settings** → **API**
4. Copiez la clé **anon public**

## 📋 APIs migrées

### ✅ CountryAPI
- `getAll()` - Récupère tous les pays
- `getById(id)` - Récupère un pays par ID
- `search(query)` - Recherche de pays
- `getByRegime(regimeId)` - Pays par régime politique
- `getDetails(id)` - Détails d'un pays (TODO: implémenter les relations)
- `getGeoData()` - Données géographiques (TODO)
- `getByOrganization(orgId)` - Pays par organisation (TODO)

### ⏳ APIs en cours
- OrganizationAPI
- PoliticalRegimeAPI
- ArmedConflictAPI
- NavigationAPI

## 🔄 Transformation des données

Les données de Supabase sont transformées pour correspondre aux types TypeScript existants :

```typescript
// Base de données Supabase
{
  id: "france",
  nom: "France",
  drapeau: "🇫🇷",
  capitale: "Paris",
  latitude: 48.8566,
  longitude: 2.3522
}

// Type Country de l'application
{
  id: "france",
  title: "France",        // nom → title
  flag: "🇫🇷",           // drapeau → flag
  capitale: "Paris",
  coordonnees: [48.8566, 2.3522]  // latitude/longitude → coordonnees
}
```

## 🚀 Test de la migration

1. Configurez vos variables d'environnement
2. Lancez l'application : `npm run dev`
3. Vérifiez que les pays se chargent depuis Supabase
4. Testez la recherche et la navigation

## 📝 Prochaines étapes

1. Migrer les autres APIs (Organization, PoliticalRegime, etc.)
2. Implémenter les relations complexes (pays par organisation)
3. Ajouter les données géographiques
4. Optimiser les performances avec le cache Supabase
5. Supprimer l'ancien serveur API local

## 🐛 Dépannage

### Erreur de connexion
- Vérifiez vos variables d'environnement
- Assurez-vous que la clé anon est correcte
- Vérifiez que le projet Supabase est actif

### Données manquantes
- Vérifiez que la migration des données est complète
- Consultez les logs de la console pour les erreurs Supabase

### Types TypeScript
- Vérifiez que `src/vite-env.d.ts` existe
- Redémarrez le serveur de développement si nécessaire