import React from 'react';

import { Form } from 'antd';

import RichTextEditor from './index';

type RichTextValue = {
  content: string | null | undefined;
  contentHtml?: string | null | undefined;
  format: 'lexical' | 'plain';
};

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
