import React from 'react';
import { RouteObject, useRoutes } from 'react-router-dom';

import NotFoundPage from '@picasso/shared/src/NotFoundPage';
import Policies from '@picasso/shared/src/Policies';

// Routes
import ProtectedLayout from 'src/Hub/Auth/ProtectedLayout';
import authRoutes from 'src/Hub/Auth/routes';

import Layout from 'src/App/Layout';

import superUserRoutes from 'src/SuperUser/routes';

import { AnimatePresence, LayoutGroup } from 'framer-motion';
import HomeContainer from 'src/Hub/Home/HomeContainer';
import HomePage from 'src/Hub/Home/HomePage';

const AppRoutes = () => {
  const routes: RouteObject[] = [
    {
      path: '/',
      element: <Layout />,
      children: [
        {
          path: 'policies',
          children: [
            { path: 'terms', element: <Policies.Terms /> },
            { path: 'privacy', element: <Policies.Privacy /> },
            { path: 'security', element: <Policies.Security /> },
          ],
        },
        {
          path: 'auth',
          children: authRoutes(),
        },
        {
          path: '',
          element: <ProtectedLayout redirect={true} />,
          children: [
            {
              path: 'super',
              children: superUserRoutes(),
            },
            {
              path: '',
              element: <HomeContainer />,
              children: [
                {
                  path: '',
                  element: <HomePage />,
                },
              ],
            },
          ],
        },
        {
          path: '*',
          element: <NotFoundPage />,
        },
      ],
    },
  ];

  return (
    <AnimatePresence mode="wait">
      <LayoutGroup>{useRoutes(routes)}</LayoutGroup>
    </AnimatePresence>
  );
};

export default AppRoutes;
