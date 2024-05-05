import React from 'react';

import Policies from '@picasso/shared/src/Policies';

import _ from 'lodash';

import Layout from 'src/Components/Layout';

function termsPage() {
  return (
    <Layout title="Terms">
      <Policies.Terms />
    </Layout>
  );
}

export default termsPage;
