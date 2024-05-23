// Reference: https://github.com/jantimon/next-relay-demo
import React, { useMemo } from 'react';
import {
  PreloadedQuery,
  RelayEnvironmentProvider,
  useRelayEnvironment,
} from 'react-relay/hooks';
import {
  GraphQLResponse,
  OperationType,
  QueryResponseCache,
} from 'relay-runtime';

import { NextComponentType, NextPageContext } from 'next';

import ErrorBoundary from '@picasso/shared/src/Components/ErrorBoundary';
import Suspense from '@picasso/shared/src/Components/Suspense';

import _ from 'lodash';

import { StaticProps } from './relay';
import { createEnvironment } from './relayEnvironment';

const cache = new QueryResponseCache({ size: 250, ttl: 60 * 1000 });

interface ReactRelayContainerProps<
  T extends OperationType,
  TKey extends string
> {
  Component: NextComponentType<NextPageContext, any, any>;
  pageProps: StaticProps<T, TKey>['props'];
}

export function ReactRelayContainer<
  T extends OperationType,
  TKey extends string
>({ Component, pageProps }: ReactRelayContainerProps<T, TKey>) {
  const environment = useMemo(() => createEnvironment(cache), []);

  return (
    <RelayEnvironmentProvider environment={environment}>
      <ErrorBoundary>
        <Suspense paragraph={20}>
          <Hyderate Component={Component} pageProps={pageProps} />
        </Suspense>
      </ErrorBoundary>
    </RelayEnvironmentProvider>
  );
}

function Hyderate<T extends OperationType, TKey extends string>({
  Component,
  pageProps,
}: ReactRelayContainerProps<T, TKey>) {
  const environment = useRelayEnvironment();

  const transformedProps = useMemo(() => {
    const preloadedQueries = pageProps.preloadedQueries || {
      query: {
        params: {},
      },
    };

    const queryKeys = _.keys(preloadedQueries) as TKey[];
    const queryRefs: Record<TKey, PreloadedQuery<T> | null> = _.mapValues(
      preloadedQueries,
      (_query) => null
    );

    _.each(queryKeys, (key) => {
      const query = preloadedQueries[key];

      const { params, variables, data, hash } = query;

      if (!data) {
        queryRefs[key] = null;
      }

      if (hash) {
        cache.set(hash, variables, {
          data: data,
        } as GraphQLResponse);
      }

      // TODO: create using a function exported from react-relay package
      const ref: PreloadedQuery<T> = {
        environment,
        id: params.id,
        fetchKey: params.id || 0,
        fetchPolicy: 'store-and-network',
        dispose: () => {
          // noop
        },
        isDisposed: false,
        name: params.name,
        kind: 'PreloadedQuery',
        variables: variables,
      };

      queryRefs[key] = ref;
    });

    return { ...pageProps, queryRefs };
  }, [pageProps]);

  return <Component {...transformedProps} />;
}
