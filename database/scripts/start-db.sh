#!/bin/bash

# =====================================================
# Script de démarrage de la base de données WikiGeopolitics
# =====================================================

echo "====================================================="
echo "Démarrage de la base de données WikiGeopolitics"
echo "====================================================="

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Erreur: Docker n'est pas installé"
    echo "Installez Docker depuis: https://docs.docker.com/get-docker/"
    exit 1
fi

# Vérifier si Docker Compose est installé
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Erreur: Docker Compose n'est pas installé"
    echo "Installez Docker Compose depuis: https://docs.docker.com/compose/install/"
    exit 1
fi

# Vérifier si le fichier docker-compose.yml existe
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Erreur: docker-compose.yml non trouvé"
    echo "Assurez-vous d'être dans le répertoire racine du projet"
    exit 1
fi

# Arrêter les conteneurs existants s'ils sont en cours d'exécution
echo "🛑 Arrêt des conteneurs existants..."
docker-compose down

# Démarrer les conteneurs
echo "🚀 Démarrage des conteneurs..."
docker-compose up -d

# Attendre que PostgreSQL soit prêt
echo "⏳ Attente du démarrage de PostgreSQL..."
sleep 10

# Vérifier le statut des conteneurs
echo "📊 Statut des conteneurs:"
docker-compose ps

# Afficher les informations de connexion
echo ""
echo "====================================================="
echo "✅ Base de données démarrée avec succès!"
echo ""
echo "📋 Informations de connexion:"
echo "   Base de données: PostgreSQL"
echo "   Host: localhost"
echo "   Port: 5432"
echo "   Database: wikigeopolitics"
echo "   Username: wikigeo_user"
echo "   Password: wikigeo_password"
echo ""
echo "🌐 Interface d'administration:"
echo "   PgAdmin: http://localhost:5050"
echo "   Email: admin@wikigeopolitics.com"
echo "   Password: admin_password"
echo ""
echo "🔧 Commandes utiles:"
echo "   Arrêter: docker-compose down"
echo "   Voir les logs: docker-compose logs"
echo "   Sauvegarde: ./database/scripts/backup.sh"
echo "   Restauration: ./database/scripts/restore.sh"
echo "=====================================================" 