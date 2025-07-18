
# Indice de Stabilité des Relations Bilatérales (ISRB)

## 🎯 Objectif
L’Indice de Stabilité des Relations Bilatérales (ISRB) vise à représenter, sous forme d’un score synthétique, la qualité et la stabilité des relations entre deux pays à un instant donné, tout en tenant compte de l’historique et des événements récents.

---

## 🧱 Structure de l’indice

### Échelle
- **Plage de score** : de **–100** (hostilité complète) à **+100** (alliance stratégique forte)
- Trois zones :
  - 🔴 **Instable** : ≤ –25
  - 🟡 **Fragile** : –25 à +25
  - 🟢 **Stable** : > +25

---

## 🧠 Philosophie du modèle
L’indice repose sur deux piliers :
1. **Base structurelle** (relations longues, accords, historique)
2. **Modulation conjoncturelle** (événements récents pondérés)

---

## ⚙️ Calcul de l’indice

### 1. Composantes
#### A. Score structurel (S)
Basé sur des relations stables : traités, alliances, interdépendances économiques, militaires ou culturelles.
- S est évalué tous les 6 à 12 mois

#### B. Modulateur événementiel (E)
Somme pondérée des événements récents selon une grille standardisée.
- Chaque événement a un **impact initial** et une **courbe de décroissance** dans le temps.

#### C. Indice final (ISRB)
**ISRB(t) = S + E(t)**  
(valeur bornée à [–100 ; +100])

---

## 🔍 Évaluation des événements

### Grille de notation
Chaque événement est évalué selon 6 axes, notés de 0 à 3 :

| Axe           | Score 0         | Score 1        | Score 2               | Score 3                     |
| ------------- | --------------- | -------------- | --------------------- | --------------------------- |
| Domaine       | Culturel mineur | Diplomatique   | Économique            | Militaire / stratégique     |
| Profondeur    | Annonce vague   | Projet / débat | Accord signé / décret | Rupture / attaque / retrait |
| Durée prévue  | Ponctuelle      | ≤ 6 mois       | > 1 an                | Permanente / structurelle   |
| Engagement    | Rhétorique      | Projet         | Signature             | Mise en œuvre effective     |
| Réversibilité | Totale          | Modérée        | Difficile             | Irréversible                |
| Visibilité    | Nulle           | Nationale      | Internationale        | Crise médiatique mondiale   |

### Traduction en impact

| Total brut | Impact sur ISRB |
|------------|------------------|
| 0–4        | ±1 à ±2 points   |
| 5–8        | ±3 à ±5 points   |
| 9–12       | ±6 à ±8 points   |
| 13–15      | ±9 à ±11 points  |
| 16–18      | ±12 à ±15 points |

---

## 🕰️ Gestion temporelle

### A. Décroissance exponentielle
Chaque événement perd de l’influence avec le temps :
**Impact_t = Impact_0 × e^(–λ × Δt)**

### B. Renforcement par récurrence
Répétition de signaux similaires stabilise leur poids dans l’indice.

---

## 🧱 Inertie relationnelle & volatilité

### A. Limitation des variations
- Variation maximale de l’ISRB limitée à ±10 points / mois glissant

### B. Ancrage historique
- Une relation historiquement forte ne chute pas brutalement sans événement majeur

---

## 🧾 Exemple d’événement codé (YAML)

```yaml
titre: Menace de sanctions douanières de Trump contre la France
date: 2020-01-07
pays_1: USA
pays_2: France
direction: négative
domaine: économique
profondeur: 1
durée: 1
engagement: 1
réversibilité: 2
visibilité: 3
score_brut: 10
impact_initial: -7
décroissance: 0.3
```

---

## 📈 Visualisation recommandée
- Graphique de l’ISRB dans le temps
- Couleurs : rouge / jaune / vert
- Annotations sur les événements

---

## 🛠️ Intégration technique

### Stockage
Chaque couple de pays possède :
- un score structurel
- une liste d’événements encodés
- un indice calculé automatiquement

### API / Export
- JSON ou CSV avec score actuel, historique, événements actifs

---

## 🚀 Évolutions possibles
- Intégration automatique de flux d’actualité
- Pondération régionale
- Croisement avec indice de dépendance mutuelle
