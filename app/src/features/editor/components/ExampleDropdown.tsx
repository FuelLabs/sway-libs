import React, { useCallback } from 'react';
import Tooltip from '@mui/material/Tooltip';
import MenuItem from '@mui/material/MenuItem';
import IconButton from '@mui/material/IconButton';
import FileOpen from '@mui/icons-material/FileOpen';
import { Dropdown } from '@mui/base/Dropdown/Dropdown';
import Menu from '@mui/material/Menu/Menu';

export interface ExampleMenuItem {
  label: string;
  code: string;
}

export interface ExampleDropdownProps {
  handleSelect: (example: string) => void;
  examples: ExampleMenuItem[];
  style?: React.CSSProperties;
}

function ExampleDropdown({
  handleSelect,
  examples,
  style,
}: ExampleDropdownProps) {
  const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);

  const onButtonClick = useCallback((event: any) => {
    setAnchorEl(event.target);
  }, [setAnchorEl]);

  const handleClose = useCallback(() => {
    setAnchorEl(null);
  }, [setAnchorEl]);

  const onItemClick = useCallback((code: string) => {
    handleClose();
    handleSelect(code);
  }, [handleSelect, handleClose]);

  return (
    <div style={{ ...style }}>
      <Dropdown>
        <Tooltip placement='top' title={'Select an example'}>
          <IconButton
            style={{
              position: 'absolute',
              right: '18px',
              top: '18px',
              pointerEvents: 'all',
            }}
            onClick={onButtonClick}
            aria-label='select an example'>
            <FileOpen />
          </IconButton>
        </Tooltip>

        <Menu
          anchorEl={anchorEl}
          open={Boolean(anchorEl)}
          onClose={handleClose}>
          {examples.map(({ label, code }: ExampleMenuItem, index) => (
            <MenuItem
              key={`${label}-${index}`}
              onClick={() => onItemClick(code)}>
              {label}
            </MenuItem>
          ))}
        </Menu>
      </Dropdown>
    </div>
  );
}

export default ExampleDropdown;
