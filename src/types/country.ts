export interface Country {
  id: string;
  title: string;
  flag: string;
  continent?: string;
  coordonnees?: [number, number];
  // Nouveaux champs de la base de données
  drapeau?: string;
  capitale?: string;
  langue?: string;
  monnaie?: string;
  pib?: number;
  population?: number;
  revenuMedian?: number;
  superficieKm2?: number;
  regimePolitique?: string;
  appartenanceGeographique?: string;
  histoire?: string;
  indiceSouverainete?: number;
  indiceDependance?: number;
  statutStrategique?: string;
  dateCreation?: string;
  dateDerniereMiseAJour?: string;
  // Champs pour l'affichage détaillé
  chefEtat?: string;
  definition?: string;
  definitionSource?: string;
  definitionSourceUrl?: string;
}

export interface CountryDetail extends Country {
  sections: Array<{
    title?: string;
    value?: string;
    keyValues?: Array<{
      key: string;
      value: string;
    }>;
  }>;
  collapsibleSections?: Array<{
    id: string;
    title: string;
    expanded: boolean;
    content: string;
    source?: string;
    sourceUrl?: string;
  }>;
  coalitions?: Array<{
    id: string;
    title: string;
  }>;
  // Données détaillées depuis la base de données
  generalInfo?: {
    capitale: string;
    langue: string;
    monnaie: string;
  };
  indicateurs?: any;
  histoire?: any;
  politique?: any;
  economie?: any;
  demographie?: any;
  frontieres?: any;
  tourisme?: any;
  politicalRegime?: any;
  agriculturalData?: any;
  technologyData?: any;
  demographicData?: any;
  conflictsData?: any;
  naturalResources?: any;
  industrialData?: any;
  transportData?: any;
  chefEtat?: string;
  definition?: string;
  definitionSource?: string;
  definitionSourceUrl?: string;
} 