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

const DRAWER_WIDTH = '500px';

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

  // An error message to display to the user.
  const [drawerOpen, setDrawerOpen] = useState(true);

  const Main = styled('main', {
    shouldForwardProp: (prop) => prop !== 'open',
  })<{
    open?: boolean;
  }>(({ theme, open }) => ({
    flexGrow: 1,
    padding: theme.spacing(3),
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

  const DrawerHeader = styled('div')(({ theme }) => ({
    display: 'flex',
    alignItems: 'center',
    padding: theme.spacing(0, 1),
    // necessary for content to be below app bar
    ...theme.mixins.toolbar,
    justifyContent: 'flex-start',
  }));

  const handleDrawerOpen = () => {
    setDrawerOpen(true);
  };

  const handleDrawerClose = () => {
    setDrawerOpen(false);
  };

  const onCodeChange = useCallback(
    (code: string) => {
      saveCode(code);
      setCode(code);
    },
    [saveCode, setCode]
  );

  const results = useCompile(codeToCompile, setError);

  return (
    <div>
      <ErrorToast message={error} onClose={() => setError(undefined)} />

      <ActionToolbar
        onCompile={() => setCodeToCompile(code)}
        resetEditor={() => onCodeChange(DEFAULT_CONTRACT)}
        setDeployState={setDeployState}
        setNetwork={setNetwork}
        networkState={networkState}
        setNetworkState={setNetworkState}
      />
      <Main open={drawerOpen}>
        {/* <div style={{ display: 'flex' }}> */}
        {/* <div style={{ flex: '50%', overflow: 'auto', margin: 0 }}> */}
        <div>
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
        <DrawerHeader>
          <IconButton onClick={handleDrawerClose}>
            {theme.direction === 'rtl' ? (
              <ChevronLeftIcon />
            ) : (
              <ChevronRightIcon />
            )}
          </IconButton>
        </DrawerHeader>
        <Interface
          deployState={deployState}
          setDeployState={setDeployState}
          networkState={networkState}
          setNetwork={setNetwork}
        />
      </Drawer>
    </div>
  );
}

export default App;
