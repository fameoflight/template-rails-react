import React from 'react';

import NotFoundPage from '@picasso/shared/src/NotFoundPage';

import _ from 'lodash';

import Layout from 'src/Components/Layout';

function CustomErrorPage() {
  return (
    <Layout title="Not Found">
      <NotFoundPage />
    </Layout>
  );
}

export default CustomErrorPage;
