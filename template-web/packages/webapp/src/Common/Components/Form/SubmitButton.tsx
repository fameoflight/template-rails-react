import React from 'react';
import type { ButtonProps, FormInstance } from 'antd';
import { Button, Form, Input, Space } from 'antd';

interface SubmitButtonProps extends Omit<ButtonProps, 'form'> {
  form: FormInstance;
}

function SubmitButton(props: SubmitButtonProps) {
  const { form, ...buttonProps } = props;
  const [submittable, setSubmittable] = React.useState<boolean>(false);

  // Watch all values
  const values = Form.useWatch([], { form: props.form });

  React.useEffect(() => {
    form
      .validateFields({ validateOnly: true })
      .then(() => setSubmittable(true))
      .catch(() => setSubmittable(false));
  }, [form, values]);

  return <Button {...buttonProps} htmlType="submit" disabled={!submittable} />;
}

export default SubmitButton;
