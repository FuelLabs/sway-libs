import React from "react";
import AceEditor from "react-ace";
import "ace-builds/webpack-resolver";
import "ace-builds/src-noconflict/mode-json";
import "ace-builds/src-noconflict/theme-chrome";
import "ace-builds/src-noconflict/theme-tomorrow_night_bright";
import { StyledBorder } from "../../../components/shared";
import useTheme from "../../../context/theme";

export interface JsonEditorProps {
  code: string;
  onChange: (value: string) => void;
}

function JsonEditor({ code, onChange }: JsonEditorProps) {
  const { editorTheme, themeColor } = useTheme();

  return (
    <StyledBorder style={{ flex: 1 }} themeColor={themeColor}>
      <AceEditor
        style={{
          width: "100%",
          height: "100%",
        }}
        mode="json"
        theme={editorTheme}
        name="editor"
        fontSize="14px"
        onChange={onChange}
        value={code}
        editorProps={{ $blockScrolling: true }}
      />
    </StyledBorder>
  );
}

export default JsonEditor;
