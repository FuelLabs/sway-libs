import React, { useCallback, useState } from 'react';
import Editor from './components/Editor';
import ActionMenu from './components/ActionMenu';
import { DEFAULT_CONTRACT } from './constants';
import CompiledView from './components/CompiledView';
import ErrorToast from './components/ErrorToast';
import { useCompile } from './hooks/useCompile';

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
      <ErrorToast open={!!error} onClose={() => setError(undefined)} />

      <ActionMenu
        onCompile={() => setCodeToCompile(code)}
        resetEditor={() => setCode(DEFAULT_CONTRACT)}
      />
      <Editor code={code} onChange={onCodeChange} />

      <CompiledView results={results} />
    </div>
  );
}

export default App;
