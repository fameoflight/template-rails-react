import React from 'react';
import { graphql } from 'react-relay/hooks';
import { Navigate, Outlet, useLocation } from 'react-router-dom';

import { ProtectedLayoutQuery } from '@picasso/fragments/src/ProtectedLayoutQuery.graphql';

import FeedbackPage from '@picasso/shared/src/FeedbackPage';
import analytics from '@picasso/shared/src/analytics';
import { AuthProvider } from '@picasso/shared/src/context/authContext';
import { useNetworkLazyLoadQuery } from '@picasso/shared/src/relay/hooks';
import { searchParams } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { CommentOutlined, LogoutOutlined } from '@ant-design/icons';
import { Button, Modal } from 'antd';

import ButtonLink from 'src/Common/Components/ButtonLink';

import UserConfirmAlert from './UserConfirmAlert';

interface IProtectedLayoutProps {
  redirect: boolean;
}

function ProtectedLayout(props: IProtectedLayoutProps) {
  const location = useLocation();

  const [showFeedback, setShowFeedback] = React.useState(false);

  const force = searchParams().get('force') == 'true';

  const data = useNetworkLazyLoadQuery<ProtectedLayoutQuery>(
    graphql`
      query ProtectedLayoutQuery {
        env
        currentUser {
          id
          modelId
          name
          spoof
          ...UserConfirmAlert_record
        }
      }
    `,
    {},
    {
      fetchPolicy: force ? 'network-only' : 'store-or-network',
    }
  );

  const { currentUser } = data;

  if (!currentUser) {
    return <Navigate to="/auth/signin" />;
  }

  if (!currentUser.spoof) {
    analytics.identify(currentUser.modelId, {
      name: currentUser.name,
    });
  }

  if (props.redirect) {
    const redirectPath = '/';

    if (!_.startsWith(location.pathname, redirectPath)) {
      return <Navigate to={redirectPath} replace />;
    }
  }
  return (
    <AuthProvider value={data}>
      <UserConfirmAlert record={currentUser} />

      <Outlet />

      <div className="fixed bottom-16 right-8">
        <Button type="primary" onClick={() => setShowFeedback(true)}>
          <CommentOutlined />
          Feedback
        </Button>

        {currentUser.spoof && (
          <ButtonLink
            className="float-right ml-4"
            type="primary"
            to="/auth/end-spoof"
          >
            End Spoof <LogoutOutlined />
          </ButtonLink>
        )}
      </div>

      <Modal
        open={showFeedback}
        width="80%"
        onCancel={() => setShowFeedback(false)}
        closable={true}
        footer={null}
        title="Feedback"
        forceRender={true}
      >
        <FeedbackPage className="p-2" />
      </Modal>
    </AuthProvider>
  );
}

export default ProtectedLayout;
