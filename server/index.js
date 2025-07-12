const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Configuration CORS
app.use(cors());
app.use(express.json());

// Configuration de la base de données
const pool = new Pool({
  host: process.env.PGHOST || 'localhost',
  port: Number(process.env.PGPORT) || 5433,
  user: process.env.PGUSER || 'wikigeo_user',
  password: process.env.PGPASSWORD || 'wikigeo_password',
  database: process.env.PGDATABASE || 'wikigeopolitics',
  max: 10,
  idleTimeoutMillis: 30000,
});

// Fonction utilitaire pour les requêtes
async function query(text, params) {
  console.log('[DB] Tentative de connexion à la base de données...');
  const client = await pool.connect();
  try {
    console.log('[DB] Connexion établie, exécution de la requête:', text);
    const res = await client.query(text, params);
    console.log('[DB] Requête exécutée avec succès,', res.rows.length, 'lignes retournées');
    return res.rows;
  } catch (error) {
    console.error('[DB] Erreur lors de l\'exécution de la requête:', error);
    throw error;
  } finally {
    client.release();
    console.log('[DB] Connexion fermée');
  }
}

// Fonctions utilitaires pour le formatage
function formatCurrency(amount) {
  if (!amount) return 'Non disponible';
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(amount);
}

function formatNumber(number) {
  if (!number) return 'Non disponible';
  return new Intl.NumberFormat('fr-FR').format(number);
}

// Routes API

