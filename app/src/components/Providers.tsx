import { globalCss } from "@fuel-ui/css";
import type { ReactNode } from "react";
import { QueryClientProvider } from "@tanstack/react-query";
import { queryClient } from "../utils/queryClient";
import { FuelProvider } from "@fuels/react";
import { defaultConnectors } from "@fuels/connectors";
import ThemeProvider from "@mui/material/styles/ThemeProvider";
import useTheme from "../context/theme";

type ProvidersProps = {
  children: ReactNode;
};

export function Providers({ children }: ProvidersProps) {
  const { muiTheme, theme } = useTheme();

  return (
    <ThemeProvider theme={muiTheme}>
      <QueryClientProvider client={queryClient}>
        <FuelProvider
          fuelConfig={{
            connectors: defaultConnectors({ devMode: true }),
          }}
          theme={theme}
        >
          {globalCss()()}
          {children}
        </FuelProvider>
      </QueryClientProvider>
    </ThemeProvider>
  );
}
