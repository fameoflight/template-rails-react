import React from 'react';
import { graphql } from 'react-relay/hooks';

import { SuperUserJobRecordsQuery } from '@picasso/fragments/src/SuperUserJobRecordsQuery.graphql';

import JSONViewer from '@picasso/shared/src/Components/JSONViewer';
import Table from '@picasso/shared/src/Table';
import { useNetworkLazyReloadQuery } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

import destroyObjectMutation from 'src/Common/mutations/destroyObjectMutation';

const SuperUserJobRecordsPageQuery = graphql`
  query SuperUserJobRecordsQuery {
    superUser {
      id
      jobRecords {
        id
        concurrencyKey
        serializedParams
        queueName
        scheduledAt
      }
    }
  }
`;

function SuperUserJobRecords(props) {
  const [data, updateFetchKey] =
    useNetworkLazyReloadQuery<SuperUserJobRecordsQuery>(
      SuperUserJobRecordsPageQuery,
      {}
    );

  const jobRecords = data.superUser?.jobRecords || [];

  const columns = [
    {
      title: 'Concurrency Key',
      dataIndex: 'concurrencyKey',
      key: 'concurrencyKey',
    },
    {
      title: 'queueName',
      dataIndex: 'queueName',
      key: 'queueName',
    },
    {
      title: 'scheduledAt',
      dataIndex: 'scheduledAt',
      key: 'scheduledAt',
    },
  ];

  return (
    <div>
      <p>SuperUserJobRecords</p>
      <Table.Model
        dataSource={jobRecords}
        columns={columns}
        expandable={{
          expandedRowRender: (record) => (
            <JSONViewer data={record.serializedParams} />
          ),
        }}
        actionProps={{
          columnProps: {
            width: '20%',
          },
          actions: [
            {
              label: 'Destroy',
              key: 'destroy',
              danger: true,
            },
          ],
          onAction: (actionKey, row) => {
            if (actionKey === 'destroy') {
              destroyObjectMutation(row.id, () => {
                updateFetchKey();
              });
            }
          },
        }}
      />
    </div>
  );
}

export default SuperUserJobRecords;
