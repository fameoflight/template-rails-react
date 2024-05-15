import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { UserForm_record$key } from '@picasso/fragments/src/UserForm_record.graphql';

import _ from 'lodash';

import { Button, Form, FormInstance, Input } from 'antd';

const fragmentSpec = graphql`
  fragment UserForm_record on User {
    id
    name
    nickname
  }
`;

interface IUserFormProps {
  form?: FormInstance<any>;
  record: UserForm_record$key;
  onSubmit: (values: any) => void;
}

const UserForm = (props: IUserFormProps): any => {
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
      name="UserForm"
      onFinishFailed={onFinishFailed}
    >
      <Form.Item name="id" hidden initialValue={record?.id}>
        <Input />
      </Form.Item>

      <Form.Item
        label="Name"
        name="name"
        initialValue={record.name}
        rules={[
          {
            required: true,
            message: 'Please input name!',
          },
        ]}
      >
        <Input />
      </Form.Item>

      <Form.Item
        label="Nickname"
        name="nickname"
        tooltip="This will be used as your public name"
        initialValue={record.nickname}
      >
        <Input />
      </Form.Item>

      <Form.Item>
        <Button type="primary" htmlType="submit" className="min-w-full mt-4">
          Update
        </Button>
      </Form.Item>
    </Form>
  );
};

export default UserForm;
