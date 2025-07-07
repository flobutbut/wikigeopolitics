erDiagram
  COUNTRY ||--o{ COUNTRY_ORGANIZATION : membre
  COUNTRY ||--o{ RELATION_COUNTRY : impliqué
  COUNTRY ||--o{ CONFLICT_COUNTRY : impliqué
  COUNTRY ||--o{ RESOURCE_COUNTRY : lié
  COUNTRY ||--o{ INDUSTRY_COUNTRY : acteur
  COUNTRY ||--o{ TRADE_ROUTE_COUNTRY : acteur
  COUNTRY ||--o{ COMM_NETWORK_COUNTRY : acteur
  COUNTRY ||--o{ DEMOGRAPHIC : a
  ORGANIZATION ||--o{ COUNTRY_ORGANIZATION : membre
  ORGANIZATION ||--o{ RELATION : sponsorise
  CONFLICT ||--o{ CONFLICT_COUNTRY : participants
  CONFLICT }o--|| RESOURCE : enjeu
  CONFLICT }o--|| TRADE_ROUTE : enjeu
  RESOURCE ||--o{ RESOURCE_COUNTRY : implication
  RESOURCE ||--o{ TRADE_ROUTE : transporte
  INDUSTRY ||--o{ INDUSTRY_COUNTRY : présence
  INDUSTRY ||--o{ COMPANY : contient
  TRADE_ROUTE ||--o{ TRADE_ROUTE_COUNTRY : usage
  COMM_NETWORK ||--o{ COMM_NETWORK_COUNTRY : couverture

  COUNTRY {
    string id
    string nom
    string drapeau
    string capitale
    string langue
    string monnaie
    string continent
    float pib
    int population
    float revenuMedian
    float superficieKm2
    string regimePolitique
    string appartenanceGeographique
    geo coordonnees
    string histoire
    float indiceSouverainete
    float indiceDependance
    string statutStrategique
    date dateCreation
    date dateDerniereMiseAJour
  }

  ORGANIZATION {
    string id
    string nom
    string type
    string description
    date dateCreation
    string siege
  }

  COUNTRY_ORGANIZATION {
    string countryId
    string organizationId
    string role
    date dateAdhesion
    date dateSortie
  }

  RELATION {
    string id
    string nom
    string type
    string description
    date dateDebut
    date dateFin
    string statut
  }

  RELATION_COUNTRY {
    string relationId
    string countryId
    string statut
    date dateAdhesion
    date dateSortie
  }

  CONFLICT {
    string id
    string nom
    string type
    string statut
    date dateDebut
    date dateFin
    string intensite
    geo localisation
    object victimes
    object timeline
    object effortsPaix
    object consequences
  }

  CONFLICT_COUNTRY {
    string conflictId
    string countryId
    string role
    date dateEntree
    date dateSortie
  }

  RESOURCE {
    string id
    string nom
    string categorie
    string description
    object reservesMondiales
    object usages
    string impactEnvironnemental
    string enjeuxGeopolitiques
  }

  RESOURCE_COUNTRY {
    string resourceId
    string countryId
    string role
    float quantite
    string unite
  }

  INDUSTRY {
    string id
    string nom
    string categorie
    string description
    object productionMondiale
    object tendances
    object chaineApprovisionnement
  }

  INDUSTRY_COUNTRY {
    string industryId
    string countryId
    string role
    float valeurAjoutee
    string unite
    date annee
  }

  COMPANY {
    string id
    string nom
    string pays
    string secteur
    object indicateurs
  }

  TRADE_ROUTE {
    string id
    string nom
    string type
    object endpoints
    object volume
    object biensTransportes
    object chokepoints
    object ports
    geo geoJsonRef
  }

  TRADE_ROUTE_COUNTRY {
    string tradeRouteId
    string countryId
    string role
  }

  COMM_NETWORK {
    string id
    string nom
    string type
    string description
    date dateMiseEnService
    object acteurs
    object capacite
    geo geoJsonRef
  }

  COMM_NETWORK_COUNTRY {
    string commNetworkId
    string countryId
    string role
    string statut
  }

  DEMOGRAPHIC {
    string id
    string pays
    object population
    object tendances
    object indicateursSociaux
  }