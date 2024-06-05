import React, { useMemo } from "react";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import { ParamTypeLiteral } from "./FunctionParameters";

interface ResponseCardProps {
  response?: string | Error;
  outputType?: ParamTypeLiteral;
  style?: React.CSSProperties;
}

export function ResponseCard({
  response,
  outputType,
  style,
}: ResponseCardProps) {
  const formattedResponse = useMemo(() => {
    if (!response) return "The response will appear here.";
    if (response instanceof Error) return response.toString();
    if (!response.length) return "Waiting for reponse...";

    switch (outputType) {
      case "number": {
        return Number(JSON.parse(response));
      }
      default: {
        return response;
      }
    }
  }, [outputType, response]);

  return (
    <Card
      style={{
        right: "0",
        left: "0",
        ...style,
      }}
    >
      <CardContent
        style={{
          color: "black",
          fontSize: "14px",
          fontFamily: "monospace",
          backgroundColor: "lightgrey",
          padding: "2px 18px 2px",
          minHeight: "44px",
        }}
      >
        {<pre style={{ overflow: "auto" }}>{formattedResponse}</pre>}
      </CardContent>
    </Card>
  );
}