// Récupérer tous les pays
app.get('/api/countries', async (req, res) => {
  try {
    const rows = await query(
      'SELECT id, nom as title, drapeau as flag, continent, ST_AsText(coordonnees) as coordonnees FROM country WHERE coordonnees IS NOT NULL ORDER BY nom'
    );
    
    const countries = rows.map(row => ({
      id: row.id,
      title: row.title,
      flag: row.flag,
      continent: row.continent,
      coordonnees: row.coordonnees ? row.coordonnees.replace('POINT(', '').replace(')', '').split(' ').map(coord => parseFloat(coord)) : null
    }));
    
    res.json(countries);
  } catch (error) {
    console.error('Erreur lors de la récupération des pays:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Récupérer un pays par ID
app.get('/api/countries/:id', async (req, res) => {
  try {
    const countries = await query(
      'SELECT id, nom as title, drapeau as flag, continent, ST_AsText(coordonnees) as coordonnees FROM country WHERE id = $1',
      [req.params.id]
    );
    
    if (countries.length === 0) {
      return res.status(404).json({ error: 'Pays non trouvé' });
    }
    
    const country = countries[0];
    country.coordonnees = country.coordonnees ? country.coordonnees.replace('POINT(', '').replace(')', '').split(' ') : null;
    
    res.json(country);
  } catch (error) {
    console.error('Erreur lors de la récupération du pays:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Récupérer les données géographiques
app.get('/api/countries-geo', async (req, res) => {
  try {
    const rows = await query(
      'SELECT id, nom as name, drapeau as flag, coordonnees FROM country WHERE coordonnees IS NOT NULL ORDER BY nom'
    );
    
    const geoData = {
      type: "FeatureCollection",
      features: rows.map(row => ({
        type: "Feature",
        properties: {
          id: row.id,
          name: row.name,
          flag: row.flag
        },
        geometry: {
          type: "Point",
          coordinates: row.coordonnees
        }
      }))
    };
    
    res.json(geoData);
  } catch (error) {
    console.error('Erreur lors de la récupération des données géographiques:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Récupérer les détails d'un pays
app.get('/api/countries/:id/details', async (req, res) => {
  try {
    // Récupérer les données du pays avec son régime politique actuel
    const countryData = await query(
      `SELECT c.*, pr.name as regime_name, pr.description as regime_description,
              cpr.chef_etat, cpr.date_prise_poste
       FROM country c 
       LEFT JOIN country_political_regime cpr ON c.id = cpr.country_id AND cpr.current_regime = true
       LEFT JOIN political_regime pr ON cpr.regime_id = pr.id 
       WHERE c.id = $1`,
      [req.params.id]
    );

    if (countryData.length === 0) {
      return res.status(404).json({ error: 'Pays non trouvé' });
    }

    const country = countryData[0];

    // Récupérer les organisations du pays
    const organizations = await query(
      `SELECT o.id, o.nom, o.type, o.description, o.datecreation, o.siege,
              co.role, co.dateadhesion, co.datesortie
       FROM country_organization co
       JOIN organization o ON co.organizationid = o.id
       WHERE co.countryid = $1
       ORDER BY o.type, o.nom`,
      [req.params.id]
    );

    // Convertir les coordonnées PostGIS en format utilisable
    let coordonnees = null;
    if (country.coordonnees) {
      const coords = country.coordonnees.replace('POINT(', '').replace(')', '').split(' ');
      coordonnees = [parseFloat(coords[0]), parseFloat(coords[1])]; // [lng, lat]
    }

    // Organiser les organisations par type
    const coalitions = organizations.filter(org => 
      org.type === 'Alliance militaire' || 
      org.type === 'Organisation diplomatique' || 
      org.type === 'Organisation régionale'
    ).map(org => ({
      id: org.id,
      title: org.nom,
      type: org.type,
      role: org.role,
      dateAdhesion: org.dateadhesion,
      dateSortie: org.datesortie
    }));

    const accords = organizations.filter(org => 
      org.type === 'Organisation commerciale' || 
      org.type === 'Forum économique' || 
      org.type === 'Organisation économique'
    ).map(org => ({
      id: org.id,
      title: org.nom,
      type: org.type,
      role: org.role,
      dateAdhesion: org.dateadhesion,
      dateSortie: org.datesortie
    }));

    // Retourner les données avec la nouvelle structure
    const details = {
      id: country.id,
      title: country.nom,
      drapeau: country.drapeau,
      capitale: country.capitale,
      langue: country.langue,
      monnaie: country.monnaie,
      pib: country.pib,
      population: country.population,
      revenuMedian: country.revenumedian,
      superficieKm2: country.superficiekm2,
      regimePolitique: country.regime_name || 'Non spécifié',
      appartenanceGeographique: country.appartenancegeographique,
      chefEtat: country.chef_etat || null,
      datePrisePoste: country.date_prise_poste || null,
      histoire: country.histoire,
      indiceSouverainete: country.indicesouverainete,
      indiceDependance: country.indicedependance,
      statutStrategique: country.statutstrategique,
      dateCreation: country.datecreation,
      dateDerniereMiseAJour: country.datedernieremiseajour,
      coordonnees: coordonnees,
      // Sections pour compatibilité
      sections: [],
      collapsibleSections: [
        {
          id: 'histoire',
          title: 'Histoire',
          expanded: false,
          content: country.histoire || 'Aucune information disponible'
        },
        {
          id: 'politique',
          title: 'Système politique',
          expanded: false,
          content: `Régime politique: ${country.regime_name || 'Non spécifié'}`
        },
        {
          id: 'economie',
          title: 'Économie',
          expanded: false,
          content: `PIB: ${country.pib ? formatCurrency(country.pib) : 'Non disponible'}\nPopulation: ${country.population ? formatNumber(country.population) : 'Non disponible'}`
        },
        {
          id: 'demographie',
          title: 'Société et Démographie',
          expanded: false,
          content: `Population: ${country.population ? formatNumber(country.population) : 'Non disponible'}\nRevenu médian: ${country.revenumedian ? formatCurrency(country.revenumedian) : 'Non disponible'}`
        }
      ],
      coalitions: coalitions,
      accords: accords
    };

    res.json(details);
  } catch (error) {
    console.error('Erreur lors de la récupération des détails du pays:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Nouvel endpoint pour récupérer les organisations d'un pays
app.get('/api/countries/:id/organizations', async (req, res) => {
  try {
    const organizations = await query(
      `SELECT o.id, o.nom, o.type, o.description, o.datecreation, o.siege,
              co.role, co.dateadhesion, co.datesortie
       FROM country_organization co
       JOIN organization o ON co.organizationid = o.id
       WHERE co.countryid = $1
       ORDER BY o.type, o.nom`,
      [req.params.id]
    );

    // Organiser les organisations par type
    const coalitions = organizations.filter(org => 
      org.type === 'Alliance militaire' || 
      org.type === 'Organisation diplomatique' || 
      org.type === 'Organisation régionale'
    ).map(org => ({
      id: org.id,
      title: org.nom,
      type: org.type,
      role: org.role,
      dateAdhesion: org.dateadhesion,
      dateSortie: org.datesortie
    }));

    const accords = organizations.filter(org => 
      org.type === 'Organisation commerciale' || 
      org.type === 'Forum économique' || 
      org.type === 'Organisation économique'
    ).map(org => ({
      id: org.id,
      title: org.nom,
      type: org.type,
      role: org.role,
      dateAdhesion: org.dateadhesion,
      dateSortie: org.datesortie
    }));

    res.json({
      coalitions: coalitions,
      accords: accords,
      all: organizations.map(org => ({
        id: org.id,
        title: org.nom,
        type: org.type,
        role: org.role,
        dateAdhesion: org.dateadhesion,
        dateSortie: org.datesortie
      }))
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des organisations du pays:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Récupérer les organisations groupées par type
app.get('/api/organizations', async (req, res) => {
  try {
    console.log('[API] Tentative de récupération des organisations...');
    const organizations = await query(
      'SELECT id, nom as title, type, description FROM organization ORDER BY type, nom'
    );
    console.log('[API] Organisations récupérées:', organizations.length);
    
    // Grouper les organisations par type
    const groupedOrganizations = {};
    organizations.forEach(org => {
      if (!groupedOrganizations[org.type]) {
        groupedOrganizations[org.type] = [];
      }
      groupedOrganizations[org.type].push(org);
    });
    
    res.json(groupedOrganizations);
  } catch (error) {
    console.error('Erreur lors de la récupération des organisations:', error);
    res.status(500).json({ error: 'Erreur serveur', details: error.message });
  }
});

// Récupérer les pays membres d'une organisation
app.get('/api/organizations/:id/countries', async (req, res) => {
  try {
    console.log('[API] Tentative de récupération des pays membres de l\'organisation:', req.params.id);
    
    const countries = await query(
      `SELECT c.id, c.nom, c.drapeau, c.continent, ST_AsText(c.coordonnees) as coordonnees,
              co.role, co.dateadhesion, co.datesortie
       FROM country c 
       INNER JOIN country_organization co ON c.id = co.countryid
       WHERE co.organizationid = $1
       ORDER BY c.nom`,
      [req.params.id]
    );
    
    const formattedCountries = countries.map(country => ({
      id: country.id,
      title: country.nom,
      flag: country.drapeau,
      continent: country.continent,
      coordonnees: country.coordonnees ? country.coordonnees.replace('POINT(', '').replace(')', '').split(' ').map(coord => parseFloat(coord)) : null,
      role: country.role || null,
      dateAdhesion: country.dateadhesion || null,
      dateSortie: country.datesortie || null
    }));
    
    console.log('[API] Pays membres récupérés:', formattedCountries.length);
    res.json(formattedCountries);
  } catch (error) {
    console.error('Erreur lors de la récupération des pays membres:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Récupérer tous les régimes politiques
app.get('/api/political-regimes', async (req, res) => {
  try {
    console.log('[API] Tentative de récupération des régimes politiques...');
    const regimes = await query(
      'SELECT id, name, description FROM political_regime ORDER BY name'
    );
    console.log('[API] Régimes politiques récupérés:', regimes.length);
    
    res.json(regimes);
  } catch (error) {
    console.error('Erreur lors de la récupération des régimes politiques:', error);
    res.status(500).json({ error: 'Erreur serveur', details: error.message });
  }
});

// Récupérer les pays par régime politique
app.get('/api/political-regimes/:id/countries', async (req, res) => {
  try {
    const countries = await query(
      `SELECT c.id, c.nom, c.drapeau, c.continent, ST_AsText(c.coordonnees) as coordonnees,
              cpr.chef_etat, cpr.date_prise_poste
       FROM country c 
       INNER JOIN country_political_regime cpr ON c.id = cpr.country_id 
       WHERE cpr.regime_id = $1 AND cpr.current_regime = true 
       ORDER BY c.nom`,
      [req.params.id]
    );
    
    const formattedCountries = countries.map(country => ({
      id: country.id,
      title: country.nom,
      flag: country.drapeau,
      continent: country.continent,
      coordonnees: country.coordonnees ? country.coordonnees.replace('POINT(', '').replace(')', '').split(' ').map(coord => parseFloat(coord)) : null,
      chefEtat: country.chef_etat || null,
      datePrisePoste: country.date_prise_poste || null
    }));
    
    res.json(formattedCountries);
  } catch (error) {
    console.error('Erreur lors de la récupération des pays par régime:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Récupérer les pays avec leurs régimes politiques
app.get('/api/countries-with-regimes', async (req, res) => {
  try {
    const countries = await query(
      `SELECT c.id, c.nom, c.drapeau, c.continent, ST_AsText(c.coordonnees) as coordonnees, 
              pr.name as regime_name, pr.description as regime_description,
              cpr.chef_etat, cpr.date_prise_poste
       FROM country c 
       LEFT JOIN country_political_regime cpr ON c.id = cpr.country_id AND cpr.current_regime = true
       LEFT JOIN political_regime pr ON cpr.regime_id = pr.id 
       ORDER BY c.nom`
    );
    
    const formattedCountries = countries.map(country => ({
      id: country.id,
      title: country.nom,
      flag: country.drapeau,
      continent: country.continent,
      coordonnees: country.coordonnees ? country.coordonnees.replace('POINT(', '').replace(')', '').split(' ').map(coord => parseFloat(coord)) : null,
      currentRegime: country.regime_name ? {
        name: country.regime_name,
        description: country.regime_description
      } : null,
      chefEtat: country.chef_etat || null,
      datePrisePoste: country.date_prise_poste || null
    }));
    
    res.json(formattedCountries);
  } catch (error) {
    console.error('Erreur lors de la récupération des pays avec régimes:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Récupérer les données de navigation
app.get('/api/navigation', async (req, res) => {
  try {
    // Lire le fichier menu.json dynamiquement
    const menuPath = path.join(__dirname, '../src/data/app/menu.json');
    
    if (!fs.existsSync(menuPath)) {
      console.error('Fichier menu.json non trouvé:', menuPath);
      return res.status(500).json({ error: 'Fichier de navigation non trouvé' });
    }

    const menuData = JSON.parse(fs.readFileSync(menuPath, 'utf8'));
    const mainNavigation = menuData.applicationStructure.mainNavigation;

    // Transformer les données du menu.json en format attendu par le frontend
    const categories = mainNavigation.map(category => ({
      id: category.id,
      title: category.title,
      items: category.items || []
    }));

    // Récupérer les organisations depuis la base de données
    const organizations = await query(
      'SELECT id, nom as title, type FROM organization ORDER BY nom'
    );

    const navigationData = {
      categories: categories,
      organizations: organizations
    };

    res.json(navigationData);
  } catch (error) {
    console.error('Erreur lors de la récupération des données de navigation:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Récupérer les données d'une catégorie ou sous-page
app.get('/api/categories/:id', async (req, res) => {
  try {
    // Lire le fichier menu.json dynamiquement
    const menuPath = path.join(__dirname, '../src/data/app/menu.json');
    
    if (!fs.existsSync(menuPath)) {
      console.error('Fichier menu.json non trouvé:', menuPath);
      return res.status(500).json({ error: 'Fichier de navigation non trouvé' });
    }

    const menuData = JSON.parse(fs.readFileSync(menuPath, 'utf8'));
    const mainNavigation = menuData.applicationStructure.mainNavigation;
    const subPages = menuData.applicationStructure.subPages;

    // D'abord chercher dans les catégories principales
    let category = mainNavigation.find(cat => cat.id === req.params.id);
    let isSubPage = false;
    
    // Si pas trouvé, chercher dans les sous-pages
    if (!category) {
      const subPage = subPages[req.params.id];
      if (subPage) {
        category = {
          id: req.params.id,
          title: subPage.title,
          items: subPage.items || []
        };
        isSubPage = true;
      }
    }
    
    if (!category) {
      return res.status(404).json({ error: 'Catégorie ou sous-page non trouvée' });
    }

    // Si c'est une catégorie principale, récupérer ses sous-pages
    let subPagesData = {};
    if (!isSubPage) {
      const categoryData = category.items || [];
      categoryData.forEach(item => {
        if (subPages[item.id]) {
          subPagesData[item.id] = subPages[item.id];
        }
      });
    }

    res.json({
      category: {
        id: category.id,
        title: category.title,
        description: `Données pour ${category.title}`,
        isSubPage: isSubPage
      },
      items: category.items || [],
      subPages: subPagesData
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des données de catégorie:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Test de connexion
app.get('/api/health', async (req, res) => {
  try {
    const result = await query('SELECT 1 as test');
    res.json({ status: 'ok', message: 'Connexion à la base de données réussie' });
  } catch (error) {
    console.error('Erreur de connexion à la base de données:', error);
    res.status(500).json({ status: 'error', message: 'Erreur de connexion à la base de données' });
  }
});

// Démarrage du serveur
app.listen(port, () => {
  console.log(`Serveur API démarré sur le port ${port}`);
  console.log(`URL: http://localhost:${port}`);
}); 