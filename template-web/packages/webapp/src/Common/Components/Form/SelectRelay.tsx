import React from 'react';

import _ from 'lodash';

import { Select, SelectProps } from 'antd';

export interface ISelectRelayProps<T extends RelayNode>
  extends Omit<SelectProps, 'options'> {
  options: readonly T[];
  labelKey: keyof T;
}

function SelectRelay<T extends RelayNode>(props: ISelectRelayProps<T>) {
  const { options, labelKey, ...restProps } = props;

  const optionsList = options.map((option) => ({
    value: option.id,
    label: _.toString(option[labelKey]),
  }));

  return <Select showSearch {...restProps} options={optionsList} />;
}

export default SelectRelay;
