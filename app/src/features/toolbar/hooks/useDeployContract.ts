import { ContractFactory, JsonAbi, StorageSlot } from 'fuels';
import { useMutation } from '@tanstack/react-query';
import { useConnectors, useFuel, useWallet } from '@fuels/react';
import { track } from '@vercel/analytics/react';
import { useMemo } from 'react';

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
  const { connectors } = useConnectors();

  const walletName = useMemo(() => {
    const currentConnector = connectors.find(
      (connector) => connector.connected
    );
    return !!wallet && !!currentConnector ? currentConnector.name : 'none';
  }, [connectors, wallet]);

  const mutation = useMutation({
    // Retry once if the wallet is still loading.
    retry: walletIsLoading && !wallet ? 1 : 0,
    onSuccess,
    onError: (error) => {
      track('Deploy Error', { source: error.name, walletName });
      onError(error);
    },
    mutationFn: async () => {
      const { url: networkUrl } = await fuel.currentNetwork();
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
              networkUrl,
            });
          } catch (error) {
            track('Deploy Error', { source: 'sdk', networkUrl, walletName });
            reject(error);
          }
        }
      );

      const timeoutPromise = new Promise((_resolve, reject) =>
        setTimeout(() => {
          track('Deploy Error', { source: 'timeout', networkUrl, walletName });
          reject(
            new Error(
              `Request timed out after ${DEPLOYMENT_TIMEOUT_MS / 1000} seconds`
            )
          );
        }, DEPLOYMENT_TIMEOUT_MS)
      );

      return await Promise.race([resultPromise, timeoutPromise]);
    },
  });

  return mutation;
}
