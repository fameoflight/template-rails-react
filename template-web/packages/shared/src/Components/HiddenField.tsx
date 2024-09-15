import React, { useState } from 'react';
import _ from 'lodash';
import { EyeFilled } from '@ant-design/icons';

interface IHiddenFieldProps {
  value: string;
  className?: string;
}

function HiddenField(props: IHiddenFieldProps) {
  const [visible, setVisible] = useState(false);

  const hiddenValue = _.repeat('*', props.value.length);

  return (
    <div className={props.className}>
      <span>{visible ? props.value : hiddenValue}</span>
      <EyeFilled
        className="ml-2"
        onClick={() => {
          setVisible(!visible);
        }}
      />
    </div>
  );
}

export default HiddenField;
