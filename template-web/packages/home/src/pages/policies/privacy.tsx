import React from 'react';

import Policies from '@picasso/shared/src/Policies';

import _ from 'lodash';

import Layout from 'src/Components/Layout';

function privacyPage() {
  return (
    <Layout title="Privacy">
      <Policies.Privacy />
    </Layout>
  );
}

export default privacyPage;
