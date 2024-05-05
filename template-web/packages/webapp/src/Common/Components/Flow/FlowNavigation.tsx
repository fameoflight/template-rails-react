import React from 'react';

import _ from 'lodash';

import { LeftOutlined, RightOutlined } from '@ant-design/icons';
import { Button } from 'antd';

import { useFlowContext } from 'src/Common/Components/Flow/flowContext';
import {
  hasNextRoute,
  hasPreviousRoute,
} from 'src/Common/Components/Flow/flowUtils';

interface IFlowNavigationProps {
  className?: string;
}

function FlowNavigation(props: IFlowNavigationProps) {
  const flowContext = useFlowContext();

  const currentRoute = _.nth(flowContext.flowRoutes, flowContext.currentIndex);

  const { flowRoutes, currentIndex, navigateBy } = flowContext;

  if (!currentRoute?.navigation) {
    return null;
  }

  return (
    <div className={props.className}>
      <Button
        className="mr-4 float-left"
        disabled={!hasPreviousRoute(flowRoutes, currentIndex)}
        onClick={() => navigateBy(-1)}
      >
        <LeftOutlined /> Previous
      </Button>
      <Button
        className="float-right"
        disabled={!hasNextRoute(flowRoutes, currentIndex)}
        onClick={() => navigateBy(1)}
      >
        Next <RightOutlined />
      </Button>
    </div>
  );
}

export default FlowNavigation;
