import React, { useCallback, useEffect, useState } from 'react';
import Editor from './features/editor/components/Editor';
import ActionToolbar from './features/toolbar/components/ActionToolbar';
import { DEFAULT_CONTRACT } from './constants';
import CompiledView from './features/editor/components/CompiledView';
import { useCompile } from './features/editor/hooks/useCompile';
import { DeployState, NetworkState } from './utils/types';
import Drawer from '@mui/material/Drawer';
import ActionOverlay from './features/editor/components/ActionOverlay';
import { toast } from 'react-hot-toast';
import { ContractInterface } from './features/interact/components/ContractInterface';

const DRAWER_WIDTH = '50vw';

function App() {
  // const theme = useTheme();

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

  // The network connection state.
  const [networkState, setNetworkState] = useState(NetworkState.CAN_CONNECT);

  // An error message to display to the user.
  const [error, setError] = useState<string | undefined>(undefined);

  // The contract ID of the deployed contract.
  const [contractId, setContractId] = useState('');

  // Whether or not the current code in the editor has been compiled.
  const [isCompiled, setIsCompiled] = useState(false);

  // An error message to display to the user.
  const [drawerOpen, setDrawerOpen] = useState(false);

  useEffect(() => {
    setIsCompiled(false);
  }, [code]);

  const onCodeChange = useCallback(
    (code: string) => {
      saveCode(code);
      setCode(code);
    },
    [saveCode, setCode]
  );

  const results = useCompile(
    codeToCompile,
    setError,
    isCompiled,
    setIsCompiled
  );

  useEffect(() => {
    if (!!error?.length) {
      toast.error(error ?? '');
      setError(undefined);
    }
  }, [error, setError]);

  return (
    <div
      style={{
        minHeight: '100vh',
        padding: '15px',
        margin: '0px',
        background: '#F1F1F1',
      }}>
      <ActionToolbar
        deployState={deployState}
        contractId={contractId}
        setContractId={setContractId}
        onCompile={() => setCodeToCompile(code)}
        isCompiled={isCompiled}
        setDeployState={setDeployState}
        networkState={networkState}
        setNetworkState={setNetworkState}
        toggleDrawer={() => setDrawerOpen(!drawerOpen)}
      />

      <div
        style={{
          marginRight: drawerOpen ? DRAWER_WIDTH : 0,
          transition: 'margin 195ms cubic-bezier(0.4, 0, 0.6, 1) 0ms',
        }}>
        <ActionOverlay onClick={() => onCodeChange(DEFAULT_CONTRACT)} />
        <Editor code={code} onChange={onCodeChange} />
        <CompiledView results={results} />
      </div>
      <Drawer
        PaperProps={{
          sx: {
            background: '#F1F1F1',
          },
        }}
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
        <div
          style={{
            width: '100%',
          }}>
          <ContractInterface contractId={contractId} />
        </div>
      </Drawer>
    </div>
  );
}

export default App;
