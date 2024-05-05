import React from 'react';
import { RouteObject } from 'react-router-dom';

import ConfirmAccountPage from './ConfirmAccountPage';
import EndSpoofPage from './EndSpoofPage';
import ForgotPasswordPage from './ForgotPasswordPage';
import SignInPage from './SignInPage';
import SignOutPage from './SignOutPage';
import SignUpPage from './SignUpPage';
import UpdatePasswordPage from './UpdatePasswordPage';
import UserUpdatePage from './UserUpdatePage';
import UserUpdateOtpPage from './UserUpdatePage/UserUpdateOtpPage';
import Auth from './index';

const authRoutes = (): RouteObject[] => [
  {
    path: '',
    element: <Auth />,
    children: [
      { path: 'signin', element: <SignInPage /> },
      { path: 'signout', element: <SignOutPage /> },
      { path: 'update', element: <UserUpdatePage /> },
      {
        path: 'update-otp',
        element: <UserUpdateOtpPage />,
      },
      { path: 'forgot', element: <ForgotPasswordPage /> },
      { path: 'end-spoof', element: <EndSpoofPage /> },
      { path: 'reset/:token', element: <UpdatePasswordPage /> },
      { path: 'confirm/:token', element: <ConfirmAccountPage /> },
    ],
  },
  // make signupCode optional
  { path: 'signup', element: <SignUpPage /> },
  { path: 'signup/:signupCode', element: <SignUpPage /> },
];

export default authRoutes;
