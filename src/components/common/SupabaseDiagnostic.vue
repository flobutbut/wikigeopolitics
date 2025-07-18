<template>
  <div class="supabase-diagnostic">
    <div class="diagnostic-header">
      <h3>🚀 Diagnostic Migration Supabase</h3>
      <button @click="runDiagnostic" :disabled="isRunning" class="refresh-button">
        <span v-if="isRunning">⏳</span>
        <span v-else>🔄</span>
        {{ isRunning ? 'Test en cours...' : 'Tester' }}
      </button>
    </div>

    <div class="diagnostic-content">
      <!-- Configuration -->
      <div class="diagnostic-section">
        <h4>⚙️ Configuration</h4>
        <div class="config-status">
          <div class="config-item" :class="{ success: config.supabaseUrl, error: !config.supabaseUrl }">
            <span class="status-icon">{{ config.supabaseUrl ? '✅' : '❌' }}</span>
            <span>VITE_SUPABASE_URL</span>
            <code v-if="config.supabaseUrl">{{ config.supabaseUrl }}</code>
            <span v-else class="error-text">Non configuré</span>
          </div>
          
          <div class="config-item" :class="{ success: config.supabaseKey, error: !config.supabaseKey }">
            <span class="status-icon">{{ config.supabaseKey ? '✅' : '❌' }}</span>
            <span>VITE_SUPABASE_ANON_KEY</span>
            <code v-if="config.supabaseKey">{{ config.supabaseKey.substring(0, 20) }}...</code>
            <span v-else class="error-text">Non configuré</span>
          </div>
          
          <div class="config-item" :class="{ success: config.useSupabase, warning: !config.useSupabase }">
            <span class="status-icon">{{ config.useSupabase ? '✅' : '⚠️' }}</span>
            <span>VITE_USE_SUPABASE</span>
            <code>{{ config.useSupabase ? 'true' : 'false' }}</code>
          </div>
        </div>
      </div>

      <!-- Connexion -->
      <div class="diagnostic-section">
        <h4>🔗 Test de connexion</h4>
        <div v-if="diagnosticResult" class="connection-status">
          <div class="status-item" :class="{ success: diagnosticResult.connection, error: !diagnosticResult.connection }">
            <span class="status-icon">{{ diagnosticResult.connection ? '✅' : '❌' }}</span>
            <span>Connexion Supabase</span>
            <span v-if="diagnosticResult.connection" class="success-text">Réussie</span>
            <span v-else class="error-text">Échec</span>
          </div>
          
          <div v-if="diagnosticResult.error" class="error-details">
            <strong>Erreur :</strong>
            <code>{{ diagnosticResult.error }}</code>
          </div>
        </div>
      </div>

      <!-- Données -->
      <div v-if="diagnosticResult && diagnosticResult.stats" class="diagnostic-section">
        <h4>📊 Données disponibles</h4>
        <div class="stats-grid">
          <div class="stat-item">
            <span class="stat-number">{{ diagnosticResult.stats.countries || 0 }}</span>
            <span class="stat-label">Pays</span>
          </div>
          <div class="stat-item">
            <span class="stat-number">{{ diagnosticResult.stats.politicalRegimes || 0 }}</span>
            <span class="stat-label">Régimes</span>
          </div>
          <div class="stat-item">
            <span class="stat-number">{{ diagnosticResult.stats.organizations || 0 }}</span>
            <span class="stat-label">Organisations</span>
          </div>
          <div class="stat-item">
            <span class="stat-number">{{ diagnosticResult.stats.armedConflicts || 0 }}</span>
            <span class="stat-label">Conflits</span>
          </div>
        </div>
      </div>

      <!-- Service adaptatif -->
      <div class="diagnostic-section">
        <h4>🔄 Service adaptatif</h4>
        <div class="service-status">
          <div class="service-item">
            <span class="label">Mode actuel :</span>
            <span class="badge" :class="serviceStatus.mode">{{ serviceStatus.mode }}</span>
          </div>
          <div class="service-item">
            <span class="label">Supabase activé :</span>
            <span class="badge" :class="{ success: serviceStatus.useSupabase, error: !serviceStatus.useSupabase }">
              {{ serviceStatus.useSupabase ? 'Oui' : 'Non' }}
            </span>
          </div>
          <div class="service-item">
            <span class="label">API locale activée :</span>
            <span class="badge" :class="{ success: serviceStatus.useLocalApi, error: !serviceStatus.useLocalApi }">
              {{ serviceStatus.useLocalApi ? 'Oui' : 'Non' }}
            </span>
          </div>
        </div>
      </div>

      <!-- Instructions -->
      <div v-if="!config.supabaseUrl || !config.supabaseKey" class="diagnostic-section">
        <h4>📋 Configuration requise</h4>
        <div class="instructions">
          <ol>
            <li>Créez un fichier <code>.env.local</code> à la racine du projet</li>
            <li>Copiez le contenu de <code>.env.local.example</code></li>
            <li>Remplissez vos informations Supabase depuis le dashboard</li>
            <li>Redémarrez le serveur de développement</li>
          </ol>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import AdaptiveApiService from '@/services/adaptiveApiService'

