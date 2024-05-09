import React from 'react';
import Tooltip from '@mui/material/Tooltip';
import Select from '@mui/material/Select';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import InputLabel from '@mui/material/InputLabel/InputLabel';

const ToolchainNames = [
  'beta-5',
  'beta-4',
  'beta-3',
  'beta-2',
  'beta-1',
  'latest',
  'nightly',
] as const;
export type Toolchain = (typeof ToolchainNames)[number];

export function isToolchain(value: string | null): value is Toolchain {
  const found = ToolchainNames.find(name => name === value);
  return !!value && found !== undefined;
}

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
    <FormControl style={{ ...style }} size='small'>
      <InputLabel id='toolchain-select-label'>Toolchain</InputLabel>
      <Tooltip placement='top' title={'Fuel toolchain to use for compilation'}>
        <span>
          <Select
            id='toolchain-select'
            labelId='toolchain-select-label'
            label='Toolchain'
            style={{ minWidth: '70px', background: 'white' }}
            variant='outlined'
            value={toolchain}
            onChange={(event) => setToolchain(event.target.value as Toolchain)}>
            {ToolchainNames.map((toolchain) => (
              <MenuItem key={toolchain} value={toolchain}>
                {toolchain}
              </MenuItem>
            ))}
          </Select>
        </span>
      </Tooltip>
    </FormControl>
  );
}

export default ToolchainDropdown;
