import React from 'react';
import AceEditor from 'react-ace';
import 'ace-builds/webpack-resolver';
import 'ace-builds/src-noconflict/mode-rust';
import 'ace-builds/src-noconflict/theme-chrome';
import { StyledBorder } from '../../../components/shared';
import 'ace-mode-solidity/build/remix-ide/mode-solidity';
import ActionOverlay from './ActionOverlay';
import { DEFAULT_SOLIDITY_CONTRACT } from '../../../constants';

export interface SolidityEditorProps {
  code: string;
  onChange: (value: string) => void;
}

function SolidityEditor({ code, onChange }: SolidityEditorProps) {
  return (
    <div>
      <ActionOverlay handleReset={() => onChange(DEFAULT_SOLIDITY_CONTRACT)} />
      <StyledBorder>
        <AceEditor
          style={{
            width: '100%',
            resize: 'vertical',
            minHeight: '10vh',
            maxHeight: '80vh',
          }}
          mode='solidity'
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

export default SolidityEditor;
