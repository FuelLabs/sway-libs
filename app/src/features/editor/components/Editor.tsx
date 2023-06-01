import React from 'react';
import AceEditor from 'react-ace';
import 'ace-builds/webpack-resolver';
import 'ace-builds/src-noconflict/mode-rust';
import 'ace-builds/src-noconflict/theme-chrome';
import { StyledBorder } from '../../../components/shared';
import ActionOverlay from './ActionOverlay';
import { DEFAULT_CONTRACT } from '../../../constants';

export interface EditorProps {
  code: string;
  onChange: (value: string) => void;
}

function Editor({ code, onChange }: EditorProps) {
  return (
    <div>
      <ActionOverlay onClick={() => onChange(DEFAULT_CONTRACT)} />
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
