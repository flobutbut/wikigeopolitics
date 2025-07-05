import { query } from './db';
import { Country } from '@/types/country';

export async function getAllCountries(): Promise<Country[]> {
  const rows = await query<Country>(
    'SELECT id, nom as title, drapeau as flag, continent FROM country ORDER BY nom'
  );
  return rows;
}

export async function getCountryById(id: string): Promise<Country | null> {
  const rows = await query<Country>(
    'SELECT id, nom as title, drapeau as flag, continent FROM country WHERE id = $1',
    [id]
  );
  return rows[0] || null;
} 