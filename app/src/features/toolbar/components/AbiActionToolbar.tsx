import React, { useCallback } from "react";
import OpenInNew from "@mui/icons-material/OpenInNew";
import SecondaryButton from "../../../components/SecondaryButton";
import { useIsMobile } from "../../../hooks/useIsMobile";
import SwitchThemeButton from "./SwitchThemeButton";
import { useConnectIfNotAlready } from "../hooks/useConnectIfNotAlready";
import { useDisconnect } from "@fuels/react";

export interface AbiActionToolbarProps {
  drawerOpen: boolean;
  setDrawerOpen: (open: boolean) => void;
}

function AbiActionToolbar({
  drawerOpen,
  setDrawerOpen,
}: AbiActionToolbarProps) {
  const isMobile = useIsMobile();
  const { isConnected, connect } = useConnectIfNotAlready();
  const { disconnect } = useDisconnect();

  const onDocsClick = useCallback(() => {
    window.open("https://docs.fuel.network/docs/sway", "_blank", "noreferrer");
  }, []);

  return (
    <div
      style={{
        margin: "5px 0 10px",
        display: isMobile ? "inline-table" : "flex",
      }}
    >
      <SecondaryButton
        header={true}
        onClick={() => setDrawerOpen(!drawerOpen)}
        text="INTERACT"
        tooltip="Interact with the contract ABI"
      />
      <SecondaryButton
        header={true}
        onClick={onDocsClick}
        text="DOCS"
        tooltip={"Open documentation for Sway in a new tab"}
        endIcon={<OpenInNew style={{ fontSize: "16px" }} />}
      />
      <SecondaryButton
        header={true}
        onClick={isConnected ? disconnect : connect}
        text={isConnected ? "DISCONNECT" : "CONNECT"}
        tooltip={
          isConnected ? "Disconnect from the wallet" : "Connect to a wallet"
        }
      />
      {!isMobile && <SwitchThemeButton />}
    </div>
  );
}

export default AbiActionToolbar;
