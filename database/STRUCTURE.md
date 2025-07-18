# Structure du dossier Database

## 📁 Organisation

```
database/
├── _legacy/                    # Scripts de base de données essentiels
│   ├── 01-create-schema.sql    # Création du schéma initial
│   ├── 02-insert-sample-data.sql
│   ├── 03-extend-schema.sql
│   ├── 04-insert-political-regimes.sql
│   ├── 05-insert-agricultural-data.sql
│   ├── 06-insert-technology-data.sql
│   ├── 07-insert-demographic-data.sql
│   ├── 08-insert-detailed-countries.sql
│   ├── 09-insert-conflicts-data.sql
│   ├── 10-insert-natural-resources.sql
│   ├── 11-insert-industrial-data.sql
│   ├── 12-insert-transport-data.sql
│   ├── 13-run-all-extensions.sql
│   ├── 14-add-missing-countries.sql
│   ├── backup.sh               # Script de sauvegarde
│   └── restore.sh              # Script de restauration
├── backup/                     # Sauvegardes de la base de données
│   ├── wikigeopolitics_backup_20250707_220138.sql
│   ├── wikigeopolitics_backup_20250708_221332.sql
│   ├── wikigeopolitics_backup_20250711_003415.sql
│   ├── wikigeopolitics_backup_20250718_084814.sql
│   ├── wikigeopolitics_backup_20250718_085549.sql
│   ├── wikigeopolitics_backup_20250718_092902.sql
│   ├── wikigeopolitics_backup_20250718_114423.sql
│   ├── wikigeopolitics_backup_20250718_131551.sql
│   └── wikigeopolitics_complete_backup.sql
├── init/                       # Scripts d'initialisation
│   └── init-db-from-backup.sh  # Initialisation depuis un backup
├── scripts/                    # Scripts de maintenance (vide après nettoyage)
├── migrate-to-supabase.sh      # Migration vers Supabase
├── migrate-to-supabase.md      # Documentation migration Supabase
└── README.md                   # Documentation générale
```

## 🧹 Nettoyage effectué

### Supprimé :
- ❌ Dossiers imbriqués `database/_legacy/database/` et `database/scripts/database/`
- ❌ Doublons de backups
- ❌ Scripts de migration obsolètes (100+ fichiers)
- ❌ Scripts de nettoyage intermédiaires

### Conservé :
- ✅ Scripts de base de données essentiels (`_legacy/`)
- ✅ Backups récents et complets (`backup/`)
- ✅ Scripts d'initialisation (`init/`)
- ✅ Scripts de migration Supabase

## 🔧 Utilisation

### Sauvegarde :
```bash
cd database/_legacy && ./backup.sh
```

### Restauration :
```bash
cd database/init && ./init-db-from-backup.sh
```

### Migration vers Supabase :
```bash
cd database && ./migrate-to-supabase.sh
```

## 📊 Statistiques

- **Backups** : 9 fichiers (du 07/07/2025 au 18/07/2025)
- **Scripts essentiels** : 16 fichiers dans `_legacy/`
- **Scripts d'init** : 1 fichier
- **Structure** : Simple et maintenable 