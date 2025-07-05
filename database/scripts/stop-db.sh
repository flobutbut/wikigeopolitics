#!/bin/bash

# =====================================================
# Script d'arrêt de la base de données WikiGeopolitics
# =====================================================

echo "====================================================="
echo "Arrêt de la base de données WikiGeopolitics"
echo "====================================================="

# Vérifier si le fichier docker-compose.yml existe
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Erreur: docker-compose.yml non trouvé"
    echo "Assurez-vous d'être dans le répertoire racine du projet"
    exit 1
fi

# Afficher le statut actuel des conteneurs
echo "📊 Statut actuel des conteneurs:"
docker-compose ps

# Demander confirmation
echo ""
echo "⚠️  Êtes-vous sûr de vouloir arrêter la base de données? (y/N)"
read -r confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "❌ Arrêt annulé"
    exit 0
fi

# Arrêter les conteneurs
echo "🛑 Arrêt des conteneurs..."
docker-compose down

# Vérifier que les conteneurs sont arrêtés
echo "📊 Statut après arrêt:"
docker-compose ps

echo ""
echo "✅ Base de données arrêtée avec succès!"
echo ""
echo "🔧 Pour redémarrer:"
echo "   ./database/scripts/start-db.sh"
echo "   ou"
echo "   docker-compose up -d"
echo "=====================================================" 