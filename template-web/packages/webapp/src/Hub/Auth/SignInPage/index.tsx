import React from 'react';

import ButtonLink from 'src/Common/Components/ButtonLink';

import GoogleButton from 'src/Hub/Auth/Social/GoogleButton';
import SignInFormWrapper from './SignInFormWrapper';

function SignInPage() {
  return (
    <div>
      <h3 className="text-center text-xl font-bold text-gray-700">
        Sign in to your account
      </h3>

      <SignInFormWrapper className="my-2" />

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
