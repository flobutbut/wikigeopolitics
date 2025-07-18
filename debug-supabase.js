// Script de debug pour vérifier les données Supabase
const { createClient } = require('@supabase/supabase-js')

const supabaseUrl = 'https://tiwrzklmwcqmetucrgib.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRpd3J6a2xtd2NxbWV0dWNyZ2liIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2MTMxMTMsImV4cCI6MjA2ODE4OTExM30.8gUo9JSjU6YTr0dcwmBjCpL4Uuzg7lfDKFXzNRzzd_E'

const supabase = createClient(supabaseUrl, supabaseKey)

async function debugData() {
  console.log('🔍 Debug des données Supabase...\n')
  
  try {
    // 1. Récupérer les données brutes
    console.log('📊 1. Données brutes de Supabase:')
    const { data: rawData, error } = await supabase
      .from('country')
      .select('*')
      .limit(3)
    
    if (error) {
      console.error('❌ Erreur:', error)
      return
    }
    
    console.log('✅ Données brutes récupérées:', rawData.length, 'pays')
    console.log('Premier pays brut:', rawData[0])
    console.log('')
    
    // 2. Simuler la transformation de l'API
    console.log('🔄 2. Transformation des données (comme dans countryAPI.ts):')
    const transformedData = rawData.map(country => ({
      id: country.id,
      title: country.nom,
      flag: country.drapeau,
      continent: country.continent,
      coordonnees: country.latitude && country.longitude ? [country.latitude, country.longitude] : undefined,
      drapeau: country.drapeau,
      capitale: country.capitale,
      population: country.population,
      superficieKm2: country.superficie,
      regimePolitique: country.regime_politique,
      chefEtat: country.chef_etat
    }))
    
    console.log('✅ Données transformées:', transformedData.length, 'pays')
    console.log('Premier pays transformé:', transformedData[0])
    console.log('')
    
    // 3. Vérifier les coordonnées
    console.log('📍 3. Vérification des coordonnées:')
    transformedData.forEach((country, index) => {
      console.log(`${index + 1}. ${country.title}:`)
      console.log(`   - coordonnees: ${JSON.stringify(country.coordonnees)}`)
      console.log(`   - flag: ${country.flag}`)
      console.log(`   - continent: ${country.continent}`)
    })
    console.log('')
    
    // 4. Compter les pays avec coordonnées
    const withCoords = transformedData.filter(c => c.coordonnees)
    const withoutCoords = transformedData.filter(c => !c.coordonnees)
    
    console.log('📈 4. Statistiques:')
    console.log(`   - Total: ${transformedData.length}`)
    console.log(`   - Avec coordonnées: ${withCoords.length}`)
    console.log(`   - Sans coordonnées: ${withoutCoords.length}`)
    
    if (withoutCoords.length > 0) {
      console.log('   - Pays sans coordonnées:', withoutCoords.map(c => c.title))
    }
    
  } catch (err) {
    console.error('❌ Erreur:', err)
  }
}

debugData() 