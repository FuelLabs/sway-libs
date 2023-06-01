import { useQuery } from '@tanstack/react-query';
import { useFuel } from './useFuel';

export function useWallet(disabled?: boolean) {
  const [fuel, error, loading] = useFuel();

  const {
    data: wallet,
    isLoading,
    isError,
  } = useQuery(
    ['wallet'],
    async () => {
      if (!!fuel) {
        const isConnected = await fuel.isConnected();
        if (!isConnected) {
          await fuel.connect();
        }
        const selectedAccount = (await fuel.currentAccount()) as string;
        const selectedWallet = await fuel.getWallet(selectedAccount);
        return selectedWallet;
      } else {
        return undefined;
      }
    },
    {
      enabled: !!fuel && !disabled,
    }
  );

  if (!fuel) {
    return { wallet, isLoading: loading, isError: !!error };
  }

  return { wallet, isLoading, isError };
}
