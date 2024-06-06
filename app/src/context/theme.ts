import { useCallback } from "react";
import { darkColors, lightColors } from "@fuel-ui/css";
import { useFuelTheme } from "@fuel-ui/react";

interface ColorMapping {
  light: string;
  dark: string;
}
export type ColorName =
  | "chrome"
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
  | "gray7"
  | "gray8"
  | "sgreen1"
  | "disabled1"
  | "disabled2"
  | "disabled3";

const COLORS: Record<ColorName, ColorMapping> = {
  chrome: {
    light: "chrome",
    dark: "tomorrow_night_bright",
  },
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
    dark: lightColors.white,
  },
  gray2: {
    light: darkColors.gray6,
    dark: darkColors.gray11,
  },
  gray3: {
    light: darkColors.gray6,
    dark: darkColors.gray12,
  },
  gray4: {
    light: darkColors.gray10,
    dark: lightColors.gray10,
  },
  gray5: {
    light: darkColors.scalesGray1,
    dark: lightColors.white,
  },
  gray6: {
    light: lightColors.gray7,
    dark: darkColors.scalesGray1,
  },
  gray7: {
    light: lightColors.gray1,
    dark: darkColors.scalesGray2,
  },
  gray8: {
    light: "lightgrey",
    dark: darkColors.gray3,
  },
  sgreen1: {
    light: lightColors.scalesGreen3,
    dark: darkColors.scalesGreen2,
  },
  disabled1: {
    light: "",
    dark: darkColors.gray6,
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

export default function useTheme() {
  const { current: currentTheme, setTheme } = useFuelTheme();
  const themeColor = useCallback(
    (name: ColorName) => COLORS[name][currentTheme as "light" | "dark"],
    [currentTheme],
  );
  return {
    theme: currentTheme,
    setTheme,
    themeColor,
  };
}
