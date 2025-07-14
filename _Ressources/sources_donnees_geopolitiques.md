# Sources de données pour application géopolitique

Ce document liste les sources fiables disposant d'une API (ou équivalent) pour récupérer des données pertinentes sur les pays, les régimes politiques, l’économie, les conflits, etc.

---

## 🌍 Données générales sur les pays

| Source | Données disponibles | Accès | Lien |
|--------|---------------------|-------|------|
| **REST Countries** | Drapeau, code ISO, capitale, population, langues, monnaie, etc. | API REST | [restcountries.com](https://restcountries.com/) |
| **GeoNames** | Géolocalisation, frontières, capitales, population | API (clé gratuite) | [geonames.org](https://www.geonames.org/export/web-services.html) |
| **GADM / Natural Earth / OSM** | Frontières administratives, shapefiles, entités géographiques | Fichiers ou API (via OSM) | [gadm.org](https://gadm.org), [naturalearthdata.com](https://www.naturalearthdata.com), [OSM API](https://wiki.openstreetmap.org/wiki/API) |

---

## 🏛 Régimes politiques & institutions

| Source | Données disponibles | Accès | Lien |
|--------|---------------------|-------|------|
| **Freedom House** | Libertés politiques, types de régimes, indices de démocratie | Pas d’API publique, données téléchargeables | [freedomhouse.org](https://freedomhouse.org/data) |
| **Polity Project** | Type de régime (autoritaire, démocratie, etc.), indicateurs politiques | Données téléchargeables | [systemicpeace.org](https://www.systemicpeace.org/inscr/p5manualv2018.pdf) |
| **V-Dem** | Indicateurs très détaillés sur les régimes politiques | Données téléchargeables (inscription requise) | [v-dem.net](https://www.v-dem.net/) |

---

## 🌐 Relations internationales, alliances, organisations

| Source | Données disponibles | Accès | Lien |
|--------|---------------------|-------|------|
| **WTO API** | Accords commerciaux, membres | API publique avec clé | [apiportal.wto.org](https://apiportal.wto.org/) |
| **UN Comtrade** | Données de commerce bilatéral entre pays | API REST | [comtrade.un.org](https://comtrade.un.org/data/doc/api/) |
| **International Crisis Group** | Conflits, tensions diplomatiques | Pas d’API, données dans les rapports | [crisisgroup.org](https://www.crisisgroup.org/) |

---

## 💥 Conflits armés et sécurité

| Source | Données disponibles | Accès | Lien |
|--------|---------------------|-------|------|
| **ACLED** | Données géolocalisées sur les événements violents et conflits | API REST sur demande | [acleddata.com](https://acleddata.com/data-export-tool/) |
| **UCDP** | Données sur les conflits armés, acteurs, décès | Téléchargement CSV | [ucdp.uu.se](https://ucdp.uu.se/downloads/) |
| **Global Terrorism Database (GTD)** | Attentats, groupes terroristes | CSV téléchargeables | [start.umd.edu](https://www.start.umd.edu/gtd/) |

---

## 📊 Économie, commerce et ressources

| Source | Données disponibles | Accès | Lien |
|--------|---------------------|-------|------|
| **Banque Mondiale** | PIB, dette, commerce, agriculture, énergie | API REST | [worldbank.org](https://datahelpdesk.worldbank.org/knowledgebase/articles/889392) |
| **FAO API** | Agriculture, pêche, ressources alimentaires | API REST | [apps.fao.org](https://data.apps.fao.org/api/) |
| **IMF API** | Indicateurs macroéconomiques | API REST | [data.imf.org](https://data.imf.org/) |
| **IEA** | Production/consommation d’énergie | API payante ou CSV | [iea.org](https://www.iea.org/data-and-statistics) |

---

## 🛰 Technologie, spatial, cybersécurité

| Source | Données disponibles | Accès | Lien |
|--------|---------------------|-------|------|
| **ITU** | Infrastructures numériques, accès à internet | Téléchargement CSV | [itu.int](https://www.itu.int/en/ITU-D/Statistics/Pages/stat/default.aspx) |
| **NASA Open Data** | Programmes spatiaux, satellites | API REST | [api.nasa.gov](https://api.nasa.gov/) |
| **Celestrak / NORAD / Space-Track** | Données satellites, orbites | API REST (souvent sur demande) | [celestrak.org](https://celestrak.org/), [space-track.org](https://www.space-track.org/) |

---

## 👥 Démographie et société

| Source | Données disponibles | Accès | Lien |
|--------|---------------------|-------|------|
| **UN Data** | Population, croissance, migration | API REST limitée, CSV | [data.un.org](https://data.un.org/) |
| **UNHCR API** | Réfugiés, déplacés, migrations forcées | API publique avec clé | [data.unhcr.org](https://data.unhcr.org/en/dataviz) |
| **OECD API** | Éducation, démographie, société | API REST | [data.oecd.org](https://data.oecd.org/api/sdmx-json-documentation/) |
