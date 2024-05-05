import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { UserAvatarUpdate_user$key } from '@picasso/fragments/src/UserAvatarUpdate_user.graphql';

import _ from 'lodash';

import { Spin } from 'antd';

import AvatarUploader from 'src/Common/Components/Uploaders/AvatarUploader';

import userUpdate from 'src/Hub/Auth/UserUpdatePage/userUpdate';

const fragmentSpec = graphql`
  fragment UserAvatarUpdate_user on User {
    id
    name
    avatar {
      url
    }
  }
`;

interface IUserAvatarUpdateProps {
  user: UserAvatarUpdate_user$key;
  onUpdate?: () => void;
}

function UserAvatarUpdate(props: IUserAvatarUpdateProps) {
  const user = useFragment(fragmentSpec, props.user);

  const [commitUserUpdate, userUpdateIsInFlight] = userUpdate();

  const onSubmit = (values) => {
    commitUserUpdate({
      variables: {
        input: {
          objectId: user.id as string,
          name: values.name || user.name,
          avatarSignedId: values.avatar,
        },
      },
      onCompleted: (response, error) => {
        const errors = response.userUpdate?.errors;

        if (_.isEmpty(errors)) {
          props.onUpdate?.();
        }
      },
    });
  };

  return (
    <Spin spinning={userUpdateIsInFlight}>
      <AvatarUploader
        src={user.avatar?.url}
        fileSizeMb={5}
        onUpdate={(signedId) => onSubmit({ avatar: signedId })}
      />
    </Spin>
  );
}

export default UserAvatarUpdate;
