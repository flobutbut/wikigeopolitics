#!/bin/bash

# =====================================================
# Script de sauvegarde de la base de données WikiGeopolitics
# =====================================================

# Configuration
DB_NAME="wikigeopolitics"
DB_USER="wikigeo_user"
DB_PASSWORD="wikigeo_password"
CONTAINER_NAME="wikigeopolitics-db"
BACKUP_DIR="../backup"
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/wikigeopolitics_backup_${DATE}.sql"

# Créer le répertoire de sauvegarde s'il n'existe pas
mkdir -p "${BACKUP_DIR}"

echo "====================================================="
echo "Sauvegarde de la base de données WikiGeopolitics"
echo "Date: $(date)"
echo "Fichier: ${BACKUP_FILE}"
echo "====================================================="

# Vérifier si le conteneur PostgreSQL est en cours d'exécution
if ! docker ps | grep -q "${CONTAINER_NAME}"; then
    echo "❌ Erreur: Le conteneur PostgreSQL n'est pas en cours d'exécution"
    echo "Démarrez d'abord la base de données avec: docker-compose up -d"
    exit 1
fi

# Effectuer la sauvegarde
echo "📦 Création de la sauvegarde..."
docker exec "${CONTAINER_NAME}" pg_dump -U "${DB_USER}" -d "${DB_NAME}" > "${BACKUP_FILE}"

# Vérifier le succès de la sauvegarde
if [ $? -eq 0 ]; then
    echo "✅ Sauvegarde réussie: ${BACKUP_FILE}"
    echo "📊 Taille du fichier: $(du -h "${BACKUP_FILE}" | cut -f1)"
    
    # Lister les 5 dernières sauvegardes
    echo ""
    echo "📋 5 dernières sauvegardes:"
    ls -la "${BACKUP_DIR}"/*.sql | tail -5
else
    echo "❌ Erreur lors de la sauvegarde"
    exit 1
fi

echo "=====================================================" 