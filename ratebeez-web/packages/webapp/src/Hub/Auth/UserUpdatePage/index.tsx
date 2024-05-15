import React from 'react';
import { graphql } from 'react-relay/hooks';

import { UserUpdatePageQuery } from '@picasso/fragments/src/UserUpdatePageQuery.graphql';

import ErrorPage from '@picasso/shared/src/Components/ErrorPage';
import { useNetworkLazyLoadQuery } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

import { Button, Spin, notification } from 'antd';

import ButtonLink from 'src/Common/Components/ButtonLink';
import AvatarUploader from 'src/Common/Components/Uploaders/AvatarUploader';

import UserForm from 'src/Hub/Auth/UserUpdatePage/UserForm';

import userUpdate from './userUpdate';

function UserUpdatePage() {
  const data = useNetworkLazyLoadQuery<UserUpdatePageQuery>(graphql`
    query UserUpdatePageQuery {
      currentUser {
        id
        name
        nickname
        otpEnabled
        avatar {
          id
          url
        }
        ...UserForm_record
      }
    }
  `);

  const currentUser = data.currentUser;

  if (!currentUser) {
    return <ErrorPage errors={['User not found']} />;
  }

  const [commitUserUpdate, userUpdateIsInFlight] = userUpdate();

  const onSubmit = (values) => {
    const name = values.name || currentUser.name;
    const nickname = values.nickname || currentUser.nickname;

    commitUserUpdate({
      variables: {
        input: {
          objectId: currentUser.id,
          name: name,
          nickname: nickname,
          avatarSignedId: values.avatar,
        },
      },
      onCompleted: (response, error) => {
        const errors = response.userUpdate?.errors;

        if (_.isEmpty(errors)) {
          notification.info({
            message: 'Saved',
            description: 'User Updated',
          });
        }
      },
    });
  };

  return (
    <Spin spinning={userUpdateIsInFlight} wrapperClassName="min-h-[400px] ">
      <div className="text-center mb-4">
        <h2 className="text-md font-semibold text-gray-900 mb-4">Profile</h2>
        <AvatarUploader
          src={currentUser?.avatar?.url}
          fileSizeMb={5}
          onUpdate={(signedId) => onSubmit({ avatar: signedId })}
        />
      </div>
      <UserForm record={data.currentUser} onSubmit={onSubmit} />

      <ButtonLink to="/auth/update-otp" block>
        {currentUser.otpEnabled ? 'Update' : 'Enable'} OTP
      </ButtonLink>
    </Spin>
  );
}

export default UserUpdatePage;
