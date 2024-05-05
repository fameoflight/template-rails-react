import React from 'react';
import QRCode from 'react-qr-code';
import { graphql } from 'react-relay/hooks';
import { useNavigate } from 'react-router-dom';

import { UserUpdateOtpPageMutation } from '@picasso/fragments/src/UserUpdateOtpPageMutation.graphql';
import { UserUpdateOtpPageQuery } from '@picasso/fragments/src/UserUpdateOtpPageQuery.graphql';

import ErrorPage from '@picasso/shared/src/Components/ErrorPage';
import {
  useCompatMutation,
  useNetworkLazyLoadQuery,
} from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

import { Alert, Button, Form, Input, Spin, notification } from 'antd';

const UserUpdateOtpPagePageQuery = graphql`
  query UserUpdateOtpPageQuery {
    currentUser {
      id
      otpEnabled
      otpProvisioningUri
    }
  }
`;

function UserUpdateOtpPage(props) {
  const navigate = useNavigate();
  const data = useNetworkLazyLoadQuery<UserUpdateOtpPageQuery>(
    UserUpdateOtpPagePageQuery,
    {},
    {
      fetchPolicy: 'store-or-network',
    }
  );

  const currentUser = data.currentUser;

  console.log(currentUser);

  const provisioningUri = currentUser?.otpProvisioningUri || null;

  const otpKey = provisioningUri
    ? new URL(provisioningUri).searchParams.get('secret')
    : null;

  if (!currentUser) {
    return <ErrorPage errors={['User not found']} />;
  }

  if (!provisioningUri || !otpKey) {
    return <ErrorPage errors={['OTP key not found']} />;
  }

  const [commitUserUpdate, commitIsInFlight] =
    useCompatMutation<UserUpdateOtpPageMutation>(graphql`
      mutation UserUpdateOtpPageMutation($input: UserOtpUpdateInput!) {
        userOtpUpdate(input: $input) {
          user {
            id
            otpEnabled
            otpProvisioningUri
          }
          errors
        }
      }
    `);

  const onSubmit = (values) => {
    commitUserUpdate({
      variables: {
        input: {
          objectId: currentUser.id,
          otpKey: values.otpKey,
          otpCode1: values.otpCode1,
          otpCode2: values.otpCode2,
        },
      },
      onCompleted: (response, error) => {
        const errors = response.userOtpUpdate?.errors;
        if (_.isEmpty(errors)) {
          notification.success({
            message: values.otpKey == 'null' ? 'OTP disabled' : 'OTP enabled',
          });

          navigate('/auth/update');
        }
      },
    });
  };

  return (
    <Spin spinning={commitIsInFlight} wrapperClassName="min-h-[400px]">
      <div className="text-center mb-4">
        <h3 className="text-xl font-bold mb-4">Scan the QR code</h3>

        <QRCode value={currentUser.otpProvisioningUri} />

        <p className="text-sm mt-8">
          in your authenticator app and enter the two consecutive codes below
        </p>
      </div>

      <Form layout="vertical" onFinish={onSubmit}>
        <Form.Item name="otpKey" label="OTP key" hidden initialValue={otpKey}>
          <Input />
        </Form.Item>
        <Form.Item
          label="OTP Code 1"
          name="otpCode1"
          rules={[{ required: true, message: 'Please input your otp code!' }]}
        >
          <Input />
        </Form.Item>

        <Form.Item
          label="OTP Code 2"
          name="otpCode2"
          rules={[{ required: true, message: 'Please input your otp code!' }]}
        >
          <Input />
        </Form.Item>

        <Form.Item>
          <Button type="primary" htmlType="submit" className="min-w-full mt-4">
            {currentUser.otpEnabled ? 'Update' : 'Setup'} OTP
          </Button>
        </Form.Item>
      </Form>

      {currentUser.otpEnabled ? (
        <Button
          block
          type="primary"
          danger
          onClick={() => {
            onSubmit({
              otpKey: 'null',
              otpCode1: '',
              otpCode2: '',
            });
          }}
        >
          Disable OTP
        </Button>
      ) : null}
    </Spin>
  );
}

export default UserUpdateOtpPage;
