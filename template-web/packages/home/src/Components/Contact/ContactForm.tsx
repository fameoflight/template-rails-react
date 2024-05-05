import React from 'react';

import { Button, Form, Input } from 'antd';

interface IContactFormProps {
  submitText?: string;
  onSubmit: (values: any) => void;
}

function ContactForm(props: IContactFormProps) {
  const onFinish = (values: any) => {
    props.onSubmit(values);
  };

  const onFinishFailed = (errorInfo: any) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <Form
      name="contact"
      onFinish={onFinish}
      onFinishFailed={onFinishFailed}
      autoComplete="off"
      layout="vertical"
      size="large"
      requiredMark={false}
    >
      <Form.Item label="Name" name="name" rules={[{ required: true }]}>
        <Input />
      </Form.Item>

      <Form.Item
        label="Email"
        name="email"
        rules={[{ required: true, type: 'email' }]}
      >
        <Input />
      </Form.Item>

      <Form.Item label="Company" name="companyName">
        <Input />
      </Form.Item>

      <Form.Item label="Comment" name="comment">
        <Input.TextArea rows={4} />
      </Form.Item>

      <Form.Item>
        <Button block size="large" type="primary" htmlType="submit">
          {props.submitText || 'Submit'}
        </Button>
      </Form.Item>
    </Form>
  );
}

export default ContactForm;
