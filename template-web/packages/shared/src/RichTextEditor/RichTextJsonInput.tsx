import React from 'react';

import { Form } from 'antd';

import RichTextEditor, { RichTextValue } from './index';

interface IRichTextJsonInputProps {
  value?: RichTextValue;
  onChange?: (value: RichTextValue) => void;
}

function RichTextJsonInput(props: IRichTextJsonInputProps) {
  const { value, onChange } = props;

  return (
    <RichTextEditor
      initialContent={value?.content}
      onChange={(content) => {
        onChange?.({
          content,
          format: value?.format || 'lexical',
        });
      }}
    />
  );
}

export default RichTextJsonInput;
