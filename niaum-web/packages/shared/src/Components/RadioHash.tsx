import React from 'react';

import _ from 'lodash';

import { Radio, RadioGroupProps } from 'antd';

interface IRadioHashProps<T extends Recordable>
  extends Omit<RadioGroupProps, 'options'> {
  hash: Record<T, string>;
}

function RadioHash<T extends Recordable>(props: IRadioHashProps<T>) {
  const { hash, buttonStyle, optionType, ...restProps } = props;

  const options = _.map(hash, (label, value) => ({
    value,
    label,
  }));

  return (
    <Radio.Group
      {...restProps}
      options={options}
      buttonStyle={buttonStyle || 'solid'}
      optionType={optionType || 'button'}
    />
  );
}

export default RadioHash;
