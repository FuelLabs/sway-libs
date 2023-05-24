import { toast } from '@fuel-ui/react';
import { useCallback, useEffect } from 'react';
import { DeployState } from '../../../utils/types';
import { useFuel } from './useFuel';

export function useNetwork(
  setNetwork: React.Dispatch<React.SetStateAction<string>>,
  setDeployState: React.Dispatch<React.SetStateAction<DeployState>>
) {
  const [fuel] = useFuel();

  if (!fuel) toast.error('Fuel wallet could not be found');

  const handleNetworkChange = useCallback(
    async (network: any) => {
      setNetwork(network.url);
      setDeployState(DeployState.NOT_DEPLOYED);
    },
    [setDeployState, setNetwork]
  );

  useEffect(() => {
    fuel?.on('network', handleNetworkChange);

    return () => {
      fuel?.off('network', handleNetworkChange);
    };
  }, [fuel, handleNetworkChange]);
}

export default useNetwork;
