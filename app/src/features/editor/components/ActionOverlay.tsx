import React from 'react';
import ToolchainDropdown, { Toolchain } from './ToolchainDropdown';
import ExampleDropdown from './ExampleDropdown';
import { EXAMPLE_CONTRACTS } from '../examples';

export type EditorLanguage = 'sway' | 'solidity';

export interface ActionOverlayProps {
  handleSelectExample: (example: string) => void;
  toolchain?: Toolchain;
  setToolchain?: (toolchain: Toolchain) => void;
  editorLanguage: EditorLanguage;
}

function ActionOverlay({
  handleSelectExample,
  toolchain,
  setToolchain,
  editorLanguage,
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
        <div
          style={{
            position: 'absolute',
            right: '22px',
            top: '22px',
            pointerEvents: 'all',
          }}>
          {toolchain && setToolchain && (
            <ToolchainDropdown
              style={{ marginRight: '18px' }}
              toolchain={toolchain}
              setToolchain={setToolchain}
            />
          )}
          <ExampleDropdown
            handleSelect={handleSelectExample}
            examples={EXAMPLE_CONTRACTS[editorLanguage]}
          />
        </div>
      </div>
    </div>
  );
}

export default ActionOverlay;
