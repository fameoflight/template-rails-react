import React from 'react';

import _ from 'lodash';

import { Skeleton, SkeletonProps } from 'antd';

interface ISuspenseProps {
  children: React.ReactNode;
  skeletonProps?: SkeletonProps;
  fallback?: React.ReactNode;
  paragraph?: number;
}

const defaultSkeletonProps: SkeletonProps = {
  avatar: false,
  title: false,
  active: true,
};

const Suspense = (props: ISuspenseProps) => {
  const skeletonProps = _.merge({}, defaultSkeletonProps, props.skeletonProps);

  if (props.paragraph) {
    skeletonProps.paragraph = {
      rows: props.paragraph,
      width: _.range(props.paragraph).map(() => '100%'),
    };
  }

  const fallback = props.fallback || <Skeleton {...skeletonProps} />;

  return <React.Suspense fallback={fallback}>{props.children}</React.Suspense>;
};

export default Suspense;
