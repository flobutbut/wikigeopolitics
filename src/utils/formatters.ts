export function formatNumber(num: number): string {
  return new Intl.NumberFormat().format(num);
}

export function formatCurrency(amount: number, currency: string = 'USD'): string {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency
  }).format(amount);
} 