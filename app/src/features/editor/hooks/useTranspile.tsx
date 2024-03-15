import styled from '@emotion/styled';
import ansicolor from 'ansicolor';
import React, { useState, useEffect } from 'react';
import {
  saveAbi,
  saveBytecode,
  saveStorageSlots,
} from '../../../utils/localStorage';

export function useTranspile(
  code: string | undefined,
  setCodeToCompile: (code: string | undefined) => void,
  onSwayCodeChange: (code: string) => void,
  onError: (error: string | undefined) => void,
  setResults: (entry: React.ReactElement[]) => void
) {
  const [serverError, setServerError] = useState<boolean>(false);

  useEffect(() => {
    if (!code) {
      return;
    }
    setResults([
      <>
        Transpiling Solidity code with{' '}
        <a href='https://github.com/camden-smallwood/charcoal'>charcoal</a>...
      </>,
    ]);

    // TODO: Determine the URL based on the NODE_ENV.
    // const server_uri = 'https://api.sway-playground.org/compile';
    const server_uri = 'http://0.0.0.0:8080/transpile';
    const request = new Request(server_uri, {
      method: 'POST',
      body: JSON.stringify({
        contract: code,
        lanaguage: 'solidity',
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
        const { error, swayContract } = response;
        if (error) {
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
        } else {
          // Tell the useCompile hook to start compiling.
          onSwayCodeChange(swayContract);
          setCodeToCompile(swayContract);
          setResults([<>Successfully transpiled Solidity contract to Sway.</>]);
        }
      })
      .catch(() => {
        console.error('Unexpected error transpiling contract.');
        setServerError(true);
      });
  }, [code, setResults]);

  useEffect(() => {
    if (serverError) {
      onError(
        'There was an unexpected error transpiling your contract. Please try again.'
      );
    }
  }, [serverError, onError]);
}
