import React from 'react';
import SolidityEditor from './SolidityEditor';
import SwayEditor from './SwayEditor';
import { Toolchain } from './ToolchainDropdown';
import { useIsMobile } from '../../../hooks/useIsMobile';

export interface EditorViewProps {
  swayCode: string;
  onSwayCodeChange: (value: string) => void;
  solidityCode: string;
  onSolidityCodeChange: (value: string) => void;
  toolchain: Toolchain;
  setToolchain: (toolchain: Toolchain) => void;
  showSolidity: boolean;
}

function EditorView({
  swayCode,
  solidityCode,
  onSolidityCodeChange,
  onSwayCodeChange,
  toolchain,
  setToolchain,
  showSolidity,
}: EditorViewProps) {
  const isMobile = useIsMobile();

  return (
    <div
      style={{
        display: 'flex',
        flexDirection: isMobile ? 'column' : 'row',
        height: '50vh',
        minHeight: '10vh',
        maxHeight: '80vh',
        position: 'relative',
        resize: isMobile ? 'none' : 'vertical',
        overflow: 'auto',
      }}>
      {showSolidity && (
        <SolidityEditor code={solidityCode} onChange={onSolidityCodeChange} />
      )}
      <SwayEditor
        code={swayCode}
        onChange={onSwayCodeChange}
        toolchain={toolchain}
        setToolchain={setToolchain}
      />
    </div>
  );
}

export default EditorView;
