import React from 'react';
import { graphql } from 'react-relay/hooks';

import integrationsQueryRequest, {
  integrationsQuery,
} from '@picasso/fragments/src/integrationsQuery.graphql';

import { printHostNames } from '@picasso/shared/src/utils';

import _ from 'lodash';

import {
  RelayNextPage,
  getPreloadedQuery,
  usePreloadedQueryCompat,
} from 'src/lib/relay';

import TemplateVendorView from 'src/Components/Integrations/TemplateVendorView';
import Layout from 'src/Components/Layout';

const integrationsPageQuery = graphql`
  query integrationsQuery {
    home {
      vendorTemplates {
        id
        name
        shortId
        iconUrl
        ...TemplateVendorView_record
      }
    }
  }
`;

type integrationsNextPage = RelayNextPage<integrationsQuery>;

function integrationsPage(props: integrationsNextPage['props']) {
  const data = usePreloadedQueryCompat(integrationsPageQuery, props, 'query');

  const templates = data.home.vendorTemplates;

  // const iconUrls = _.map(templates, (template) => template.iconUrl);

  // console.log('hostnames', printHostNames(iconUrls));

  return (
    <Layout title="Integrations">
      <div className="mx-auto max-w-7xl p-4 bg-white mt-4">
        <h1 className="text-center font-semibold text-picasso-primary-900">
          Picasso Integrations
        </h1>

        <div className="mt-8 grid lg:grid-cols-6 md:grid-cols-4 grid-cols-2 gap-4">
          {templates.map((template) => (
            <TemplateVendorView
              key={template.id}
              record={template}
              className="hover:opacity-80 hover:bg-gray-50 bg-white shadow-sm"
            />
          ))}
        </div>
      </div>
    </Layout>
  );
}

export async function getStaticProps(
  _context
): Promise<integrationsNextPage['getStaticProps']> {
  return {
    props: {
      preloadedQueries: {
        query: await getPreloadedQuery<integrationsQuery>(
          integrationsQueryRequest
        ),
      },
    },
  };
}

export default integrationsPage;
