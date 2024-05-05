import React from 'react';

import _ from 'lodash';

import { classNames } from '../utils';

interface IJSONViewerProps {
  data: string | any;
  className?: string;
}

function JSONViewer(props: IJSONViewerProps) {
  const { data } = props;

  let value = data;

  try {
    value = JSON.stringify(JSON.parse(data), null, 4);
  } catch (e) {
    if (_.isObject(value)) {
      value = JSON.stringify(value, null, 4);
    } else {
      value = _.toString(value);
    }
  }

  const className = props.className || 'bg-slate-100 p-2';

  return (
    <div className={classNames(className, 'whitespace-pre overflow-scroll')}>
      <code>{value}</code>
    </div>
  );
}

export default JSONViewer;
