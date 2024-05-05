import React from 'react';

import { classNames } from '@picasso/shared/src/utils';

interface IBoxContainerProps {
  title: React.ReactNode;
  children: any;
  className?: string;
}
function BoxContainer(props: IBoxContainerProps) {
  return (
    <div className="flex flex-col justify-center items-center py-4 bg-slate-50">
      <div
        className={classNames(
          'sm:mx-auto sm:w-full sm:max-w-7xl p-8 shadow bg-white min-h-[80vh] min-w-[80vw]',
          props.className
        )}
      >
        <div className="text-center mb-12 text-gray-500">{props.title}</div>
        {props.children}
      </div>
    </div>
  );
}

export default BoxContainer;
