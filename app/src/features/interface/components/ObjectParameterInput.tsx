import React, { useEffect, useMemo } from 'react';
import AceEditor from 'react-ace';
import 'ace-builds/src-noconflict/mode-json';
import 'ace-builds/src-noconflict/theme-chrome';
import 'ace-builds/src-noconflict/ext-language_tools';
import { StyledBorder } from '../../../components/shared';
import { CallableParamValue, InputInstance } from './FunctionParameters';

export interface ObjectParameterInputProps {
  value: string;
  input: InputInstance;
  onChange: (value: string) => void;
}

function ObjectParameterInput({
  value,
  input,
  onChange,
}: ObjectParameterInputProps) {
  // Construct the default object based to show in the JSON editor.
  const defaultObject = useMemo(() => {
    const getDefaultObject = (
      input: InputInstance
    ): Record<string, CallableParamValue> => {
      return !!input.components
        ? Object.fromEntries(
            input.components.map((nested: InputInstance) => {
              return [nested.name, getDefaultValue(nested)];
            })
          )
        : {};
    };

    const getDefaultValue = (inputInst: InputInstance): CallableParamValue => {
      switch (inputInst.type.simpleType) {
        case 'string':
          return '';
        case 'number':
          return 0;
        case 'bool':
          return false;
        case 'object':
          return getDefaultObject(inputInst);
      }
    };

    return !!input.components
      ? Object.fromEntries(
          input.components.map((nested) => {
            return [nested.name, getDefaultValue(nested)];
          })
        )
      : {};
  }, [input.components]);

  useEffect(() => {
    const defaultValue = JSON.stringify(defaultObject, null, 2);
    if (!value) {
      onChange(defaultValue);
    }
  }, [defaultObject, onChange, value]);

  const lines = useMemo(
    () => (value ? value.split('\n').length + 1 : 2),
    [value]
  );

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
        onChange={onChange}
        value={value}
        editorProps={{ $blockScrolling: true }}
      />
    </StyledBorder>
  );
}

export default ObjectParameterInput;
