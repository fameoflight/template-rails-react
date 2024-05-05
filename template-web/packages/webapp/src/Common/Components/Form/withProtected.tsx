import React, { useState } from 'react';

import _ from 'lodash';

import { LockOutlined, LockTwoTone, UnlockTwoTone } from '@ant-design/icons';
import { Button } from 'antd';

export interface WithProtectedProps {
  initialProtected?: boolean;
}

type ComponentProps = {
  disabled?: boolean;
};

const withProtected = <P extends ComponentProps>(
  Component: React.ComponentType<P>
) =>
  class WithProtected extends React.Component<P & WithProtectedProps> {
    state = {
      disabled: _.isUndefined(this.props.initialProtected)
        ? true
        : this.props.initialProtected,
    };

    render() {
      const { initialProtected, disabled, ...props } = this.props;
      return (
        <div className="flex flex-row">
          <Component
            {...(props as P)}
            disabled={disabled || this.state.disabled}
          />
          <Button
            disabled={disabled}
            onClick={() => this.setState({ disabled: !this.state.disabled })}
            type="text"
          >
            {disabled ? (
              <LockOutlined />
            ) : this.state.disabled ? (
              <LockTwoTone />
            ) : (
              <UnlockTwoTone />
            )}
          </Button>
        </div>
      );
    }
  };

export default withProtected;
