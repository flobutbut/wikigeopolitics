<template>
  <div class="resource-detail-view">
    <!-- Informations principales -->
    <DetailSection
      :sections="[
        { title: 'Type de ressource', value: data.type || 'Non spécifié' },
        { title: 'Catégorie', value: data.categorie || 'Non spécifiée' },
        { title: 'État des réserves', value: formatReserveStatus(data.etatReserves) },
        { title: 'Rareté', value: formatRarity(data.rarete) }
      ]"
    />

    <!-- Informations géographiques -->
    <DetailSection
      :sections="[
        { title: 'Localisation principale', value: data.localisationPrincipale || 'Non spécifiée' },
        { title: 'Zones d\'extraction', value: formatZones(data.zonesExtraction) }
      ].filter(section => section.value && section.value !== 'Non spécifiée')"
    />

    <!-- Description -->
    <CollapsibleSection
      title="Description"
      :expanded="descriptionExpanded"
      @toggle="toggleDescription"
    >
      <div class="description-content">
        {{ data.description || 'Aucune description disponible.' }}
      </div>
    </CollapsibleSection>

    <!-- Réserves mondiales -->
    <CollapsibleSection
      title="Réserves Mondiales"
      :expanded="reservesExpanded"
      @toggle="toggleReserves"
    >
      <div v-if="data.reservesMondiales" class="reserves-info">
        <div v-if="data.reservesMondiales.total" class="reserve-stat">
          <span class="stat-label">Total mondial:</span>
          <span class="stat-value">{{ formatQuantity(data.reservesMondiales.total, data.unite) }}</span>
        </div>
        
        <div v-if="data.reservesMondiales.principauxGisements && data.reservesMondiales.principauxGisements.length > 0" class="deposits-section">
          <h4 class="section-title">Principaux gisements</h4>
          <div class="deposits-list">
            <div v-for="gisement in data.reservesMondiales.principauxGisements" :key="gisement.id" class="deposit-item">
              <div class="deposit-location">
                <span v-if="gisement.pays?.flag">{{ gisement.pays.flag }}</span>
                {{ gisement.localisation }}
              </div>
              <div v-if="gisement.quantite" class="deposit-quantity">
                {{ formatQuantity(gisement.quantite, data.unite) }}
              </div>
              <div v-if="gisement.pourcentageMondial" class="deposit-percentage">
                {{ gisement.pourcentageMondial.toFixed(1) }}% des réserves mondiales
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune information sur les réserves disponible.
      </div>
    </CollapsibleSection>

    <!-- Production mondiale -->
    <CollapsibleSection
      title="Production Mondiale"
      :expanded="productionExpanded"
      @toggle="toggleProduction"
    >
      <div v-if="data.productionMondiale" class="production-info">
        <div v-if="data.productionMondiale.annuelle" class="production-stat">
          <span class="stat-label">Production annuelle:</span>
          <span class="stat-value">{{ formatQuantity(data.productionMondiale.annuelle, data.unite) }}</span>
        </div>
        
        <div v-if="data.productionMondiale.principauxProducteurs && data.productionMondiale.principauxProducteurs.length > 0" class="producers-section">
          <h4 class="section-title">Principaux producteurs</h4>
          <div class="producers-list">
            <div v-for="producteur in data.productionMondiale.principauxProducteurs" :key="producteur.id" class="producer-item">
              <div class="producer-country">
                <span v-if="producteur.flag">{{ producteur.flag }}</span>
                {{ producteur.nom }}
              </div>
              <div v-if="producteur.production" class="producer-output">
                {{ formatQuantity(producteur.production, data.unite) }}/an
              </div>
              <div v-if="producteur.pourcentageMondial" class="producer-percentage">
                {{ producteur.pourcentageMondial.toFixed(1) }}% de la production mondiale
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune information sur la production disponible.
      </div>
    </CollapsibleSection>

    <!-- Usages et applications -->
    <CollapsibleSection
      title="Usages et Applications"
      :expanded="usagesExpanded"
      @toggle="toggleUsages"
    >
      <div v-if="data.usages && data.usages.length > 0" class="usages-list">
        <div v-for="usage in data.usages" :key="usage.domaine" class="usage-item">
          <div class="usage-domain">{{ usage.domaine }}</div>
          <div v-if="usage.description" class="usage-description">{{ usage.description }}</div>
          <div v-if="usage.pourcentageUtilisation" class="usage-percentage">
            {{ usage.pourcentageUtilisation.toFixed(1) }}% de l'utilisation mondiale
          </div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucun usage documenté.
      </div>
    </CollapsibleSection>

    <!-- Prix et marché -->
    <CollapsibleSection
      title="Prix et Marché"
      :expanded="marketExpanded"
      @toggle="toggleMarket"
    >
      <div v-if="data.marche" class="market-info">
        <div v-if="data.marche.prixActuel" class="price-info">
          <span class="price-label">Prix actuel:</span>
          <span class="price-value">{{ formatPrice(data.marche.prixActuel, data.marche.deviseReference) }}</span>
        </div>
        
        <div v-if="data.marche.volatilite" class="volatility-info">
          <span class="volatility-label">Volatilité:</span>
          <span class="volatility-value" :class="getVolatilityClass(data.marche.volatilite)">
            {{ formatVolatility(data.marche.volatilite) }}
          </span>
        </div>
        
        <div v-if="data.marche.principauxExportateurs && data.marche.principauxExportateurs.length > 0" class="exporters-section">
          <h4 class="section-title">Principaux exportateurs</h4>
          <div class="exporters-list">
            <div v-for="exportateur in data.marche.principauxExportateurs" :key="exportateur.id" class="exporter-item">
              <span v-if="exportateur.flag">{{ exportateur.flag }}</span>
              {{ exportateur.nom }}
              <span v-if="exportateur.partMarche" class="market-share">
                ({{ exportateur.partMarche.toFixed(1) }}%)
              </span>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune information de marché disponible.
      </div>
    </CollapsibleSection>

    <!-- Impact environnemental -->
    <CollapsibleSection
      title="Impact Environnemental"
      :expanded="environmentExpanded"
      @toggle="toggleEnvironment"
    >
      <div v-if="data.impactEnvironnemental" class="environment-info">
        <div v-if="data.impactEnvironnemental.emissionsCO2" class="impact-stat">
          <span class="stat-label">Émissions CO₂:</span>
          <span class="stat-value">{{ data.impactEnvironnemental.emissionsCO2 }} kg CO₂/unité</span>
        </div>
        
        <div v-if="data.impactEnvironnemental.risques && data.impactEnvironnemental.risques.length > 0" class="risks-section">
          <h4 class="section-title">Risques environnementaux</h4>
          <div class="risks-list">
            <div v-for="risque in data.impactEnvironnemental.risques" :key="risque" class="risk-item">
              <span class="risk-bullet">⚠️</span>
              <span class="risk-text">{{ risque }}</span>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="no-data">
        Aucune information environnementale disponible.
      </div>
    </CollapsibleSection>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import DetailSection from '@/components/aside/DetailSection.vue'
