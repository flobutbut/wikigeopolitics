export interface Country {
  id: string;
  title: string;
  flag: string;
  continent?: string;
  coordinates?: [number, number];
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
} 