import React from 'react';

import _ from 'lodash';

import { classNames } from '../utils';

interface IProgressBarProps {
  label?: string;
  color?: TailwindColor;
  size?: TailwindSize;
  percent: number;
}

function ProgressBar(props: IProgressBarProps) {
  const percent = props.percent > 100 ? 100 : props.percent;

  const size = props.size || 'md';

  const color = props.color || 'picasso-primary';

  const baseClasses = 'w-full bg-gray-200 rounded-full mb-4';

  const sizeClasses: Record<TailwindSize, string> = {
    sm: 'h-1.5',
    md: 'h-2.5',
    lg: 'h-4',
    xl: 'h-6',
    xxl: 'h-8',
  };

  return (
    <>
      <div className="mb-1 text-base font-medium">{props.label}</div>
      <div className={classNames(baseClasses, sizeClasses[size])}>
        <div
          className={classNames(
            'h-full rounded-full',
            `bg-${color}-500 dark:bg-${color}-500`
          )}
          style={{ width: `${percent}%` }}
        ></div>
      </div>
    </>
  );
}

export default ProgressBar;
