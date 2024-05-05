import React from 'react';
import { RelayEnvironmentProvider } from 'react-relay/hooks';
import { BrowserRouter } from 'react-router-dom';

// hack to import css
import '@picasso/shared';
import analytics from '@picasso/shared/src/analytics';
import api from '@picasso/shared/src/api';
import jTokerAuthProvider from '@picasso/shared/src/api/jTokerAuthProvider';
import createRelayEnvironment from '@picasso/shared/src/relay/createRelayEnvironment';

import AppRoutes from 'src/App/AppRoutes';

jTokerAuthProvider.setup(api.basePath());

if (process.env.NODE_ENV === 'production') {
  analytics.init();
}

const clientRelayEnv = createRelayEnvironment({
  endpoint: '/api/internal/graphql',
  kind: 'browser',
  format: 'msgpack',
  gracefulFailure: false,
});

function AppRoot() {
  if (!clientRelayEnv) {
    throw new Error('RelayEnvironment is not defined');
  }

  return (
    <RelayEnvironmentProvider environment={clientRelayEnv}>
      <BrowserRouter>
        <AppRoutes />
      </BrowserRouter>
    </RelayEnvironmentProvider>
  );
}

export default AppRoot;
