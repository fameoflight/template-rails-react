import React from 'react';

import type { NextPage } from 'next';

import Layout from 'src/Components/Layout';
import Pricing from 'src/Components/Pricing';

const PricingPage: NextPage = () => {
  return (
    <Layout title="Pricing">
      <Pricing />
    </Layout>
  );
};

export default PricingPage;
