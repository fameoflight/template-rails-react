import React from 'react';

import RichTextEditor from './index';

import { RichTextJsonValue } from './utils';

interface IRichTextJsonViewProps {
  value?: RichTextJsonValue | null;
  className?: string;
  namespace?: string;
}

function RichTextJsonView(props: IRichTextJsonViewProps) {
  return (
    <div className={`rich-text-json-view ${props.className}`}>
      <RichTextEditor
        readOnly
        namespace={props.namespace}
        initialContent={{
          content: props.value?.content || undefined,
          contentHtml: props.value?.contentHtml || undefined,
          contentMarkdown: props.value?.contentMarkdown || undefined,
          format: props.value?.format || 'lexical',
        }}
      />
    </div>
  );
}

export default RichTextJsonView;
