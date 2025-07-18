#!/bin/bash

# 🚀 Script de migration vers Supabase - WikiGeopolitics
# Usage: ./migrate-to-supabase.sh

set -e  # Arrêt en cas d'erreur

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKUP_FILE="backup/wikigeopolitics_backup_20250718_192138.sql"
ENV_FILE=".env.local"

echo -e "${BLUE}🚀 Migration WikiGeopolitics vers Supabase${NC}"
echo "=========================================="

# Vérification des prérequis
echo -e "${YELLOW}📋 Vérification des prérequis...${NC}"

# Vérifier que le fichier de sauvegarde existe
if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${RED}❌ Fichier de sauvegarde non trouvé: $BACKUP_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Fichier de sauvegarde trouvé${NC}"

# Vérifier que psql est installé
if ! command -v psql &> /dev/null; then
    echo -e "${RED}❌ PostgreSQL client (psql) n'est pas installé${NC}"
    echo "Installez-le avec: brew install postgresql"
    exit 1
fi

echo -e "${GREEN}✅ PostgreSQL client disponible${NC}"

# Charger les informations depuis .env.local
echo -e "${YELLOW}🔧 Chargement de la configuration depuis .env.local${NC}"

if [ -f "../.env.local" ]; then
    # Charger les variables une par une pour éviter les problèmes de caractères spéciaux
    export SUPABASE_DB_HOST=$(grep "SUPABASE_DB_HOST=" ../.env.local | cut -d'=' -f2)
    export SUPABASE_DB_PORT=$(grep "SUPABASE_DB_PORT=" ../.env.local | cut -d'=' -f2)
    export SUPABASE_DB_NAME=$(grep "SUPABASE_DB_NAME=" ../.env.local | cut -d'=' -f2)
    export SUPABASE_DB_USER=$(grep "SUPABASE_DB_USER=" ../.env.local | cut -d'=' -f2)
    export SUPABASE_DB_PASSWORD=$(grep "SUPABASE_DB_PASSWORD=" ../.env.local | cut -d'=' -f2)
    echo "✅ Configuration chargée depuis .env.local"
    echo "Host: '$SUPABASE_DB_HOST'"
    echo "User: '$SUPABASE_DB_USER'"
    echo "Database: '$SUPABASE_DB_NAME'"
    echo "Port: '$SUPABASE_DB_PORT'"
    echo "Password: '${SUPABASE_DB_PASSWORD:0:3}***'"
else
    echo -e "${RED}❌ Fichier .env.local non trouvé${NC}"
    exit 1
fi

# Construire l'URL de connexion
CONNECTION_URL="postgresql://${SUPABASE_DB_USER}:${SUPABASE_DB_PASSWORD}@${SUPABASE_DB_HOST}:${SUPABASE_DB_PORT}/${SUPABASE_DB_NAME}"
echo "URL de connexion: postgresql://${SUPABASE_DB_USER}:***@${SUPABASE_DB_HOST}:${SUPABASE_DB_PORT}/${SUPABASE_DB_NAME}"

echo -e "${YELLOW}🔍 Test de connexion à Supabase...${NC}"

# Test de connexion
if psql "$CONNECTION_URL" -c "SELECT 1;" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Connexion à Supabase réussie${NC}"
else
    echo -e "${RED}❌ Échec de la connexion à Supabase${NC}"
    echo "Vérifiez vos informations de connexion"
    exit 1
fi

# Sauvegarde de la configuration
echo -e "${YELLOW}💾 Sauvegarde de la configuration...${NC}"

cat > "$ENV_FILE" << EOF
# Supabase Configuration
VITE_SUPABASE_URL=https://${SUPABASE_DB_HOST#db.}
VITE_SUPABASE_ANON_KEY=your_anon_key_here
VITE_SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# Database Configuration (pour migration)
SUPABASE_DB_HOST=${SUPABASE_DB_HOST}
SUPABASE_DB_PORT=${SUPABASE_DB_PORT}
SUPABASE_DB_NAME=${SUPABASE_DB_NAME}
SUPABASE_DB_USER=${SUPABASE_DB_USER}
SUPABASE_DB_PASSWORD=${SUPABASE_DB_PASSWORD}
EOF

echo -e "${GREEN}✅ Configuration sauvegardée dans $ENV_FILE${NC}"

# Confirmation avant migration
echo -e "${YELLOW}⚠️  ATTENTION: Cette opération va écraser les données existantes sur Supabase${NC}"
read -p "Êtes-vous sûr de vouloir continuer? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}❌ Migration annulée${NC}"
    exit 0
fi

# Migration des données
echo -e "${YELLOW}🔄 Migration des données vers Supabase...${NC}"

# Créer un fichier temporaire pour nettoyer le script SQL
TEMP_SQL="/tmp/wikigeopolitics_migration.sql"

# Nettoyer le script SQL (supprimer les commandes CREATE DATABASE, etc.)
echo "SET session_replication_role = replica;" > "$TEMP_SQL"
echo "SET search_path TO public;" >> "$TEMP_SQL"
cat "$BACKUP_FILE" | grep -v "CREATE DATABASE\|DROP DATABASE\|\\c " >> "$TEMP_SQL"
echo "SET session_replication_role = DEFAULT;" >> "$TEMP_SQL"

# Exécuter la migration
if psql "$CONNECTION_URL" -f "$TEMP_SQL"; then
    echo -e "${GREEN}✅ Migration des données réussie${NC}"
else
    echo -e "${RED}❌ Échec de la migration${NC}"
    echo "Vérifiez les logs ci-dessus pour plus de détails"
    rm -f "$TEMP_SQL"
    exit 1
fi

# Nettoyer le fichier temporaire
rm -f "$TEMP_SQL"

# Vérification post-migration
echo -e "${YELLOW}🔍 Vérification post-migration...${NC}"

# Vérifier les tables principales
echo "Vérification des tables:"
psql "$CONNECTION_URL" -c "
SELECT 
    'country' as table_name, COUNT(*) as count FROM country
UNION ALL
SELECT 
    'political_regime' as table_name, COUNT(*) as count FROM political_regime
UNION ALL
SELECT 
    'organization' as table_name, COUNT(*) as count FROM organization
UNION ALL
SELECT 
    'armed_conflict' as table_name, COUNT(*) as count FROM armed_conflict;
"

# Vérifier PostGIS
echo -e "\nVérification PostGIS:"
psql "$CONNECTION_URL" -c "SELECT PostGIS_Version();"

echo -e "${GREEN}✅ Migration terminée avec succès!${NC}"

# Instructions post-migration
echo -e "${BLUE}📋 Prochaines étapes:${NC}"
echo "1. Récupérez vos clés API dans le dashboard Supabase"
echo "2. Mettez à jour VITE_SUPABASE_ANON_KEY dans $ENV_FILE"
echo "3. Installez le client Supabase: npm install @supabase/supabase-js"
echo "4. Adaptez votre code pour utiliser Supabase"
echo "5. Testez votre application"

echo -e "${GREEN}🎉 Migration vers Supabase terminée!${NC}" 