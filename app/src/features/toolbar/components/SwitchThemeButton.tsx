import { useThemeContext } from '../../../context/theme';
import IconButton from '@mui/material/IconButton';
import LightModeIcon from '@mui/icons-material/LightMode';
import DarkModeIcon from '@mui/icons-material/DarkMode';
import { darkColors, lightColors } from '@fuel-ui/css';

function SwitchThemeButton () {
    const {theme,setTheme} = useThemeContext();
    return (
        <IconButton 
        aria-label='swithThemes'
        onClick={()=>setTheme(theme === 'light' ? 'dark' : 'light')}
        sx={{marginRight: '15px', marginBottom: '10px', position: "absolute", right: '0px' , top: '20px'}}
        >
            {theme === 'light' && <LightModeIcon sx={{color: darkColors.gray7}}/>}
            {theme !== 'light' && <DarkModeIcon sx={{color: lightColors.scalesGreen7}}/>}
        </IconButton>
    )
      
}

export default SwitchThemeButton;
