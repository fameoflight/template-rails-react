import React from 'react';
import { graphql } from 'react-relay/hooks';

import { SuperUserUserSearchMutation } from '@picasso/fragments/src/SuperUserUserSearchMutation.graphql';
import { SuperUserUserSearchQuery } from '@picasso/fragments/src/SuperUserUserSearchQuery.graphql';

import AdvanceTabs, {
  IAdvanceTabProps,
} from '@picasso/shared/src/Components/AdvanceTabs';
import {
  useCompatMutation,
  useNetworkLazyLoadQuery,
} from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

import { Input } from 'antd';

import PageContainer from 'src/Common/Components/PageContainer';

import UsersTable from 'src/SuperUser/Components/UsersTable';

const pageQuery = graphql`
  query SuperUserUserSearchQuery($term: String) {
    superUser {
      id
      name
      users(term: $term) {
        id
        ...UsersTable_users
      }
    }
  }
`;

function SuperUserUserSearch() {
  const [term, setTerm] = React.useState<string | null>(null);

  const data = useNetworkLazyLoadQuery<SuperUserUserSearchQuery>(pageQuery, {
    term: term,
  });

  const { superUser } = data;

  const [commitSpoof, spoofIsInFlight] =
    useCompatMutation<SuperUserUserSearchMutation>(graphql`
      mutation SuperUserUserSearchMutation($input: SuperUserUpdateInput!) {
        superUserUpdate(input: $input) {
          errors
        }
      }
    `);

  const onSpoofClick = (user: RelayNode) => {
    commitSpoof({
      variables: {
        input: {
          spoofId: user.id,
        },
      },
      onCompleted: (response) => {
        const errors = response.superUserUpdate?.errors;

        if (_.isEmpty(errors)) {
          window.location.replace('/');
        }
      },
      updater: (store) => {
        store.invalidateStore();
      },
    });
  };

  const tabs: IAdvanceTabProps<string>[] = [
    {
      key: 'users',
      label: 'Users',
      render: () => (
        <>
          <Input.Search
            placeholder="Search Users (name or email)"
            onSearch={(term) => setTerm(term)}
            className="mb-4"
            enterButton="Search"
          />
          <UsersTable users={superUser.users} onSpoofClick={onSpoofClick} />
        </>
      ),
    },
  ];

  return (
    <PageContainer title="Companies" loading={spoofIsInFlight}>
      <AdvanceTabs tabs={tabs} />
    </PageContainer>
  );
}

export default SuperUserUserSearch;
