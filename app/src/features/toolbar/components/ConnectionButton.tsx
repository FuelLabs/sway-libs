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

  const { text, onClick, isDisabled, endIcon } = useMemo(() => {
    if (networkState === NetworkState.CAN_CONNECT) {
      return {
        text: 'Link wallet',
        onClick: onConnectClick,
        isDisabled: false,
        endIcon: <GppBadIcon />,
      };
    } else if (networkState === NetworkState.CONNECTING) {
      return {
        text: 'Connecting',
        onClick: () => {},
        isDisabled: true,
        endIcon: <Spinner size={18} />,
      };
    } else if (networkState === NetworkState.CAN_DISCONNECT) {
      return {
        text: 'Unlink wallet',
        onClick: onDisconnectClick,
        isDisabled: false,
        endIcon: <GppGoodIcon />,
      };
    } else {
      return {
        text: 'Disconnecting',
        onClick: () => {},
        isDisabled: true,
        endIcon: <Spinner size={18} />,
      };
    }
  }, [networkState, onConnectClick, onDisconnectClick]);

  return (
    <Tooltip title={text}>
      <Button
        onClick={onClick}
        disabled={isDisabled}
        endIcon={endIcon}
        color='primary'
        variant='outlined'
        type='submit'>
        Wallet
      </Button>
    </Tooltip>
  );
}

export default ConnectionButton;
