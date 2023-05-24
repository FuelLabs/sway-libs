import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders compile and reset buttons', () => {
  render(<App />);
  const compileButton = screen.getByLabelText('Compile sway code');
  const resetButton = screen.getByLabelText('reset the editor');
  expect(compileButton).toBeInTheDocument();
  expect(resetButton).toBeInTheDocument();
});
