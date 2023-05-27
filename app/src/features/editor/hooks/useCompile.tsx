import styled from '@emotion/styled';
import ansicolor from 'ansicolor';
import React, { useState, useEffect } from 'react';
import {
  loadAbi,
  loadBytecode,
  saveAbi,
  saveBytecode,
} from '../../../utils/localStorage';
import { CopyableHex } from '../../../components/shared';

function toResults(
  prefixedBytecode: string,
  abi: string
): React.ReactElement[] {
  return [
    <div key={'bytecode'}>
      <b>Bytecode</b>:<br />
      <CopyableHex hex={prefixedBytecode} />
      <br />
      <br />
    </div>,
    <div key={'abi'}>
      <b>ABI:</b>
      <br />
      {abi}
    </div>,
  ];
}

function loadResults(): React.ReactElement[] | undefined {
  let abi = loadAbi();
  let bytecode = loadBytecode();
  if (!abi.length || !bytecode.length) {
    return undefined;
  }
  return toResults(bytecode, abi);
}

export function useCompile(
  code: string | undefined,
  onError: (error: string | undefined) => void,
  isCompiled: boolean,
  setIsCompiled: (isCompiled: boolean) => void
): React.ReactElement[] {
  const [results, setResults] = useState<React.ReactElement[]>([]);
  const [serverError, setServerError] = useState<boolean>(false);

  useEffect(() => {
    console.log('code: ', code);
    console.log('isCompiled: ', isCompiled);

    if (!code) {
      setResults(loadResults() ?? [<>Click 'Compile' to build your code.</>]);
      return;
    }

    if (!code.length) {
      setResults([<>Add some code to compile.</>]);
      return;
    }

    if (isCompiled) {
      return;
    }

    setResults([<>Compiling...</>]);

    // TODO: Determine the URL based on the NODE_ENV.
    const server_uri = 'https://api.sway-playground.org/compile';
    // const server_uri = 'https://127.0.0.1/compile';
    const request = new Request(server_uri, {
      method: 'POST',
      body: JSON.stringify({
        contents: code,
      }),
    });

    fetch(request)
      .then((response) => {
        if (response.status < 400) {
          return response.json();
        } else {
          setServerError(true);
        }
      })
      .then((response) => {
        const error = response.error;
        if (error.length) {
          // Preserve the ANSI color codes from the compiler output.
          let parsedAnsi = ansicolor.parse(error);
          let results = parsedAnsi.spans.map((span, i) => {
            const { text, css } = span;
            const Span = styled.span`
              ${css}
            `;
            return <Span key={`${i}-${text}`}>{text}</Span>;
          });
          setResults(results);
          saveAbi('');
          saveBytecode('');
        } else {
          const { abi, bytecode } = response;
          const prefixedBytecode = `0x${bytecode}`;
          saveAbi(abi);
          saveBytecode(prefixedBytecode);
          setResults(toResults(prefixedBytecode, abi));
        }
      })
      .catch(() => {
        console.error('Unexpected error compiling contract.');
        setServerError(true);
      });
    setIsCompiled(true);
  }, [code, isCompiled, results.length, setIsCompiled]);

  useEffect(() => {
    if (serverError) {
      onError(
        serverError
          ? 'There was an unexpected error compiling your contract. Please try again.'
          : undefined
      );
    }
  }, [serverError, onError]);

  return results;
}
