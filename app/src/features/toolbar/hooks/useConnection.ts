import { useMutation } from '@tanstack/react-query';
import { useFuel } from './useFuel';
import { DeployState, NetworkState } from '../../../utils/types';

export function useConnection(
  connect: boolean,
  setNetworkState: (state: NetworkState) => void,
  setDeployState: (state: DeployState) => void,
  setError: (error: string) => void
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

  function handleError(error: string) {
    setError(error);
    if (connect) {
      setNetworkState(NetworkState.CAN_CONNECT);
    }
  }

  function handleSuccess(data: string) {
    if (data === '') {
      setNetworkState(NetworkState.CAN_CONNECT);
      setDeployState(DeployState.NOT_DEPLOYED);
    } else {
      setNetworkState(NetworkState.CAN_DISCONNECT);
    }
  }

  return mutation;
}
