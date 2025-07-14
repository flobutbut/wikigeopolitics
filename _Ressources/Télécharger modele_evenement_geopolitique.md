
# Modèle de fiche d'événement géopolitique

Ce fichier définit un modèle structuré pour représenter un **événement géopolitique** dans une base de données ou une plateforme interactive. Il permet d'intégrer des actes isolés, symboliques, indirects ou majeurs, sans préjuger de leur interprétation.

---

## 🧩 Structure générale (YAML)

```yaml
id: string_unique
titre: "Résumé court de l'événement"
date: "YYYY-MM-DD"
categorie: "Catégorie principale" # Déclaration, Mesure économique, Opération indirecte, etc.
sous_categorie: "Précision facultative"
acteur_principal: "Nom de l’État ou entité initiatrice"
acteurs_concernes: ["Acteur 1", "Acteur 2"]
zone_concernee: "Région ou domaine d’impact (ex: mer de Chine, énergie)"
contexte: "Contexte ou enchaînement d’événements lié"
etat: "statut actuel (en cours, terminé, annulé, non suivi d’effet)"
impact_potentiel:
  - "Tension diplomatique"
  - "Réalignement régional"
  - "Effet sur marché"
sources:
  - type: "media / officiel / think tank / journalisme indépendant"
    auteur: "Nom"
    publication: "Nom du média"
    date: "YYYY-MM"
    fiabilité: "faible / modérée / élevée"
niveau_de_certitude: "officiel / présumé / rumeur"
évolution_possible: true/false
evenement_relie:
  - id_evenement_1
  - id_evenement_2
```

---

## 🎯 Liste des catégories principales recommandées

| Catégorie                 | Description                                                |
|--------------------------|------------------------------------------------------------|
| 📝 Déclaration politique  | Discours, menaces, annonces officielles                    |
| 📜 Décision stratégique   | Lois, traités, reconnaissances diplomatiques               |
| 💸 Mesure économique      | Sanctions, tarifs, embargos, aides conditionnées           |
| 🛰️ Opération indirecte    | Cyberattaque, sabotage, financement occulte                |
| 🤝 Accord / alliance      | Signature ou renouvellement d’accords                      |
| 🔥 Incident / provocation | Acte isolé ou volontaire (collision, attaque ponctuelle)   |
| 🧠 Opération d’influence  | Désinformation, lobbying international, propagande         |
| 🌪 Crise systémique       | Pandémie, catastrophe, effondrement institutionnel         |

---

## 📊 Dimensions d’analyse

- **Intention** : dissuasion, chantage, image, rupture...
- **Cible(s)** : autre État, organisation, population...
- **Portée** : locale / régionale / mondiale
- **Durée** : immédiate, latente, structurelle
- **Impact estimé** : faible / moyen / fort (par domaine)
- **Réversibilité** : réversible ou irréversible
- **Lien avec dynamiques existantes** : tournant ou continuité ?

---

## 🗂 Affichage dans la plateforme

Chaque événement peut être :
- Affiché dans une **timeline** ou une **carte contextuelle**
- Relié à des pays affectés
- Associé à des **indices géopolitiques** (souveraineté, protectionnisme, influence)
- Lié à d’autres événements ou tendances

---

## 📌 Bonnes pratiques

- Toujours sourcer avec **niveau de fiabilité**
- Séparer **faits** et **interprétations**
- Utiliser des termes neutres
- Réévaluer les événements en fonction de nouveaux éléments
