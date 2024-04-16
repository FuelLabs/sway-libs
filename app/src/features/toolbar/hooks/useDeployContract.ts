import { ContractFactory, JsonAbi, StorageSlot } from 'fuels';
import { useMutation } from '@tanstack/react-query';
import { useFuel, useWallet } from '@fuels/react';
import { track } from '@vercel/analytics/react';
import { useEffect, useState } from 'react';
import { toMetricProperties } from '../../../utils/metrics';

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
  const [metricMetadata, setMetricMetadata] = useState({});

  useEffect(() => {
    const waitForMetadata = async () => {
      const name = fuel.currentConnector()?.name ?? 'none';
      const networkUrl = wallet?.provider.url ?? 'none';
      const version = (await wallet?.provider.getVersion()) ?? 'none';
      setMetricMetadata({ name, version, networkUrl });
    };
    waitForMetadata();
  }, [wallet, fuel]);

  const mutation = useMutation({
    // Retry once if the wallet is still loading.
    retry: walletIsLoading && !wallet ? 1 : 0,
    onSuccess,
    onError: (error) => {
      console.error(`Deployment failed: ${error.message}`);
      track('Deploy Error', toMetricProperties(error, metricMetadata));
      onError(error);
    },
    mutationFn: async () => {
      if (!wallet) {
        if (walletIsLoading) {
          updateLog('Connecting to wallet...');
        } else {
          throw new Error('Failed to connect to wallet', {
            cause: { source: 'wallet' },
          });
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
              networkUrl: contract.provider.url,
            });
          } catch (error) {
            reject(
              new Error(`SDK Error: ${JSON.stringify(error)}`, {
                cause: { source: 'sdk' },
              })
            );
          }
        }
      );

      const timeoutPromise = new Promise((_resolve, reject) =>
        setTimeout(() => {
          reject(
            new Error(
              `Request timed out after ${DEPLOYMENT_TIMEOUT_MS / 1000} seconds`,
              { cause: { source: 'timeout' } }
            )
          );
        }, DEPLOYMENT_TIMEOUT_MS)
      );

      return await Promise.race([resultPromise, timeoutPromise]);
    },
  });

  return mutation;
}
