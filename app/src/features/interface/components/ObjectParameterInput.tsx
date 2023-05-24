import React from 'react';
import AceEditor from 'react-ace';
import 'ace-builds/src-noconflict/mode-json';
import 'ace-builds/src-noconflict/theme-chrome';
import 'ace-builds/src-noconflict/ext-language_tools';
import { StyledBorder } from '../../../components/shared';

export interface ObjectParameterInputProps {
  // code: string;
  // onChange: (value: string) => void;
}

function ObjectParameterInput({}: ObjectParameterInputProps) {
  const value = `{ 
  "a": 1 
}`;
  const lines = value.split('\n').length;
  return (
    <StyledBorder>
      <AceEditor
        style={{ width: '100%' }}
        minLines={lines}
        maxLines={lines}
        mode='json'
        theme='chrome'
        name='editor'
        fontSize='14px'
        onChange={() => console.log('change')}
        value={value}
        editorProps={{ $blockScrolling: true }}
      />
    </StyledBorder>
  );
}

export default ObjectParameterInput;
