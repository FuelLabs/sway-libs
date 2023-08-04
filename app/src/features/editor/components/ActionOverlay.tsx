import React from 'react';
import IconButton from '@mui/material/IconButton';
import Delete from '@mui/icons-material/Delete';
import ToolchainDropdown, { Toolchain } from './ToolchainDropdown';
import Tooltip from '@mui/material/Tooltip';

export interface ActionOverlayProps {
  handleReset: () => void;
  toolchain: Toolchain;
  setToolchain: (toolchain: Toolchain) => void;
}

function ActionOverlay({
  handleReset,
  toolchain,
  setToolchain,
}: ActionOverlayProps) {
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
        <ToolchainDropdown
          style={{
            position: 'absolute',
            right: '68px',
            top: '18px',
            pointerEvents: 'all',
          }}
          toolchain={toolchain}
          setToolchain={setToolchain}
        />
        <div>
          <Tooltip placement='top' title={'Reset the editor'}>
            <IconButton
              style={{
                position: 'absolute',
                right: '18px',
                top: '18px',
                pointerEvents: 'all',
              }}
              onClick={handleReset}
              aria-label='reset the editor'>
              <Delete />
            </IconButton>
          </Tooltip>
        </div>
      </div>
    </div>
  );
}

export default ActionOverlay;
