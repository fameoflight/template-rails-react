import React from 'react';

import type { NextPage } from 'next';

import AboutCTA from 'src/Components/About/AboutCTA';
import AboutHero from 'src/Components/About/AboutHero';
import Layout from 'src/Components/Layout';

const AboutPage: NextPage = () => {
  return (
    <Layout title="About">
      <div className="flex-grow flex flex-col">
        <AboutHero />
        <AboutCTA />
      </div>
    </Layout>
  );
};

export default AboutPage;
