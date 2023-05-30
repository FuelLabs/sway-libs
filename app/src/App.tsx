import React, { useCallback, useState } from 'react';
import Editor from './features/editor/components/Editor';
import ActionToolbar from './features/toolbar/components/ActionToolbar';
import { DEFAULT_CONTRACT } from './constants';
import CompiledView from './features/editor/components/CompiledView';
import { useCompile } from './features/editor/hooks/useCompile';
import { DeployState, NetworkState } from './utils/types';
import Drawer from '@mui/material/Drawer';
import ActionOverlay from './features/editor/components/ActionOverlay';
import { ContractInterface } from './features/interact/components/ContractInterface';
import ErrorToast from './components/ErrorToast';
import { loadCode, saveCode } from './utils/localStorage';

const DRAWER_WIDTH = '50vw';

function App() {
  // The current code in the editor.
  const [code, setCode] = useState(loadCode() ?? DEFAULT_CONTRACT);

  // The most recent code that the user has requested to compile.
  const [codeToCompile, setCodeToCompile] = useState<string | undefined>(
    undefined
  );

  // Whether or not the current code in the editor has been compiled.
  const [isCompiled, setIsCompiled] = useState(false);

  // The compilation results.
  const [results, setResults] = useState<React.ReactElement[]>([]);

  // The deployment state
  const [deployState, setDeployState] = useState(DeployState.NOT_DEPLOYED);

  // The network connection state.
  const [networkState, setNetworkState] = useState(NetworkState.CAN_CONNECT);

  // An error message to display to the user.
  const [error, setError] = useState<string | undefined>(undefined);

  // The contract ID of the deployed contract.
  const [contractId, setContractId] = useState('');

  // An error message to display to the user.
  const [drawerOpen, setDrawerOpen] = useState(false);

  const onCodeChange = useCallback(
    (code: string) => {
      saveCode(code);
      setCode(code);
      setIsCompiled(false);
    },
    [setCode]
  );

  useCompile(codeToCompile, setError, setIsCompiled, setResults);

  return (
    <div
      style={{
        minHeight: '100vh',
        padding: '15px',
        margin: '0px',
        background: '#F1F1F1',
      }}>
      <ErrorToast message={error} onClose={() => setError(undefined)} />
      <ActionToolbar
        deployState={deployState}
        setContractId={setContractId}
        onCompile={() => setCodeToCompile(code)}
        isCompiled={isCompiled}
        setDeployState={setDeployState}
        networkState={networkState}
        setNetworkState={setNetworkState}
        toggleDrawer={() => setDrawerOpen(!drawerOpen)}
        setError={setError}
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
          <ContractInterface contractId={contractId} setError={setError} />
        </div>
      </Drawer>
    </div>
  );
}

export default App;
