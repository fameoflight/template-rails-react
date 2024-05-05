import React from 'react';

import _ from 'lodash';

import { Select, SelectProps } from 'antd';

export interface ISelectHashProps<T extends Recordable>
  extends Omit<SelectProps, 'options'> {
  hash: Record<T, string>;
}

function SelectHash<T extends Recordable>(props: ISelectHashProps<T>) {
  const { hash, ...restProps } = props;

  const options = _.map(hash, (label, value) => ({
    value,
    label,
  }));

  return <Select showSearch {...restProps} options={options} />;
}

export default SelectHash;
