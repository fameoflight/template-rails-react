import React, { useEffect } from 'react';
import { Outlet } from 'react-router-dom';
import { useLocation } from 'react-router-dom';

import { initTheme } from '@picasso/shared/index';
import ErrorBoundary from '@picasso/shared/src/Components/ErrorBoundary';
import Suspense from '@picasso/shared/src/Components/Suspense';
import analytics from '@picasso/shared/src/analytics';

import _ from 'lodash';

import { ConfigProvider, Skeleton } from 'antd';

import BrandedNavBar from 'src/Common/Components/Dashboard/BrandedNavBar';

import Footer from 'src/App/Footer';

interface SuspenseFallbackProps {
  paragraph: number;
}

function SuspenseFallback(props: SuspenseFallbackProps) {
  return (
    <BrandedNavBar navigationItems={[]}>
      <Skeleton
        title={false}
        avatar={false}
        paragraph={{
          rows: props.paragraph,
          width: _.range(props.paragraph).map(() => '100%'),
        }}
        active
      />
    </BrandedNavBar>
  );
}

function Layout() {
  const location = useLocation();

  useEffect(() => {
    analytics.pageView(location.pathname);
  }, [location]);

  initTheme();

  return (
    <ErrorBoundary>
      <ConfigProvider>
        <div className="flex flex-col min-h-screen">
          <Suspense fallback={<SuspenseFallback paragraph={100} />}>
            <Outlet />
          </Suspense>
          <div className="flex-shrink">
            <Footer />
          </div>
        </div>
      </ConfigProvider>
    </ErrorBoundary>
  );
}

export default Layout;
