import { useCallback, useEffect, useState } from "react";
import LogView from "./features/editor/components/LogView";
import { loadAbi, saveAbi, saveSwayCode } from "./utils/localStorage";
import InteractionDrawer from "./features/interact/components/InteractionDrawer";
import { useLog } from "./features/editor/hooks/useLog";
import { Analytics } from "@vercel/analytics/react";
import useTheme from "./context/theme";
import AbiActionToolbar from "./features/toolbar/components/AbiActionToolbar";
import AbiEditorView from "./features/editor/components/AbiEditorView";

const DRAWER_WIDTH = "40vw";

function AbiApp() {
  // The current sway code in the editor.
  const [abiCode, setAbiCode] = useState<string>(loadAbi());

  // Functions for reading and writing to the log output.
  const [log, updateLog] = useLog();

  // The contract ID of the deployed contract.
  const [contractId, setContractId] = useState("");

  // An error message to display to the user.
  const [drawerOpen, setDrawerOpen] = useState(false);

  // The theme color for the app.
  const { themeColor } = useTheme();

  // Update the ABI in localstorage when the editor changes.
  useEffect(() => {
    saveAbi(abiCode);
  }, [abiCode]);

  const onSwayCodeChange = useCallback(
    (code: string) => {
      saveSwayCode(code);
      setAbiCode(code);
    },
    [setAbiCode],
  );

  return (
    <div
      style={{
        padding: "15px",
        margin: "0px",
        background: themeColor("white4"),
      }}
    >
      <AbiActionToolbar drawerOpen={drawerOpen} setDrawerOpen={setDrawerOpen} />
      <div
        style={{
          marginRight: drawerOpen ? DRAWER_WIDTH : 0,
          transition: "margin 195ms cubic-bezier(0.4, 0, 0.6, 1) 0ms",
          height: "calc(100vh - 95px)",
          display: "flex",
          flexDirection: "column",
        }}
      >
        <AbiEditorView
          abiCode={abiCode}
          onAbiCodeChange={onSwayCodeChange}
          contractId={contractId}
          setContractId={setContractId}
        />
        <LogView results={log} />
      </div>
      <InteractionDrawer
        isOpen={drawerOpen}
        width={DRAWER_WIDTH}
        contractId={contractId}
        updateLog={updateLog}
      />
      <Analytics />
    </div>
  );
}

export default AbiApp;
