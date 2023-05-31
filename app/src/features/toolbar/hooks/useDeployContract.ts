import { ContractFactory, JsonAbi } from 'fuels';
import { useMutation } from '@tanstack/react-query';
import { useWallet } from './useWallet';

const DEPLOYMENT_TIMEOUT_MS = 120000;

export function useDeployContract(
  abi: string,
  bytecode: string,
  onError: (error: any) => void,
  onSuccess: (data: any) => void
) {
  const { wallet } = useWallet();

  const mutation = useMutation(
    async () => {
      if (!wallet) {
        throw new Error('Wallet is not connected');
      }

      const contractIdPromise = new Promise(async (resolve, reject) => {
        const contractFactory = new ContractFactory(
          bytecode,
          JSON.parse(abi) as JsonAbi,
          wallet
        );

        try {
          const contract = await contractFactory.deployContract({
            storageSlots: [],
          });
          resolve(contract.id.toB256());
        } catch (error) {
          reject(error);
        }
      });

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

      return await Promise.race([contractIdPromise, timeoutPromise]);
    },
    {
      onSuccess: onSuccess,
      onError: onError,
    }
  );

  return mutation;
}
