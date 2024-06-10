import React, { useEffect, useMemo } from "react";
import AceEditor from "react-ace";
import "ace-builds/webpack-resolver";
import "ace-builds/src-noconflict/mode-json";
import "ace-builds/src-noconflict/theme-chrome";
import "ace-builds/src-noconflict/theme-tomorrow_night_bright";
import useTheme from "../../../context/theme";
import { StyledBorder } from "../../../components/shared";
import {
  CallableParamValue,
  InputInstance,
  ObjectParamValue,
  VectorParamValue,
} from "./FunctionParameters";

export interface ComplexParameterInputProps {
  value: string;
  input: InputInstance;
  onChange: (value: string) => void;
}

function ComplexParameterInput({
  value,
  input,
  onChange,
}: ComplexParameterInputProps) {
  // Construct the default object based to show in the JSON editor.
  const defaultObjectOrVector = useMemo(() => {
    const getDefaultObject = (input: InputInstance): ObjectParamValue => {
      return input.components
        ? Object.fromEntries(
            input.components.map((nested: InputInstance) => {
              return [nested.name, getDefaultValue(nested)];
            }),
          )
        : {};
    };

    const getDefaultVector = (input: InputInstance): VectorParamValue => {
      return input.components?.map(getDefaultValue) ?? [];
    };

    const getDefaultValue = (input: InputInstance): CallableParamValue => {
      switch (input.type.literal) {
        case "string":
          return "";
        case "number":
          return 0;
        case "bool":
          return false;
        case "enum":
        case "option":
        case "object":
          return getDefaultObject(input);
        case "vector":
          return getDefaultVector(input);
      }
    };

    return getDefaultValue(input);
  }, [input]);

  useEffect(() => {
    const defaultValue = JSON.stringify(defaultObjectOrVector, null, 4);
    if (!value) {
      onChange(defaultValue);
    }
  }, [defaultObjectOrVector, onChange, value]);

  const lines = useMemo(
    () => (value ? value.split("\n").length + 1 : 2),
    [value],
  );

  const { editorTheme, themeColor } = useTheme();

  return (
    <StyledBorder themeColor={themeColor}>
      <AceEditor
        style={{ width: "100%" }}
        minLines={lines}
        maxLines={lines}
        mode="json"
        theme={editorTheme}
        name="editor"
        fontSize="14px"
        onChange={onChange}
        value={value}
        editorProps={{ $blockScrolling: true }}
      />
    </StyledBorder>
  );
}

export default ComplexParameterInput;
