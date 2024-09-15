import React, { ErrorInfo, useEffect, useState } from 'react';
import { ErrorBoundary as ReactErrorBoundary } from 'react-error-boundary';

const DefaultFallback: React.FC<{ error: Error }> = ({ error }) => (
  <div className="p-4 bg-red-100 border border-red-300 rounded">
    <h3 className="text-lg font-semibold text-red-800">Something went wrong</h3>
    <p className="text-sm text-red-600">{error.message}</p>
  </div>
);

const errorHandler = (error: Error, info: ErrorInfo) => {
  console.error('Caught an error:', error, info);
};

interface LightErrorBoundaryProps {
  children: React.ReactNode;
  fallback?: React.ReactNode;
  params?: any;
}

function LightErrorBoundary({
  children,
  fallback,
  params,
}: LightErrorBoundaryProps) {
  const [key, setKey] = useState(0);

  useEffect(() => {
    setKey((prevKey) => prevKey + 1);
  }, [params]);

  return (
    <ReactErrorBoundary
      key={key}
      FallbackComponent={fallback ? () => <>{fallback}</> : DefaultFallback}
      onError={errorHandler}
    >
      {children}
    </ReactErrorBoundary>
  );
}

export default LightErrorBoundary;
