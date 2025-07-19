// Script de test pour la recherche de pays - Version Node.js
const { createClient } = require('@supabase/supabase-js')

// Configuration Supabase (utiliser les mêmes valeurs que dans supabaseService.ts)
const supabaseUrl = 'https://yzxecnlsuvhitkjrsaes.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6eGVjbmxzdXZoaXRranJzYWVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0MDk3NjcsImV4cCI6MjA1Mjk4NTc2N30.DY6C8qKoMHWXGJ4rMTU0_jFc8-SBcgA9Zi8tn8xjhG0'

const supabase = createClient(supabaseUrl, supabaseKey)

console.log('🧪 Test de la recherche de pays...')

async function testCountrySearch() {
  try {
    console.log('📡 Test de connexion Supabase...')
    
    // Test de connexion basique
    const { data: testData, error: testError } = await supabase
      .from('country')
      .select('count')
      .limit(1)
    
    if (testError) {
      throw new Error(`Erreur de connexion: ${testError.message}`)
    }
    
    console.log('✅ Connexion Supabase réussie')
    
    // Test de récupération des pays avec régimes
    console.log('📡 Récupération des pays avec régimes...')
    const { data: countries, error } = await supabase
      .from('country')
      .select(`
        id,
        nom,
        population,
        drapeau
      `)
      .order('nom')
      .limit(10)
    
    if (error) {
      console.error('❌ Erreur lors de la récupération:', error)
      
      // Fallback: récupération basique
      console.log('🔄 Tentative de récupération basique...')
      const { data: basicCountries, error: basicError } = await supabase
        .from('country')
        .select('id, nom, population, drapeau')
        .limit(5)
      
      if (basicError) {
        throw new Error(`Erreur récupération basique: ${basicError.message}`)
      }
      
      console.log(`✅ ${basicCountries.length} pays récupérés (mode basique)`)
      basicCountries.forEach(country => {
        console.log(`  • ${country.nom} - ${country.population?.toLocaleString() || 'N/A'} hab.`)
      })
      
      return
    }
    
    console.log(`✅ ${countries.length} pays récupérés`)
    
    // Afficher quelques exemples
    const examples = countries.slice(0, 5)
    console.log('📋 Exemples:')
    examples.forEach(country => {
      console.log(`  • ${country.nom} - ${country.population?.toLocaleString() || 'N/A'} hab.`)
    })
    
    // Test de recherche
    console.log('\n🔍 Test de recherche pour "france":')
    const franceResults = countries.filter(c => 
      c.nom.toLowerCase().includes('france')
    )
    
    if (franceResults.length > 0) {
      franceResults.forEach(country => {
        console.log(`  ✓ ${country.nom} - ${country.population?.toLocaleString()} hab.`)
      })
    } else {
      console.log('  ⚠️ Aucun pays trouvé contenant "france"')
    }
    
    // Test de performance
    console.log('\n⚡ Test de performance...')
    const start = Date.now()
    const { data: perfTest } = await supabase
      .from('country')
      .select('id, nom')
      .ilike('nom', '%fr%')
      .limit(5)
    
    const duration = Date.now() - start
    console.log(`✅ Recherche en ${duration}ms - ${perfTest?.length || 0} résultats`)
    
  } catch (error) {
    console.error('❌ Erreur:', error.message)
    console.error('Stack:', error.stack)
  }
}

testCountrySearch()