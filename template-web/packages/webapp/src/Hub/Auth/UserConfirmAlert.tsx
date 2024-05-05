import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { UserConfirmAlert_record$key } from '@picasso/fragments/src/UserConfirmAlert_record.graphql';

import Warnings from '@picasso/shared/src/Components/Warnings';

import _ from 'lodash';

import { Button, notification } from 'antd';

import userUpdate from 'src/Hub/Auth/UserUpdatePage/userUpdate';

import moment from 'moment';

const fragmentSpec = graphql`
  fragment UserConfirmAlert_record on User {
    id
    createdAt
    confirmedAt
  }
`;

interface IUserConfirmAlertProps {
  record: UserConfirmAlert_record$key;
}

function UserConfirmAlert(props: IUserConfirmAlertProps) {
  const record = useFragment(fragmentSpec, props.record);

  const [commitUserUpdate, userUpdateIsInFlight] = userUpdate();

  if (record.confirmedAt) {
    return null;
  }

  const resendConfirmation = () => {
    commitUserUpdate({
      variables: {
        input: {
          objectId: record.id,
          sendConfirmationInstructions: true,
        },
      },

      onCompleted: (response) => {
        const errors = response.userUpdate?.errors;

        if (_.isEmpty(errors)) {
          notification.success({
            message: 'Confirmation instructions sent',
            description: 'Please check your email',
          });
        }
      },
    });
  };

  return (
    <Warnings
      title="Attention please!"
      errors={[
        'Please check your email and click on the confirmation link to activate your account.',
      ]}
      actions={[
        <Button
          key="resend"
          type="ghost"
          size="small"
          onClick={resendConfirmation}
          loading={userUpdateIsInFlight}
        >
          Resend instructions
        </Button>,
      ]}
    />
  );
}

export default UserConfirmAlert;
