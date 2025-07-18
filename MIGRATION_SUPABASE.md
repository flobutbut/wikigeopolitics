# 🚀 Guide de Migration Supabase - WikiGeopolitics

## 📊 État Actuel

**✅ Préparations terminées :**
- ✅ Service Supabase complet (`src/services/supabaseService.ts`)
- ✅ Types TypeScript définis (`src/types/supabase.ts`)
- ✅ Script de migration automatisé (`database/migrate-to-supabase.sh`)
- ✅ Package Supabase installé (`@supabase/supabase-js@2.51.0`)
- ✅ Service adaptatif créé (`src/services/adaptiveApiService.ts`)
- ✅ Composant de diagnostic développé (`src/components/common/SupabaseDiagnostic.vue`)
- ✅ Panel de debug intégré (`src/components/debug/DebugPanel.vue`)

**⏳ Étapes restantes :**
1. Configuration des variables d'environnement
2. Migration effective des données
3. Test et validation
4. Basculement progressif

## 🛠️ Instructions de Migration

### Étape 1: Configuration Supabase

1. **Créez votre projet Supabase :**
   - Allez sur https://supabase.com/dashboard
   - Créez un nouveau projet
   - Nom : `wikigeopolitics`
   - Région : Europe (Paris) recommandé
   - Mot de passe : (notez-le bien)

2. **Récupérez vos clés API :**
   - Dashboard → Settings → API
   - Notez : `Project URL` et `anon public key`

3. **Configurez l'environnement :**
   ```bash
   # Copiez le fichier d'exemple
   cp .env.local.example .env.local
   
   # Éditez .env.local avec vos vraies valeurs
   nano .env.local
   ```

   ```env
   # Remplacez ces valeurs par les vôtres
   VITE_SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
   VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   VITE_USE_SUPABASE=true
   VITE_USE_LOCAL_API=false
   ```

### Étape 2: Migration des Données

1. **Préparez vos données locales :**
   ```bash
   # Créez un backup récent de votre base locale
   docker exec wikigeopolitics-db pg_dump -U wikigeo_user -d wikigeopolitics > database/backup/latest_backup.sql
   ```

2. **Exécutez le script de migration :**
   ```bash
   # Rendez le script exécutable
   chmod +x database/migrate-to-supabase.sh
   
   # Lancez la migration
   ./database/migrate-to-supabase.sh
   ```

3. **Suivez les instructions du script :**
   - Entrez vos informations de connexion Supabase
   - Confirmez la migration
   - Vérifiez les résultats

### Étape 3: Test et Validation

1. **Démarrez l'application :**
   ```bash
   npm run dev
   ```

2. **Ouvrez le Debug Panel :**
   - Raccourci : `Ctrl + Shift + D`
   - Ou cliquez sur l'icône 🔧 en haut à droite

3. **Vérifiez la migration dans l'onglet "🚀 Supabase" :**
   - ✅ Configuration correcte
   - ✅ Connexion réussie
   - ✅ Données disponibles (nombre de pays, régimes, etc.)

4. **Testez les fonctionnalités :**
   - Navigation dans les pays
   - Sélection sur la carte
   - Floating panels
   - Recherche et filtres

### Étape 4: Basculement Progressif

Le service adaptatif permet une migration en douceur :

1. **Mode hybride** (recommandé pour débuter) :
   ```env
   VITE_USE_SUPABASE=true
   VITE_USE_LOCAL_API=true
   ```
   → Supabase en priorité, fallback vers l'API locale

2. **Mode Supabase uniquement** (production) :
   ```env
   VITE_USE_SUPABASE=true
   VITE_USE_LOCAL_API=false
   ```
   → Utilise uniquement Supabase

3. **Rollback possible** :
   ```env
   VITE_USE_SUPABASE=false
   VITE_USE_LOCAL_API=true
   ```
   → Retour à l'API locale

## 🔧 Outils de Diagnostic

### Debug Panel (Ctrl + Shift + D)

Accessible uniquement en développement, le Debug Panel contient :

1. **🚀 Supabase :**
   - État de la configuration
   - Test de connexion
   - Statistiques des données
   - Instructions de configuration

2. **📊 Stores :**
   - État des stores Pinia
   - Sélections actives
   - Données chargées

3. **🌍 Env :**
   - Variables d'environnement
   - Configuration actuelle

4. **⚡ Perf :**
   - Métriques de performance
   - Utilisation mémoire

### Service Adaptatif

Le `AdaptiveApiService` gère automatiquement :
- Basculement entre APIs
- Fallback en cas d'erreur
- Logs détaillés
- Cache intelligent

## 📋 Checklist de Migration

### Avant Migration
- [ ] Backup de la base locale créé
- [ ] Projet Supabase créé et configuré
- [ ] Variables d'environnement définies
- [ ] Script de migration testé

### Pendant Migration
- [ ] Script de migration exécuté sans erreur
- [ ] Données migrées (vérification par comptage)
- [ ] Extensions PostGIS activées
- [ ] Permissions correctement configurées

### Après Migration
- [ ] Debug Panel affiche ✅ pour Supabase
- [ ] Navigation des pays fonctionne
- [ ] Floating panels s'affichent correctement
- [ ] Recherche et filtres opérationnels
- [ ] Performance acceptable

### Production
- [ ] Variables d'environnement de production configurées
- [ ] Mode Supabase uniquement activé
- [ ] Monitoring activé
- [ ] Backups automatiques configurés

## 🚨 Troubleshooting

### Problème : Connexion Supabase échoue
**Solution :**
1. Vérifiez les variables d'environnement
2. Confirmez que le projet Supabase est actif
3. Vérifiez les logs dans le Debug Panel

### Problème : Données manquantes après migration
**Solution :**
1. Vérifiez les logs du script de migration
2. Contrôlez les comptages dans Supabase Dashboard
3. Re-exécutez la migration si nécessaire

### Problème : Performance dégradée
**Solution :**
1. Vérifiez votre région Supabase (Europe recommandé)
2. Activez la mise en cache
3. Considérez le plan payant pour plus de ressources

### Problème : Rollback nécessaire
**Solution :**
1. Changez `VITE_USE_SUPABASE=false` dans `.env.local`
2. Redémarrez le serveur de développement
3. Vérifiez que l'API locale fonctionne

## 📞 Support

- **Documentation Supabase :** https://supabase.com/docs
- **Community Discord :** https://discord.supabase.com
- **Debug Panel :** `Ctrl + Shift + D` dans l'application

---

**🎉 Une fois la migration terminée, vous bénéficierez de :**
- Hébergement cloud automatique
- Scalabilité automatique
- Backups automatiques
- API REST et GraphQL générées
- Dashboard d'administration
- Monitoring intégré

La migration est conçue pour être **progressive** et **réversible**. N'hésitez pas à tester en mode hybride avant le basculement complet !