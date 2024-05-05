import React, { useState } from 'react';

import _ from 'lodash';

import { Checkbox, CheckboxProps } from 'antd';

type CheckboxSelectOptionType = {
  label: React.ReactNode;
  value: string | number;
};

type CheckboxSelectValue = (string | number)[] | null | undefined;

interface CheckboxSelectProps
  extends Omit<CheckboxProps, 'checked' | 'onChange' | 'value'> {
  value?: CheckboxSelectValue;
  options: CheckboxSelectOptionType[];
  onChange?: (value: CheckboxSelectValue) => void;
}

function CheckboxSelect(props: CheckboxSelectProps) {
  const { id, value, options, onChange, ...checkBoxProps } = props;

  const [checkedIds, setCheckedIds] = useState<CheckboxSelectValue>(value);

  const triggerChange = (changedValue: CheckboxSelectValue) => {
    setCheckedIds(changedValue);
    onChange?.(changedValue);
  };

  const onCheckboxChange = (
    option: CheckboxSelectOptionType | null,
    checked: boolean
  ) => {
    if (option == null) {
      triggerChange(checked ? null : []);
    } else {
      let newCheckedIds = _.clone(checkedIds) || [];
      if (checked) {
        newCheckedIds.push(option.value);
      } else {
        newCheckedIds = _.without(checkedIds, option.value);
      }

      triggerChange(newCheckedIds);
    }
  };

  return (
    <span key={id}>
      <Checkbox
        onChange={(e) => onCheckboxChange(null, e.target.checked)}
        checked={checkedIds == null}
        {...checkBoxProps}
      >
        Everyone
      </Checkbox>

      {_.map(options, (option) => (
        <span key={option.value}>
          <Checkbox
            onChange={(e) => onCheckboxChange(option, e.target.checked)}
            checked={_.includes(checkedIds, option.value)}
            {...checkBoxProps}
          >
            {option.label}
          </Checkbox>
        </span>
      ))}
    </span>
  );
}

export default CheckboxSelect;
