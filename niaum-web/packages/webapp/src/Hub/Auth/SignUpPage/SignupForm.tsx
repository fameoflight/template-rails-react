import React from 'react';
import { Link, useParams } from 'react-router-dom';

import _ from 'lodash';

import { Button, Checkbox, Form, Input } from 'antd';
import { PasswordInput } from 'antd-password-input-strength';

export const PASSWORD_REGEX = /^.{8,}$/;

interface ISignupFormProps {
  onSubmit: (values: any) => void;
}

const SignupForm = (props: ISignupFormProps) => {
  const params = useParams();

  const signupCode = _.get(params, 'signupCode');

  return (
    <Form
      preserve={false}
      name="basic"
      layout="vertical"
      onFinish={props.onSubmit}
    >
      <Form.Item hidden name="signupCode" initialValue={signupCode}>
        <Input />
      </Form.Item>

      <Form.Item
        label="Name"
        name="name"
        rules={[
          {
            required: true,
            message: 'Please input email',
          },
        ]}
      >
        <Input placeholder="Your name" />
      </Form.Item>

      <Form.Item
        label="Email"
        name="email"
        rules={[
          {
            type: 'email',
            message: 'The input is not valid E-mail!',
          },
          {
            required: true,
            message: 'Please input email',
          },
        ]}
      >
        <Input placeholder="Your email" />
      </Form.Item>

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
        name="confirm"
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

      <Form.Item
        name="agreement"
        valuePropName="checked"
        rules={[
          {
            validator: (_rule, value) =>
              value
                ? Promise.resolve()
                : Promise.reject(new Error('Should accept agreement')),
          },
        ]}
      >
        <Checkbox>
          I agree to{' '}
          <Link to="/policies/terms" target="_blank">
            terms and conditions
          </Link>
        </Checkbox>
      </Form.Item>

      <Form.Item className="mt-4">
        <Button block type="primary" htmlType="submit">
          Sign Up
        </Button>
      </Form.Item>
    </Form>
  );
};

export default SignupForm;
