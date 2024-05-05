import React from 'react';

import { Form, FormInstance, Modal } from 'antd';
import { ModalProps } from 'antd/lib/modal';

interface IFormChildProps<T> {
  form: FormInstance<any>;
  record: null | T;
  onSubmit?: (values: any) => void;
}

interface IFormModalProps
  extends Omit<ModalProps, 'onCancel' | 'onOk' | 'visible'> {
  onSubmit: (values: null | any) => void;
  children?: React.ReactElement<IFormChildProps<any>> | null;
}

function FormModal({ onSubmit, children, ...restProps }: IFormModalProps): any {
  if (restProps.open) {
    if (React.Children.toArray(children).length !== 1) {
      throw new Error('only one children allowed');
    }
  }

  const [form] = Form.useForm();

  return (
    <Modal
      okText="Submit"
      {...restProps}
      onCancel={() => {
        onSubmit(null);
      }}
      destroyOnClose
      onOk={() => {
        form
          .validateFields()
          .then((values) => {
            form.resetFields();
            onSubmit(values);
          })
          .catch((info) => {
            console.error('Validate Failed:', info);
          });
      }}
    >
      {children && React.cloneElement(children, { form })}
    </Modal>
  );
}

export default FormModal;
