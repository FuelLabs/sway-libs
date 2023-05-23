import styled from '@emotion/styled';
import ansicolor from 'ansicolor';
import React, { useState, useEffect } from 'react';

export function useCompile(
  code: string | undefined,
  onError: (error: string | undefined) => void
): React.ReactElement[] {
  const [results, setResults] = useState<React.ReactElement[]>([]);
  const [serverError, setServerError] = useState<boolean>(false);

  useEffect(() => {
    if (!code) {
      setResults([<>Click 'Compile' to build your code.</>]);
      return;
    }

    if (!code.length) {
      setResults([<>Add some code to compile.</>]);
      return;
    }

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
            return <Span>{text}</Span>;
          });
          setResults(results);
        } else {
          setResults([
            <>
              <b>Bytecode</b>:<br />
              0x{response.bytecode}
              <br />
              <br />
            </>,
            <>
              <b>ABI:</b>
              <br />
              {response.abi}
            </>,
          ]);
        }
      })
      .catch(() => {
        console.error('Unexpected error compiling contract.');
        setServerError(true);
      });
  }, [code]);

  useEffect(() => {
    if (serverError) {
      onError(
        serverError
          ? 'There was an unexpected error compiling your contract. Please try again.'
          : undefined
      );
      //   setServerError(false);
    }
  }, [serverError, onError]);

  return results;
}
