import React, { useEffect } from 'react';

import analytics from '@picasso/shared/src/analytics';

import { Spin } from 'antd';

import JToker from 'j-toker';

function SignOutPage() {
  const signOut = () => {
    analytics.reset();
    window.location.replace('/');
  };

  useEffect(() => {
    JToker.signOut()
      .then(() => {
        signOut();
      })
      .catch(() => {
        signOut();
      });
  });

  return (
    <Spin spinning={true} wrapperClassName="text-center min-h-[300px]">
      <h1 className="mt-24">Signing out...</h1>
    </Spin>
  );
}

export default SignOutPage;
