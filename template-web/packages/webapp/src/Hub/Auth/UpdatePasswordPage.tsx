import React from 'react';
import { useParams } from 'react-router-dom';

import Errors from '@picasso/shared/src/Components/Errors';
import api from '@picasso/shared/src/api';
import { searchParams } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Spin } from 'antd';

import UpdatePasswordForm from 'src/Hub/Auth/UpdatePasswordForm';

function UpdatePasswordPage() {
  const params = useParams();

  const [loading, setLoading] = React.useState(false);

  const [errors, setErrors] = React.useState([]);

  const token = params.token;

  const next = () => {
    return searchParams().get('next') || '/';
  };

  const onComplete = () => {
    window.location.replace(next());
  };

  const onSubmit = (formValues) => {
    setLoading(true);

    api
      .browserRequestClient()
      .put({
        endpoint: '/api/internal/auth/password',
        data: {
          reset_password_token: token,
          password: formValues.password,
          password_confirmation: formValues.password_confirmation,
        },
      })
      .then((response) => {
        api.updateAuthHeaders(response);
        onComplete();
      })
      .catch((error) => {
        setLoading(false);
        setErrors(error.response.data.errors);
      });
  };

  return (
    <Spin wrapperClassName="p-8" spinning={loading}>
      <Errors errors={errors} className="mb-8" />
      <UpdatePasswordForm onSubmit={onSubmit} />
    </Spin>
  );
}

export default UpdatePasswordPage;
