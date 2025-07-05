#!/bin/bash
set -e

# Configuration
DB=wikigeopolitics
USER=wikigeo_user
CONTAINER=wikigeopolitics-db
BACKUP_DIR=database/backup
MAX_BACKUPS=10  # Garde les 10 derniers backups

# Création du dossier backup s'il n'existe pas
mkdir -p $BACKUP_DIR

# Génération du nom de fichier avec timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="wikigeopolitics_backup_${TIMESTAMP}.sql"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILE"

echo "🔄 Création du backup: $BACKUP_FILE"

# Création du backup
docker exec $CONTAINER pg_dump -U $USER -d $DB > "$BACKUP_PATH"

# Vérification que le backup a été créé
if [ -f "$BACKUP_PATH" ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_PATH" | cut -f1)
    echo "✅ Backup créé avec succès: $BACKUP_FILE ($BACKUP_SIZE)"
    
    # Mise à jour du backup principal (pour l'init)
    cp "$BACKUP_PATH" "$BACKUP_DIR/wikigeopolitics_complete_backup.sql"
    echo "📋 Backup principal mis à jour"
    
    # Nettoyage des anciens backups (garde les MAX_BACKUPS plus récents)
    echo "🧹 Nettoyage des anciens backups..."
    cd $BACKUP_DIR
    ls -t wikigeopolitics_backup_*.sql | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm
    cd - > /dev/null
    
    echo "📊 Backups disponibles:"
    ls -lh $BACKUP_DIR/wikigeopolitics_backup_*.sql 2>/dev/null || echo "Aucun backup trouvé"
    
else
    echo "❌ Erreur: Le backup n'a pas été créé"
    exit 1
fi 