import React from 'react';
import { useNavigate } from 'react-router-dom';

import { Button, ButtonProps } from 'antd';

interface IButtonLinkProps extends Omit<ButtonProps, 'onClick'> {
  to: string;
  children?: any;
}
const ButtonLink = ({ children, to, ...restProps }: IButtonLinkProps) => {
  const navigate = useNavigate();

  const onClick = () => {
    navigate(to);
  };

  return (
    <Button onClick={onClick} {...restProps}>
      {children}
    </Button>
  );
};

export default ButtonLink;
