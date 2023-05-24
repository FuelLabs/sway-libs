import { DeployState, NetworkState } from '../../../utils/types';
import { useConnection } from '../hooks/useConnection';
import { Button } from '@fuel-ui/react';

interface NetworkButtonProps {
  setDeployState: React.Dispatch<React.SetStateAction<DeployState>>;
  setNetwork: React.Dispatch<React.SetStateAction<string>>;
  networkState: NetworkState;
  setNetworkState: React.Dispatch<React.SetStateAction<NetworkState>>;
}

export function ConnectionButton({
  setDeployState,
  setNetwork,
  networkState,
  setNetworkState,
}: NetworkButtonProps) {
  const connectMutation = useConnection(
    true,
    setNetwork,
    setNetworkState,
    setDeployState
  );

  function onConnectClick() {
    setNetworkState(NetworkState.CONNECTING);
    connectMutation.mutate();
  }

  const disConnectMutation = useConnection(
    false,
    setNetwork,
    setNetworkState,
    setDeployState
  );

  function onDisconnectClick() {
    setNetworkState(NetworkState.DISCONNECTING);
    disConnectMutation.mutate();
  }

  return (
    <>
      {networkState === NetworkState.CAN_CONNECT ? (
        <Button onPress={onConnectClick} type='button' color='green'>
          CONNECT
        </Button>
      ) : networkState === NetworkState.CONNECTING ? (
        <Button type='button' color='gray' isDisabled>
          CONNECTING...
        </Button>
      ) : networkState === NetworkState.CAN_DISCONNECT ? (
        <Button onPress={onDisconnectClick} type='button' color='red'>
          DISCONNECT
        </Button>
      ) : (
        <Button type='button' color='gray' isDisabled>
          {' '}
          DISCONNECTING...
        </Button>
      )}
    </>
  );
}
