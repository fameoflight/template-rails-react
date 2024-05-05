import React, { useEffect } from 'react';
import { graphql } from 'relay-runtime';

import { EndSpoofPageMutation } from '@picasso/fragments/src/EndSpoofPageMutation.graphql';

import { useCompatMutation } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

import { Spin } from 'antd';

const EndSpoofPage = () => {
  const [commitSpoof, spoofIsInFlight] =
    useCompatMutation<EndSpoofPageMutation>(graphql`
      mutation EndSpoofPageMutation($input: SuperUserUpdateInput!) {
        superUserUpdate(input: $input) {
          errors
        }
      }
    `);

  useEffect(() => {
    commitSpoof({
      variables: {
        input: {
          spoofId: null,
        },
      },
      onCompleted: (response, payloadError) => {
        const errors = response.superUserUpdate?.errors;

        if (_.isEmpty(errors)) {
          window.location.replace('/');
        }
      },
      updater: (store) => {
        store.invalidateStore();
      },
    });
  }, []);

  return (
    <Spin spinning={spoofIsInFlight}>
      <div>Redirect...</div>
    </Spin>
  );
};

export default EndSpoofPage;
