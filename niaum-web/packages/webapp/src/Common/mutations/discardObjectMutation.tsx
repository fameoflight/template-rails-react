import { graphql } from 'relay-runtime';

import { discardObjectMutationMutation } from '@picasso/fragments/src/discardObjectMutationMutation.graphql';

import { commitCompatMutation } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

function discardObjectMutation(
  objectId: string,
  onCompleted?: (
    response: discardObjectMutationMutation['response'],
    payloadError: any
  ) => void,
  onError?: (error) => void
) {
  commitCompatMutation<discardObjectMutationMutation>({
    variables: { input: { objectId } },
    mutation: graphql`
      mutation discardObjectMutationMutation($input: DiscardObjectInput!) {
        discardObject(input: $input) {
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

export default discardObjectMutation;
