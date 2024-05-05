import React from 'react';
import { graphql } from 'react-relay/hooks';

import { SuperUserJobRecordsQuery } from '@picasso/fragments/src/SuperUserJobRecordsQuery.graphql';

import JSONViewer from '@picasso/shared/src/Components/JSONViewer';
import Table from '@picasso/shared/src/Table';
import { useNetworkLazyReloadQuery } from '@picasso/shared/src/relay/hooks';

import _ from 'lodash';

import destroyObjectMutation from 'src/Common/mutations/destroyObjectMutation';
import PageContainer from 'src/Common/Components/PageContainer';

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
      title: 'Queue Name',
      dataIndex: 'queueName',
      key: 'queueName',
    },
    {
      title: 'Scheduled At',
      dataIndex: 'scheduledAt',
      key: 'scheduledAt',
    },
  ];

  return (
    <PageContainer title="Job Records">
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
            width: '10%',
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
    </PageContainer>
  );
}

export default SuperUserJobRecords;
