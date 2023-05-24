import { toast } from '@fuel-ui/react';
import { useMutation } from '@tanstack/react-query';
import { useFuel } from './useFuel';
import { DeployState, NetworkState } from '../../../utils/types';
import { displayError } from '../../../utils/error';

export function useConnection(
  connect: boolean,
  setNetwork: React.Dispatch<React.SetStateAction<string>>,
  setNetworkState: React.Dispatch<React.SetStateAction<NetworkState>>,
  setDeployState: React.Dispatch<React.SetStateAction<DeployState>>
) {
  const [fuel] = useFuel();
  if (!fuel) toast.error('Fuel wallet could not be found');

  const mutation = useMutation(
    async () => {
      const isConnected = await fuel.isConnected();
      if (connect) {
        if (!isConnected) {
          setNetworkState(NetworkState.CONNECTING);
          await fuel.connect();
        }
        let provider = await fuel.getProvider();
        if (provider !== undefined && provider !== null) {
          return provider.url;
        }
        return '';
      } else {
        if (isConnected) {
          setNetworkState(NetworkState.DISCONNECTING);
          await fuel.disconnect();
        }
        return '';
      }
    },
    {
      onSuccess: (data) => {
        handleSuccess(data);
      },
      onError: handleError,
    }
  );

  function handleError(error: any) {
    displayError(error);
    if (connect) {
      setNetworkState(NetworkState.CAN_CONNECT);
    }
  }

  function handleSuccess(data: any) {
    if (data === '') {
      setNetwork('');
      setNetworkState(NetworkState.CAN_CONNECT);
      setDeployState(DeployState.NOT_DEPLOYED);
    } else {
      setNetwork(data);
      setNetworkState(NetworkState.CAN_DISCONNECT);
    }
  }

  return mutation;
}
