import React from "react";
import { useIsMobile } from "../../../hooks/useIsMobile";
import JsonEditor from "./JsonEditor";
import { TextField } from "@mui/material";

export interface AbiEditorViewProps {
  abiCode: string;
  onAbiCodeChange: (value: string) => void;
  contractId: string;
  setContractId: (contractId: string) => void;
}

function AbiEditorView({
  abiCode,
  onAbiCodeChange,
  contractId,
  setContractId,
}: AbiEditorViewProps) {
  const isMobile = useIsMobile();

  return (
    <div>
      <TextField
        id="contract-id"
        label="Contract ID"
        variant="outlined"
        size="small"
        value={contractId}
        onChange={(e) => setContractId(e.target.value)}
        style={{ width: "100%", marginBottom: "10px" }}
      />
      <div
        style={{
          display: "flex",
          flexDirection: isMobile ? "column" : "row",
          height: "50vh",
          minHeight: "10vh",
          maxHeight: "80vh",
          position: "relative",
          resize: isMobile ? "none" : "vertical",
          overflow: "auto",
        }}
      >
        <JsonEditor code={abiCode} onChange={onAbiCodeChange} />
      </div>
    </div>
  );
}

export default AbiEditorView;
