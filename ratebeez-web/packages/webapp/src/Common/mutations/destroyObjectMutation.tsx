import { graphql } from 'relay-runtime';

import { destroyObjectMutationMutation } from '@picasso/fragments/src/destroyObjectMutationMutation.graphql';

import { commitCompatMutation } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

function destroyObjectMutation(
  objectId: string,
  onCompleted?: (
    response: destroyObjectMutationMutation['response'],
    payloadError: any
  ) => void,
  onError?: (error) => void
) {
  commitCompatMutation<destroyObjectMutationMutation>({
    variables: { input: { objectId } },
    mutation: graphql`
      mutation destroyObjectMutationMutation($input: DestroyObjectInput!) {
        destroyObject(input: $input) {
          errors
        }
      }
    `,
    onCompleted,
    onError,
    updater: (store) => {
      store.delete(objectId);
    },
  });
}

export default destroyObjectMutation;