// État réactif
const isRunning = ref(false)
const diagnosticResult = ref<any>(null)

// Configuration
const config = reactive({
  supabaseUrl: import.meta.env.VITE_SUPABASE_URL || '',
  supabaseKey: import.meta.env.VITE_SUPABASE_ANON_KEY || '',
  useSupabase: import.meta.env.VITE_USE_SUPABASE === 'true'
})

// Service status
const serviceStatus = reactive(AdaptiveApiService.getServiceStatus())

// Exécuter le diagnostic
const runDiagnostic = async () => {
  isRunning.value = true
  diagnosticResult.value = null
  
  try {
    // Test de connexion
    const connection = await AdaptiveApiService.testSupabaseConnection()
    
    let stats = null
    let error = null
    
    if (connection) {
      try {
        // Si la connexion fonctionne, récupérer les stats
        const SupabaseService = await import('@/services/supabaseService')
        stats = await SupabaseService.default.getGlobalStats()
      } catch (statsError) {
        console.warn('Erreur récupération stats:', statsError)
        error = `Erreur récupération stats: ${statsError}`
      }
    } else {
      error = 'Impossible de se connecter à Supabase'
    }
    
    diagnosticResult.value = {
      connection,
      stats,
      error,
      timestamp: new Date().toLocaleTimeString()
    }
    
  } catch (globalError) {
    diagnosticResult.value = {
      connection: false,
      error: `Erreur globale: ${globalError}`,
      timestamp: new Date().toLocaleTimeString()
    }
  } finally {
    isRunning.value = false
  }
}

// Test automatique au montage
onMounted(() => {
  if (config.supabaseUrl && config.supabaseKey) {
    runDiagnostic()
  }
})
</script>

<style scoped>
.supabase-diagnostic {
  background: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: var(--spacing-lg);
  margin: var(--spacing-md) 0;
  font-family: var(--font-family-mono, monospace);
}

.diagnostic-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-lg);
  padding-bottom: var(--spacing-md);
  border-bottom: 1px solid var(--border-color);
}

.diagnostic-header h3 {
  margin: 0;
  color: var(--primary-color);
}

.refresh-button {
  background: var(--primary-color);
  color: white;
  border: none;
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm) var(--spacing-md);
  cursor: pointer;
  transition: opacity 0.2s;
}

.refresh-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.diagnostic-section {
  margin-bottom: var(--spacing-lg);
}

.diagnostic-section h4 {
  margin: 0 0 var(--spacing-md) 0;
  color: var(--text-color);
  font-size: var(--font-size-lg);
}

.config-status, .connection-status {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.config-item, .status-item {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  padding: var(--spacing-sm);
  border-radius: var(--radius-sm);
  background: var(--surface-dimmed);
}

.config-item.success, .status-item.success {
  border-left: 3px solid #22c55e;
}

.config-item.error, .status-item.error {
  border-left: 3px solid #ef4444;
}

.config-item.warning {
  border-left: 3px solid #f59e0b;
}

.status-icon {
  font-size: var(--font-size-lg);
}

.success-text {
  color: #22c55e;
  font-weight: var(--font-weight-medium);
}

.error-text {
  color: #ef4444;
  font-weight: var(--font-weight-medium);
}

.error-details {
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: var(--radius-sm);
  padding: var(--spacing-sm);
  margin-top: var(--spacing-sm);
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: var(--spacing-md);
}

.stat-item {
  background: var(--surface-dimmed);
  border-radius: var(--radius-sm);
  padding: var(--spacing-md);
  text-align: center;
}

.stat-number {
  display: block;
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-bold);
  color: var(--primary-color);
}

.stat-label {
  display: block;
  font-size: var(--font-size-sm);
  color: var(--text-muted);
  margin-top: var(--spacing-xs);
}

.service-status {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.service-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-sm);
  background: var(--surface-dimmed);
  border-radius: var(--radius-sm);
}

.label {
  font-weight: var(--font-weight-medium);
}

.badge {
  padding: var(--spacing-xs) var(--spacing-sm);
  border-radius: var(--radius-xs);
  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-medium);
  text-transform: uppercase;
}

.badge.success {
  background: #dcfce7;
  color: #16a34a;
}

.badge.error {
  background: #fef2f2;
  color: #dc2626;
}

.badge.supabase {
  background: #dbeafe;
  color: #2563eb;
}

.badge.local {
  background: #f3e8ff;
  color: #7c3aed;
}

.badge.double {
  background: #fef3c7;
  color: #d97706;
}

.instructions {
  background: #fffbeb;
  border: 1px solid #fed7aa;
  border-radius: var(--radius-sm);
  padding: var(--spacing-md);
}

.instructions ol {
  margin: 0;
  padding-left: var(--spacing-lg);
}

.instructions li {
  margin-bottom: var(--spacing-xs);
}

code {
  background: var(--surface-dimmed);
  padding: 2px 4px;
  border-radius: var(--radius-xs);
  font-family: var(--font-family-mono, monospace);
  font-size: var(--font-size-sm);
}
</style>