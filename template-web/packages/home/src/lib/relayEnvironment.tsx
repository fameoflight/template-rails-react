import { QueryResponseCache } from 'relay-runtime';

import api from '@picasso/shared/src/api';
import jTokerAuthProvider from '@picasso/shared/src/api/jTokerAuthProvider';
import createRelayEnvironment from '@picasso/shared/src/relay/createRelayEnvironment';
import { isBrowser } from '@picasso/shared/src/utils';

const IS_SERVER = !isBrowser();

const IS_PRODUCTION = process.env.NODE_ENV === 'production';

if (!IS_SERVER) {
  jTokerAuthProvider.setup(api.basePath());
}

if (IS_PRODUCTION) {
  api.setBasePath('https://api.usepicasso.com');
}

export function createEnvironment(cache?: QueryResponseCache) {
  return createRelayEnvironment({
    endpoint: '/api/internal/graphql',
    // this causes problem in localhost since I can be logged in
    // this also bypass j-toker
    kind: 'server',
    format: 'msgpack',
    gracefulFailure: true,
    responseCache: cache,
  });
}
