import React, { useMemo } from 'react';
import { DeployState, NetworkState } from '../../../utils/types';
import { useConnection } from '../hooks/useConnection';
import { ButtonSpinner } from '../../../components/shared';
import SecondaryButton from '../../../components/SecondaryButton';
import { useFuel } from '../hooks/useFuel';

interface ConnectionButtonProps {
  networkState: NetworkState;
  setNetworkState: (state: NetworkState) => void;
  setDeployState: (state: DeployState) => void;
}

function ConnectionButton({
  setDeployState,
  networkState,
  setNetworkState,
}: ConnectionButtonProps) {
  const [fuel] = useFuel();
  const connectMutation = useConnection(true, setNetworkState, setDeployState);

  const disConnectMutation = useConnection(
    false,
    setNetworkState,
    setDeployState
  );

  const { tooltip, onClick } = useMemo(() => {
    function onConnectClick() {
      setNetworkState(NetworkState.CONNECTING);
      connectMutation.mutate();
    }

    function onDisconnectClick() {
      setNetworkState(NetworkState.DISCONNECTING);
      disConnectMutation.mutate();
    }

    return {
      tooltip: !!fuel
        ? 'Connect Fuel wallet'
        : 'Install Fuel wallet to connect to the network',
      onClick:
        networkState === NetworkState.CAN_CONNECT
          ? onConnectClick
          : onDisconnectClick,
    };
  }, [
    connectMutation,
    disConnectMutation,
    fuel,
    networkState,
    setNetworkState,
  ]);

  return (
    <SecondaryButton
      style={{ minWidth: '115px', marginLeft: '15px' }}
      onClick={onClick}
      text='CONNECT'
      disabled={
        !fuel ||
        [NetworkState.CONNECTING, NetworkState.DISCONNECTING].includes(
          networkState
        )
      }
      endIcon={
        networkState === NetworkState.CONNECTING ? <ButtonSpinner /> : undefined
      }
      tooltip={tooltip}
    />
  );
}

export default ConnectionButton;
