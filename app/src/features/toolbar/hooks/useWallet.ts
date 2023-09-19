import { useQuery } from '@tanstack/react-query';
import { useFuel } from '@fuel-wallet/react';

export function useWallet(disabled?: boolean) {
  const { fuel } = useFuel();

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
        const selectedAccount = await fuel.currentAccount();
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
    return { wallet };
  }

  return { wallet, isLoading, isError };
}
