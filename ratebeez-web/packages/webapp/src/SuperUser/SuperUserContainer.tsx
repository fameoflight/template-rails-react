import React from 'react';
import { graphql } from 'react-relay/hooks';
import { Outlet } from 'react-router-dom';

import { SuperUserContainerQuery } from '@picasso/fragments/src/SuperUserContainerQuery.graphql';

import { useNetworkLazyLoadQuery } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

import BrandedNavBar from 'src/Common/Components/Dashboard/BrandedNavBar';

function SuperUserContainer() {
  const data = useNetworkLazyLoadQuery<SuperUserContainerQuery>(graphql`
    query SuperUserContainerQuery {
      superUser {
        id
        name
      }
      currentUser {
        id
        name
      }
    }
  `);

  if (!data.currentUser) {
    return null;
  }

  const navigationItems = [
    { name: 'Home', link: '' },
    { name: 'Users', link: 'users' },
    {
      name: 'Job Records',
      link: 'job-records',
    },
  ];

  return (
    <BrandedNavBar navigationItems={navigationItems}>
      <div className="mt-4 px-4">
        <Outlet />
      </div>
    </BrandedNavBar>
  );
}

export default SuperUserContainer;
