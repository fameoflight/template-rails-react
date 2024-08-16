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

import ProtectedLayout from 'src/Hub/Auth/ProtectedLayout';

const authRoutes = (): RouteObject[] => [
  {
    path: '',
    element: <Auth />,
    children: [
      {
        path: '',
        element: <ProtectedLayout redirect={true} />,
        children: [
          { path: 'update', element: <UserUpdatePage /> },
          {
            path: 'update-otp',
            element: <UserUpdateOtpPage />,
          },
        ],
      },
      { path: 'signin', element: <SignInPage /> },
      { path: 'signout', element: <SignOutPage /> },
      { path: 'forgot', element: <ForgotPasswordPage /> },
      { path: 'end-spoof', element: <EndSpoofPage /> },
      { path: 'reset/:token', element: <UpdatePasswordPage /> },
      { path: 'confirm/:token', element: <ConfirmAccountPage /> },
      { path: 'signup', element: <SignUpPage /> },
      { path: 'signup/:inviteCode', element: <SignUpPage /> },
    ],
  },
  // make signupCode optional
];

export default authRoutes;
