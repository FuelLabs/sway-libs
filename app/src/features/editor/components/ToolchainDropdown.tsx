import React from 'react';
import Tooltip from '@mui/material/Tooltip';
import Select from '@mui/material/Select';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';

const ToolchainNames = [
  'beta-4',
  'beta-3',
  'beta-2',
  'beta-1',
  'latest',
  'nightly',
] as const;
export type Toolchain = (typeof ToolchainNames)[number];

export interface ToolchainDropdownProps {
  toolchain: Toolchain;
  setToolchain: (toolchain: Toolchain) => void;
  style?: React.CSSProperties;
}
function ToolchainDropdown({
  toolchain,
  setToolchain,
  style,
}: ToolchainDropdownProps) {
  return (
    <div style={{ ...style }}>
      <FormControl sx={{ minWidth: '70px' }} size='small'>
        <Tooltip
          placement='top'
          title={'The Fuel toolchain to use for compilation'}>
          <span>
            <Select
              sx={{ backgroundColor: 'white', fontSize: '16px' }}
              variant='outlined'
              value={toolchain}
              onChange={(event) =>
                setToolchain(event.target.value as Toolchain)
              }>
              {ToolchainNames.map((toolchain) => (
                <MenuItem key={toolchain} value={toolchain}>
                  {toolchain}
                </MenuItem>
              ))}
            </Select>
          </span>
        </Tooltip>
      </FormControl>
    </div>
  );
}

export default ToolchainDropdown;
