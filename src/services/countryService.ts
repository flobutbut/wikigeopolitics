import { Country, CountryDetail } from '@/types/country';

export default {
  async getCountries(): Promise<Country[]> {
    const response = await import('@/data/countries/index.json');
    return response.default;
  },
  
  async getCountryDetail(id: string): Promise<CountryDetail> {
    try {
      const response = await import(`@/data/countries/${id}.json`);
      return response.default;
    } catch (error) {
      console.error(`Failed to load country detail for ${id}:`, error);
      throw new Error(`Country not found: ${id}`);
    }
  }
}; 