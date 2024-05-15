import React from 'react';

import _ from 'lodash';

import { Button, Form, Input } from 'antd';
import { PasswordInput } from 'antd-password-input-strength';

interface IUpdatePasswordFormProps {
  form?: any;
  onSubmit?: (values: any) => void;
}

export const PASSWORD_REGEX = /^.{8,}$/;

function UpdatePasswordForm({ form, onSubmit }: IUpdatePasswordFormProps): any {
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
      name="UpdatePasswordForm"
      onFinishFailed={onFinishFailed}
    >
      <Form.Item
        label="Password"
        name="password"
        rules={[
          {
            pattern: PASSWORD_REGEX,
            message: 'Password length should be minimum 8 characters',
          },
          {
            required: true,
            message: 'Please input password!',
          },
        ]}
      >
        <PasswordInput placeholder="Password" />
      </Form.Item>

      <Form.Item
        name="password_confirmation"
        label="Confirm Password"
        dependencies={['password']}
        hasFeedback
        rules={[
          {
            required: true,
            message: 'Please confirm your password!',
          },
          ({ getFieldValue }) => ({
            validator(_rule, value) {
              if (!value || getFieldValue('password') === value) {
                return Promise.resolve();
              }
              return Promise.reject(
                new Error('The two passwords that you entered do not match!')
              );
            },
          }),
        ]}
      >
        <Input.Password placeholder="Confirm Password" />
      </Form.Item>

      {onSubmit ? (
        <Form.Item>
          <Button type="primary" htmlType="submit">
            Submit
          </Button>
        </Form.Item>
      ) : null}
    </Form>
  );
}

export default UpdatePasswordForm;
