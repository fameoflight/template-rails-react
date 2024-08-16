import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { UserOtpAlert_record$key } from '@picasso/fragments/src/UserOtpAlert_record.graphql';

import _ from 'lodash';

import { Alert } from 'antd';

import ButtonLink from 'src/Common/Components/ButtonLink';

const fragmentSpec = graphql`
  fragment UserOtpAlert_record on User {
    id
    otpEnabled
  }
`;

interface IUserOtpAlertProps {
  className?: string;
  record: UserOtpAlert_record$key;
}

function UserOtpAlert(props: IUserOtpAlertProps) {
  const record = useFragment(fragmentSpec, props.record);

  if (!record) {
    return null;
  }

  if (record.otpEnabled) {
    return null;
  }

  return (
    <Alert
      className={props.className}
      message="Two Factor Authentication is not enabled"
      description={
        <div>
          <p>
            Two Factor Authentication is not enabled for your account. It&#39;s
            highly recommended to enable it for your account.
          </p>

          <ButtonLink
            to="/auth/update-otp"
            className="mt-4"
            size="small"
            type="dashed"
          >
            Enable
          </ButtonLink>
        </div>
      }
      type="warning"
      showIcon
    />
  );
}

export default UserOtpAlert;
