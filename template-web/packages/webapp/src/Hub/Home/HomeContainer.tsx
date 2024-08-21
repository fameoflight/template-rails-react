import React from 'react';
import { graphql } from 'react-relay/hooks';
import { Outlet } from 'react-router-dom';

import { HomeContainerQuery } from '@picasso/fragments/src/HomeContainerQuery.graphql';

import { useNetworkLazyLoadQuery } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

import BrandedNavBar from 'src/Common/Components/Dashboard/BrandedNavBar';

function HomeContainer() {
  const data = useNetworkLazyLoadQuery<HomeContainerQuery>(graphql`
    query HomeContainerQuery {
      currentUser {
        id
        name
      }
    }
  `);

  const currentUser = data.currentUser;

  if (!currentUser) {
    return null;
  }

  const navigationItems = [
    {
      name: 'Home',
      link: '/',
    },
  ];

  return (
    <BrandedNavBar navigationItems={navigationItems}>
      <div className="mt-4 px-2">
        <Outlet />
      </div>
    </BrandedNavBar>
  );
}

export default HomeContainer;
