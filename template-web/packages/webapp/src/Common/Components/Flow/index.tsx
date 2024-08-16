import React from 'react';
import { useNavigate } from 'react-router-dom';

import Suspense from '@picasso/shared/src/Components/Suspense';
import motion from '@picasso/shared/src/Components/motion';

import _ from 'lodash';

import FlowNavigation from 'src/Common/Components/Flow/FlowNavigation';
import FlowSteps from 'src/Common/Components/Flow/FlowSteps';
import { FlowProvider } from 'src/Common/Components/Flow/flowContext';

import { getNextRoute } from './flowUtils';
import { IFlowRoute } from './types';

interface IFlowProps {
  currentIndex: number;
  flowRoutes: IFlowRoute[];
  completedPath?: string;
  navigateBy?: (changeBy: number) => void;
  children: JSX.Element;
}

function Flow({
  currentIndex,
  flowRoutes,
  completedPath,
  navigateBy,
  children,
}: IFlowProps) {
  const navigate = useNavigate();

  const navigateByInternal = (changeBy: number) => {
    if (navigateBy) {
      navigateBy(changeBy);
    } else {
      const nextRoute = getNextRoute(flowRoutes, currentIndex, changeBy);

      if (nextRoute) {
        navigate(nextRoute.path);
      }
    }
  };

  const onStepComplete = () => {
    const nextRoute = getNextRoute(flowRoutes, currentIndex, 1);
    if (nextRoute) {
      navigateByInternal(1);
    } else if (completedPath) {
      navigate(completedPath);
    }
  };

  const flowProvider = {
    navigateBy: navigateByInternal,
    onStepComplete,
    flowRoutes,
    currentIndex,
  };

  return (
    <FlowProvider value={flowProvider}>
      <FlowSteps className="my-8" />

      <motion.shift
        motionKey={`${currentIndex}`}
        values={{
          x: currentIndex > 0 ? 100 : 0,
          y: currentIndex > 0 ? 0 : 100,
        }}
        transition={{ duration: 0.5 }}
      >
        <Suspense>{children}</Suspense>
      </motion.shift>

      <FlowNavigation className="my-4" />
    </FlowProvider>
  );
}

export default Flow;
