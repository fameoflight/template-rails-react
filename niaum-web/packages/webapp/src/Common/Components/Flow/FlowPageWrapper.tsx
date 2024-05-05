import React from 'react';

import { RightOutlined } from '@ant-design/icons';
import { Button, ButtonProps } from 'antd';

import { useFlowContext } from 'src/Common/Components/Flow/flowContext';

interface IFlowPageWrapperProps extends ButtonProps {
  children: React.ReactNode;
  buttonLabel?: string;
  buttonIcon?: React.ReactNode;
  wrapperClassName?: string;
  buttonWrapperClassName?: string;
}

const FlowPageWrapper = (props: IFlowPageWrapperProps) => {
  const { children, wrapperClassName, buttonWrapperClassName, ...rest } = props;

  const flowContext = useFlowContext();

  const onNextStep = () => {
    flowContext.onStepComplete();
  };

  return (
    <div className={wrapperClassName}>
      {children}

      <div className={buttonWrapperClassName || 'text-center mt-32'}>
        <Button type="primary" onClick={onNextStep} {...rest}>
          {props.buttonLabel || 'Next'}
          <span className="ml-4">{props.buttonIcon || <RightOutlined />}</span>
        </Button>
      </div>
    </div>
  );
};

export default FlowPageWrapper;
