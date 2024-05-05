import React from 'react';

import Errors from '@picasso/shared/src/Components/Errors';
import api from '@picasso/shared/src/api';
import { searchParams } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Spin } from 'antd';

import SignInForm from './SignInForm';

interface ISignInFormWrapperProps {
  children?: React.ReactNode;
  className?: string;
}

interface ISignInFormWrapperState {
  loading: boolean;
  showTwoFactor: boolean;
  errors: any[];
}

class SignInFormWrapper extends React.Component<
  ISignInFormWrapperProps,
  ISignInFormWrapperState
> {
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

        <SignInForm
          onSubmit={this.onFinish}
          showTwoFactor={this.state.showTwoFactor}
        >
          {this.props.children}
        </SignInForm>
      </Spin>
    );
  }
}

export default SignInFormWrapper;
