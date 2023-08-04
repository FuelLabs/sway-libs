import React from 'react';
import AceEditor from 'react-ace';
import 'ace-builds/webpack-resolver';
import 'ace-builds/src-noconflict/mode-rust';
import 'ace-builds/src-noconflict/theme-chrome';
import { StyledBorder } from '../../../components/shared';
import ActionOverlay from './ActionOverlay';
import { DEFAULT_CONTRACT } from '../../../constants';
import { Toolchain } from './ToolchainDropdown';

export interface EditorProps {
  code: string;
  onChange: (value: string) => void;
  toolchain: Toolchain;
  setToolchain: (toolchain: Toolchain) => void;
}

function Editor({ code, onChange, toolchain, setToolchain }: EditorProps) {
  return (
    <div>
      <ActionOverlay
        handleReset={() => onChange(DEFAULT_CONTRACT)}
        toolchain={toolchain}
        setToolchain={setToolchain}
      />
      <StyledBorder>
        <AceEditor
          style={{ width: '100%', height: 'calc(60vh - 75px)' }}
          mode='rust'
          theme='chrome'
          name='editor'
          fontSize='14px'
          onChange={onChange}
          value={code}
          editorProps={{ $blockScrolling: true }}
        />
      </StyledBorder>
    </div>
  );
}

export default Editor;
