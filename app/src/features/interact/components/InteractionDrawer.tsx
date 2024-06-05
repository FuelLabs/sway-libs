import React from "react";
import Drawer from "@mui/material/Drawer";
import { ContractInterface } from "./ContractInterface";

export interface InteractionDrawerProps {
  isOpen: boolean;
  width: string;
  contractId: string;
  updateLog: (entry: string) => void;
}

function InteractionDrawer({
  isOpen,
  width,
  contractId,
  updateLog,
}: InteractionDrawerProps) {
  return (
    <Drawer
      PaperProps={{
        sx: {
          background: "#F1F1F1",
        },
      }}
      sx={{
        width: width,
        flexShrink: 0,
        "& .MuiDrawer-paper": {
          width: width,
        },
      }}
      variant="persistent"
      anchor="right"
      open={isOpen}
    >
      <div
        style={{
          width: "100%",
        }}
      >
        {isOpen && (
          <ContractInterface contractId={contractId} updateLog={updateLog} />
        )}
      </div>
    </Drawer>
  );
}

export default InteractionDrawer;
