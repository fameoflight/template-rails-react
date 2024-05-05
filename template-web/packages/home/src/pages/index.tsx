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
import Hero from 'src/Components/Home/Hero';
import Layout from 'src/Components/Layout';

const pagesHomePageQuery = graphql`
  query pagesHomeQuery {
    env
  }
`;

type pagesHomeNextPage = RelayNextPage<pagesHomeQuery>;

function pagesHomePage(props: pagesHomeNextPage['props']) {
  const data = usePreloadedQueryCompat(pagesHomePageQuery, props, 'query');

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
