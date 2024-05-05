import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { VersionItemView_record$key } from '@picasso/fragments/src/VersionItemView_record.graphql';

import TailwindButton from '@picasso/shared/src/Components/TailwindButton';
import { titlize } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Button, Modal } from 'antd';

import DateView from 'src/Common/Components/Display/DateView';
import VersionChangeView from 'src/Common/Components/Version/VersionChangeView';

const fragmentSpec = graphql`
  fragment VersionItemView_record on Version {
    id
    event
    createdAt
    user {
      name
    }
    changes {
      ...VersionChangeView_records
    }
  }
`;

interface IVersionItemViewProps {
  record: VersionItemView_record$key;
}

export function getActionVerb(event: string) {
  const actionMap = {
    create: 'Created',
    update: 'Updated',
    destroy: 'Deleted',
  };
  const action = actionMap[event];

  if (!action) {
    console.warn(`Unknown event: ${event}`);
  }

  return action ? action : titlize(event);
}

function VersionItemView(props: IVersionItemViewProps) {
  const record = useFragment(fragmentSpec, props.record);

  const [modal, contextHolder] = Modal.useModal();

  const handleShowChanges = () => {
    modal.info({
      title: 'Changes',
      width: 800,
      content: (
        <VersionChangeView
          records={record.changes}
          skippedKeys={['updated_at', 'created_at']}
        />
      ),
      okText: 'Close',
    });
  };

  return (
    <>
      <Button type="link" onClick={handleShowChanges} className="p-0">
        Show Changes
      </Button>

      {contextHolder}
    </>
  );
}

export default VersionItemView;
