import React from 'react';
import { RouteObject } from 'react-router-dom';

import SuperUserJobRecords from 'src/SuperUser/SuperUserJobRecords';

import SuperUserHomePage from './SuperUserHomePage';
import SuperUserUserSearch from './SuperUserUserSearch';

import SuperUserContainer from './SuperUserContainer';

const superUserRoutes = (): RouteObject[] => [
  {
    element: <SuperUserContainer />,
    children: [
      { index: true, element: <SuperUserHomePage /> },
      { path: 'users', element: <SuperUserUserSearch /> },
      {
        path: 'job-records',
        element: <SuperUserJobRecords />,
      },
    ],
  },
];

export default superUserRoutes;
