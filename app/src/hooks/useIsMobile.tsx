import React from 'react';
import useTheme from "@mui/material/styles/useTheme";
import useMediaQuery from "@mui/material/useMediaQuery/useMediaQuery";

export function useIsMobile() {
    const theme = useTheme();
    return useMediaQuery(theme.breakpoints.down('md'));  
}
