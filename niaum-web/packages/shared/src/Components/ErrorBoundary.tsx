import React, { ErrorInfo } from 'react';
import {
  FallbackProps,
  ErrorBoundary as ReactErrorBoundary,
} from 'react-error-boundary';

import _ from 'lodash';

import { LeftOutlined } from '@ant-design/icons';
import { Button, Result } from 'antd';
import { ResultStatusType } from 'antd/lib/result';

import { isBrowser } from '../utils';

interface ErrorFallbackProps extends FallbackProps {
  extra: React.ReactNode[];
}

const ADMIN_ERROR = 'Cannot return null for non-nullable field Query.adminUser';

function ErrorFallback(props: ErrorFallbackProps) {
  const error = props.error;

  let status: ResultStatusType = '500';
  let title: React.ReactNode = error.message || 'Something went wrong';

  let stackLines = (error.stack || '').split('\n');

  if (_.includes(stackLines, ADMIN_ERROR)) {
    status = '403';
    title = (
      <div className="text-lg max-w-2xl mx-auto">
        <span>Access Denied</span>

        <div className="mt-1 text-base">
          <p>You are not authorized to access this page.</p>
          <p>
            Only admin users can access this page. Please contact your admin for
            more permissions.
          </p>
        </div>
      </div>
    );

    stackLines = [];
  }

  return (
    <Result
      status={status}
      title={title}
      className="mt-12"
      subTitle={
        <div className="bg-red-100 max-w-2xl p-4 mx-auto border border-red-300 my-4 text-left">
          <div className="text-sm text-red-900">{error.message}</div>

          <div className="flex flex-col space-y-1">
            {stackLines.map((line, index) => (
              <div key={index} className="text-sm text-red-800 mt-1">
                {line}
              </div>
            ))}
          </div>
        </div>
      }
      extra={props.extra}
    />
  );
}

const myErrorHandler = (error: Error, info: ErrorInfo) => {
  console.error(error, info);
};

interface IErrorBoundaryProps {
  children: React.ReactNode;
  onClick?: () => void;
}

function ErrorBoundary(props: IErrorBoundaryProps) {
  const { children } = props;

  const onClick =
    props.onClick ||
    (() => {
      if (!isBrowser()) {
        throw new Error('window is undefined');
      }
      window.history.back();
    });

  return (
    <ReactErrorBoundary
      FallbackComponent={(props: FallbackProps) => (
        <ErrorFallback
          {...props}
          extra={[
            <Button key="btn" type="primary" onClick={onClick}>
              <LeftOutlined /> Back Home
            </Button>,
          ]}
        />
      )}
      onError={myErrorHandler}
    >
      {children}
    </ReactErrorBoundary>
  );
}

export default ErrorBoundary;
