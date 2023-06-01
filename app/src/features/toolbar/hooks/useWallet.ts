import { useQuery } from '@tanstack/react-query';

export function useWallet() {
  const fuel = window?.fuel;

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
      enabled: !!fuel,
    }
  );

  if (!fuel) {
    return { wallet, isLoading, isError: true };
  }

  return { wallet, isLoading, isError };
}
