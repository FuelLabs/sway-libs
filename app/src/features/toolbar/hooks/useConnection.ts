import { useMutation } from '@tanstack/react-query';
import { useFuel } from './useFuel';
import { DeployState, NetworkState } from '../../../utils/types';
import { displayError } from '../../../utils/error';

export function useConnection(
  connect: boolean,
  setNetworkState: (state: NetworkState) => void,
  setDeployState: (state: DeployState) => void,
  setNetwork: (network: string) => void
) {
  const [fuel] = useFuel();

  const mutation = useMutation(
    async () => {
      if (!!fuel) {
        const isConnected = await fuel.isConnected();
        if (connect) {
          if (!isConnected) {
            setNetworkState(NetworkState.CONNECTING);
            await fuel.connect();
          }
          const provider = await fuel.getProvider();
          if (!!provider) {
            return provider.url;
          }
        } else {
          if (isConnected) {
            setNetworkState(NetworkState.DISCONNECTING);
            await fuel.disconnect();
          }
        }
      }
      return '';
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
