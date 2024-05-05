import React from 'react';
import { Location, Outlet, useLocation, useNavigate } from 'react-router-dom';

import _ from 'lodash';

import Flow from './index';

import { getFlowParam, getNextRoute } from './flowUtils';
import { IFlowRoute, IReactRouterFlowRoute } from './types';

const currentRouteIndex = (
  flowRoutes: IReactRouterFlowRoute[],
  location: Location
): number => {
  const pathName = location.pathname;

  return _.findIndex(flowRoutes, (flowRoute) => {
    const lastFlowRoutePart = _.last(_.split(flowRoute.path, '/'));

    return _.endsWith(pathName, lastFlowRoutePart);
  });
};

interface IReactRouterFlowProps {
  param?: string;
  reactRouterFlowRoutes: IReactRouterFlowRoute[];
  completedPath?: string;
}

function ReactRouterFlow({
  param,
  reactRouterFlowRoutes,
  completedPath,
}: IReactRouterFlowProps) {
  const location = useLocation();
  const navigate = useNavigate();

  const currentIndex = currentRouteIndex(reactRouterFlowRoutes, location);

  const flowRoutes: IFlowRoute[] = _.map(
    reactRouterFlowRoutes,
    (rFlowRoute) => ({
      title: rFlowRoute.flowTitle,
      description: rFlowRoute.flowDescription,
      ...rFlowRoute,
    })
  );

  const currentRoute = getNextRoute(flowRoutes, currentIndex, 0);

  const paramValue = getFlowParam(param, currentRoute);

  // Note this is to handle params
  // Usecase is for Plaid we need custom authorization while keep other
  // components same see also override
  const internalNavigate = (path: string) => {
    if (param) {
      navigate(`${paramValue}/${path}`);
    } else {
      navigate(path);
    }
  };

  const navigateBy = (changeBy) => {
    const nextRoute = getNextRoute(flowRoutes, currentIndex, changeBy);
    if (nextRoute) {
      internalNavigate(nextRoute.path);
    }
  };

  return (
    <Flow
      navigateBy={navigateBy}
      currentIndex={currentIndex}
      completedPath={completedPath}
      flowRoutes={flowRoutes}
    >
      <Outlet />
    </Flow>
  );
}

export default ReactRouterFlow;
