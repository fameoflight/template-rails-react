import React, { useState } from 'react';

import _ from 'lodash';

import { Input, InputProps, Select, SelectProps } from 'antd';

import ImageUrlInput from 'src/Common/Components/Form/ImageUrlInput';
import withProtected from 'src/Common/Components/Form/withProtected';

function BetterInput(props: InputProps) {
  if (props.disabled) {
    return <div>{props.value}</div>;
  }

  return <Input {...props} />;
}

const Protected = {
  Input: withProtected<InputProps>(BetterInput),
  Select: withProtected<SelectProps>(Select),
  ImageUrlInput: withProtected(ImageUrlInput),
};

export default Protected;
