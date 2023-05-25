// import { Card, Text } from '@fuel-ui/react';

import { Spinner } from '@fuel-ui/react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';

interface ResponseCardProps {
  response: string | undefined;
}

export function ResponseCard({ response }: ResponseCardProps) {
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
          minHeight: '24px',
        }}>
        {response === undefined ? (
          'The response will appear here.'
        ) : response.length === 0 ? (
          <div style={{ position: 'absolute' }}>
            <Spinner size={24} />
          </div>
        ) : (
          response
        )}
      </CardContent>
    </Card>
  );
}
