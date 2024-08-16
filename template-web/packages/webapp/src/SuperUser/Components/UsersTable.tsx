import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import {
  UsersTable_users$data,
  UsersTable_users$key,
} from '@picasso/fragments/src/UsersTable_users.graphql';

import Table from '@picasso/shared/src/Table';

import _ from 'lodash';

import { ColumnType } from 'antd/lib/table';

type UserType = UsersTable_users$data[0];

const fragmentSpec = graphql`
  fragment UsersTable_users on User @relay(plural: true) {
    id
    name
  }
`;

interface IUsersTableProps {
  users: UsersTable_users$key;
  onSpoofClick: (user: UserType) => void;
}

const UsersTable = (props: IUsersTableProps) => {
  const users = useFragment(fragmentSpec, props.users);

  const columns: ColumnType<UserType>[] = [
    {
      title: 'Name',
      dataIndex: 'name',
      key: 'name',
    },
  ];

  return (
    <Table.Model
      dataSource={users}
      columns={columns}
      actionProps={{
        actions: [
          {
            label: 'Spoof',
            key: 'spoof',
            danger: true,
          },
        ],
        onAction: (action, row) => {
          if (action === 'spoof') {
            props.onSpoofClick(row);
          }
        },
      }}
    />
  );
};

export default UsersTable;
