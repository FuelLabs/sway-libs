import { Card, Text } from '@fuel-ui/react';

interface FunctionReturnInfoProps {
  response: string;
}

export function FunctionReturnInfo({ response }: FunctionReturnInfoProps) {
  return (
    <Card
      style={{
        right: '0',
        left: '0',
        maxHeight: '200px',
        overflowWrap: 'anywhere',
        overflowY: 'scroll',
        backgroundColor: 'lightgrey',
        marginTop: '10px',
      }}>
      <Card.Body>
        <Text style={{ color: 'black', fontSize: '14px' }}>{response}</Text>
      </Card.Body>
    </Card>
  );
}
