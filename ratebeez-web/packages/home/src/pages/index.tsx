import React from 'react';
import { graphql } from 'react-relay/hooks';

import pagesHomeQueryRequest, {
  pagesHomeQuery,
} from '@picasso/fragments/src/pagesHomeQuery.graphql';

import _ from 'lodash';

import {
  RelayNextPage,
  getPreloadedQuery,
  usePreloadedQueryCompat,
} from 'src/lib/relay';

import Contact from 'src/Components/Home/Contact';
import Features from 'src/Components/Home/Features';
import Hero from 'src/Components/Home/Hero';
import IntegrationsCarousel from 'src/Components/Integrations/IntegrationsCarousel';
import Layout from 'src/Components/Layout';
import Link from 'src/Components/Link';

const pagesHomePageQuery = graphql`
  query pagesHomeQuery {
    home {
      vendorTemplates {
        id
        name
        shortId
        iconUrl
        ...IntegrationsCarousel_records
      }
    }
  }
`;

type pagesHomeNextPage = RelayNextPage<pagesHomeQuery>;

function pagesHomePage(props: pagesHomeNextPage['props']) {
  const data = usePreloadedQueryCompat(pagesHomePageQuery, props, 'query');

  const templates = data.home.vendorTemplates;

  return (
    <Layout title="">
      <Hero />
      <Contact />
    </Layout>
  );
}

export async function getStaticProps(
  _context
): Promise<pagesHomeNextPage['getStaticProps']> {
  return {
    props: {
      preloadedQueries: {
        query: await getPreloadedQuery<pagesHomeQuery>(pagesHomeQueryRequest),
      },
    },
  };
}

export default pagesHomePage;
