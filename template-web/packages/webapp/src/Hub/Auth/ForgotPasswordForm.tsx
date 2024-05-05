import React from 'react';

import _ from 'lodash';

import { Button, Form, Input } from 'antd';

interface IForgotPasswordFormProps {
  form?: any;
  onSubmit?: (values: any) => void;
}

function ForgotPasswordForm({ form, onSubmit }: IForgotPasswordFormProps): any {
  const onFinish = (values) => {
    if (onSubmit) {
      onSubmit(values);
    }
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <Form
      preserve={false}
      form={form}
      layout="vertical"
      onFinish={onFinish}
      name="ForgotPasswordForm"
      onFinishFailed={onFinishFailed}
    >
      <h3 className="text-center text-xl font-bold text-gray-700 mb-8">
        Forgot your password?
      </h3>
      <Form.Item
        label="Email"
        name="email"
        rules={[
          {
            required: true,
            type: 'email',
            message: 'Please input email!',
          },
        ]}
      >
        <Input />
      </Form.Item>

      <Form.Item>
        <Button block type="primary" htmlType="submit" className="px-6 my-4">
          Send Instructions
        </Button>
      </Form.Item>
    </Form>
  );
}

export default ForgotPasswordForm;
