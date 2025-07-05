import { Pool } from 'pg';

const pool = new Pool({
  host: process.env.PGHOST || 'localhost',
  port: Number(process.env.PGPORT) || 5433,
  user: process.env.PGUSER || 'wikigeo_user',
  password: process.env.PGPASSWORD || 'wikigeo_password',
  database: process.env.PGDATABASE || 'wikigeopolitics',
  max: 10,
  idleTimeoutMillis: 30000,
});

export default pool;

export async function query<T = any>(text: string, params?: any[]): Promise<T[]> {
  const client = await pool.connect();
  try {
    const res = await client.query(text, params);
    return res.rows;
  } finally {
    client.release();
  }
} 