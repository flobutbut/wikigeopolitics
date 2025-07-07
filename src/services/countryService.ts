import { Country, CountryDetail } from '@/types/country';

export default {
  async getCountries(): Promise<Country[]> {
    try {
      const response = await fetch('http://localhost:3000/api/countries');
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      console.log('✅ API response:', data.length, 'pays reçus');
      console.log('Premier pays:', data[0]);
      return data;
    } catch (error) {
      console.error('Erreur lors du chargement des pays:', error);
      throw error;
    }
  },
  
  async getCountryDetail(id: string): Promise<CountryDetail> {
    try {
      const response = await fetch(`http://localhost:3000/api/countries/${id}/details`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      return data;
    } catch (error) {
      console.error(`Failed to load country detail for ${id}:`, error);
      throw new Error(`Country not found: ${id}`);
    }
  }
}; 