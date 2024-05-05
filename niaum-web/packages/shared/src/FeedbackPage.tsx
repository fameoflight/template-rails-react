import React from 'react';
import { graphql } from 'react-relay/hooks';

import { FeedbackPageQuery } from '@picasso/fragments/src/FeedbackPageQuery.graphql';

import { useNetworkLazyLoadQuery } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

import Feedback from './Components/Feedback';
import Suspense from './Components/Suspense';

const FeedbackPagePageQuery = graphql`
  query FeedbackPageQuery {
    currentUser {
      id
      cannyToken
    }
  }
`;

interface FeedbackPageProps {
  className?: string;
}

function FeedbackPageComponent(props: FeedbackPageProps) {
  const data = useNetworkLazyLoadQuery<FeedbackPageQuery>(
    FeedbackPagePageQuery,
    {},
    {
      fetchPolicy: 'store-or-network',
    }
  );

  const currentUser = data.currentUser;

  if (!currentUser) {
    return null;
  }

  return (
    <Feedback className={props.className} ssoToken={currentUser.cannyToken} />
  );
}

function FeedbackPage(props: FeedbackPageProps) {
  return (
    <Suspense>
      <FeedbackPageComponent {...props} />
    </Suspense>
  );
}
export default FeedbackPage;
