import React from 'react';

import NextLink from 'next/link';

import { classNames } from '@picasso/shared/src/utils';

interface ILinkProps {
  to: string;
  className?: string;
  children: React.ReactNode;
}
function Link(props: ILinkProps) {
  if (props.to.startsWith('http')) {
    return (
      <a
        href={props.to}
        className={props.className}
        target="_blank"
        rel="noopener noreferrer"
      >
        {props.children}
      </a>
    );
  }

  return (
    <NextLink href={props.to}>
      <span className={classNames('cursor-pointer', props.className)}>
        {props.children}
      </span>
    </NextLink>
  );
}

export default Link;
