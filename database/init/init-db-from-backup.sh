#!/bin/bash
set -e

DB=wikigeopolitics
USER=wikigeo_user
CONTAINER=wikigeopolitics-db
BACKUP_PATH=/backups/wikigeopolitics_complete_backup.sql

# Copie le backup dans le conteneur (si besoin)
docker cp database/backup/wikigeopolitics_complete_backup.sql $CONTAINER:$BACKUP_PATH

# Drop et recrée la base
docker exec $CONTAINER dropdb -U $USER --if-exists $DB
docker exec $CONTAINER createdb -U $USER $DB

# Restaure le backup
docker exec -i $CONTAINER psql -U $USER -d $DB < database/backup/wikigeopolitics_complete_backup.sql

echo "Base de données restaurée à partir du backup !" 