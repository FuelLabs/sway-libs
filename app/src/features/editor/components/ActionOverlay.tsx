import React from 'react';
import IconButton from '@mui/material/IconButton';
import Delete from '@mui/icons-material/Delete';

export interface ActionOverlayProps {
  onClick: () => void;
}

function ActionOverlay({ onClick }: ActionOverlayProps) {
  return (
    <div style={{ position: 'relative' }}>
      <div
        style={{
          position: 'absolute',
          height: '100%',
          width: '100%',
          zIndex: 1,
          pointerEvents: 'none',
        }}>
        <IconButton
          style={{
            position: 'absolute',
            right: '18px',
            top: '18px',
            pointerEvents: 'all',
          }}
          onClick={onClick}
          aria-label='reset the editor'>
          <Delete />
        </IconButton>
      </div>
    </div>
  );
}

export default ActionOverlay;
