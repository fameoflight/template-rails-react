import React from 'react';

import Markdown from 'react-markdown';

import { RichTextType } from './RichTextInput';

interface IRichTextViewProps {
  className?: string;
  value: RichTextType | null | undefined;
}

function RichTextView(props: IRichTextViewProps) {
  const { value } = props;

  if (!value) {
    return null;
  }

  const { format, content } = value;

  if (format === 'markdown') {
    return (
      <div className={props.className}>
        <Markdown>{content}</Markdown>
      </div>
    );
  }

  return <div className={props.className}>{content}</div>;
}

export default RichTextView;