import CollapsibleSection from '@/components/aside/CollapsibleSection.vue'

interface ResourceData {
  id: string
  title: string
  type?: string
  categorie?: string
  etatReserves?: 'abondant' | 'limite' | 'rare' | 'critique'
  rarete?: 'commun' | 'peu_commun' | 'rare' | 'tres_rare'
  localisationPrincipale?: string
  zonesExtraction?: string[]
  description?: string
  unite?: string
  reservesMondiales?: {
    total?: number
    principauxGisements?: Array<{
      id: string
      localisation: string
      pays?: { flag?: string }
      quantite?: number
      pourcentageMondial?: number
    }>
  }
  productionMondiale?: {
    annuelle?: number
    principauxProducteurs?: Array<{
      id: string
      nom: string
      flag?: string
      production?: number
      pourcentageMondial?: number
    }>
  }
  usages?: Array<{
    domaine: string
    description?: string
    pourcentageUtilisation?: number
  }>
  marche?: {
    prixActuel?: number
    deviseReference?: string
    volatilite?: 'faible' | 'moyenne' | 'forte' | 'extreme'
    principauxExportateurs?: Array<{
      id: string
      nom: string
      flag?: string
      partMarche?: number
    }>
  }
  impactEnvironnemental?: {
    emissionsCO2?: number
    risques?: string[]
  }
}

defineProps<{
  data: ResourceData
}>()

// États des sections collapsibles
const descriptionExpanded = ref(true)
const reservesExpanded = ref(true)
const productionExpanded = ref(false)
const usagesExpanded = ref(false)
const marketExpanded = ref(false)
const environmentExpanded = ref(false)

// Fonctions de toggle
const toggleDescription = () => { descriptionExpanded.value = !descriptionExpanded.value }
const toggleReserves = () => { reservesExpanded.value = !reservesExpanded.value }
const toggleProduction = () => { productionExpanded.value = !productionExpanded.value }
const toggleUsages = () => { usagesExpanded.value = !usagesExpanded.value }
const toggleMarket = () => { marketExpanded.value = !marketExpanded.value }
const toggleEnvironment = () => { environmentExpanded.value = !environmentExpanded.value }

// Fonctions de formatage
const formatReserveStatus = (status?: string) => {
  if (!status) return 'Non spécifié'
  const statusMap: Record<string, string> = {
    'abondant': '🟢 Abondant',
    'limite': '🟡 Limité',
    'rare': '🟠 Rare',
    'critique': '🔴 Critique'
  }
  return statusMap[status] || status
}

