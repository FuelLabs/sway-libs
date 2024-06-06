import IconButton from "@mui/material/IconButton";
import LightModeIcon from "@mui/icons-material/LightMode";
import DarkModeIcon from "@mui/icons-material/DarkMode";
import { darkColors, lightColors } from "@fuel-ui/css";
import useTheme from "../../../context/theme";

function SwitchThemeButton() {
  const { theme, setTheme } = useTheme();

  const handleChange = async () => {
    const next = theme === "dark" ? "light" : "dark";
    setTheme(next);
  };

  return (
    <IconButton
      aria-label="swithThemes"
      onClick={handleChange}
      sx={{
        marginRight: "15px",
        marginBottom: "10px",
        position: "absolute",
        right: "0px",
        top: "20px",
        zIndex: 1300,
      }}
    >
      {theme === "light" && <LightModeIcon sx={{ color: darkColors.gray7 }} />}
      {theme !== "light" && <DarkModeIcon sx={{ color: lightColors.gray1 }} />}
    </IconButton>
  );
}

export default SwitchThemeButton;
