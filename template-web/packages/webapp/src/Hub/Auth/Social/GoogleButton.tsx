import React from 'react';
import { GoogleOAuthProvider, useGoogleLogin } from '@react-oauth/google';
import { searchParams } from '@picasso/shared/src/utils';

import { Button } from 'antd';
import { GoogleOutlined } from '@ant-design/icons';

import api from '@picasso/shared/src/api';

interface IGoogleButtonProps {
  children: React.ReactNode;
  className?: string;
  onError?: () => void;
}

function GoogleInternalButton(props: IGoogleButtonProps) {
  const [loading, setLoading] = React.useState(false);

  const onComplete = () => {
    const nextUrl = searchParams().get('next') || '/';
    window.location.replace(nextUrl);
  };
  const onSuccess = (response: any) => {
    setLoading(true);
    api
      .browserRequestClient()
      .post({
        endpoint: '/api/internal/users/google_login',
        data: response,
      })
      .then((response) => {
        api.updateAuthHeaders(response);
        onComplete();
      })
      .catch((error) => {
        console.log('Google login error', error);
      })
      .finally(() => {
        setLoading(false);
        console.log('Google login complete');
      });
  };

  const onError = () => {
    if (props.onError) {
      props.onError();
    }
  };

  const login = useGoogleLogin({
    onSuccess: onSuccess,
    onError: onError,
  });

  return (
    <Button
      loading={loading}
      className={props.className}
      type="primary"
      icon={<GoogleOutlined />}
      block
      onClick={() => login()}
    >
      {props.children}
    </Button>
  );
}

const googleClientId: string =
  '1067778399043-vnc72lc69jqalfs9cs6paa7um96hohk4.apps.googleusercontent.com';

function GoogleButton(props: IGoogleButtonProps) {
  return (
    <GoogleOAuthProvider clientId={googleClientId}>
      <GoogleInternalButton {...props} />
    </GoogleOAuthProvider>
  );
}

export default GoogleButton;
