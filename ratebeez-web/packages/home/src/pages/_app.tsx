import React from 'react';

import type { AppProps } from 'next/app';
import { GoogleAnalytics } from 'nextjs-google-analytics';

import { initTheme } from '@picasso/shared/index';

import _ from 'lodash';

import { ConfigProvider } from 'antd';

import { ReactRelayContainer } from 'src/lib/ReactRelayContainer';
import { StaticProps } from 'src/lib/relay';

import { AnimatePresence } from 'framer-motion';

import './_app.css';

interface MyAppProps extends AppProps {
  pageProps: StaticProps<any>['props'];
}

function MyApp(props: MyAppProps) {
  const { Component, pageProps } = props;

  initTheme();

  return (
    <ConfigProvider>
      <AnimatePresence mode="wait">
        <ReactRelayContainer Component={Component} pageProps={pageProps} />
      </AnimatePresence>

      <GoogleAnalytics
        strategy="lazyOnload"
        gaMeasurementId="G-L8V42JB07D"
        trackPageViews
      />
    </ConfigProvider>
  );
}

export default MyApp;
