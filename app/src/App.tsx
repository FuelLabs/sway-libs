import React, { useCallback, useState } from 'react';
import Editor from './features/editor/components/Editor';
import ActionToolbar from './features/toolbar/components/ActionToolbar';
import { DEFAULT_CONTRACT } from './constants';
import CompiledView from './features/editor/components/CompiledView';
import ErrorToast from './components/ErrorToast';
import { useCompile } from './features/editor/hooks/useCompile';
import { ContractInterface } from './features/interact/components/ContractInterface';
import { Interface } from './features/interact/components/Interface';
import { DeployState, NetworkState } from './utils/types';
import { styled, useTheme } from '@mui/material/styles';
import IconButton from '@mui/material/IconButton';
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft';
import ChevronRightIcon from '@mui/icons-material/ChevronRight';
import Drawer from '@mui/material/Drawer';
import { lightGray } from 'ansicolor';
import Delete from '@mui/icons-material/Delete';

const DRAWER_WIDTH = '50vw';

function App() {
  const theme = useTheme();

  const saveCode = useCallback((code: string) => {
    localStorage.setItem('playground_contract', code);
  }, []);

  const loadCode = useCallback(() => {
    return localStorage.getItem('playground_contract') || '';
  }, []);

  // The current code in the editor.
  const [code, setCode] = useState(loadCode() ?? DEFAULT_CONTRACT);

  // The most recent code that the user has requested to compile.
  const [codeToCompile, setCodeToCompile] = useState<string | undefined>(
    undefined
  );

  // The deployment state
  const [deployState, setDeployState] = useState(DeployState.NOT_DEPLOYED);

  // The network URL.
  const [network, setNetwork] = useState('');

  // The network connection state.
  const [networkState, setNetworkState] = useState(NetworkState.CAN_CONNECT);

  // An error message to display to the user.
  const [error, setError] = useState<string | undefined>(undefined);

  // The contract ID of the deployed contract.
  const [contractId, setContractId] = useState('');

  const [isCompiling, setIsCompiling] = useState(false);

  // An error message to display to the user.
  const [drawerOpen, setDrawerOpen] = useState(false);

  const Main = styled('main', {
    shouldForwardProp: (prop) => prop !== 'open',
  })<{
    open?: boolean;
  }>(({ theme, open }) => ({
    flexGrow: 1,
    transition: theme.transitions.create('margin', {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
    marginRight: 0,
    ...(open && {
      transition: theme.transitions.create('margin', {
        easing: theme.transitions.easing.easeOut,
        duration: theme.transitions.duration.enteringScreen,
      }),
      marginRight: DRAWER_WIDTH,
    }),
  }));

  const onCodeChange = useCallback(
    (code: string) => {
      saveCode(code);
      setCode(code);
    },
    [saveCode, setCode]
  );

  const results = useCompile(codeToCompile, setError, setIsCompiling);

  return (
    <div>
      <ErrorToast message={error} onClose={() => setError(undefined)} />

      <ActionToolbar
        deployState={deployState}
        contractId={contractId}
        setContractId={setContractId}
        onCompile={() => setCodeToCompile(code)}
        isCompiling={isCompiling}
        setDeployState={setDeployState}
        setNetwork={setNetwork}
        networkState={networkState}
        setNetworkState={setNetworkState}
        toggleDrawer={() => setDrawerOpen(!drawerOpen)}
      />
      <Main open={drawerOpen}>
        <div style={{ position: 'relative' }}>
          <div
            style={{
              position: 'absolute',
              height: '100%',
              width: '100%',
              zIndex: 5000,
              pointerEvents: 'none',
            }}>
            <IconButton
              style={{
                position: 'absolute',
                right: '5px',
                top: '5px',
                zIndex: 5000,
                pointerEvents: 'all',
              }}
              onClick={() => onCodeChange(DEFAULT_CONTRACT)}
              aria-label='reset the editor'>
              <Delete />
            </IconButton>
          </div>

          <Editor code={code} onChange={onCodeChange} />
          <CompiledView results={results} />
        </div>

        {/* </div> */}
      </Main>
      <Drawer
        sx={{
          width: DRAWER_WIDTH,
          flexShrink: 0,
          '& .MuiDrawer-paper': {
            width: DRAWER_WIDTH,
          },
        }}
        variant='persistent'
        anchor='right'
        open={drawerOpen}>
        <div style={{ height: '100%', width: '100%', background: '#F1F1F1' }}>
          <Interface
            contractId={contractId}
            deployState={deployState}
            setDeployState={setDeployState}
            networkState={networkState}
            setNetwork={setNetwork}
          />
        </div>
      </Drawer>
    </div>
  );
}

export default App;
