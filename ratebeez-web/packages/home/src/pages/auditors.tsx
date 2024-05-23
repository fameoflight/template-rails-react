import React from 'react';
import { graphql } from 'react-relay/hooks';

import auditorsPageQueryRequest, {
  auditorsPageQuery,
} from '@picasso/fragments/src/auditorsPageQuery.graphql';

import _ from 'lodash';

import {
  RelayNextPage,
  getPreloadedQuery,
  usePreloadedQueryCompat,
} from 'src/lib/relay';

import Hero from 'src/Components/Auditors/Hero';
import Contact from 'src/Components/Home/Contact';
import Features from 'src/Components/Home/Features';
import IntegrationsCarousel from 'src/Components/Integrations/IntegrationsCarousel';
import Layout from 'src/Components/Layout';
import Link from 'src/Components/Link';

const pageQuery = graphql`
  query auditorsPageQuery {
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

type pagesHomeNextPage = RelayNextPage<auditorsPageQuery>;

function pagesHomePage(props: pagesHomeNextPage['props']) {
  const data = usePreloadedQueryCompat(pageQuery, props, 'query');

  const templates = data.home.vendorTemplates;

  return (
    <Layout title="">
      <Hero />
      <Features />
      <div className="py-8 bg-gray-50">
        <Link to="/integrations">
          <h2 className="text-center text-picasso-primary-900 font-semibold text-2xl mb-8 pb-4">
            Integrations
          </h2>
        </Link>
        <IntegrationsCarousel records={templates} />
      </div>
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
        query: await getPreloadedQuery<auditorsPageQuery>(
          auditorsPageQueryRequest
        ),
      },
    },
  };
}

export default pagesHomePage;
