#!/bin/bash

# =====================================================
# Script de restauration de la base de données WikiGeopolitics
# =====================================================

# Configuration
DB_NAME="wikigeopolitics"
DB_USER="wikigeo_user"
DB_PASSWORD="wikigeo_password"
CONTAINER_NAME="wikigeopolitics-db"
BACKUP_DIR="./database/backups"

echo "====================================================="
echo "Restauration de la base de données WikiGeopolitics"
echo "====================================================="

# Vérifier si le conteneur PostgreSQL est en cours d'exécution
if ! docker ps | grep -q "${CONTAINER_NAME}"; then
    echo "❌ Erreur: Le conteneur PostgreSQL n'est pas en cours d'exécution"
    echo "Démarrez d'abord la base de données avec: docker-compose up -d"
    exit 1
fi

# Lister les sauvegardes disponibles
echo "📋 Sauvegardes disponibles:"
ls -la "${BACKUP_DIR}"/*.sql 2>/dev/null | nl

if [ $? -ne 0 ]; then
    echo "❌ Aucune sauvegarde trouvée dans ${BACKUP_DIR}"
    exit 1
fi

# Demander à l'utilisateur de choisir une sauvegarde
echo ""
echo "Entrez le numéro de la sauvegarde à restaurer (ou 'q' pour quitter):"
read -r choice

if [ "$choice" = "q" ] || [ "$choice" = "Q" ]; then
    echo "❌ Restauration annulée"
    exit 0
fi

# Récupérer le fichier de sauvegarde sélectionné
BACKUP_FILE=$(ls "${BACKUP_DIR}"/*.sql | sed -n "${choice}p")

if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Fichier de sauvegarde invalide"
    exit 1
fi

echo "📦 Restauration depuis: ${BACKUP_FILE}"
echo "⚠️  ATTENTION: Cette opération va écraser la base de données actuelle!"
echo "Êtes-vous sûr de vouloir continuer? (y/N)"
read -r confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "❌ Restauration annulée"
    exit 0
fi

# Effectuer la restauration
echo "🔄 Restauration en cours..."
docker exec -i "${CONTAINER_NAME}" psql -U "${DB_USER}" -d "${DB_NAME}" < "${BACKUP_FILE}"

# Vérifier le succès de la restauration
if [ $? -eq 0 ]; then
    echo "✅ Restauration réussie!"
    echo "📊 Base de données restaurée depuis: ${BACKUP_FILE}"
else
    echo "❌ Erreur lors de la restauration"
    exit 1
fi

echo "=====================================================" 