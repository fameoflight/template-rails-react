import React from 'react';
import { Button, Form, Input, Spin, Tooltip } from 'antd';
import { FormInstance } from 'antd/es/form/Form';
import SubmitButton from 'src/Common/Components/Form/SubmitButton';

interface ITextAreaFormProps {
  form: FormInstance;
  loading: boolean;
  wrapperClassName?: string;
  onSubmit?: (text: string, data?: any, values?: any) => void;
  disabled?: boolean;
  placeholder?: string;
  buttonText?: string;
  dataComponent?: (text?: string) => React.ReactNode;
  children?: React.ReactNode;
}

function TextAreaForm(props: ITextAreaFormProps) {
  const [text, setText] = React.useState('');

  const onSubmit = (values: any) => {
    const text = values.text;
    const data = values.data;

    props.onSubmit?.(text, data, values);
  };

  return (
    <Spin spinning={props.loading} wrapperClassName={props.wrapperClassName}>
      <Form
        layout="vertical"
        form={props.form}
        onFinish={(values) => onSubmit(values)}
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
            onChange={(e) => setText(e.target.value)}
            disabled={props.disabled}
            allowClear={true}
            placeholder={props.placeholder}
            autoSize={{ minRows: 4 }}
          />
        </Form.Item>

        {props.dataComponent && (
          <>
            <div className="my-2 text-sm text-gray-400 font-light">
              It's important to write question first, as it will be used for
              randomization
            </div>
            <Form.Item name="data" rules={[{ required: true }]} noStyle>
              {props.dataComponent(text)}
            </Form.Item>
          </>
        )}

        {props.children}

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
