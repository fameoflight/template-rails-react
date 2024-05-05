import React from 'react';

import _ from 'lodash';

import { Button, Form, FormInstance, Input } from 'antd';

interface ILogInFormProps {
  children?: React.ReactNode;
  onSubmit: (values: any) => void;
  showTwoFactor: boolean;
}

const LogInForm = (props: ILogInFormProps): any => {
  const [form] = Form.useForm();

  const onFinish = (values) => {
    props.onSubmit?.(values);

    form.setFieldsValue({
      otp: '',
    });
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <Form
      form={form}
      layout="vertical"
      onFinish={onFinish}
      name="LogInForm"
      onFinishFailed={onFinishFailed}
    >
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

      <Form.Item
        label="Password"
        name="password"
        rules={[
          {
            required: true,
            message: 'Please input password!',
          },
        ]}
      >
        <Input.Password />
      </Form.Item>

      {props.showTwoFactor && (
        <Form.Item label="Two Factor Code" name="otp">
          <Input />
        </Form.Item>
      )}

      {props.children}

      <Form.Item>
        <Button block type="primary" htmlType="submit">
          Log In
        </Button>
      </Form.Item>
    </Form>
  );
};

export default LogInForm;
