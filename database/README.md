# Gestion de la Base de Données - WikiGeopolitics

## Vue d'ensemble

Ce dossier contient tous les outils pour gérer la base de données PostgreSQL du projet WikiGeopolitics.

## Structure

```
database/
├── backup/                    # Backups de la base
│   ├── wikigeopolitics_complete_backup.sql  # Backup principal (pour l'init)
│   └── wikigeopolitics_backup_YYYYMMDD_HHMMSS.sql  # Backups versionnés
├── init/
│   └── init-db-from-backup.sh              # Script d'initialisation
├── scripts/
│   ├── backup-db.sh                        # Script de backup
│   └── restore-db.sh                       # Script de restauration
└── _legacy/                                # Anciens scripts (archivés)
```

## Scripts Disponibles

### 🔄 Initialisation
```bash
# Initialiser la base depuis le backup principal
sh database/init/init-db-from-backup.sh
```

### 💾 Backup
```bash
# Créer un backup avec versioning automatique
sh database/scripts/backup-db.sh
```

**Fonctionnalités du backup :**
- Timestamp automatique dans le nom de fichier
- Mise à jour du backup principal
- Nettoyage automatique (garde les 10 derniers)
- Affichage de la taille et liste des backups

### 🔙 Restauration
```bash
# Restaurer depuis le backup principal
sh database/scripts/restore-db.sh

# Lister tous les backups disponibles
sh database/scripts/restore-db.sh -l

# Restaurer depuis un backup spécifique
sh database/scripts/restore-db.sh -f wikigeopolitics_backup_20241222_143022.sql
```

**Fonctionnalités de la restauration :**
- Confirmation avant suppression
- Vérification de l'existence du fichier
- Aide intégrée avec `-h`
- Vérification post-restauration

## Workflow Recommandé

### 1. Première Installation
```bash
# Démarrer les conteneurs
docker-compose up -d

# Initialiser la base
sh database/init/init-db-from-backup.sh
```

### 2. Développement Quotidien
```bash
# Avant de faire des modifications importantes
sh database/scripts/backup-db.sh

# Si quelque chose ne va pas, restaurer
sh database/scripts/restore-db.sh
```

### 3. Mise à Jour de la Base
```bash
# Après avoir ajouté des données
sh database/scripts/backup-db.sh

# Le backup principal est automatiquement mis à jour
# pour les prochaines initialisations
```

## Configuration

### Variables d'Environnement
Les scripts utilisent ces valeurs par défaut :
- **Base de données** : `wikigeopolitics`
- **Utilisateur** : `wikigeo_user`
- **Conteneur** : `wikigeopolitics-db`
- **Dossier backup** : `database/backup`
- **Max backups** : 10 (automatiquement nettoyés)

### Connexion
- **Host** : localhost
- **Port** : 5433
- **Interface admin** : PgAdmin sur http://localhost:5050

## Sécurité

- ⚠️ **Confirmation requise** avant restauration
- 📋 **Vérification** de l'existence des fichiers
- 🧹 **Nettoyage automatique** des anciens backups
- 📊 **Vérification post-restauration**

## Dépannage

### Erreur de connexion
```bash
# Vérifier que les conteneurs sont démarrés
docker ps

# Redémarrer si nécessaire
docker-compose restart
```

### Backup corrompu
```bash
# Lister tous les backups
sh database/scripts/restore-db.sh -l

# Restaurer depuis un backup plus ancien
sh database/scripts/restore-db.sh -f wikigeopolitics_backup_20241221_120000.sql
```

### Base vide après restauration
```bash
# Vérifier le contenu du backup
head -20 database/backup/wikigeopolitics_complete_backup.sql

# Réinitialiser depuis le backup principal
sh database/init/init-db-from-backup.sh
``` 