const formatRarity = (rarity?: string) => {
  if (!rarity) return 'Non spécifiée'
  const rarityMap: Record<string, string> = {
    'commun': 'Commun',
    'peu_commun': 'Peu commun',
    'rare': 'Rare',
    'tres_rare': 'Très rare'
  }
  return rarityMap[rarity] || rarity
}

const formatZones = (zones?: string[]) => {
  if (!zones || zones.length === 0) return undefined
  return zones.join(', ')
}

const formatQuantity = (quantity?: number, unit?: string) => {
  if (!quantity) return 'Non spécifié'
  if (quantity >= 1e9) {
    return `${(quantity / 1e9).toFixed(1)} milliards ${unit || 'unités'}`
  } else if (quantity >= 1e6) {
    return `${(quantity / 1e6).toFixed(1)} millions ${unit || 'unités'}`
  } else {
    return `${quantity.toLocaleString('fr-FR')} ${unit || 'unités'}`
  }
}

const formatPrice = (price?: number, currency?: string) => {
  if (!price) return 'Non spécifié'
  return `${price.toLocaleString('fr-FR')} ${currency || '€'}`
}

const formatVolatility = (volatility?: string) => {
  if (!volatility) return 'Non spécifiée'
  const volatilityMap: Record<string, string> = {
    'faible': 'Faible',
    'moyenne': 'Moyenne',
    'forte': 'Forte',
    'extreme': 'Extrême'
  }
  return volatilityMap[volatility] || volatility
}

const getVolatilityClass = (volatility?: string) => {
  if (!volatility) return ''
  const classMap: Record<string, string> = {
    'faible': 'volatility-low',
    'moyenne': 'volatility-medium',
    'forte': 'volatility-high',
    'extreme': 'volatility-extreme'
  }
  return classMap[volatility] || ''
}
</script>

<style scoped>
.resource-detail-view {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-md);
}

.description-content {
  line-height: 1.6;
  color: var(--text-dark);
}

.reserves-info, .production-info, .market-info, .environment-info {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.reserve-stat, .production-stat, .impact-stat {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-xs) var(--spacing-sm);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
}

.stat-label, .price-label, .volatility-label {
  font-weight: var(--font-weight-medium);
  color: var(--text-dark);
}

.stat-value, .price-value {
  font-weight: var(--font-weight-bold);
  color: var(--text-muted);
}

.section-title {
  margin: 0 0 var(--spacing-sm) 0;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-bold);
  color: var(--primary-color);
}

.deposits-section, .producers-section, .exporters-section, .risks-section {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
}

.deposits-list, .producers-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.deposit-item, .producer-item {
  background-color: var(--surface-color);
  border-radius: var(--radius-xs);
  padding: var(--spacing-xs);
  border-left: 3px solid var(--primary-color);
}

.deposit-location, .producer-country {
  font-weight: var(--font-weight-medium);
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
}

.deposit-quantity, .producer-output {
  font-size: var(--font-size-sm);
  color: var(--text-muted);
  margin-top: var(--spacing-xs);
}

.deposit-percentage, .producer-percentage {
  font-size: var(--font-size-xs);
  color: var(--text-muted);
  font-style: italic;
  margin-top: var(--spacing-xs);
}

.usages-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.usage-item {
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
  border-left: 3px solid var(--primary-color);
}

.usage-domain {
  font-weight: var(--font-weight-medium);
  color: var(--primary-color);
}

.usage-description {
  margin-top: var(--spacing-xs);
  line-height: 1.5;
  color: var(--text-dark);
}

.usage-percentage {
  margin-top: var(--spacing-xs);
  font-size: var(--font-size-sm);
  color: var(--text-muted);
  font-style: italic;
}

.price-info, .volatility-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-xs) var(--spacing-sm);
  background-color: var(--surface-dimmed);
  border-radius: var(--radius-sm);
}

.volatility-value {
  font-weight: var(--font-weight-bold);
}

.volatility-low { color: #22c55e; }
.volatility-medium { color: #f59e0b; }
.volatility-high { color: #ef4444; }
.volatility-extreme { color: #dc2626; }

.exporters-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.exporter-item {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
  padding: var(--spacing-xs);
  background-color: var(--surface-color);
  border-radius: var(--radius-xs);
}

.market-share {
  color: var(--text-muted);
  font-size: var(--font-size-sm);
}

.risks-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.risk-item {
  display: flex;
  align-items: flex-start;
  gap: var(--spacing-sm);
  padding: var(--spacing-xs) 0;
}

.risk-bullet {
  margin-top: 2px;
}

.risk-text {
  flex: 1;
  line-height: 1.5;
}

.no-data {
  padding: var(--spacing-sm);
  color: var(--text-muted);
  font-style: italic;
  text-align: center;
}
</style>