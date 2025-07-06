#!/bin/bash

# Script pour démarrer le serveur backend WikiGeopolitics

echo "🚀 Démarrage du serveur backend WikiGeopolitics..."

# Vérifier si Node.js est installé
if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Aller dans le dossier server
cd server

# Vérifier si les dépendances sont installées
if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances..."
    npm install
fi

# Démarrer le serveur
echo "🌐 Démarrage du serveur API sur http://localhost:3000"
npm run dev 