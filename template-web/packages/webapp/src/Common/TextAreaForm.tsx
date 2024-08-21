import React from 'react';
import { Button, Form, Input, Spin, Tooltip } from 'antd';
import { FormInstance } from 'antd/es/form/Form';
import SubmitButton from 'src/Common/Components/Form/SubmitButton';

interface ITextAreaFormProps {
  form: FormInstance;
  loading: boolean;
  wrapperClassName?: string;
  onSubmit?: (text: string, data?: any) => void;
  disabled?: boolean;
  placeholder?: string;
  buttonText?: string;
  dataComponent?: React.ReactNode;
}

function TextAreaForm(props: ITextAreaFormProps) {
  return (
    <Spin spinning={props.loading} wrapperClassName={props.wrapperClassName}>
      <Form
        layout="vertical"
        form={props.form}
        onFinish={(values) => props.onSubmit?.(values.text, values.data)}
        onKeyDown={(e) => {
          if (e.key === 'Enter' && e.shiftKey) {
            props.form.submit();
          }
        }}
      >
        <Form.Item
          name="text"
          rules={[{ required: true }, { min: 10 }]}
          noStyle
        >
          <Input.TextArea
            disabled={props.disabled}
            allowClear={true}
            placeholder={props.placeholder}
            autoSize={{ minRows: 4 }}
          />
        </Form.Item>

        {props.dataComponent && (
          <Form.Item name="data" rules={[{ required: true }]} noStyle>
            {props.dataComponent}
          </Form.Item>
        )}

        <Tooltip title="Press Shift + Enter to send">
          <SubmitButton
            form={props.form}
            type="primary"
            htmlType="submit"
            className="min-w-[100px] justify-center mt-2"
          >
            {props.buttonText || 'Submit'}
          </SubmitButton>
        </Tooltip>
      </Form>
    </Spin>
  );
}

export default TextAreaForm;
