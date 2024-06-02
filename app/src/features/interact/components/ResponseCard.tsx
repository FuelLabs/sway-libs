import React, { useMemo } from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import { ParamTypeLiteral } from './FunctionParameters';
import useTheme from '../../../context/theme';

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

  const { themeColor } = useTheme();

  return (
    <Card
      style={{
        right: '0',
        left: '0',
        ...style,
        background: 'transparent'
      }}>
      <CardContent
        style={{
          color: themeColor('gray1'),
          fontSize: '14px',
          fontFamily: 'monospace',
          background: themeColor('gray8'),
          padding: '2px 18px 2px',
          minHeight: '44px',
        }}>
        {<pre style={{ overflow: 'auto' }}>{formattedResponse}</pre>}
      </CardContent>
    </Card>
  );
}
