// 🚀 Service Supabase pour WikiGeopolitics
// Remplace l'API service existant pour utiliser Supabase

import { createClient } from '@supabase/supabase-js'

// Configuration Supabase
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL as string
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY as string

if (!supabaseUrl || !supabaseKey) {
  throw new Error('Configuration Supabase manquante. Vérifiez vos variables d\'environnement.')
}

export const supabase = createClient(supabaseUrl, supabaseKey)

// Types pour la compatibilité avec l'API existante
export interface Country {
  id: string
  nom: string
  capitale: string
  population: number
  superficie: number
  latitude: number
  longitude: number
  drapeau: string
  regime_politique: string
  continent: string
  chef_etat: string
}

export interface Organization {
  id: string
  nom: string
  acronyme: string
  type: string
  description: string
  date_creation: string
  siege: string
}

export interface PoliticalRegime {
  id: string
  nom: string
  description: string
  caracteristiques: string[]
}

export interface ArmedConflict {
  id: string
  nom: string
  description: string
  date_debut: string
  date_fin: string
  type: string
  intensite: string
  pays_impliques: string[]
  epicenter?: {
    coordinates: [number, number]
    type: string
  }
  statut?: string
  impact_geopolitique?: string
  annee_debut?: number
  annee_fin?: number
}

