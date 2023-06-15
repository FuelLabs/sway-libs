import React from 'react';
import { render, screen } from '@testing-library/react';
import InteractionDrawer from './InteractionDrawer';

const DRAWER_WIDTH = '50vw';
const CONTRACT_ID = 'contractId1';

describe('InteractionDrawer', () => {
  const updateLog = jest.fn();

  test('hidden when closed', () => {
    render(
      <InteractionDrawer
        isOpen={false}
        width={DRAWER_WIDTH}
        contractId={CONTRACT_ID}
        updateLog={updateLog}
      />
    );
    screen.debug();
    // const compileButton = screen.getByLabelText('Compile sway code');
    // const resetButton = screen.getByLabelText('reset the editor');
    // expect(compileButton).toBeInTheDocument();
    // expect(resetButton).toBeInTheDocument();
  });
});
