import { query } from './db';
import { Country } from '@/types/country';

export async function addCountry(country: Country): Promise<void> {
  await query(
    'INSERT INTO country (id, nom, drapeau, continent) VALUES ($1, $2, $3, $4)',
    [country.id, country.title, country.flag, country.continent]
  );
}

export async function updateCountry(country: Country): Promise<void> {
  await query(
    'UPDATE country SET nom = $2, drapeau = $3, continent = $4, updated_at = NOW() WHERE id = $1',
    [country.id, country.title, country.flag, country.continent]
  );
} 