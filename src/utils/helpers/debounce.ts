/**
 * Debounce utility - delays invoking a function until after a specified wait time
 * Useful for improving performance when handling frequent events like scrolling or typing
 * 
 * @param func - The function to debounce
 * @param wait - The number of milliseconds to delay
 * @returns A debounced version of the input function
 */
export function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait = 300
): (...args: Parameters<T>) => void {
  let timeout: ReturnType<typeof setTimeout> | null = null;
  
  return function(...args: Parameters<T>): void {
    const later = () => {
      timeout = null;
      func(...args);
    };
    
    if (timeout !== null) {
      clearTimeout(timeout);
    }
    
    timeout = setTimeout(later, wait);
  };
}

/**
 * Throttle utility - limits how often a function can be called in a given time period
 * Unlike debounce which resets the timer on each call, throttle guarantees the function
 * is called at least once within the specified interval
 * 
 * @param func - The function to throttle
 * @param limit - The minimum time between function calls in milliseconds
 * @returns A throttled version of the input function
 */
export function throttle<T extends (...args: any[]) => any>(
  func: T,
  limit = 300
): (...args: Parameters<T>) => void {
  let lastCall = 0;
  
  return function(...args: Parameters<T>): void {
    const now = Date.now();
    
    if (now - lastCall >= limit) {
      lastCall = now;
      func(...args);
    }
  };
} 