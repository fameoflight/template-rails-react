import { graphql } from 'relay-runtime';

import { userUpdateMutation } from '@picasso/fragments/src/userUpdateMutation.graphql';

import { useCompatMutation } from '@picasso/shared/src/relay/hooks';

function userUpdate() {
  return useCompatMutation<userUpdateMutation>(graphql`
    mutation userUpdateMutation($input: UserUpdateInput!) {
      userUpdate(input: $input) {
        user {
          id
          name
          avatar {
            id
            url
          }
          ...UserAvatarUpdate_user
        }
        errors
      }
    }
  `);
}

export default userUpdate;
