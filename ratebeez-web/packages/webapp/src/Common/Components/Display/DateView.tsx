import React from 'react';

import { US_DATE_FORMAT, US_DATE_TIME_FORMAT } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Tooltip } from 'antd';

import moment from 'moment';

interface IDateViewProps {
  value: any;
  format?: string;
  valueType?: 'date' | 'datetime';
  className?: string;
}

function DateView({ value, valueType, format, className }: IDateViewProps) {
  if (value === null) {
    return null;
  }

  const momentObj = _.isNumber(value) ? moment.unix(value) : moment(value);

  const valueFormat =
    format || valueType === 'date' ? US_DATE_FORMAT : US_DATE_TIME_FORMAT;

  return (
    <Tooltip
      color="blue"
      className={className}
      title={() => momentObj.fromNow()}
    >
      {momentObj.format(valueFormat)}
    </Tooltip>
  );
}

export default DateView;
