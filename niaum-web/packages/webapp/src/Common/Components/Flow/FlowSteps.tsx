import React from 'react';

import _ from 'lodash';

import { Steps } from 'antd';

import { useFlowContext } from 'src/Common/Components/Flow/flowContext';

interface IFlowStepsProps {
  className?: string;
}

function FlowSteps(props: IFlowStepsProps) {
  const flowContext = useFlowContext();

  const currentRoute = _.nth(flowContext.flowRoutes, flowContext.currentIndex);

  if (currentRoute?.hideSteps) {
    return null;
  }

  return (
    <Steps
      progressDot
      current={flowContext.currentIndex}
      className={props.className}
    >
      {_.map(flowContext.flowRoutes, (flowRoute) => (
        <Steps.Step
          key={flowRoute.path}
          title={flowRoute.title}
          description={flowRoute.description}
        />
      ))}
    </Steps>
  );
}

export default FlowSteps;
