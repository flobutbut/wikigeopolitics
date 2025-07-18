# Consolidation de l'indice de dépendance et de souveraineté géopolitique

Ce document synthétise les axes méthodologiques et conceptuels nécessaires pour construire un **indice robuste**, **explorable** et **crédible** de dépendance et souveraineté géopolitique, intégrant la complexité systémique des interdépendances entre ressources, domaines stratégiques et géographie.

---

## 1. Structure de l’indice

### 1.1 Pilier principaux (exemples proposés)
- Énergie
- Alimentation / agriculture
- Technologie & Numérique
- Défense
- Économie & Finances
- Politique extérieure

### 1.2 Composition d’un pilier
Chaque pilier est composé de 2 à 4 sous-indicateurs :
- Chaque sous-indicateur est noté sur 100 (où 100 = souveraineté totale, 0 = dépendance critique)
- Exemple pour le pilier "Énergie" :
  - % d’énergie importée
  - % de renouvelables dans le mix énergétique TOTAL
  - % des infrastructures sous contrôle national

### 1.3 Indice global
Indice global = Moyenne pondérée des scores de chaque pilier

---

## 2. Normalisation & pondération

### 2.1 Normalisation
- Utilisation de **min-max scaling** ou **percentiles**
- Transformation logarithmique possible en cas de distribution déséquilibrée
- Référentiels historiques à établir pour chaque sous-indicateur

### 2.2 Pondération
- Pondérations fixes par défaut
- Possibilité d’un mode "personnalisé" (ex : focus défense ou économie)
- Pondérations ajustables selon région, contexte ou typologie de pays

---

## 3. Dépendances croisées entre piliers

Certains domaines ne sont pas indépendants :

| Pilier principal     | Dépend de…                           | Exemple concret                                         |
| -------------------- | ------------------------------------ | ------------------------------------------------------- |
| Alimentation         | Énergie, Commerce                    | Engrais azotés → Gaz naturel                            |
| Défense              | Industrie, Technologie               | Avions de chasse → composants numériques                |
| Économie             | Stabilité politique, infrastructures | IDE, accès au cloud                                     |
| Politique extérieure | Capacité militaire, ressources       | Relations diplomatiques dépendantes d’approvisionnement |

### 3.1 Intégration proposée
- Graphe de dépendances inter-piliers (visuel + logique)
- Système d’alerte : "ce bon score dépend de X pilier vulnérable"
- Indice de robustesse systémique (nombre de dépendances critiques croisées)

---

## 4. Distribution stratégique et vulnérabilités logistiques

### 4.1 Pourquoi c’est crucial
Un pays peut être producteur mais vulnérable si :
- Les ressources sont concentrées géographiquement
- Les routes commerciales passent par un seul point
- Les infrastructures sont exposées ou non souveraines

### 4.2 Intégration dans l’indice
Création d’un sous-indice "distribution stratégique" :
- Diversité spatiale (interne ou externe)
- Robustesse des infrastructures logistiques
- Présence de goulots d’étranglement (Suez, Malacca, Odessa…)

### 4.3 Données utiles
- Géolocalisation des ressources (`geoJsonRef`)
- Réseaux de communication (câbles, satellites, data centers)
- Routes commerciales (`TRADE_ROUTE`)

---

## 5. Données sources et traçabilité

### 5.1 Données typiques à intégrer
- IEA (énergie), FAO (agriculture), ITU (cyber), SIPRI (défense), World Bank (économie), Our World In Data

### 5.2 Stockage des scores par pays
Chaque pilier doit contenir les composants, sources et dates :
```json
"energie": {
  "score": 48,
  "composants": {
    "importation": 60,
    "renouvelables": 25,
    "souveraineteInfrastructures": 60
  },
  "sources": {
    "importation": "IEA 2023",
    "renouvelables": "Our World in Data 2022"
  }
}
```

---

## 6. Cas d’usage et visualisation

- Cartes de souveraineté ou dépendance par domaine
- Comparateurs entre pays
- Radar "robustesse stratégique"
- Alerte sur dépendances critiques (indirectes ou croisées)
- Graphe dynamique de relations systémiques

---

## 7. Évolutivité

L’indice est conçu pour être :
- Extensible (nouveaux piliers ou indicateurs)
- Adaptable (pondération ou seuils contextuels)
- Interopérable (données issues de ta base relationnelle : `RESOURCE`, `TRADE_ROUTE`, `COMM_NETWORK`, etc.)