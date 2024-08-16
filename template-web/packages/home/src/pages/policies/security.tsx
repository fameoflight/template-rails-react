import React from 'react';

import Policies from '@picasso/shared/src/Policies';

import _ from 'lodash';

import Layout from 'src/Components/Layout';

function securityPage() {
  return (
    <Layout title="Security">
      <Policies.Security />
    </Layout>
  );
}

export default securityPage;
