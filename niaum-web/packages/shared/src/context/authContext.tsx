import React from 'react';

import { ProtectedLayoutQuery$data } from '@picasso/fragments/src/ProtectedLayoutQuery.graphql';

interface IAuthContext {
  readonly currentUser: ProtectedLayoutQuery$data['currentUser'];
  readonly env: string;
}

const defaultValue: IAuthContext = {
  currentUser: null,
  env: 'development',
};

const AuthContext = React.createContext<IAuthContext>(defaultValue);

interface IAuthProviderProps {
  children: React.ReactNode;
  value: IAuthContext;
}

function AuthProvider({ children, value }: IAuthProviderProps) {
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

function useAuthContext() {
  const context = React.useContext(AuthContext);

  return context || defaultValue;
}

export { AuthProvider, useAuthContext };
