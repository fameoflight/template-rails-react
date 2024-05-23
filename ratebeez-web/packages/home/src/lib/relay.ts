import { PreloadedQuery } from 'react-relay';
import { usePreloadedQuery } from 'react-relay/hooks';
import {
  ConcreteRequest,
  GraphQLTaggedNode,
  OperationType,
  RequestParameters,
  VariablesOf,
} from 'relay-runtime';

import type { NextPage } from 'next';

import { fetchQuery } from '@picasso/shared/src/relay/networkLayer';

import _ from 'lodash';

export type PartialPreloadedQuery<TQuery extends OperationType> = {
  hash: string;
  params: RequestParameters;
  variables: TQuery['variables'];
  data: Awaited<TQuery['response']>;
};

export type PartialPreloadedQueries<
  TQuery extends OperationType,
  TQueryKey extends string,
> = Record<TQueryKey, PartialPreloadedQuery<TQuery>>;

export interface StaticProps<
  TQuery extends OperationType,
  TQueryKey extends string = 'query',
> {
  props: {
    preloadedQueries: PartialPreloadedQueries<TQuery, TQueryKey>;
  };
  revalidate?: number;
}

export interface PageProps<
  TQuery extends OperationType,
  TQueryKey extends string = 'query',
> {
  preloadedQueries: PartialPreloadedQueries<TQuery, TQueryKey>;
  queryRefs: Record<TQueryKey, PreloadedQuery<TQuery>>;
}

export interface RelayNextPage<
  TQuery extends OperationType,
  TQueryKey extends string = 'query',
> {
  props: PageProps<TQuery, TQueryKey>;
  getStaticProps: StaticProps<TQuery, TQueryKey>;
  Page: NextPage<PageProps<TQuery, TQueryKey>>;
}

export async function getPreloadedQuery<TQuery extends OperationType>(
  queryRequest: ConcreteRequest,
  variables?: VariablesOf<TQuery>
): Promise<PartialPreloadedQuery<TQuery>> {
  const query = queryRequest.params.text;

  if (!query) {
    throw new Error('Query  is missing');
  }

  const response = await fetchQuery({
    operation: queryRequest.params,
    networkLayer: {
      kind: 'server',
      endpoint: '/api/internal/graphql',
      format: 'msgpack',
      gracefulFailure: false,
    },
    variables: variables || {},
    cacheConfig: {
      force: true,
    },
  });

  return {
    hash: query,
    params: queryRequest.params,
    variables: variables || {},
    data: response.data as Awaited<TQuery['response']>,
  };
}

export function usePreloadedQueryCompat<
  TQuery extends OperationType,
  TQueryKey extends string = 'query',
>(
  gqlQuery: GraphQLTaggedNode,
  pageProps: PageProps<TQuery, TQueryKey>,
  queryKey: TQueryKey
): TQuery['response'] {
  const queryRef = pageProps.queryRefs[queryKey];

  return usePreloadedQuery(gqlQuery, queryRef, {
    UNSTABLE_renderPolicy: 'partial',
  });
}
