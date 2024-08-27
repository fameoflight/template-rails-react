import React from 'react';

import RichTextEditor, { RichTextEditorOnChange } from './index';
import { RichTextJsonValue } from './utils';

interface IRichTextJsonInputProps {
  value?: RichTextJsonValue;
  namespace?: string;
  onChange?: (value: RichTextJsonValue) => void;
  className?: string;
  toolbar?: boolean;
}

function RichTextJsonInput(props: IRichTextJsonInputProps) {
  const { value, onChange } = props;

  return (
    <div className={`rich-text-json-input ${props.className}`}>
      <RichTextEditor
        toolbar={props.toolbar}
        namespace={props.namespace}
        initialContent={{
          content: value?.content || undefined,
          contentHtml: value?.contentHtml || undefined,
          contentMarkdown: value?.contentMarkdown || undefined,
          format: value?.format || 'lexical',
        }}
        onChange={(value: RichTextEditorOnChange) => {
          onChange?.({
            content: value.content,
            contentHtml: value.contentHtml,
            contentMarkdown: value.contentMarkdown,
            format: props.value?.format || 'lexical',
          });
        }}
      />
    </div>
  );
}

export default RichTextJsonInput;
