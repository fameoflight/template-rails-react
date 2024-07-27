import React from 'react';
import {
  UseMutationConfig,
  useLazyLoadQuery,
  useMutation,
} from 'react-relay/hooks';
import {
  CacheConfig,
  Disposable,
  FetchPolicy,
  GraphQLTaggedNode,
  IEnvironment,
  MutationConfig,
  MutationParameters,
  OperationType,
  RenderPolicy,
  VariablesOf,
  commitMutation,
} from 'relay-runtime';
import { PayloadError } from 'relay-runtime';

import { ConcreteRequest, RequestParameters } from 'relay-runtime';

import _ from 'lodash';

import { notification } from 'antd';

import useFetchKey from '../hooks/useFetchKey';
import createRelayEnvironment from './createRelayEnvironment';
import { fetchQuery } from '@picasso/shared/src/relay/networkLayer';

import { findAllByKey } from '../utils';

export type PartialPreloadedQuery<TQuery extends OperationType> = {
  hash: string;
  params: RequestParameters;
  variables: TQuery['variables'];
  data: Awaited<TQuery['response']>;
};

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
      kind: 'browser',
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

const openNotificationWithIcon = (description: string | React.ReactNode) => {
  notification.error({
    message: 'Error',
    description,
  });
};

function showMutationErrors<TMutation extends MutationParameters>(
  response: TMutation['response'],
  payloadErrors: readonly PayloadError[] | null | undefined
) {
  let mutationErrors = findAllByKey(response, 'errors');

  if (!_.isEmpty(payloadErrors)) {
    const payloadErrorMessages = _.map(payloadErrors, 'message');
    mutationErrors = _.concat(mutationErrors, payloadErrorMessages);
  }

  if (!_.isEmpty(mutationErrors)) {
    const errorView = (
      <div className="space-y-1">
        {mutationErrors.map((message, idx) => (
          <p key={idx}>{message}</p>
        ))}
      </div>
    );

    openNotificationWithIcon(errorView);
  }
}

const defaultOnError = (error: Error) => {
  const message = _.get(error, 'message') || 'Internal server error';

  notification.error({
    message: 'Error',
    description: message,
  });
};

export function useCompatMutation<TMutation extends MutationParameters>(
  mutation: GraphQLTaggedNode,
  commitMutationFn?: (
    environment: IEnvironment,
    config: MutationConfig<TMutation>
  ) => Disposable
): [(config: UseMutationConfig<TMutation>) => Disposable, boolean] {
  const [commitUseMutation, commitIsInFlight] = useMutation(
    mutation,
    commitMutationFn
  );

  const commitMutationEnhanced = (config: UseMutationConfig<TMutation>) => {
    const { onCompleted, ...restConfig } = config;

    return commitUseMutation({
      onError: defaultOnError,
      ...restConfig,
      onCompleted: (response: TMutation['response'], payloadErrors) => {
        showMutationErrors(response, payloadErrors);

        onCompleted?.(response, payloadErrors);
      },
    });
  };

  return [commitMutationEnhanced, commitIsInFlight];
}

export function useNetworkLazyLoadQuery<TQuery extends OperationType>(
  gqlQuery: GraphQLTaggedNode,
  variables?: VariablesOf<TQuery>,
  options?: {
    fetchKey?: string | number | undefined;
    fetchPolicy?: FetchPolicy | undefined;
    networkCacheConfig?: CacheConfig;
    UNSTABLE_renderPolicy?: RenderPolicy;
  }
): TQuery['response'] {
  const optionKeys = ['fetchKey', 'fetchPolicy', 'networkCacheConfig'];

  for (const key of optionKeys) {
    if (_.includes(variables, key)) {
      console.error(
        `Variables cannot contain ${key}, should be passed as options`
      );
    }
  }

  const fetchPolicy = options?.fetchPolicy || 'store-and-network';

  const queryVariables = variables || {};

  return useLazyLoadQuery(gqlQuery, queryVariables, {
    fetchPolicy: fetchPolicy,
    ...options,
  });
}

type UseNetworkLazyReloadQueryReturn<TQuery extends OperationType> = [
  TQuery['response'], // data
  () => void, // updateData
  string, // fetchKey
];

export function useNetworkLazyReloadQuery<TQuery extends OperationType>(
  gqlQuery: GraphQLTaggedNode,
  variables?: VariablesOf<TQuery>,
  options?: {
    fetchKey?: string | number;
    fetchPolicy?: FetchPolicy;
    networkCacheConfig?: CacheConfig;
    UNSTABLE_renderPolicy?: RenderPolicy;
  }
): UseNetworkLazyReloadQueryReturn<TQuery> {
  if (options?.fetchKey) {
    throw new Error(
      'fetchKey cannot be passed as options, use useNetworkLazyLoadQuery'
    );
  }

  const [fetchKey, updateFetchKey] = useFetchKey();

  const data = useNetworkLazyLoadQuery(gqlQuery, variables, {
    ...options,
    fetchKey,
  });

  return [
    data,
    () => {
      updateFetchKey();
    },
    fetchKey,
  ];
}

export function commitCompatMutation<TMutation extends MutationParameters>(
  props: MutationConfig<TMutation>
) {
  const relayEnv = createRelayEnvironment({
    endpoint: '/api/internal/graphql',
    kind: 'browser',
    format: 'msgpack',
    gracefulFailure: false,
  });

  if (!relayEnv) {
    throw new Error('Relay environment is not initialized');
  }

  const { onCompleted, ...restProps } = props;

  return commitMutation<TMutation>(relayEnv, {
    onError: defaultOnError,
    ...restProps,
    onCompleted: (response, payloadErrors) => {
      showMutationErrors(response, payloadErrors);

      onCompleted?.(response, payloadErrors);
    },
  });
}
