import React from 'react';

import { classNames } from '../utils';

interface ITailwindButtonProps {
  onClick?: () => void;
  type?: 'primary' | 'secondary';
  color?: TailwindColor;
  size?: TailwindSize;
  className?: string;
  children?: React.ReactNode;
}

function TailwindButton(props: ITailwindButtonProps) {
  const onClick = () => {
    props.onClick?.();
  };

  const color = props.color || 'picasso-primary';

  const size = props.size || 'md';

  const type = props.type || 'primary';

  const colorClasses = {
    primary: `bg-${color}-800 hover:opacity-80 text-white focus:ring-${color}-500`,
    secondary: `bg-white hover:opacity-90 text-${color}-900 focus:ring-${color}-500`,
  };

  const commonClasses =
    'inline-flex items-center border border-transparent shadow-sm font-medium font-medium  focus:outline-none focus:ring-2 focus:ring-offset-2 hover:shadow';

  const sizeClasses: Record<TailwindSize, string> = {
    sm: 'rounded px-2.5 py-1.5 text-xs',
    md: 'rounded px-3 py-2 text-sm',
    lg: 'rounded px-4 py-2 text-base',
    xl: 'rounded-md px-4 py-2 text-base',
    xxl: 'rounded-md px-6 py-3 text-base',
  };

  return (
    <button
      onClick={onClick}
      type="button"
      className={classNames(
        commonClasses,
        colorClasses[type],
        sizeClasses[size],
        props.className
      )}
    >
      {props.children}
    </button>
  );
}

export default TailwindButton;
