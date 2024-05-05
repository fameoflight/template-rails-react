import React from 'react';
import { graphql } from 'react-relay/hooks';

import { ModelAttachmentPageMutation } from '@picasso/fragments/src/ModelAttachmentPageMutation.graphql';
import { ModelAttachmentPageQuery } from '@picasso/fragments/src/ModelAttachmentPageQuery.graphql';

import ErrorPage from '@picasso/shared/src/Components/ErrorPage';
import Suspense from '@picasso/shared/src/Components/Suspense';
import useFetchKey from '@picasso/shared/src/hooks/useFetchKey';
import {
  useCompatMutation,
  useNetworkLazyLoadQuery,
} from '@picasso/shared/src/relay/hooks';
import uploadFile from '@picasso/shared/src/utils/files/upload';

import _ from 'lodash';

import { FileAddOutlined } from '@ant-design/icons';
import { Button, Modal, Spin } from 'antd';

import FormModal from 'src/Common/Components/Modals/FormModal';
import ModelAttachmentForm from 'src/Common/ModelAttachment/ModelAttachmentForm';
import ModelAttachmentList from 'src/Common/ModelAttachment/ModelAttachmentList';
import destroyObjectMutation from 'src/Common/mutations/destroyObjectMutation';

interface IModelAttachmentPageProps {
  modelAttachableId: string;
  accept?: string;
  viewType?: 'list' | 'table';
  attachmentName?: string;
  actions?: React.ReactNode[];
  onUpdate?: () => void;
  onDelete?: true | ((attachment: RelayNode) => void);
}

function ModelAttachmentContainer(props: IModelAttachmentPageProps) {
  const attachmentName = props.attachmentName || 'Attachment';
  const [fetchKey, updateFetchKey] = useFetchKey();

  const [loading, setLoading] = React.useState(false);
  const data = useNetworkLazyLoadQuery<ModelAttachmentPageQuery>(
    graphql`
      query ModelAttachmentPageQuery($id: ID!) {
        node(id: $id) {
          id
          __typename
          ... on ModelAttachmentInterface {
            id
            attachments {
              id
              ...ModelAttachmentList_records
            }
          }
        }
      }
    `,
    { id: props.modelAttachableId },
    {
      fetchKey,
    }
  );

  const [isModalOpen, setIsModalOpen] = React.useState(false);

  const node = data.node;
  const attachments = data.node?.attachments;

  if (!node || !attachments) {
    return <ErrorPage errors={['Something went wrong']} />;
  }

  const onUpdate = () => {
    updateFetchKey();
    props.onUpdate?.();
  };

  const [commitAttachment, commitAttachmentIsInFlight] =
    useCompatMutation<ModelAttachmentPageMutation>(graphql`
      mutation ModelAttachmentPageMutation(
        $input: ModelAttachmentCreateUpdateInput!
      ) {
        modelAttachmentCreateUpdate(input: $input) {
          modelAttachment {
            id
          }
          errors
        }
      }
    `);

  const onSubmit = async (values: any) => {
    setIsModalOpen(false);
    if (!values) {
      return;
    }

    setLoading(true);

    const uploadFileResponse = await uploadFile({ file: values.file });

    const attachmentId = uploadFileResponse?.signedId;

    commitAttachment({
      variables: {
        input: {
          ownerId: props.modelAttachableId,
          name: values.name,
          attachmentSignedId: attachmentId,
        },
      },
      onCompleted: (response, payloadErrors) => {
        setLoading(false);
        const errors = response.modelAttachmentCreateUpdate?.errors;

        if (_.isEmpty(errors)) {
          onUpdate();
        }
      },
    });
  };

  const onDelete = (modelAttachment: RelayNode) => {
    if (props.onDelete !== true) {
      props.onDelete?.(modelAttachment);
      return;
    }

    // Default delete
    Modal.confirm({
      title: 'Are you sure?',
      content: (
        <div>
          <p>
            You are about to delete <b>{attachmentName}</b>
          </p>
          <p className="bg-red-100 p-2 rounded text-red-600 mt-2">
            This action cannot be undone. All data associated with this{' '}
            {attachmentName} will be deleted.
          </p>
        </div>
      ),
      okText: 'Delete',
      okType: 'danger',
      cancelText: 'Cancel',
      onOk: () => {
        destroyObjectMutation(modelAttachment.id, (response) => {
          if (_.isEmpty(response.destroyObject?.errors)) {
            onUpdate();
          }
        });
      },
    });
  };

  return (
    <Spin spinning={commitAttachmentIsInFlight || loading}>
      <ModelAttachmentList
        records={attachments}
        viewType={props.viewType}
        onDelete={props.onDelete ? onDelete : undefined}
      />

      <div className="mt-4 flex flex-row space-x-4">
        <Button onClick={() => setIsModalOpen(true)} type="primary">
          <FileAddOutlined /> Add {attachmentName}
        </Button>

        {props.actions}
      </div>

      <FormModal
        title={`Add ${attachmentName}`}
        open={isModalOpen}
        onSubmit={onSubmit}
      >
        <ModelAttachmentForm
          record={null}
          uploadProps={{
            accept: props.accept,
            fileSizeLimitMB: 10,
          }}
        />
      </FormModal>
    </Spin>
  );
}

function ModelAttachmentPage(props: IModelAttachmentPageProps) {
  return (
    <Suspense>
      <ModelAttachmentContainer {...props} />
    </Suspense>
  );
}

export default ModelAttachmentPage;
