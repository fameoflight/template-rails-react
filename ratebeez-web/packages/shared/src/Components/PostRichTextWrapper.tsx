import React from 'react';

import { classNames } from '../utils';

interface IPostRichTextWrapperProps {
  children: React.ReactNode;
  className?: string;
}

export const POST_DEFAULT_CLASSNAME = 'prose prose-md';

function PostRichTextWrapper(props: IPostRichTextWrapperProps) {
  return (
    <div className={classNames(POST_DEFAULT_CLASSNAME, props.className)}>
      {props.children}
    </div>
  );
}

export default PostRichTextWrapper;
