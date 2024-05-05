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
    requiredFieldLogger: (arg) => {
      console.error('requiredFieldLogger', arg);
    },
    log: (event) => {
      // console.debug('[relay environment event]', event);
    },
  });
}

export default createRelayEnvironment;
