import React from "react";
import Accordion from "@mui/material/Accordion";
import AccordionSummary from "@mui/material/AccordionSummary";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import AccordionDetails from "@mui/material/AccordionDetails";
import FormLabel from "@mui/material/FormLabel";
import { InputInstance, ParamTypeLiteral } from "./FunctionParameters";
import { FunctionForm } from "./FunctionForm";
import { ResponseCard } from "./ResponseCard";
import useTheme from "../../../context/theme";
import { DarkThemeStyling } from "../../../components/shared";

export interface FunctionCallAccordionProps {
  contractId: string;
  functionName: string;
  inputInstances: InputInstance[];
  outputType?: ParamTypeLiteral;
  response?: string | Error;
  setResponse: (response: string | Error) => void;
  updateLog: (entry: string) => void;
}

export function FunctionCallAccordion({
  contractId,
  functionName,
  inputInstances,
  outputType,
  response,
  setResponse,
  updateLog,
}: FunctionCallAccordionProps) {
  const { theme, themeColor } = useTheme();
  const dropdownStyling =
    theme !== "light" ? DarkThemeStyling.darkAccordion : {};
  return (
    <Accordion key={contractId + functionName} sx={{ ...dropdownStyling }}>
      <AccordionSummary
        expandIcon={<ExpandMoreIcon sx={{ color: themeColor("gray4") }} />}
      >
        <FormLabel
          style={{ fontFamily: "monospace", color: themeColor("white3") }}
        >
          {functionName}
        </FormLabel>
      </AccordionSummary>
      <AccordionDetails style={{ paddingTop: 0 }}>
        <FunctionForm
          contractId={contractId}
          functionName={functionName}
          inputInstances={inputInstances}
          setResponse={setResponse}
          updateLog={updateLog}
        />
        <ResponseCard
          style={{ marginTop: "15px" }}
          outputType={outputType}
          response={response}
        />
      </AccordionDetails>
    </Accordion>
  );
}
