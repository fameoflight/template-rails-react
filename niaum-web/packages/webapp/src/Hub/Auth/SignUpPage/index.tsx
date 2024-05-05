import React, { useState } from 'react';
import { Link } from 'react-router-dom';

import logoPath from '@picasso/shared/assets/logo/web/svg/color.svg';
import Errors from '@picasso/shared/src/Components/Errors';
import { searchParams } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Button, Spin } from 'antd';

import SignupForm from 'src/Hub/Auth/SignUpPage/SignupForm';
import api from '@picasso/shared/src/api';
import GoogleButton from 'src/Hub/Auth/Social/GoogleButton';

function SignUpPage() {
  const [loading, setLoading] = useState(false);

  const [errors, setErrors] = useState([]);

  const onComplete = () => {
    const nextUrl = searchParams().get('next') || '/';
    window.location.replace(nextUrl);
  };

  const onSubmit = (values) => {
    setLoading(true);
    api
      .browserRequestClient()
      .post({
        endpoint: '/api/internal/auth',
        data: values,
      })
      .then((response) => {
        api.updateAuthHeaders(response);
        onComplete();
      })
      .catch((error) => {
        const response = error.response;
        if (response.data.errors) {
          if (response.data.errors.full_messages) {
            setErrors(response.data.errors.full_messages);
          } else {
            setErrors(response.data.errors);
          }
        }
      })
      .finally(() => {
        setLoading(false);
      });
  };

  return (
    <div className="min-h-screen flex flex-row items-center  bg-slate-100">
      <div className="flex-1 max-w-7xl mx-auto p-8 space-y-8 md:space-y-0 bg-white">
        <div className="text-center mt-4">
          <img
            className="mx-auto h-10 mb-4"
            src={logoPath as any}
            alt="Picasso Logo"
          />
        </div>
        <div className="mx-auto w-full max-w-sm">
          <div>
            <h2 className="text-3xl font-bold tracking-tight text-picasso-primary-900">
              Sign up for an account
            </h2>
          </div>

          <Spin spinning={loading} wrapperClassName="mt-8">
            <Errors errors={errors} className="mb-4" />

            <SignupForm onSubmit={onSubmit} />
          </Spin>

          <div className="mt-8">
            <GoogleButton>Sign up with Google</GoogleButton>
          </div>

          <div className="mt-6">
            <div className="relative">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-gray-300" />
              </div>
              <div className="relative flex justify-center text-sm">
                <span className="px-2  text-gray-500">Or continue with</span>
              </div>
            </div>

            <div className="mt-6 grid grid-cols-3 gap-3">
              <Button className="col-span-3">
                <Link to="/auth/signin">Sign In</Link>
              </Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default SignUpPage;
