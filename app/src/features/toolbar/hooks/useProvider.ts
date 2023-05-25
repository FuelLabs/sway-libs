import { toast } from '@fuel-ui/react';
import { useQuery } from '@tanstack/react-query';
import { useFuel } from './useFuel';

export function useProvider() {
  const [fuel, loading, error] = useFuel();

  const {
    data: provider,
    isLoading,
    isError,
  } = useQuery(
    ['provider'],
    async () => {
      if (!!fuel) {
        const isConnected = await fuel.isConnected();
        if (!isConnected) {
          return undefined;
        }
        const fuelProvider = await fuel.getProvider();
        return fuelProvider;
      } else {
        return undefined;
      }
    },
    {
      enabled: !!fuel,
    }
  );

  if (!fuel) {
    return { provider, isLoading: loading, isError: !!error };
  }

  return { provider, isLoading, isError };
}
