import React from 'react';
import AceEditor from 'react-ace';
import 'ace-builds/src-noconflict/mode-rust';
import 'ace-builds/src-noconflict/theme-chrome';
import 'ace-builds/src-noconflict/ext-language_tools';
import { StyledBorder } from '../../../components/shared';

export interface EditorProps {
  code: string;
  onChange: (value: string) => void;
}

function Editor({ code, onChange }: EditorProps) {
  return (
    <StyledBorder>
      <AceEditor
        style={{ width: '100%' }}
        minLines={10}
        mode='rust'
        theme='chrome'
        name='editor'
        fontSize='14px'
        onChange={onChange}
        value={code}
        editorProps={{ $blockScrolling: true }}
      />
    </StyledBorder>
  );
}

export default Editor;
