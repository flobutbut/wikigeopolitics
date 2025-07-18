// Script de test pour vérifier la connexion Supabase
// Usage: node test-supabase.js

const { createClient } = require('@supabase/supabase-js')

// Configuration (à remplacer par vos vraies valeurs)
const supabaseUrl = 'https://tiwrzklmwcqmetucrgib.supabase.co'
const supabaseKey = process.env.SUPABASE_ANON_KEY || 'votre_cle_ici'

console.log('🔍 Test de connexion Supabase...')
console.log('URL:', supabaseUrl)
console.log('Clé:', supabaseKey.substring(0, 20) + '...')

if (supabaseKey === 'votre_cle_ici') {
  console.log('❌ Veuillez définir votre clé Supabase :')
  console.log('export SUPABASE_ANON_KEY="votre_vraie_cle"')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseKey)

async function testConnection() {
  try {
    console.log('\n📊 Test de récupération des pays...')
    
    const { data, error } = await supabase
      .from('country')
      .select('id, nom, capitale')
      .limit(5)
    
    if (error) {
      console.error('❌ Erreur:', error.message)
      return
    }
    
    console.log('✅ Connexion réussie !')
    console.log(`📈 ${data.length} pays récupérés :`)
    
    data.forEach(country => {
      console.log(`  - ${country.nom} (${country.capitale})`)
    })
    
    // Test du nombre total
    const { count } = await supabase
      .from('country')
      .select('*', { count: 'exact', head: true })
    
    console.log(`\n📊 Total des pays dans la base : ${count}`)
    
  } catch (err) {
    console.error('❌ Erreur de connexion:', err.message)
  }
}

testConnection() 