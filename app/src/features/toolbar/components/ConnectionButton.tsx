import React, { useMemo } from 'react';
import { DeployState, NetworkState } from '../../../utils/types';
import { useConnection } from '../hooks/useConnection';
import Button from '@mui/material/Button';
import { Spinner } from '@fuel-ui/react';
import { Tooltip } from '@mui/material';
import GppGoodIcon from '@mui/icons-material/GppGood';
import GppBadIcon from '@mui/icons-material/GppBad';

interface ConnectionButtonProps {
  networkState: NetworkState;
  setNetworkState: (state: NetworkState) => void;
  setDeployState: (state: DeployState) => void;
  setNetwork: (network: string) => void;
}

function ConnectionButton({
  setDeployState,
  setNetwork,
  networkState,
  setNetworkState,
}: ConnectionButtonProps) {
  const connectMutation = useConnection(
    true,
    setNetworkState,
    setDeployState,
    setNetwork
  );

  function onConnectClick() {
    setNetworkState(NetworkState.CONNECTING);
    connectMutation.mutate();
  }

  const disConnectMutation = useConnection(
    false,
    setNetworkState,
    setDeployState,
    setNetwork
  );

  function onDisconnectClick() {
    setNetworkState(NetworkState.DISCONNECTING);
    disConnectMutation.mutate();
  }

  const { text, tooltip, onClick, isDisabled, spinner } = useMemo(() => {
    return {
      text: [NetworkState.CAN_CONNECT, NetworkState.CONNECTING].includes(
        networkState
      )
        ? 'Connect'
        : 'Disconnect',
      tooltip: [NetworkState.CAN_CONNECT, NetworkState.CONNECTING].includes(
        networkState
      )
        ? 'Connect Fuel wallet'
        : 'Disconnect Fuel wallet',
      onClick:
        networkState === NetworkState.CAN_CONNECT
          ? onConnectClick
          : onDisconnectClick,
      isDisabled: [
        NetworkState.CONNECTING,
        NetworkState.DISCONNECTING,
      ].includes(networkState),
      spinner: networkState === NetworkState.CONNECTING,
    };
  }, [networkState, onConnectClick, onDisconnectClick]);

  return (
    <Tooltip title={tooltip}>
      <Button
        style={{ width: '128px' }}
        onClick={onClick}
        disabled={isDisabled}
        endIcon={spinner ? <Spinner size={18} /> : undefined}
        color='primary'
        variant='outlined'
        type='submit'>
        {text}
      </Button>
    </Tooltip>
  );
}

export default ConnectionButton;
