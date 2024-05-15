import React, { useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { graphql } from 'relay-runtime';

import { ConfirmAccountPageQuery } from '@picasso/fragments/src/ConfirmAccountPageQuery.graphql';

import api from '@picasso/shared/src/api';
import { useNetworkLazyReloadQuery } from '@picasso/shared/src/relay/hooks';
import { searchParams } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Button, Form, Input, Spin } from 'antd';

const pageQuery = graphql`
  query ConfirmAccountPageQuery {
    currentUser {
      id
      name
      confirmedAt
    }
  }
`;

function ConfirmAccountPage() {
  const [data] = useNetworkLazyReloadQuery<ConfirmAccountPageQuery>(pageQuery);

  const [loading, setLoading] = React.useState(false);

  const params = useParams();

  const token = params.token;

  const next = () => {
    return searchParams().get('next') || '/';
  };

  const onComplete = () => {
    window.location.replace(next());
  };

  const redirectUri = window.location.origin;

  const onSubmit = () => {
    setLoading(true);
    api
      .browserRequestClient()
      .get({
        endpoint: '/api/internal/auth/confirmation',
        params: {
          confirmation_token: token,
          redirect_url: redirectUri,
        },
      })
      .then((response) => {
        api.updateAuthHeaders(response);
        onComplete();
      })
      .catch((error) => {
        onComplete();
      });
  };

  useEffect(() => {
    if (data.currentUser?.confirmedAt) {
      onComplete();
    }
  }, [data.currentUser]);

  // Note(hemantv): Form is use to submit the form on enter key press.
  // many email clients will visit the link in the email, so to avoid confirmation

  return (
    <Spin spinning={loading}>
      <h2 className="text-xl font-bold mb-8">Confirming your account</h2>

      <Form layout="vertical" onFinish={onSubmit}>
        <Form.Item
          name="email"
          label="Email"
          rules={[
            {
              required: true,
              type: 'email',
              message: 'Please input your email!',
            },
          ]}
        >
          <Input />
        </Form.Item>

        <Form.Item name="token" label="Token" hidden initialValue={token}>
          <Input />
        </Form.Item>

        <Form.Item>
          <Button block type="primary" htmlType="submit">
            Confirm
          </Button>
        </Form.Item>
      </Form>
    </Spin>
  );
}

export default ConfirmAccountPage;
