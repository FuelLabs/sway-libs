// import { Card, Text } from '@fuel-ui/react';

import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';

interface FunctionReturnInfoProps {
  response: string;
}

export function FunctionReturnInfo({ response }: FunctionReturnInfoProps) {
  return (
    <Card
      style={{
        right: '0',
        left: '0',
        // overflowWrap: 'anywhere',
        // overflowY: 'scroll',
        marginTop: '15px',
      }}>
      <CardContent
        style={{
          color: 'black',
          fontSize: '14px',
          fontFamily: 'monospace',
          backgroundColor: 'lightgrey',
          padding: '14px',
        }}>
        {response}
      </CardContent>
    </Card>
  );
}
