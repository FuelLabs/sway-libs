import React, { useCallback, useState } from 'react';
import Editor from './features/editor/components/Editor';
import ActionMenu from './components/ActionMenu';
import { DEFAULT_CONTRACT } from './constants';
import CompiledView from './features/editor/components/CompiledView';
import ErrorToast from './components/ErrorToast';
import { useCompile } from './features/editor/hooks/useCompile';
import { ContractInterface } from './features/interface/components/ContractInterface';
import { Interface } from './features/interface/components/Interface';
import { DeployState } from './utils/types';

function App() {
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

  // An error message to display to the user.
  const [error, setError] = useState<string | undefined>(undefined);

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

      <ActionMenu
        onCompile={() => setCodeToCompile(code)}
        resetEditor={() => onCodeChange(DEFAULT_CONTRACT)}
      />
      <div style={{ display: 'flex' }}>
        <div style={{ flex: '50%', overflow: 'auto', margin: 0 }}>
          <Editor code={code} onChange={onCodeChange} />
          <CompiledView results={results} />
        </div>
        <div style={{ flex: '50%' }}>
          <Interface
            deployState={deployState}
            setDeployState={setDeployState}
          />
        </div>
      </div>
    </div>
  );
}

export default App;
