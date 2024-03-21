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
  editorLanguage
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
        {(toolchain && setToolchain) && <ToolchainDropdown
          style={{
            position: 'absolute',
            right: '68px',
            top: '18px',
            pointerEvents: 'all',
          }}
          toolchain={toolchain}
          setToolchain={setToolchain}
        />}
        <ExampleDropdown handleSelect={handleSelectExample} examples={EXAMPLE_CONTRACTS[editorLanguage]} />
      </div>
    </div>
  );
}

export default ActionOverlay;
