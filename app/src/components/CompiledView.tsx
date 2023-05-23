import React from 'react';

import { StyledBorder } from './shared';

export interface CompiledViewProps {
  results: React.ReactElement[];
}

function CompiledView({ results }: CompiledViewProps) {
  return (
    <StyledBorder
      style={{
        background: 'white',
        padding: '15px',
        overflow: 'auto',
      }}>
      <pre style={{ fontSize: '14px' }}>{results}</pre>
    </StyledBorder>
  );
}

export default CompiledView;
