import { useCallback, useEffect } from 'react';
import { DeployState } from '../../../utils/types';
import { useFuel } from './useFuel';

export function useNetwork(
  setNetwork: React.Dispatch<React.SetStateAction<string>>,
  setDeployState: React.Dispatch<React.SetStateAction<DeployState>>
) {
  const [fuel] = useFuel();

  const handleNetworkChange = useCallback(
    async (network: any) => {
      setNetwork(network.url);
      setDeployState(DeployState.NOT_DEPLOYED);
    },
    [setDeployState, setNetwork]
  );

  useEffect(() => {
    if (!!fuel) {
      // Register event listeners.
      fuel.on('network', handleNetworkChange);
      fuel.off('network', handleNetworkChange);
    }
  }, [fuel, handleNetworkChange]);
}

export default useNetwork;
