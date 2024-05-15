import React from 'react';

import Errors from '@picasso/shared/src/Components/Errors';
import api from '@picasso/shared/src/api';
import { searchParams } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Button, Form, Input, Spin } from 'antd';

import LogInForm from 'src/Hub/Auth/SignInPage/LogInForm';

interface ISignInFormProps {
  children: React.ReactNode;
  className?: string;
}

interface ISignInFormState {
  loading: boolean;
  showTwoFactor: boolean;
  errors: any[];
}

class SignInForm extends React.Component<ISignInFormProps, ISignInFormState> {
  constructor(props) {
    super(props);

    this.state = {
      loading: false,
      showTwoFactor: false,
      errors: [],
    };
  }

  onComplete = () => {
    const nextUrl = searchParams().get('next') || '/';
    window.location.replace(nextUrl);
  };

  onFinish = (formValues) => {
    this.setState({ errors: [], loading: true });

    const passwordHash = btoa(
      JSON.stringify({
        password: formValues.password,
        otp: formValues.otp,
      })
    );

    api
      .browserRequestClient()
      .post({
        endpoint: '/api/internal/auth/sign_in',
        data: {
          email: formValues.email,
          password: passwordHash,
        },
      })
      .then((response) => {
        api.updateAuthHeaders(response);
        this.onComplete();
      })
      .catch((error) => {
        if (this.state.showTwoFactor) {
          this.setState({
            loading: false,
            errors: error.response.data.errors,
          });
        } else {
          this.setState({
            loading: false,
            showTwoFactor: true,
          });
        }
      });
  };

  render() {
    return (
      <Spin
        spinning={this.state.loading}
        wrapperClassName={this.props.className}
      >
        <Errors errors={this.state.errors} className="mb-4" />

        <LogInForm
          onSubmit={this.onFinish}
          showTwoFactor={this.state.showTwoFactor}
        >
          {this.props.children}
        </LogInForm>
      </Spin>
    );
  }
}

export default SignInForm;
