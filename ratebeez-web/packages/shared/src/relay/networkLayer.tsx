import {
  CacheConfig,
  Network,
  QueryResponseCache,
  RequestParameters,
} from 'relay-runtime';

import _ from 'lodash';

import { decode } from '@msgpack/msgpack';

import api from '../api';

// Define a function that fetches the results of an operation (query/mutation/etc)
// and returns its results as a Promise:

type FetchFormat = 'json' | 'msgpack';

type ClientInstanceType = 'browser' | 'server';

export type FetchQueryOptions = {
  variables: Record<string, unknown>;
  networkLayer: NetworkLayerOptions;
  operation: RequestParameters;
  cacheConfig?: CacheConfig;
};

export function fetchQuery(options: FetchQueryOptions) {
  const { operation, cacheConfig, variables, networkLayer } = options;

  const { endpoint, format, kind, responseCache } = networkLayer;

  const query = operation.text || '';

  if (_.isEmpty(query)) {
    throw Error('No query found in fetchQuery request');
  }

  const queryID = query;

  const isMutation = operation.operationKind === 'mutation';
  const isQuery = operation.operationKind === 'query';
  const forceFetch = cacheConfig?.force;

  const fromCache = responseCache?.get(queryID, variables);

  if (!forceFetch && isQuery) {
    if (fromCache) {
      return fromCache;
    }
  }

  const apiInstance = api.apiInstance(kind);

  return apiInstance
    .post({
      endpoint: `${endpoint}.${format}`,
      data: JSON.stringify({
        query,
        variables,
      }),
      responseType: 'arraybuffer',
    })
    .then((response) => {
      const data: any = decode(response.data);

      const errors = _.get(data, 'errors');

      if (!_.isEmpty(errors)) {
        console.error('response error', JSON.stringify(errors, null, 4));
      }

      return data;
    })
    .then((data) => {
      if (isQuery && data) {
        responseCache?.set(queryID, variables, data);
      }

      if (isMutation) {
        responseCache?.clear();
      }

      return data;
    })
    .catch((error) => {
      if (options.networkLayer.gracefulFailure) {
        if (fromCache) {
          return fromCache;
        }
      }
      throw error;
    });
}

export type NetworkLayerOptions = {
  endpoint: string;
  format: FetchFormat;
  kind: ClientInstanceType;
  gracefulFailure: boolean;
  responseCache?: QueryResponseCache;
};

function networkLayer(options: NetworkLayerOptions) {
  return Network.create((operation, variables, cacheConfig) => {
    return fetchQuery({
      variables,
      operation,
      cacheConfig,
      networkLayer: options,
    });
  });
}

// Create a network layer from the fetch function
export default networkLayer;
