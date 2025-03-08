export interface MenuItem {
  id: string;
  title: string;
  type?: string;
  hasSubmenu?: boolean;
  items?: MenuItem[];
  toggleOptions?: Array<{
    id: string;
    title: string;
    enabled: boolean;
  }>;
}

export interface SubPage {
  title: string;
  searchEnabled: boolean;
  hasReturnButton: boolean;
  items?: MenuItem[];
  organizations?: Array<{
    id: string;
    title: string;
  }>;
} 