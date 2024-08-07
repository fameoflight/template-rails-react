import React from 'react';
import { graphql } from 'react-relay/hooks';

import { HomePageQuery } from '@picasso/fragments/src/HomePageQuery.graphql';

import { useNetworkLazyLoadQuery } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

const pageQuery = graphql`
  query HomePageQuery {
    currentUser {
      id
      name
    }
  }
`;

function HomePage() {
  const data = useNetworkLazyLoadQuery<HomePageQuery>(pageQuery);

  if (!data.currentUser) {
    return null;
  }

  return (
    <div>
      <h1>Welcome, {_.get(data, 'currentUser.name')}!</h1>
    </div>
  );
}

export default HomePage;
