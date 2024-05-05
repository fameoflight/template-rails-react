import React from 'react';

import Errors from '@picasso/shared/src/Components/Errors';

import { Alert } from 'antd';

import ForgotPasswordForm from 'src/Hub/Auth/ForgotPasswordForm';

import JToker from 'j-toker';

function ForgotPasswordPage() {
  const [sent, setSent] = React.useState(false);

  const [errors, setErrors] = React.useState([]);

  const onSubmit = (formValues) => {
    JToker.requestPasswordReset(formValues)
      .then(() => {
        setSent(true);
      })
      .fail((resp) => {
        setErrors(resp.data.errors);
      });
  };

  return (
    <div>
      <Errors errors={errors} className="mb-8" />

      {!sent ? (
        <ForgotPasswordForm onSubmit={onSubmit} />
      ) : (
        <Alert
          className="border-0"
          showIcon={true}
          type="success"
          message={<h3 className="-mt-1">Instructions Sent!</h3>}
          description={
            <div className="mt-4">
              <p>We have sent password instructions to your email.</p>

              <p className="mt-2">
                Please check your inbox including spam folder for password reset
                instructions.
              </p>
            </div>
          }
        />
      )}
    </div>
  );
}

export default ForgotPasswordPage;
