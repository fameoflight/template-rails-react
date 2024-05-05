import React from 'react';

import Errors from '@picasso/shared/src/Components/Errors';
import api from '@picasso/shared/src/api';
import { searchParams } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Spin } from 'antd';

import SignupForm from './SignupForm';

interface ISignUpFormWrapperProps {
  children?: React.ReactNode;
  className?: string;
}

interface ISignUpFormWrapperState {
  loading: boolean;
  errors: any[];
}

class SignUpFormWrapper extends React.Component<
  ISignUpFormWrapperProps,
  ISignUpFormWrapperState
> {
  constructor(props) {
    super(props);

    this.state = {
      loading: false,
      errors: [],
    };
  }

  onComplete = () => {
    const nextUrl = searchParams().get('next') || '/';
    window.location.replace(nextUrl);
  };

  onFinish = (formValues) => {
    this.setState({ errors: [], loading: true });

    api
      .browserRequestClient()
      .post({
        endpoint: '/api/internal/auth/',
        data: {
          name: formValues.name,
          email: formValues.email,
          password: formValues.password,
          inviteCode: formValues.inviteCode,
        },
      })
      .then((response) => {
        api.updateAuthHeaders(response);
        this.onComplete();
      })
      .catch((error) => {
        this.setState({
          loading: false,
          errors: error.response.data.errors,
        });
      });
  };

  render() {
    return (
      <Spin
        spinning={this.state.loading}
        wrapperClassName={this.props.className}
      >
        <Errors errors={this.state.errors} className="my-2" />

        <SignupForm onSubmit={this.onFinish}>{this.props.children}</SignupForm>
      </Spin>
    );
  }
}

export default SignUpFormWrapper;
