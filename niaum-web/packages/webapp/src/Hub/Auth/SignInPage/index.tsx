import React from 'react';
import { Link } from 'react-router-dom';

import ButtonLink from 'src/Common/Components/ButtonLink';

import SignInForm from './SignInForm';
import GoogleButton from 'src/Hub/Auth/Social/GoogleButton';

function SignInPage() {
  return (
    <div>
      <h3 className="text-center text-xl font-bold text-gray-700">
        Sign in to your account
      </h3>

      <SignInForm className="my-8">
        <div className="flex items-center justify-between my-8">
          <div className="flex items-center">
            <input
              id="remember-me"
              name="remember-me"
              type="checkbox"
              className="h-4 w-4 text-picasso-primary-800 focus:ring-picasso-primary-700 border-gray-300 rounded"
            />
            <label
              htmlFor="remember-me"
              className="ml-2 block text-sm text-gray-900"
            >
              Remember me
            </label>
          </div>

          <div className="text-sm">
            <Link
              to="/auth/forgot"
              className="font-medium text-picasso-primary-800 hover:text-picasso-primary-700"
            >
              Forgot your password?
            </Link>
          </div>
        </div>
      </SignInForm>

      <div className="mt-8">
        <GoogleButton>Sign in with Google</GoogleButton>
      </div>

      <div className="mt-8">
        <div className="relative">
          <div className="absolute inset-0 flex items-center">
            <div className="w-full border-t border-gray-300" />
          </div>
          <div className="relative flex justify-center text-sm">
            <span className="px-2 bg-white text-gray-500">
              Or continue with
            </span>
          </div>
        </div>
      </div>

      <div className="mt-6">
        <ButtonLink to="/auth/signup" block>
          Sign Up
        </ButtonLink>
      </div>
    </div>
  );
}

export default SignInPage;
