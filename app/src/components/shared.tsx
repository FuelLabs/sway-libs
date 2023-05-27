import styled from '@emotion/styled';
import { darkColors } from '@fuel-ui/css';
import { Copyable, Spinner } from '@fuel-ui/react';

export const StyledBorder = styled.div`
  border: 4px solid lightgrey;
  border-radius: 5px;
`;

export const ButtonSpinner = () => <Spinner size={18} />;

export const CopyableHex = ({ hex }: { hex: string }) => {
  const formattedHex = hex.slice(0, 6) + '...' + hex.slice(-5, -1);
  return (
    <Copyable
      style={{ color: darkColors.gray6, fontFamily: 'Space Grotesk' }}
      value={hex}>
      {formattedHex}
    </Copyable>
  );
};
