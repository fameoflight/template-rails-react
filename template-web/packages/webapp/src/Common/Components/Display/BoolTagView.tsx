import React from 'react';

import { Tag } from 'antd';

interface IBoolTagViewProps {
  value: boolean | null | undefined;
  display?: any;
}

function BoolTagView(props: IBoolTagViewProps) {
  const display = props.display || (props.value ? 'True' : 'False');

  return <Tag color={props.value ? 'green' : 'red'}>{display}</Tag>;
}

export default BoolTagView;
