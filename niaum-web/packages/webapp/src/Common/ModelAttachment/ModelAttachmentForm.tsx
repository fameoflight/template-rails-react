import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { ModelAttachmentForm_record$key } from '@picasso/fragments/src/ModelAttachmentForm_record.graphql';

import SingleFileFormItem, {
  UploadProps,
} from '@picasso/shared/src/Components/SingleFileFormItem';

import _ from 'lodash';

import { Button, Form, FormInstance, Input } from 'antd';

const fragmentSpec = graphql`
  fragment ModelAttachmentForm_record on ModelAttachment {
    id
    name
    attachment {
      id
      url
      contentType
    }
  }
`;

interface IModelAttachmentFormProps {
  form?: FormInstance<any>;
  record: ModelAttachmentForm_record$key | null;
  uploadProps: UploadProps;
  onSubmit?: (values: any) => void;
}

const ModelAttachmentForm = (props: IModelAttachmentFormProps): any => {
  const record = useFragment(fragmentSpec, props.record);
  const onFinish = (values) => {
    props.onSubmit?.(values);
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <Form
      preserve={false}
      form={props.form}
      layout="vertical"
      onFinish={onFinish}
      name="ModelAttachmentForm"
      onFinishFailed={onFinishFailed}
    >
      <Form.Item name="id" hidden initialValue={record?.id}>
        <Input />
      </Form.Item>

      <Form.Item
        label="Name"
        name="name"
        initialValue={record?.name}
        rules={[
          {
            required: true,
            message: 'Please input name!',
          },
        ]}
      >
        <Input />
      </Form.Item>

      <SingleFileFormItem
        name="file"
        uploadProps={props.uploadProps}
        attachmentProps={{
          name: record?.name || 'Attachment',
          attachment: record?.attachment,
        }}
      />
      {props.onSubmit ? (
        <Form.Item>
          <Button type="primary" htmlType="submit">
            Submit
          </Button>
        </Form.Item>
      ) : null}
    </Form>
  );
};

export default ModelAttachmentForm;
