import React from 'react';
import { Navigate, RouteObject } from 'react-router-dom';

import { invariant } from '@picasso/shared/src/utils';

import _ from 'lodash';

import ReactRouterFlow from 'src/Common/Components/Flow/ReactRouterFlow';

import { IReactRouterFlowRoute } from './types';

type UseReactRouterFlowType = {
  param?: string;
  routes: IReactRouterFlowRoute[];
  overrides?: {
    path: string;
    element: React.ReactNode;
  }[];
  completedPath?: string;
};

const useReactRouterFlow = (props: UseReactRouterFlowType) => {
  const { param, routes, overrides } = props;

  invariant(routes.length !== 0, 'ensure at least one child in flow children');

  const firstRoute = _.first(routes) as IReactRouterFlowRoute;

  const flowRoutes: RouteObject[] = [];

  if (param) {
    invariant(param[0] !== ':', 'no : required in param');
    invariant(_.findIndex(param) !== -1, 'no subpath allowed in param');
    // Note (hemantv): This is to insert a index route into the flow
    flowRoutes.push({
      element: <Navigate to={`:${param}/${firstRoute.path}`} replace />,
      index: true,
    });
  } else {
    // Note (hemantv): This is to insert a index route into the flow
    flowRoutes.push({
      element: <Navigate to={firstRoute.path} replace />,
      index: true,
    });
  }

  _.each(routes, (route) => {
    invariant(
      _.findIndex(route.path) !== -1,
      `no subpath allowed in route ${route.path}`
    );

    const path = param ? `:${param}/${route.path}` : route.path;

    flowRoutes.push({
      path,
      element: route.element,
    });
  });

  _.each(overrides, (route) => {
    flowRoutes.push({
      path: route.path,
      element: route.element,
    });
  });

  return [
    {
      path: '',
      element: (
        <ReactRouterFlow
          param={param}
          reactRouterFlowRoutes={routes}
          completedPath={props.completedPath}
        />
      ),
      children: flowRoutes,
    },
  ];
};

export default useReactRouterFlow;
