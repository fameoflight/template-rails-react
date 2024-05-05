import React from 'react';

import { titlize } from '@picasso/shared/src/utils';
import { trimSuffix } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Button, Form, Input, Select } from 'antd';

interface ISelectFormProps<T> {
  form?: any;
  value?: T;
  label?: string;
  name: string;
  options: { label: string; value: T }[];
  onSubmit?: (values: any) => void;
}

function SelectForm<T>(props: ISelectFormProps<T>): any {
  const onFinish = (values) => {
    props.onSubmit?.(values);
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  const label = titlize(trimSuffix(props.name, 'Id'));

  return (
    <Form
      form={props.form}
      layout="vertical"
      onFinish={onFinish}
      name="SelectForm"
      onFinishFailed={onFinishFailed}
    >
      <Form.Item
        label={props.label || label}
        name={props.name}
        initialValue={props.value}
        rules={[
          {
            required: true,
            message: `Please input ${props.name}!`,
          },
        ]}
      >
        <Select options={props.options} />
      </Form.Item>

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

export default SelectForm;
