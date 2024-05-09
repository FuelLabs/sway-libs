import React, { useState, useEffect, useCallback } from 'react';
import Divider from '@mui/material/Divider';
import { darkColors } from '@fuel-ui/css';

const RESULT_LINE_LIMIT = 500;

export function useLog(): [React.ReactElement[], (entry?: string | React.ReactElement[]) => void] {
  // The complete results to show in the compilation output section.
  const [results, setResults] = useState<React.ReactElement[]>([]);

  // The most recent results to add to the compilation output section.
  const [resultsToAdd, setResultsToAdd] = useState<React.ReactElement[]>();
  const resultsToAddRef = React.useRef<React.ReactElement[]>();

  const updateLog = useCallback(
    (entry?: string | React.ReactElement[]) => {
      if (!!entry) {
        setResultsToAdd(
          typeof entry === 'string' ? [<div>{entry}</div>] : entry
        );
      }
    },
    [setResultsToAdd]
  );

  // Update the results to show only if there are new results to add.
  useEffect(() => {
    if (resultsToAdd && resultsToAdd !== resultsToAddRef.current) {
      resultsToAddRef.current = resultsToAdd;
      const newResults = [...results];
      if (newResults.length > 0) {
        newResults.push(
          <Divider style={{ margin: '10px 0 10px', color: darkColors.gray6 }}>
            {new Date().toLocaleString()}
          </Divider>
        );
      }
      newResults.push(...resultsToAdd);
      if (newResults.length > RESULT_LINE_LIMIT) {
        setResults(newResults.slice(newResults.length - RESULT_LINE_LIMIT));
      } else {
        setResults(newResults);
      }
    }
  }, [results, resultsToAdd, resultsToAddRef, setResults]);

  return [results, updateLog] ;
}
