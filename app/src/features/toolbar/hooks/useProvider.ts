import { useQuery } from '@tanstack/react-query';

export function useProvider() {
  const fuel = window?.fuel;

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
    return { provider, isLoading, isError: true };
  }

  return { provider, isLoading, isError };
}
