import React from 'react';

import _ from 'lodash';

import { Progress, ProgressProps, Tooltip } from 'antd';

interface ILinearProgressProps extends ProgressProps {
  total: number;
  count: number;
  title?: string;
  className?: string;
}
const LinearProgress = (props: ILinearProgressProps) => {
  const { total, count, title, ...rest } = props;

  const percent = _.round(count / total, 2);

  const tooltipTitle = title || `Completed ${count}/${total}`;

  return (
    <Tooltip title={tooltipTitle}>
      <Progress
        className={props.className}
        percent={percent * 100}
        showInfo={false}
      />
    </Tooltip>
  );
};

export default LinearProgress;
