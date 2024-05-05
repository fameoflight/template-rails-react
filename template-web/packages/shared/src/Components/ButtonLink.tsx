import React from 'react';

import { Button, ButtonProps } from 'antd';

interface IButtonLinkProps extends Omit<ButtonProps, 'onClick'> {
  to: string;
  children?: any;
}

const ButtonLink = ({ children, to, ...restProps }: IButtonLinkProps) => {
  const onClick = () => {
    window.location.href = to;
  };

  return (
    <Button onClick={onClick} {...restProps}>
      {children}
    </Button>
  );
};

export default ButtonLink;
