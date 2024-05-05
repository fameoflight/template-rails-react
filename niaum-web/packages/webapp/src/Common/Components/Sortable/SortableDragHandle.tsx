import React from 'react';
import { SortableHandle } from 'react-sortable-hoc';

import _ from 'lodash';

import { DragOutlined } from '@ant-design/icons';

const SortableDragHandle: React.ComponentClass<{ className?: string }> =
  SortableHandle((props: { className: string }) => (
    <span className={props.className}>
      <DragOutlined />
    </span>
  ));

export default SortableDragHandle;
