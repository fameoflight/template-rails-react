import React, { useCallback, useState } from 'react';

import _ from 'lodash';

import { Select, SelectProps } from 'antd';

type OptionType = {
  label: string;
  value: string;
};

function stringOptions(options: (string | null)[]): OptionType[] {
  return _.map(_.compact(options), (option) => ({
    label: option,
    value: option,
  }));
}

interface ISelectCreatableProps extends Omit<SelectProps, 'options'> {
  options: readonly string[];
}

function SelectCreatable(props: ISelectCreatableProps) {
  const { options, ...restProps } = props;

  if (props.value && !_.isArray(props.value)) {
    console.error('SelectCreatable: values must be an array');
  }

  const [currentSearch, setCurrentSearch] = useState<string | null>(null);

  const optionOptions = useCallback(
    () =>
      stringOptions(
        _.uniq([currentSearch, ...options, ...(props.value || [])])
      ),
    [currentSearch, options]
  );

  return (
    <Select
      {...restProps}
      showSearch
      options={optionOptions()}
      onSearch={(value) => {
        setCurrentSearch(value);
      }}
    />
  );
}

export default SelectCreatable;
