import React from 'react';

import { IFlowRoute } from './types';

interface IFlowContextType {
  onStepComplete: () => void;
  navigateBy: (changeBy: number) => void;
  flowRoutes: IFlowRoute[];
  currentIndex: number;
}

const defaultValue: IFlowContextType = {
  // TODO: remove right now for backward compatibility
  onStepComplete: () => {
    throw new Error('default on complete called');
  },
  navigateBy: (changeBy: number) => {
    throw new Error('default on complete called');
  },
  flowRoutes: [],
  currentIndex: 0,
};

const FlowContext = React.createContext<IFlowContextType>(defaultValue);

interface IFlowProviderProps {
  children: React.ReactNode;
  value: IFlowContextType;
}

function FlowProvider({ children, value }: IFlowProviderProps) {
  /* eslint-disable react/jsx-no-constructed-context-values */
  return <FlowContext.Provider value={value}>{children}</FlowContext.Provider>;
}

function useFlowContext() {
  const context = React.useContext(FlowContext);
  if (context === undefined) {
    throw new Error('useFlowContext must be used within a FlowProvider');
  }
  return context;
}

export { FlowProvider, useFlowContext };
