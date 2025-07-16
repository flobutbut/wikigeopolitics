# 🚀 Migration vers Supabase - WikiGeopolitics

## 📋 Prérequis

1. **Compte Supabase créé** ✅
2. **Projet Supabase initialisé**
3. **Base de données locale fonctionnelle** ✅
4. **Sauvegardes SQL disponibles** ✅

## 🔧 Étapes de migration

### Étape 1: Configuration du projet Supabase

1. **Connectez-vous à Supabase** : https://supabase.com/dashboard
2. **Créez un nouveau projet** :
   - Nom : `wikigeopolitics`
   - Mot de passe : `wikigeo_password_supabase`
   - Région : Europe (Paris) recommandé
   - Plan : Gratuit pour commencer

### Étape 2: Récupération des informations de connexion

Dans votre dashboard Supabase :
- **Settings** → **Database**
- Notez les informations suivantes :
  - Host : `db.xxxxxxxxxxxxx.supabase.co`
  - Database name : `postgres`
  - Port : `5432`
  - User : `postgres`
  - Password : (celui que vous avez défini)

### Étape 3: Migration des données

#### Option A: Via l'interface Supabase (Recommandé)

1. **Accédez à l'éditeur SQL** dans Supabase
2. **Importez le fichier** `wikigeopolitics_complete_backup.sql`
3. **Exécutez le script** en une seule fois

#### Option B: Via ligne de commande

```bash
# Installation de l'outil Supabase CLI
npm install -g supabase

# Connexion à votre projet
supabase login
supabase link --project-ref YOUR_PROJECT_REF

# Migration des données
psql "postgresql://postgres:[YOUR-PASSWORD]@db.xxxxxxxxxxxxx.supabase.co:5432/postgres" < database/backup/wikigeopolitics_complete_backup.sql
```

### Étape 4: Vérification de la migration

1. **Vérifiez les tables** dans l'éditeur SQL :
```sql
-- Vérification des tables principales
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Vérification des données
SELECT COUNT(*) FROM country;
SELECT COUNT(*) FROM political_regime;
SELECT COUNT(*) FROM organization;
SELECT COUNT(*) FROM armed_conflict;
```

2. **Testez les extensions PostGIS** :
```sql
-- Vérification PostGIS
SELECT PostGIS_Version();
SELECT ST_AsText(ST_GeomFromText('POINT(0 0)'));
```

### Étape 5: Configuration de l'application

#### Mise à jour des variables d'environnement

Créez un fichier `.env.local` :

```env
# Supabase Configuration
VITE_SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
VITE_SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# Database Configuration (pour migration)
SUPABASE_DB_HOST=db.xxxxxxxxxxxxx.supabase.co
SUPABASE_DB_PORT=5432
SUPABASE_DB_NAME=postgres
SUPABASE_DB_USER=postgres
SUPABASE_DB_PASSWORD=your_password_here
```

#### Mise à jour de l'API Service

```typescript
// src/services/apiService.ts
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseKey)

// Adaptation des requêtes existantes pour Supabase
export const apiService = {
  // ... vos méthodes existantes adaptées
}
```

### Étape 6: Tests et validation

1. **Testez la connexion** :
```typescript
// Test de connexion
const { data, error } = await supabase
  .from('country')
  .select('*')
  .limit(5)

console.log('Test connexion:', data, error)
```

2. **Vérifiez les fonctionnalités** :
   - Affichage des pays sur la carte
   - Sélection des pays
   - Affichage des détails
   - Recherche et filtres

## 🔄 Rollback plan

En cas de problème, vous pouvez revenir à votre base locale :

```bash
# Redémarrer les conteneurs Docker
docker-compose down
docker-compose up -d

# Restaurer depuis la sauvegarde
docker exec -i wikigeopolitics-db psql -U wikigeo_user -d wikigeopolitics < database/backup/wikigeopolitics_complete_backup.sql
```

## 📊 Monitoring post-migration

### Métriques à surveiller

1. **Performance des requêtes**
2. **Utilisation de l'espace disque**
3. **Nombre de connexions simultanées**
4. **Temps de réponse des APIs**

### Optimisations possibles

1. **Indexation** des colonnes fréquemment utilisées
2. **Partitioning** des grandes tables
3. **Caching** côté application
4. **Connection pooling** pour Supabase

## 🚨 Points d'attention

### Limitations Supabase (Plan gratuit)
- **500 MB** de base de données
- **2 GB** de bande passante
- **50,000** lignes par mois
- **2** projets maximum

### Extensions PostGIS
- Vérifiez que PostGIS est activé dans votre projet Supabase
- Certaines fonctions avancées peuvent nécessiter un plan payant

### Sécurité
- Utilisez les **Row Level Security (RLS)** de Supabase
- Configurez les **policies** appropriées
- Ne partagez jamais les clés de service

## 📞 Support

En cas de problème :
1. **Documentation Supabase** : https://supabase.com/docs
2. **Community Discord** : https://discord.supabase.com
3. **GitHub Issues** : https://github.com/supabase/supabase/issues

---

**Date de migration :** [À compléter]
**Version de la base :** `wikigeopolitics_complete_backup.sql`
**Responsable :** [Votre nom] 