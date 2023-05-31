import { useEffect, useState } from 'react';

export const globalWindow =
  typeof window !== 'undefined' ? window : ({} as Window);

export function useFuel() {
  const [error, setError] = useState<string | undefined>();
  const [isLoading, setLoading] = useState(true);
  const [fuel, setFuel] = useState<Window['fuel']>(globalWindow.fuel);

  useEffect(() => {
    const timeout = setTimeout(() => {
      if (globalWindow.fuel) {
        setFuel(globalWindow.fuel);
      } else {
        setError('Fuel wallet is not installed');
      }
      setLoading(false);
    }, 500);
    return () => clearTimeout(timeout);
  }, []);

  return [fuel, error, isLoading] as const;
}
