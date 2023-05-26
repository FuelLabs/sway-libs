import styled from '@emotion/styled';
import { Spinner } from '@fuel-ui/react';

export const StyledBorder = styled.div`
  border: 4px solid lightgrey;
  border-radius: 5px;
`;

export const ButtonSpinner = () => <Spinner size={18} />;
