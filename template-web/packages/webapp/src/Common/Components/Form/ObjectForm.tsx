import React from 'react';

import _ from 'lodash';

import { Button, Form, Input } from 'antd';

interface IObjectFormProps {
  form?: any;
  record?: null | {
    id: string;
    name: string | null;
    description?: string | null;
  };
  children?: any;
  onSubmit?: (values: any) => void;
}

function ObjectForm(props: IObjectFormProps): any {
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
      name="ObjectForm"
      onFinishFailed={onFinishFailed}
    >
      <Form.Item name="id" hidden initialValue={props.record?.id}>
        <Input />
      </Form.Item>

      <Form.Item
        label="Name"
        name="name"
        initialValue={props.record?.name}
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
        label="Description"
        name="description"
        initialValue={props.record?.description}
      >
        <Input.TextArea />
      </Form.Item>

      {props.children}

      {props.onSubmit ? (
        <Form.Item>
          <Button type="primary" htmlType="submit">
            Submit
          </Button>
        </Form.Item>
      ) : null}
    </Form>
  );
}

export default ObjectForm;
