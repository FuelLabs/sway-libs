import React, { useMemo } from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import { ParamTypeLiteral } from './FunctionParameters';
import { darkColors } from '@fuel-ui/css';
import { useThemeContext } from '../../../theme/themeContext';

interface ResponseCardProps {
  response?: string | Error;
  outputType?: ParamTypeLiteral;
  style?: React.CSSProperties;
}

export function ResponseCard({
  response,
  outputType,
  style,
}: ResponseCardProps) {
  const formattedResponse = useMemo(() => {
    if (!response) return 'The response will appear here.';
    if (response instanceof Error) return response.toString();
    if (!response.length) return 'Waiting for reponse...';

    switch (outputType) {
      case 'number': {
        return Number(JSON.parse(response));
      }
      default: {
        return response;
      }
    }
  }, [outputType, response]);

  // Import theme state
  const theme = useThemeContext().theme;

  return (
    <Card
      style={{
        right: '0',
        left: '0',
        ...style,
        background: theme === 'light' ? '' : 'transparent'
      }}>
      <CardContent
        style={{
          color: theme === 'light' ? darkColors.gray6 : '#E0FFFF',
          fontSize: '14px',
          fontFamily: 'monospace',
          background: theme === 'light' ? 'lightgrey': '#1F1F1F',
          padding: '2px 18px 2px',
          minHeight: '44px',
        }}>
        {<pre style={{ overflow: 'auto' }}>{formattedResponse}</pre>}
      </CardContent>
    </Card>
  );
}
