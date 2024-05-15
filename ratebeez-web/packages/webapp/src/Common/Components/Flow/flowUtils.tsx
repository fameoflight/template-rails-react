import { Location, useParams } from 'react-router-dom';

import { invariant } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { IFlowRoute } from './types';

export const hasPreviousRoute = (
  flowRoutes: IFlowRoute[],
  currentIdx: number
): boolean => currentIdx > 0;

export const hasNextRoute = (
  flowRoutes: IFlowRoute[],
  currentIdx: number
): boolean => _.inRange(currentIdx, 0, flowRoutes.length - 1);

export const getNextRoute = (
  flowRoutes: IFlowRoute[],
  currentIdx: number,
  changeBy: number
): IFlowRoute | undefined => _.nth(flowRoutes, currentIdx + changeBy);

export const getFlowParam = (
  param: string | undefined,
  currentRoute: IFlowRoute | undefined
): string | null => {
  if (!param) {
    return null;
  }

  const params = useParams();

  invariant(currentRoute, 'current route can not null');

  const paramValue = _.get(params, param);

  if (paramValue) {
    return paramValue;
  }

  const pathParts = _.reverse(_.split(window.location.pathname, '/'));

  invariant(
    pathParts[0] === currentRoute.path,
    'current route not match window location'
  );

  return pathParts[1];
};
