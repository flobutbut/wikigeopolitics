export interface Country {
  id: string;
  title: string;
  flag: string;
  continent?: string;
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
} 