import styled from "@emotion/styled";
import CircularProgress from "@mui/material/CircularProgress";
import Copyable from "./Copyable";
import { lightColors } from "@fuel-ui/css";
import { ColorName } from "../context/theme";

export const StyledBorder = styled.div<{
  themeColor: (name: ColorName) => string;
}>`
  border: 4px solid ${(props) => props.themeColor("gray4")};
  border-radius: 5px;
`;

export const ButtonSpinner = () => (
  <CircularProgress
    style={{
      margin: "2px",
      height: "14px",
      width: "14px",
      color: lightColors.scalesGreen10,
    }}
  />
);

export const CopyableHex = ({
  hex,
  tooltip,
}: {
  hex: string;
  tooltip: string;
}) => {
  const formattedHex = hex.slice(0, 6) + "..." + hex.slice(-4, hex.length);
  return <Copyable value={hex} label={formattedHex} tooltip={tooltip} />;
};
