import { ContractFactory, JsonAbi, StorageSlot } from 'fuels';
import { useMutation } from '@tanstack/react-query';
import { useFuel, useWallet } from '@fuel-wallet/react';

const DEPLOYMENT_TIMEOUT_MS = 120000;

export interface DeployContractData {
  contractId: string;
  networkUrl: string;
}

export function useDeployContract(
  abi: string,
  bytecode: string,
  storageSlots: string,
  onError: (error: any) => void,
  onSuccess: (data: any) => void,
  updateLog: (entry: string) => void
) {
  const { wallet, isLoading: walletIsLoading } = useWallet();
  const { fuel } = useFuel();

  const mutation = useMutation(
    async () => {
      const network = await fuel.currentNetwork();
      if (!wallet) {
        if (walletIsLoading) {
          updateLog('Connecting to wallet...');
        } else {
          throw new Error('Failed to connect to wallet');
        }
      }

      const resultPromise = new Promise(
        async (resolve: (data: DeployContractData) => void, reject) => {
          const contractFactory = new ContractFactory(
            bytecode,
            JSON.parse(abi) as JsonAbi,
            wallet
          );

          try {
            const contract = await contractFactory.deployContract({
              storageSlots: JSON.parse(storageSlots) as StorageSlot[],
            });
            resolve({
              contractId: contract.id.toB256(),
              networkUrl: network.url,
            });
          } catch (error) {
            reject(error);
          }
        }
      );

      const timeoutPromise = new Promise((_resolve, reject) =>
        setTimeout(
          () =>
            reject(
              new Error(
                `Request timed out after ${
                  DEPLOYMENT_TIMEOUT_MS / 1000
                } seconds`
              )
            ),
          DEPLOYMENT_TIMEOUT_MS
        )
      );

      return await Promise.race([resultPromise, timeoutPromise]);
    },
    {
      // Retry once if the wallet is still loading.
      retry: walletIsLoading && !wallet ? 1 : 0,
      onSuccess: onSuccess,
      onError: onError,
    }
  );

  return mutation;
}
