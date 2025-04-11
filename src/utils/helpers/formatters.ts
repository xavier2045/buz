/**
 * Format a date into a human-readable string
 * 
 * @param date - The date to format
 * @param locale - The locale to use for formatting
 * @returns A formatted date string
 */
export function formatDate(date: Date | string | number, locale = 'zh-CN'): string {
  const dateObj = date instanceof Date ? date : new Date(date);
  
  return new Intl.DateTimeFormat(locale, {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  }).format(dateObj);
}

/**
 * Format a date with time
 * 
 * @param date - The date to format
 * @param locale - The locale to use for formatting
 * @returns A formatted date and time string
 */
export function formatDateTime(date: Date | string | number, locale = 'zh-CN'): string {
  const dateObj = date instanceof Date ? date : new Date(date);
  
  return new Intl.DateTimeFormat(locale, {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  }).format(dateObj);
}

/**
 * Format a number as a currency amount
 * 
 * @param amount - The amount to format
 * @param currency - The currency code
 * @param locale - The locale to use for formatting
 * @returns A formatted currency string
 */
export function formatCurrency(amount: number, currency = 'CNY', locale = 'zh-CN'): string {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency,
    minimumFractionDigits: 0,
    maximumFractionDigits: 2
  }).format(amount);
}

/**
 * Format a relative time (e.g., "3 days ago", "in 5 minutes")
 * 
 * @param date - The date to format relative to now
 * @param locale - The locale to use for formatting
 * @returns A relative time string
 */
export function formatRelativeTime(date: Date | string | number, locale = 'zh-CN'): string {
  const dateObj = date instanceof Date ? date : new Date(date);
  const now = new Date();
  const diffInSeconds = Math.floor((now.getTime() - dateObj.getTime()) / 1000);
  
  const rtf = new Intl.RelativeTimeFormat(locale, { numeric: 'auto' });
  
  if (diffInSeconds < 60) {
    return rtf.format(-diffInSeconds, 'second');
  }
  
  const diffInMinutes = Math.floor(diffInSeconds / 60);
  if (diffInMinutes < 60) {
    return rtf.format(-diffInMinutes, 'minute');
  }
  
  const diffInHours = Math.floor(diffInMinutes / 60);
  if (diffInHours < 24) {
    return rtf.format(-diffInHours, 'hour');
  }
  
  const diffInDays = Math.floor(diffInHours / 24);
  if (diffInDays < 30) {
    return rtf.format(-diffInDays, 'day');
  }
  
  const diffInMonths = Math.floor(diffInDays / 30);
  if (diffInMonths < 12) {
    return rtf.format(-diffInMonths, 'month');
  }
  
  const diffInYears = Math.floor(diffInMonths / 12);
  return rtf.format(-diffInYears, 'year');
} 