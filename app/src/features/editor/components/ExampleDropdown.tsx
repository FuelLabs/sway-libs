import React from 'react';
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

function ExampleDropdown({ handleSelect, examples, style }: ExampleDropdownProps) {
  const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);

  const onButtonClick = (event: any ) => { // todo
    console.log('click', event.target);
    setAnchorEl(event.target);
  };

  const onItemClick = (code: string) => { // todo
    console.log(code);
    // console.log('item click', event.target.value);
    handleClose();
    // handleSelect(event.target.value);
    handleSelect(code);
  };


  const handleClose = () => {
    console.log('close');
    setAnchorEl(null);
  }

  return (
    <div style={{ ...style }}>
       

        <Dropdown 
          >
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

          <Menu keepMounted anchorEl={anchorEl} open={Boolean(anchorEl)} onClose={handleClose} >
            {examples.map(({label, code}: ExampleMenuItem, index) => (<MenuItem key={`${label}-${index}`} onClick={() => onItemClick(code)} >{label}</MenuItem>)) }
            {/* <MenuItem onClick={onItemClick} value={0}>Profile</MenuItem>
            <MenuItem onClick={onItemClick} value={1} >Language settings</MenuItem>
            <MenuItem onClick={onItemClick} value={2}>Log out</MenuItem> */}
          </Menu>
        </Dropdown>
    </div>
  );
}

export default ExampleDropdown;
