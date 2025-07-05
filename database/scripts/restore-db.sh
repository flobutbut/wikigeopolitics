#!/bin/bash
set -e

# Configuration
DB=wikigeopolitics
USER=wikigeo_user
CONTAINER=wikigeopolitics-db
BACKUP_DIR=database/backup

# Fonction d'aide
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -f, --file FILE     Restaurer depuis un fichier spécifique"
    echo "  -l, --list          Lister tous les backups disponibles"
    echo "  -h, --help          Afficher cette aide"
    echo ""
    echo "Exemples:"
    echo "  $0                    # Restaurer depuis le backup principal"
    echo "  $0 -f backup_20241222_143022.sql  # Restaurer depuis un backup spécifique"
    echo "  $0 -l                # Lister tous les backups"
}

# Fonction pour lister les backups
list_backups() {
    echo "📋 Backups disponibles:"
    echo ""
    if [ -d "$BACKUP_DIR" ]; then
        ls -lh "$BACKUP_DIR"/wikigeopolitics_backup_*.sql 2>/dev/null | while read line; do
            echo "  $line"
        done
        echo ""
        echo "Backup principal:"
        ls -lh "$BACKUP_DIR/wikigeopolitics_complete_backup.sql" 2>/dev/null || echo "  Aucun backup principal trouvé"
    else
        echo "  Aucun backup trouvé"
    fi
}

# Traitement des arguments
BACKUP_FILE=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            BACKUP_FILE="$2"
            shift 2
            ;;
        -l|--list)
            list_backups
            exit 0
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "❌ Option inconnue: $1"
            show_help
            exit 1
            ;;
    esac
done

# Détermination du fichier de backup à utiliser
if [ -z "$BACKUP_FILE" ]; then
    BACKUP_FILE="$BACKUP_DIR/wikigeopolitics_complete_backup.sql"
    echo "🔄 Restauration depuis le backup principal..."
else
    # Si le fichier ne contient pas le chemin complet, l'ajouter
    if [[ "$BACKUP_FILE" != /* ]] && [[ "$BACKUP_FILE" != ./* ]]; then
        BACKUP_FILE="$BACKUP_DIR/$BACKUP_FILE"
    fi
    echo "🔄 Restauration depuis: $BACKUP_FILE"
fi

# Vérification que le fichier existe
if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Erreur: Le fichier de backup n'existe pas: $BACKUP_FILE"
    echo ""
    list_backups
    exit 1
fi

echo "⚠️  ATTENTION: Cette opération va supprimer la base de données actuelle!"
echo "   Base: $DB"
echo "   Backup: $BACKUP_FILE"
echo ""
read -p "Êtes-vous sûr de vouloir continuer? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Restauration annulée"
    exit 0
fi

echo "🔄 Suppression de la base existante..."
docker exec $CONTAINER dropdb -U $USER --if-exists $DB

echo "🔄 Création de la nouvelle base..."
docker exec $CONTAINER createdb -U $USER $DB

echo "🔄 Restauration depuis le backup..."
docker exec -i $CONTAINER psql -U $USER -d $DB < "$BACKUP_FILE"

echo "✅ Restauration terminée avec succès!"
echo "📊 Vérification:"
docker exec -i $CONTAINER psql -U $USER -d $DB -c "SELECT COUNT(*) as total_countries FROM country;" 