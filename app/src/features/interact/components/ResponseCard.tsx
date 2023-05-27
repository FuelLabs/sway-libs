import React from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';

interface ResponseCardProps {
  response: React.ReactElement[] | string;
  style?: React.CSSProperties;
}

export function ResponseCard({ response, style }: ResponseCardProps) {
  return (
    <Card
      style={{
        right: '0',
        left: '0',
        ...style,
        // overflowWrap: 'anywhere',
        // overflowY: 'scroll',
      }}>
      <CardContent
        style={{
          color: 'black',
          fontSize: '14px',
          fontFamily: 'monospace',
          backgroundColor: 'lightgrey',
          padding: '2px 18px 2px',
          minHeight: '52px',
        }}>
        {
          <pre>
            {response?.length === 0 ? 'Waiting for reponse...' : response}
          </pre>
        }
      </CardContent>
    </Card>
  );
}
