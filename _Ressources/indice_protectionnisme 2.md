
# Indice de Protectionnisme

L’indice de protectionnisme vise à mesurer le degré de fermeture d’un pays vis-à-vis des flux extérieurs selon trois grands axes : économique, migratoire, et technologique/réglementaire. Il repose sur une évaluation objective, suivie d’une lecture synthétique fondée sur le score médian.

## 📊 Structure générale

### 1. Pilier Économique (0–100)

Ce pilier mesure les barrières commerciales et la volonté d’un État à protéger son marché.

**Sous-indicateurs :**

| Sous-indicateur                     | Description                                             |
| ----------------------------------- | ------------------------------------------------------- |
| Barrières tarifaires moyennes       | Droits de douane appliqués aux importations             |
| Barrières non tarifaires            | Normes sanitaires, quotas, restrictions administratives |
| Subventions sectorielles nationales | Aides à l’agriculture, industrie, etc.                  |
| Accords de libre-échange            | Nombre et nature des accords commerciaux actifs         |

Chaque sous-indicateur est normalisé sur 0–100, la moyenne des sous-scores constitue le score du pilier.

---

### 2. Pilier Migratoire (0–100)

Ce pilier reflète l’ouverture d’un pays aux personnes étrangères (visas, asile, regroupement familial...).

**Sous-indicateurs :**

| Sous-indicateur                  | Description                                                      |
|----------------------------------|------------------------------------------------------------------|
| Taux de refus de visa            | Pour les visiteurs, travailleurs, étudiants                      |
| Acceptation de réfugiés          | Nombre annuel rapporté à la population                           |
| Règles de regroupement familial  | Conditions d’obtention, critères restrictifs                     |
| Existence de quotas migratoires  | Présents ou non, et dans quelle proportion                       |

---

### 3. Pilier Technologique & Réglementaire (0–100)

Ce pilier évalue les stratégies de souveraineté numérique, la censure, et le contrôle de l’économie numérique.

**Sous-indicateurs :**

| Sous-indicateur                       | Description                                                                 |
|--------------------------------------|-----------------------------------------------------------------------------|
| Souveraineté numérique               | Intranet national, indépendance cloud, systèmes critiques contrôlés        |
| Localisation des données             | Obligation de stockage local, restrictions d’exportation                   |
| Restrictions aux investissements     | Blocages dans des secteurs stratégiques (ex. énergie, numérique, défense) |
| Censure / contrôle de l’information  | Filtrage des contenus, surveillance des réseaux, lois de cybersécurité     |

---

## 🧮 Méthode de calcul

Chaque pilier est noté sur **100 points** via la moyenne de ses sous-indicateurs.

Exemple :
```
Pilier économique = (tarifaire + non-tarifaire + subventions + accords) / 4
```

---

## 🟨 Agrégation du score

L’indice global d’un pays est **le score médian des trois piliers**, et **non la moyenne**, afin de refléter la **tendance réelle** sans effet de compensation.

Exemple :

| Pilier        | Score |
|---------------|--------|
| Économie      | 46     |
| Migration     | 90     |
| Technologique | 40     |
| **Score médian** | **46** |

---

## 🚦 Niveaux d’alerte

| Score médian | Niveau d’alerte       | Interprétation générale                              |
|--------------|------------------------|------------------------------------------------------|
| 0 – 39       | 🟢 Ouverture forte      | Le pays est globalement ouvert aux échanges extérieurs |
| 40 – 69      | 🟡 Protectionnisme modéré | Comportement sélectif ou équilibré selon les axes     |
| 70 – 100     | 🔴 Protectionnisme affirmé | Politique largement fermée dans au moins deux piliers |

---

## 🗂 Structure des résultats dans l’interface

- **Carte interactive** : couleur selon le niveau d’alerte.
- **Détail par pays** :
  - Score par pilier (100 pts chacun)
  - Libellés descriptifs par sous-indicateur (facultatif)
  - Score médian global
  - Niveau d’alerte
- **Comparaison possible entre pays**
- **Historique possible (à venir)** : évolution de l’indice dans le temps

---

## 📌 Notes méthodologiques

- Toutes les sources doivent être transparentes et datées.
- Les sous-indicateurs sont mis à l’échelle 0–100 avec des seuils définis.
- Aucun indicateur n’est absolu : l’indice reflète une **lecture synthétique relative et contextualisée**.
