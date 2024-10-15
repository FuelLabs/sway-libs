import { useCallback, useMemo } from "react";
import { darkColors, lightColors } from "@fuel-ui/css";
import { useFuelTheme } from "@fuel-ui/react";
import createTheme from "@mui/material/styles/createTheme";

interface ColorMapping {
  light: string;
  dark: string;
}
export type ColorName =
  | "black1"
  | "white1"
  | "white2"
  | "white3"
  | "white4"
  | "gray1"
  | "gray2"
  | "gray3"
  | "gray4"
  | "gray5"
  | "gray6"
  | "sgreen1"
  | "disabled1"
  | "disabled2"
  | "disabled3";

const COLORS: Record<ColorName, ColorMapping> = {
  black1: {
    light: darkColors.black,
    dark: lightColors.gray4,
  },
  white1: {
    light: lightColors.whiteA5,
    dark: darkColors.scalesGreen2,
  },
  white2: {
    light: lightColors.white,
    dark: darkColors.scalesGray1,
  },
  white3: {
    light: "#00000099",
    dark: darkColors.gray12,
  },
  white4: {
    light: lightColors.gray2,
    dark: darkColors.black,
  },
  gray1: {
    light: darkColors.gray6,
    dark: darkColors.gray11,
  },
  gray2: {
    light: darkColors.gray10,
    dark: lightColors.gray10,
  },
  gray3: {
    light: darkColors.scalesGray1,
    dark: lightColors.white,
  },
  gray4: {
    light: lightColors.gray7,
    dark: darkColors.scalesGray1,
  },
  gray5: {
    light: lightColors.gray1,
    dark: darkColors.scalesGray2,
  },
  gray6: {
    light: "lightgrey",
    dark: darkColors.gray3,
  },
  sgreen1: {
    light: lightColors.scalesGreen3,
    dark: darkColors.scalesGreen2,
  },
  disabled1: {
    light: "",
    dark: darkColors.gray8,
  },
  disabled2: {
    light: lightColors.scalesGreen4,
    dark: darkColors.scalesGreen3,
  },
  disabled3: {
    light: "",
    dark: darkColors.gray1,
  },
};

type Theme = "light" | "dark";

export default function useTheme() {
  const { current: currentTheme, setTheme } = useFuelTheme();

  const themeColor = useCallback(
    (name: ColorName) => COLORS[name][currentTheme as Theme],
    [currentTheme],
  );
  const editorTheme = useMemo(
    () => (currentTheme === "light" ? "chrome" : "tomorrow_night"),
    [currentTheme],
  );
  const muiTheme = createTheme({
    palette: {
      mode: currentTheme as Theme,
    },
  });
  return {
    theme: currentTheme as Theme,
    editorTheme,
    setTheme,
    themeColor,
    muiTheme,
  };
}
