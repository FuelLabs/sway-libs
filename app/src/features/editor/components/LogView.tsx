import React, { useEffect, useRef } from "react";
import useTheme from "../../../context/theme";
import { StyledBorder } from "../../../components/shared";

export interface LogViewProps {
  results: React.ReactElement[];
}

function LogView({ results }: LogViewProps) {
  const { themeColor } = useTheme();

  const scrollRef = useRef<null | HTMLDivElement>(null);

  // Scroll to the bottom of the results when they change.
  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollIntoView({ behavior: "smooth" });
    }
  }, [results]);

  return (
    <StyledBorder
      themeColor={themeColor}
      style={{
        color: themeColor("gray3"),
        padding: "15px",
        overflow: "auto",
        marginTop: "15px",
        flex: 1,
        scrollMarginTop: "99999px",
      }}
    >
      <pre style={{ fontSize: "14px", margin: 0 }}>
        {results.map((element, index) => (
          <div key={`${index}`}>{element}</div>
        ))}
        <div ref={scrollRef} />
      </pre>
    </StyledBorder>
  );
}

export default LogView;
