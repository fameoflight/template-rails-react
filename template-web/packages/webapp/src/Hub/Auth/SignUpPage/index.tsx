import React from 'react';

import ButtonLink from 'src/Common/Components/ButtonLink';

import GoogleButton from 'src/Hub/Auth/Social/GoogleButton';

import SignUpFormWrapper from './SignUpFormWrapper';

function SignUpPage() {
  return (
    <div>
      <h3 className="text-center text-xl font-bold text-gray-700">
        Sign up for account
      </h3>

      <SignUpFormWrapper className="my-2" />

      <div className="mt-8">
        <GoogleButton>Sign up with Google</GoogleButton>
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
        <ButtonLink to="/auth/signin" block>
          Sign In
        </ButtonLink>
      </div>
    </div>
  );
}

export default SignUpPage;
