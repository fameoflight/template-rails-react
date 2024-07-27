import React from 'react';

import { Button, ButtonProps, Dropdown, Menu, MenuProps } from 'antd';

interface IDropdownButtonProps extends Omit<ButtonProps, 'onClick'> {
  children: React.ReactNode;
  onClick?: (key: string) => void;
  values: { key: string; label: React.ReactNode; disabled?: boolean }[];
}

const DropdownButton = (props: IDropdownButtonProps) => {
  const { children, onClick, values, ...rest } = props;

  const onMenuClick: MenuProps['onClick'] = (e) => {
    props.onClick?.(e.key);
  };

  const menu = <Menu onClick={onMenuClick} items={props.values} />;

  return (
    <Dropdown overlay={menu} trigger={['click']}>
      <Button {...rest}>{children}</Button>
    </Dropdown>
  );
};

export default DropdownButton;
