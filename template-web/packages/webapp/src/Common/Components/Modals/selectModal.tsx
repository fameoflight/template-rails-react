import React from 'react';

import { Form, FormInstance, Modal, ModalFuncProps } from 'antd';

import SelectForm from 'src/Common/Components/Form/SelectForm';

interface SelectFuncProps extends Omit<ModalFuncProps, 'onOk' | 'onCancel'> {
  onSubmit: (values: any) => void;
  name: string;
  label?: string;
  form: FormInstance<any>;
  options: { label: string; value: any }[];
}

function selectModal(props: SelectFuncProps) {
  const { name, label, options, onSubmit, form, ...restProps } = props;

  return Modal.confirm({
    ...restProps,
    icon: null,
    content: (
      <SelectForm form={form} options={options} name={name} label={label} />
    ),
    onOk: () => {
      return new Promise<string>((resolve, reject) => {
        form
          .validateFields()
          .then((values) => {
            onSubmit(values);
            resolve(values);
          })
          .catch(reject);
      });
    },
  });
}

export default selectModal;
