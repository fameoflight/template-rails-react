import { Environment, RecordSource, Store } from 'relay-runtime';

import networkLayer, { NetworkLayerOptions } from './networkLayer';

function createRelayEnvironment(options: NetworkLayerOptions) {
  const isServer = options.kind === 'server';

  return new Environment({
    isServer,
    network: networkLayer(options),
    // don't keep cache
    store: new Store(new RecordSource(), {
      queryCacheExpirationTime: 60 * 60 * 1000,
      gcReleaseBufferSize: 1000,
    }),
    log: (event) => {
      // console.debug('[relay environment event]', event);
    },
  });
}

export function getRelayEnv() {
  const relayEnv = createRelayEnvironment({
    endpoint: '/api/internal/graphql',
    kind: 'browser',
    format: 'msgpack',
    gracefulFailure: false,
  });

  if (!relayEnv) {
    throw new Error('Relay environment is not initialized');
  }

  return relayEnv;
}

export default createRelayEnvironment;
