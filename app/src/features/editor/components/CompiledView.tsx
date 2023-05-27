import React from 'react';

import { StyledBorder } from '../../../components/shared';
export interface CompiledViewProps {
  results: React.ReactElement[];
}

function CompiledView({ results }: CompiledViewProps) {
  return (
    <StyledBorder
      style={{
        background: 'white',
        color: 'black',
        padding: '15px',
        overflow: 'auto',
        marginTop: '15px',
      }}>
      <pre style={{ fontSize: '14px', margin: 0 }}>
        {results.map((element, index) => (
          <div key={`${index}`}>{element}</div>
        ))}
      </pre>
    </StyledBorder>
  );
}

export default CompiledView;
