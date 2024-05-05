import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import {
  ModelAttachmentList_records$data,
  ModelAttachmentList_records$key,
} from '@picasso/fragments/src/ModelAttachmentList_records.graphql';

import Table from '@picasso/shared/src/Table';

import _ from 'lodash';

import { CloseOutlined, DeleteOutlined } from '@ant-design/icons';
import { ColumnsType } from 'antd/lib/table';

import ModelAttachmentView from 'src/Common/ModelAttachment/ModelAttachmentView';

type RecordType = ModelAttachmentList_records$data[0];

const fragmentSpec = graphql`
  fragment ModelAttachmentList_records on ModelAttachment @relay(plural: true) {
    id
    name
    attachment {
      contentType
    }
    ...ModelAttachmentView_attachment
  }
`;

interface IModelAttachmentListProps {
  records: ModelAttachmentList_records$key;
  viewType?: 'table' | 'list';
  onDelete?: (modelAttachment: RelayNode) => void;
}

function ModelAttachmentList(props: IModelAttachmentListProps) {
  const records = useFragment(fragmentSpec, props.records);

  const viewType = props.viewType || 'list';

  if (viewType == 'list') {
    return (
      <div className="flex space-x-2">
        {_.map(records, (attachment) => {
          return (
            <div
              key={attachment.id}
              className="inline hover:opacity-80 hover:bg-gray-50"
            >
              {props.onDelete && (
                <DeleteOutlined
                  className="text-red-500 float-right z-10 clear-both cursor-pointer"
                  onClick={() => {
                    props.onDelete?.(attachment);
                  }}
                />
              )}

              <ModelAttachmentView attachment={attachment} />
            </div>
          );
        })}
      </div>
    );
  }

  const columns: ColumnsType<RecordType> = [
    {
      dataIndex: 'id',
      key: 'id',
      render: (id) => _.findIndex(records, { id }) + 1,
      width: 48,
    },
    {
      title: 'Name',
      dataIndex: 'name',
      key: 'name',
    },
    {
      title: 'Type',
      dataIndex: ['attachment', 'contentType'],
      key: 'contentType',
    },
  ];

  return (
    <Table.Model
      columns={columns}
      dataSource={records}
      expandable={{
        expandedRowRender: (record) => {
          return <ModelAttachmentView attachment={record} />;
        },
      }}
    />
  );
}

export default ModelAttachmentList;
