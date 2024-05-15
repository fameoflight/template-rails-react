import React from 'react';
import { graphql } from 'react-relay/hooks';

import { SuperUserHomePageQuery } from '@picasso/fragments/src/SuperUserHomePageQuery.graphql';

import { useNetworkLazyLoadQuery } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

const pageQuery = graphql`
  query SuperUserHomePageQuery {
    superUser {
      id
      name
    }
  }
`;

function SuperUserHomePage() {
  const data = useNetworkLazyLoadQuery<SuperUserHomePageQuery>(pageQuery);

  const { superUser } = data;

  return (
    <div>
      <h2>Hello Super User {superUser.name}</h2>
    </div>
  );
}

export default SuperUserHomePage;
