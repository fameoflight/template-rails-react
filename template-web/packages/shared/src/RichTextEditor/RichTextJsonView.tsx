import React from 'react';

import { Form } from 'antd';

import RichTextEditor, { RichTextValue } from './index';

interface IRichTextJsonViewProps {
  value?: RichTextValue;
  className?: string;
}

function RichTextJsonView(props: IRichTextJsonViewProps) {
  return (
    <div className={`rich-text-json-view ${props.className}`}>
      <RichTextEditor readOnly initialContent={props.value?.content} />
    </div>
  );
}

export default RichTextJsonView;