// Service Supabase avec les mêmes méthodes que l'API locale
export const supabaseService = {
  // Récupérer tous les pays
  async getCountries(): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .order('nom')
    
    if (error) throw error
    return data || []
  },

  // Récupérer tous les pays avec leurs régimes politiques (optimisé pour la recherche)
  async getCountriesWithRegimes(): Promise<any[]> {
    try {
      // Récupérer tous les pays
      const { data: countries, error: countryError } = await supabase
        .from('country')
        .select('id, nom, population, drapeau')
        .order('nom')
      
      if (countryError) throw countryError
      if (!countries) return []

      // Récupérer tous les régimes politiques actuels en une seule requête
      const { data: regimes, error: regimeError } = await supabase
        .from('country_political_regime')
        .select(`
          country_id,
          political_regime:regime_id(name)
        `)
        .eq('current_regime', true)
      
      if (regimeError) {
        console.warn('Erreur récupération régimes politiques:', regimeError)
      }

      // Créer un map pour accès rapide aux régimes
      const regimeMap = new Map()
      if (regimes) {
        regimes.forEach(regime => {
          regimeMap.set(regime.country_id, regime.political_regime?.name || 'Non spécifié')
        })
      }

      // Combiner pays et régimes
      return countries.map(country => ({
        id: country.id,
        nom: country.nom,
        population: country.population,
        drapeau: country.drapeau,
        regimePolitique: regimeMap.get(country.id) || 'Non spécifié'
      }))
      
    } catch (error) {
      console.error('Erreur dans getCountriesWithRegimes:', error)
      // Fallback : récupérer au moins les pays sans régimes
      const { data: countries } = await supabase
        .from('country')
        .select('id, nom, population, drapeau')
        .order('nom')
      
      return (countries || []).map(country => ({
        id: country.id,
        nom: country.nom,
        population: country.population,
        drapeau: country.drapeau,
        regimePolitique: 'Non spécifié'
      }))
    }
  },

  // Récupérer un pays par ID avec toutes les données pour floating panel
  async getCountryById(id: string): Promise<any | null> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .eq('id', id)
      .single()
    
    if (error) throw error
    
    if (!data) return null

    // Récupérer le régime politique ET le dirigeant depuis la table country_political_regime
    const { data: regimeData } = await supabase
      .from('country_political_regime')
      .select('political_regime:regime_id(name), chef_etat, date_prise_poste')
      .eq('country_id', id)
      .eq('current_regime', true)
      .single()
    
    
    // Récupérer le chef d'état depuis la table country_political_regime
    const chef_etat = regimeData?.chef_etat || 'Non spécifié'
    const datePrisePoste = regimeData?.date_prise_poste || 'Non spécifiée'

    // Récupérer les conflits armés du pays
    const conflitsArmes = await this.getConflictsByCountry(id)
    
    // Récupérer les organisations du pays
    const organisations = await this.getOrganizationsByCountry(id)
    
    // Mapper les données vers l'interface attendue pour les floating panels
    return {
      id: data.id,
      nom: data.nom,
      capitale: data.capitale,
      langue: data.langue,
      monnaie: data.monnaie,
      population: data.population,
      superficie: data.superficiekm2 || data.superficie,
      pib: data.pib,
      revenuMedian: data.revenumedian,
      coordonnees: data.coordonnees,
      drapeau: data.drapeau,
      regime_politique: regimeData?.political_regime?.name || 'Non spécifié',
      continent: data.continent,
      chef_etat: chef_etat,
      datePrisePoste: datePrisePoste,
      formeEtat: regimeData?.political_regime?.name || 'Non spécifiée',
      histoire: data.histoire,
      indiceSouverainete: data.indicesouverainete,
      indiceDependance: data.indicedependance,
      statutStrategique: data.statutstrategique,
      dateCreation: data.datecreation,
      dateDerniereMiseAJour: data.datedernieremiseajour,
      appartenanceGeographique: data.appartenancegeographique,
      
      // Données complexes
      sections: data.sections || [],
      indicateurs: data.indicateurs || {},
      politique: data.politique || {},
      economie: data.economie || {},
      demographie: data.demographie || {},
      frontieres: data.frontieres || {},
      
      // Données relationnelles - conflitsArmes vient déjà de getConflictsByCountry() avec le bon mapping
      conflitsArmes: conflitsArmes,
      
      coalitions: organisations.filter(org => 
        org.type === 'Coalition' || 
        org.type === 'Alliance' || 
        org.type === 'Union' ||
        org.type === 'Bloc' ||
        org.type?.toLowerCase().includes('coalition') ||
        org.type?.toLowerCase().includes('alliance')
      ).map(org => ({
        id: org.id,
        title: org.nom,
        type: org.type,
        role: 'membre',
        dateAdhesion: org.datecreation || org.date_creation
      })),
      
      accords: organisations.filter(org => 
        org.type === 'Traité' || 
        org.type === 'Accord' ||
        org.type === 'Zone de libre-échange' ||
        org.type === 'Accord commercial' ||
        org.type?.toLowerCase().includes('accord') ||
        org.type?.toLowerCase().includes('traité') ||
        org.type?.toLowerCase().includes('libre') ||
        org.type?.toLowerCase().includes('échange')
      ).map(org => ({
        id: org.id,
        title: org.nom,
        type: org.type,
        role: 'signataire',
        dateAdhesion: org.datecreation || org.date_creation
      }))
    }
  },

  // Récupérer les organisations d'un pays
  async getOrganizationsByCountry(countryId: string): Promise<any[]> {
    const { data: orgIds, error: idError } = await supabase
      .from('country_organization')
      .select('organizationid')
      .eq('countryid', countryId)
    
    if (idError || !orgIds || orgIds.length === 0) return []
    
    const { data: organizations, error: orgError } = await supabase
      .from('organization')
      .select('*')
      .in('id', orgIds.map(o => o.organizationid))
    
    if (orgError) return []
    return organizations || []
  },

  // Récupérer les organisations par type
  async getOrganizationsByType(): Promise<Record<string, Organization[]>> {
    const { data, error } = await supabase
      .from('organization')
      .select('*')
      .order('nom')
    
    if (error) throw error

    // Compter les pays pour chaque organisation et grouper par type
    const orgsWithCount = await Promise.all(
      (data || []).map(async (org) => {
        const { count } = await supabase
          .from('country_organization')
          .select('*', { count: 'exact', head: true })
          .eq('organizationid', org.id)
        
        return {
          ...org,
          country_count: count || 0
        }
      })
    )

    // Grouper par type
    const grouped = orgsWithCount.reduce((acc, org) => {
      const type = org.type || 'Autre'
      if (!acc[type]) acc[type] = []
      acc[type].push(org)
      return acc
    }, {} as Record<string, (Organization & { country_count: number })[]>)

    return grouped
  },

  // Récupérer les régimes politiques
  async getPoliticalRegimes(): Promise<PoliticalRegime[]> {
    const { data, error } = await supabase
      .from('political_regime')
      .select('*')
      .order('name')
    
    if (error) throw error

    // Compter les pays pour chaque régime séparément
    const regimesWithCount = await Promise.all(
      (data || []).map(async (regime) => {
        const { count } = await supabase
          .from('country_political_regime')
          .select('*', { count: 'exact', head: true })
          .eq('regime_id', regime.id)
          .eq('current_regime', true)
        
        return {
          id: regime.id,
          nom: regime.name,
          description: regime.description || '',
          caracteristiques: [],
          country_count: count || 0
        }
      })
    )

    return regimesWithCount
  },

  // Récupérer les conflits armés
  async getArmedConflicts(): Promise<ArmedConflict[]> {
    const { data, error } = await supabase
      .from('armed_conflict')
      .select('*')
      .order('startyear', { ascending: false })
    
    if (error) throw error

    // Transformer les données pour correspondre à l'interface, en gardant l'epicenter brut
    return (data || []).map(conflict => ({
      id: conflict.id,
      nom: conflict.name,
      description: conflict.description || '',
      date_debut: conflict.startyear?.toString() || '',
      date_fin: conflict.endyear?.toString() || '',
      type: conflict.status || '',
      intensite: conflict.casualtyestimates || '',
      pays_impliques: conflict.involvedcountries || [],
      epicenter: conflict.epicenter // Garder l'epicenter brut pour la carte
    }))
  },

  // Rechercher des pays
  async searchCountries(query: string): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .or(`nom.ilike.%${query}%,capitale.ilike.%${query}%`)
      .order('nom')
      .limit(20)
    
    if (error) throw error
    return data || []
  },

  // Récupérer les pays par continent
  async getCountriesByContinent(continent: string): Promise<Country[]> {
    const { data, error } = await supabase
      .from('country')
      .select('*')
      .eq('continent', continent)
      .order('nom')
    
    if (error) throw error
    return data || []
  },

  // Récupérer les pays par régime politique
  async getCountriesByRegime(regimeId: string): Promise<Country[]> {
    // Récupérer les IDs des pays avec ce régime
    const { data: countryIds, error: idError } = await supabase
      .from('country_political_regime')
      .select('country_id')
      .eq('regime_id', regimeId)
      .eq('current_regime', true)
    
    if (idError) throw idError
    if (!countryIds || countryIds.length === 0) return []
    
    // Récupérer les données des pays
    const { data: countries, error: countryError } = await supabase
      .from('country')
      .select('*')
      .in('id', countryIds.map(c => c.country_id))
      .order('nom')
    
    if (countryError) throw countryError
    return countries || []
  },

  // Récupérer les pays par organisation
  async getCountriesByOrganization(organizationId: string): Promise<Country[]> {
    // Récupérer les IDs des pays membres de cette organisation
    const { data: countryIds, error: idError } = await supabase
      .from('country_organization')
      .select('countryid')
      .eq('organizationid', organizationId)
    
    if (idError) throw idError
    if (!countryIds || countryIds.length === 0) return []
    
    // Récupérer les données des pays
    const { data: countries, error: countryError } = await supabase
      .from('country')
      .select('*')
      .in('id', countryIds.map(c => c.countryid))
      .order('nom')
    
    if (countryError) throw countryError
    return countries || []
  },

  // Récupérer un conflit armé par ID avec toutes les données pour floating panel
  async getArmedConflictById(id: string): Promise<any | null> {
    const { data, error } = await supabase
      .from('armed_conflict')
      .select('*')
      .eq('id', id)
      .single()
    
    if (error) throw error
    if (!data) return null


    // Récupérer les pays impliqués avec leurs détails
    const paysImpliques = await this.getCountriesByConflict(id)
    
    // Récupérer les zones de combat
    const zones = await this.getCombatZonesByConflict(id)

    return {
      id: data.id,
      nom: data.name,
      description: data.description || '',
      date_debut: data.startyear?.toString() || '',
      date_fin: data.endyear?.toString() || '',
      type: data.status || '',
      intensite: data.casualtyestimates || '',
      pays_impliques: data.involvedcountries || [],
      epicenter: data.epicenter,
      
      // Champs additionnels pour les floating panels
      statut: data.statut || data.status || '',
      impact_geopolitique: data.geopoliticalimpact || '',
      annee_debut: data.startyear,
      annee_fin: data.endyear,
      
      // Données enrichies pour floating panels
      paysImpliques: paysImpliques.map(country => ({
        id: country.id,
        nom: country.nom,
        flag: country.drapeau,
        role: 'participant', // À déterminer selon la relation
        dateEntree: data.startyear?.toString()
      })),
      
      zones: zones.map(zone => zone.name),
      
      localisation: data.epicenter ? 
        `${data.epicenter.coordinates[1]}, ${data.epicenter.coordinates[0]}` : 
        '',
      
      // Timeline basique (à enrichir si colonne timeline existe)
      timeline: [
        {
          id: `start-${id}`,
          date: data.startyear?.toString() || '',
          titre: 'Début du conflit',
          description: data.description || ''
        },
        ...(data.endyear ? [{
          id: `end-${id}`,
          date: data.endyear.toString(),
          titre: 'Fin du conflit',
          description: 'Résolution ou cessation du conflit'
        }] : [])
      ],
      
      // Victimes basiques (gestion du format JSON de casualtyestimates)
      victimes: (() => {
        if (typeof data.casualtyestimates === 'object' && data.casualtyestimates !== null) {
          // Format JSON comme celui fourni par l'utilisateur
          const casualties = data.casualtyestimates
          return {
            total: casualties.total_casualties_2024 || casualties.total || 'Non spécifié',
            civils: casualties.ukrainian_civilian_deaths || casualties.civilian_deaths || 'Non spécifié',
            militaires: casualties.ukrainian_military_deaths || casualties.military_deaths || 'Non spécifié',
            prisonniers: casualties.prisoners_of_war || 'Non spécifié',
            deplaces: casualties.displaced_refugees || 'Non spécifié',
            deplaces_internes: casualties.internally_displaced || 'Non spécifié',
            casualties_mensuelles: casualties.monthly_russian_casualties_2024 || 'Non spécifié',
            details: casualties // Garder toutes les données pour affichage détaillé
          }
        } else {
          // Format string simple
          return {
            total: data.casualtyestimates || 'Non spécifié',
            civils: 'Non spécifié',
            militaires: 'Non spécifié'
          }
        }
      })(),
      
      // Intensité enrichie pour l'affichage
      intensite_detaillee: (() => {
        if (typeof data.casualtyestimates === 'object' && data.casualtyestimates !== null) {
          return data.casualtyestimates
        } else {
          return { resume: data.casualtyestimates || 'Non spécifié' }
        }
      })()
    }
  },

  // Récupérer les pays impliqués dans un conflit
  async getCountriesByConflict(conflictId: string): Promise<Country[]> {
    // Récupérer les IDs des pays impliqués dans ce conflit
    const { data: countryIds, error: idError } = await supabase
      .from('conflict_country')
      .select('countryid')
      .eq('conflictid', conflictId)
    
    if (idError) {
      console.error('[supabaseService] Erreur récupération IDs pays:', idError)
      throw idError
    }
    
    if (!countryIds || countryIds.length === 0) {
      return []
    }
    
    // Récupérer les données des pays
    const countryIdsList = countryIds.map(c => c.countryid)
    
    const { data: countries, error: countryError } = await supabase
      .from('country')
      .select('*')
      .in('id', countryIdsList)
      .order('nom')
    
    if (countryError) {
      console.error('[supabaseService] Erreur récupération données pays:', countryError)
      throw countryError
    }
    
    return countries || []
  },

  // Récupérer les conflits impliquant un pays
  async getConflictsByCountry(countryId: string): Promise<ArmedConflict[]> {
    // Récupérer les IDs des conflits impliquant ce pays
    const { data: conflictIds, error: idError } = await supabase
      .from('conflict_country')
      .select('conflictid')
      .eq('countryid', countryId)
    
    if (idError) throw idError
    if (!conflictIds || conflictIds.length === 0) return []
    
    // Récupérer les données des conflits
    const { data: conflicts, error: conflictError } = await supabase
      .from('armed_conflict')
      .select('*')
      .in('id', conflictIds.map(c => c.conflictid))
      .order('startyear', { ascending: false })
    
    if (conflictError) throw conflictError
    
    // Transformer les données pour correspondre à l'interface, comme dans getArmedConflicts()
    return (conflicts || []).map(conflict => ({
      id: conflict.id,
      nom: conflict.name, // Utilise conflict.name comme dans getArmedConflicts()
      description: conflict.description || '',
      date_debut: conflict.startyear?.toString() || '',
      date_fin: conflict.endyear?.toString() || '',
      type: conflict.status || '',
      intensite: conflict.casualtyestimates || '',
      pays_impliques: conflict.involvedcountries || []
    }))
  },

  // Récupérer les zones de combat d'un conflit spécifique
  async getCombatZonesByConflict(conflictId: string): Promise<any[]> {
    const { data, error } = await supabase
      .from('armed_conflict_combat_zone')
      .select('*')
      .eq('conflict_id', conflictId)
      .order('name')
    
    if (error) {
      console.error('[supabaseService] Erreur zones de combat:', error)
      throw error
    }
    
    return data || []
  },

  // Récupérer toutes les zones de combat actives
  async getActiveCombatZones(): Promise<any[]> {
    const { data, error } = await supabase
      .from('armed_conflict_combat_zone')
      .select('*')
      .eq('status', 'active')
      .order('name')
    
    if (error) throw error
    return data || []
  },

  // Récupérer les conflits armés par statut
  async getArmedConflictsByStatus(status: 'active' | 'inactive' | 'resolved'): Promise<ArmedConflict[]> {
    const { data, error } = await supabase
      .from('armed_conflict')
      .select('*')
      .eq('status', status)
      .order('startyear', { ascending: false })
    
    if (error) throw error

    // Transformer les données pour correspondre à l'interface
    return (data || []).map(conflict => ({
      id: conflict.id,
      nom: conflict.name,
      description: conflict.description || '',
      date_debut: conflict.startyear?.toString() || '',
      date_fin: conflict.endyear?.toString() || '',
      type: conflict.status || '',
      intensite: conflict.casualtyestimates || '',
      pays_impliques: conflict.involvedcountries || []
    }))
  },

  // Rechercher des conflits armés
  async searchArmedConflicts(query: string): Promise<ArmedConflict[]> {
    const { data, error } = await supabase
      .from('armed_conflict')
      .select('*')
      .or(`name.ilike.%${query}%,description.ilike.%${query}%`)
      .order('startyear', { ascending: false })
    
    if (error) throw error

    // Transformer les données pour correspondre à l'interface
    return (data || []).map(conflict => ({
      id: conflict.id,
      nom: conflict.name,
      description: conflict.description || '',
      date_debut: conflict.startyear?.toString() || '',
      date_fin: conflict.endyear?.toString() || '',
      type: conflict.status || '',
      intensite: conflict.casualtyestimates || '',
      pays_impliques: conflict.involvedcountries || []
    }))
  },

  // Récupérer une organisation par ID avec toutes les données pour floating panel
  async getOrganizationById(id: string): Promise<any | null> {
    const { data, error } = await supabase
      .from('organization')
      .select('*')
      .eq('id', id)
      .single()
    
    if (error) throw error
    if (!data) return null


    // Récupérer les pays membres
    const paysMembres = await this.getCountriesByOrganization(id)

    return {
      id: data.id,
      nom: data.nom,
      acronyme: data.acronyme,
      type: data.type,
      description: data.description,
      dateCreation: data.datecreation || data.date_creation,
      siege: data.siege,
      
      // Données enrichies pour floating panels
      title: data.nom,
      statut: 'active', // À déterminer selon les données
      domaineAction: data.type,
      adresse: data.siege,
      objectifs: data.description ? [data.description] : [],
      
      // Pays membres avec détails
      paysMembres: paysMembres.map(country => ({
        id: country.id,
        nom: country.nom,
        flag: country.drapeau,
        statut: 'membre',
        dateAdhesion: data.datecreation || data.date_creation,
        role: 'membre'
      })),
      
      // Structure basique (à enrichir si colonnes structure existent)
      structure: {
        organigramme: 'Non spécifié',
        secretaireGeneral: 'Non spécifié',
        mandatDebut: data.datecreation || data.date_creation,
        organesDecision: ['Assemblée générale', 'Conseil d\'administration']
      },
      
      // Activités basiques
      activites: [
        {
          id: `act-${id}-1`,
          titre: 'Coordination des membres',
          description: data.description || '',
          date: data.datecreation || data.date_creation
        }
      ],
      
      // Financement basique
      financement: {
        budgetAnnuel: 'Non spécifié',
        sources: [
          {
            type: 'Contributions des membres',
            pourcentage: 100
          }
        ]
      }
    }
  },

  // Rechercher des organisations
  async searchOrganizations(query: string): Promise<any[]> {
    const { data, error } = await supabase
      .from('organization')
      .select('*')
      .or(`nom.ilike.%${query}%,description.ilike.%${query}%,acronyme.ilike.%${query}%`)
      .order('nom')
    
    if (error) throw error
    return data || []
  }
}

// Export par défaut pour la compatibilité
export default supabaseService 